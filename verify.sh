#!/usr/bin/env bash
# Проверяет слот, чтение новой строки с реплики и восстановление из бэкапа.
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

# Выполняет SQL от postgres через локальный сокет. Параметры: имя ВМ и запрос.
pg_sql() {
    local vm=$1 query=$2
    vagrant ssh "$vm" --no-tty -c         "sudo -u postgres psql -X -h /run/otus-postgresql -d postgres -Atq -v ON_ERROR_STOP=1 -c \"$query\"" |
        tr -d '\r'
}

token=$(cat /proc/sys/kernel/random/uuid)
[[ "$token" =~ ^[a-f0-9-]{36}$ ]]
pg_sql node1 "INSERT INTO public.otus_probe VALUES ('$token');"

for attempt in {1..12}; do
    seen=$(pg_sql node2 "SELECT token FROM public.otus_probe WHERE token='$token' AND pg_is_in_recovery();")
    [[ "$seen" == "$token" ]] && break
    sleep 2
done
if [[ "$seen" != "$token" ]]; then
    printf 'node2: реплика не вернула маркер %s\n' "$token" >&2
    exit 1
fi

slot=$(pg_sql node1 "SELECT s.slot_name FROM pg_replication_slots s JOIN pg_stat_replication r ON s.active_pid=r.pid WHERE s.slot_name='node2_slot' AND s.slot_type='physical' AND r.application_name='node2' AND r.state='streaming';")
if [[ "$slot" != node2_slot ]]; then
    printf 'node1: не найден активный поток node2 через слот node2_slot\n' >&2
    exit 1
fi
printf 'node2: streaming через %s, получен маркер %s\n' "$slot" "$token"

vagrant ssh backup --no-tty -c     "sudo systemctl start otus-pg-backup.service && sudo -u pgbackup /usr/local/bin/otus-pg-restore-check latest '$token'"

# Версия 1 · 2026-11-16 · Проверка слота и восстановления контрольной строки.
