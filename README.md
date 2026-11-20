настроить потоковую репликацию PostgreSQL со слотами и реализовать корректное резервное копирование для обеспечения отказоустойчивости сервиса
##  Поднять ВМ

Если ВМ из старого каталога `~/postgresql-lab` ещё работают, останови их из этого каталога через `vagrant halt`. Обе версии используют одну внутреннюю сеть и те же IP-адреса.

```bash
root@nfsc:~/postgresql-lab-focal# cd ~/postgresql-lab-focal &&
  vagrant validate &&
  ansible-playbook --syntax-check -i node1,node2,backup, ansible/provision.yml &&
  vagrant up node1 --provider=virtualbox &&
  vagrant up node2 --provider=virtualbox &&
  vagrant up backup --provider=virtualbox &&
  vagrant status
Vagrantfile validated successfully.

playbook: ansible/provision.yml
Bringing machine 'node1' up with 'virtualbox' provider...
==> node1: Importing base box 'generic/ubuntu2004'...
==> node1: Matching MAC address for NAT networking...
==> node1: Setting the name of the VM: postgresql-lab-focal_node1_1794943502807_78320
==> node1: Clearing any previously set network interfaces...
==> node1: Preparing network interfaces based on configuration...
    node1: Adapter 1: nat
    node1: Adapter 2: intnet
==> node1: Forwarding ports...
    node1: 22 (guest) => 2222 (host) (adapter 1)
==> node1: Running 'pre-boot' VM customizations...
==> node1: Booting VM...
==> node1: Waiting for machine to boot. This may take a few minutes...
    node1: SSH address: 127.0.0.1:2222
    node1: SSH username: vagrant
    node1: SSH auth method: private key
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1: Warning: Connection reset. Retrying...
    node1:
    node1: Vagrant insecure key detected. Vagrant will automatically replace
    node1: this with a newly generated keypair for better security.
    node1:
    node1: Inserting generated public key within guest...
    node1: Removing insecure key from the guest if it's present...
    node1: Key inserted! Disconnecting and reconnecting using new SSH key...
==> node1: Machine booted and ready!
==> node1: Checking for guest additions in VM...
    node1: The guest additions on this VM do not match the installed version of
    node1: VirtualBox! In most cases this is fine, but in rare cases it can
    node1: prevent things such as shared folders from working properly. If you see
    node1: shared folder errors, please make sure the guest additions within the
    node1: virtual machine match the version of VirtualBox you have installed on
    node1: your host and reload your VM.
    node1:
    node1: Guest Additions Version: 6.1.38
    node1: VirtualBox Version: 7.0
==> node1: Setting hostname...
==> node1: Configuring and enabling network interfaces...
==> node1: Running provisioner: ansible...
    node1: Running ansible-playbook...

PLAY [Развернуть PostgreSQL и резервное копирование] ***************************

TASK [Создать каталог настроек системного резолвера] ***************************
changed: [node1]

TASK [Настроить DNS VirtualBox NAT для установки пакетов] **********************
changed: [node1]

TASK [Применить DNS до загрузки пакетов] ***************************************

RUNNING HANDLER [Перечитать DNS] ***********************************************
changed: [node1]

TASK [Установить зависимости APT и поддержку переключения пользователя] ********
changed: [node1]

TASK [Установить ключ репозитория PGDG] ****************************************
changed: [node1]

TASK [Подключить архив PGDG для Ubuntu 20.04] **********************************
changed: [node1]

TASK [Установить postgresql-common] ********************************************
changed: [node1]

TASK [Отключить автоматическое создание пакетного кластера] ********************
changed: [node1]

TASK [Установить PostgreSQL 16 и клиентские утилиты] ***************************
changed: [node1]

TASK [Создать каталог конфигурации] ********************************************
changed: [node1]

TASK [Создать родительский каталог PGDATA] *************************************
changed: [node1]

TASK [Установить конфигурацию кластера и правила доступа] **********************
changed: [node1] => (item=postgresql.conf)
changed: [node1] => (item=pg_hba.conf)

TASK [Установить настройки потоковой репликации] *******************************
skipping: [node1]

TASK [Установить пароль подключения реплики с правами 0600] ********************
skipping: [node1]

TASK [Подготовить PGDATA и опубликовать после успешного создания] **************
changed: [node1]

TASK [Установить unit PostgreSQL] **********************************************
changed: [node1]

TASK [Применить конфигурацию PostgreSQL] ***************************************

RUNNING HANDLER [Перезапустить PostgreSQL] *************************************
changed: [node1]

TASK [Включить PostgreSQL] *****************************************************
changed: [node1]

TASK [Дождаться готовности PostgreSQL] *****************************************
ok: [node1]

TASK [Создать роли репликации, постоянный слот и контрольную таблицу] **********
changed: [node1]

TASK [Создать пользователя для бэкапов] ****************************************
skipping: [node1]

TASK [Создать закрытый каталог бэкапов] ****************************************
skipping: [node1]

TASK [Установить пароль роли бэкапа с правами 0600] ****************************
skipping: [node1]

TASK [Задать адрес primary для сервиса бэкапов] ********************************
skipping: [node1]

TASK [Установить скрипты бэкапа и пробного восстановления] *********************
skipping: [node1] => (item=otus-pg-backup)
skipping: [node1] => (item=otus-pg-restore-check)
skipping: [node1]

TASK [Установить сервис и таймер бэкапов] **************************************
skipping: [node1] => (item=otus-pg-backup.service)
skipping: [node1] => (item=otus-pg-backup.timer)
skipping: [node1]

TASK [Включить ежедневное резервное копирование] *******************************
skipping: [node1]

PLAY RECAP *********************************************************************
node1                      : ok=18   changed=17   unreachable=0    failed=0    skipped=9    rescued=0    ignored=0

Bringing machine 'node2' up with 'virtualbox' provider...
==> node2: Importing base box 'generic/ubuntu2004'...
==> node2: Matching MAC address for NAT networking...
==> node2: Setting the name of the VM: postgresql-lab-focal_node2_1794944319625_5218
==> node2: Fixed port collision for 22 => 2222. Now on port 2200.
==> node2: Clearing any previously set network interfaces...
==> node2: Preparing network interfaces based on configuration...
    node2: Adapter 1: nat
    node2: Adapter 2: intnet
==> node2: Forwarding ports...
    node2: 22 (guest) => 2200 (host) (adapter 1)
==> node2: Running 'pre-boot' VM customizations...
==> node2: Booting VM...
==> node2: Waiting for machine to boot. This may take a few minutes...
    node2: SSH address: 127.0.0.1:2200
    node2: SSH username: vagrant
    node2: SSH auth method: private key
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2: Warning: Remote connection disconnect. Retrying...
    node2: Warning: Connection reset. Retrying...
    node2:
    node2: Vagrant insecure key detected. Vagrant will automatically replace
    node2: this with a newly generated keypair for better security.
    node2:
    node2: Inserting generated public key within guest...
    node2: Removing insecure key from the guest if it's present...
    node2: Key inserted! Disconnecting and reconnecting using new SSH key...
==> node2: Machine booted and ready!
==> node2: Checking for guest additions in VM...
    node2: The guest additions on this VM do not match the installed version of
    node2: VirtualBox! In most cases this is fine, but in rare cases it can
    node2: prevent things such as shared folders from working properly. If you see
    node2: shared folder errors, please make sure the guest additions within the
    node2: virtual machine match the version of VirtualBox you have installed on
    node2: your host and reload your VM.
    node2:
    node2: Guest Additions Version: 6.1.38
    node2: VirtualBox Version: 7.0
==> node2: Setting hostname...
==> node2: Configuring and enabling network interfaces...
==> node2: Running provisioner: ansible...
    node2: Running ansible-playbook...

PLAY [Развернуть PostgreSQL и резервное копирование] ***************************

TASK [Создать каталог настроек системного резолвера] ***************************
changed: [node2]

TASK [Настроить DNS VirtualBox NAT для установки пакетов] **********************
changed: [node2]

TASK [Применить DNS до загрузки пакетов] ***************************************

RUNNING HANDLER [Перечитать DNS] ***********************************************
changed: [node2]

TASK [Установить зависимости APT и поддержку переключения пользователя] ********
changed: [node2]

TASK [Установить ключ репозитория PGDG] ****************************************
changed: [node2]

TASK [Подключить архив PGDG для Ubuntu 20.04] **********************************
changed: [node2]

TASK [Установить postgresql-common] ********************************************
changed: [node2]

TASK [Отключить автоматическое создание пакетного кластера] ********************
changed: [node2]

TASK [Установить PostgreSQL 16 и клиентские утилиты] ***************************
changed: [node2]

TASK [Создать каталог конфигурации] ********************************************
changed: [node2]

TASK [Создать родительский каталог PGDATA] *************************************
changed: [node2]

TASK [Установить конфигурацию кластера и правила доступа] **********************
changed: [node2] => (item=postgresql.conf)
changed: [node2] => (item=pg_hba.conf)

TASK [Установить настройки потоковой репликации] *******************************
changed: [node2]

TASK [Установить пароль подключения реплики с правами 0600] ********************
changed: [node2]

TASK [Подготовить PGDATA и опубликовать после успешного создания] **************
changed: [node2]

TASK [Установить unit PostgreSQL] **********************************************
changed: [node2]

TASK [Применить конфигурацию PostgreSQL] ***************************************

RUNNING HANDLER [Перезапустить PostgreSQL] *************************************
changed: [node2]

TASK [Включить PostgreSQL] *****************************************************
changed: [node2]

TASK [Дождаться готовности PostgreSQL] *****************************************
ok: [node2]

TASK [Создать роли репликации, постоянный слот и контрольную таблицу] **********
skipping: [node2]

TASK [Создать пользователя для бэкапов] ****************************************
skipping: [node2]

TASK [Создать закрытый каталог бэкапов] ****************************************
skipping: [node2]

TASK [Установить пароль роли бэкапа с правами 0600] ****************************
skipping: [node2]

TASK [Задать адрес primary для сервиса бэкапов] ********************************
skipping: [node2]

TASK [Установить скрипты бэкапа и пробного восстановления] *********************
skipping: [node2] => (item=otus-pg-backup)
skipping: [node2] => (item=otus-pg-restore-check)
skipping: [node2]

TASK [Установить сервис и таймер бэкапов] **************************************
skipping: [node2] => (item=otus-pg-backup.service)
skipping: [node2] => (item=otus-pg-backup.timer)
skipping: [node2]

TASK [Включить ежедневное резервное копирование] *******************************
skipping: [node2]

PLAY RECAP *********************************************************************
node2                      : ok=19   changed=18   unreachable=0    failed=0    skipped=8    rescued=0    ignored=0

Bringing machine 'backup' up with 'virtualbox' provider...
==> backup: Importing base box 'generic/ubuntu2004'...
==> backup: Matching MAC address for NAT networking...
==> backup: Setting the name of the VM: postgresql-lab-focal_backup_1794945178880_6266
==> backup: Fixed port collision for 22 => 2222. Now on port 2201.
==> backup: Clearing any previously set network interfaces...
==> backup: Preparing network interfaces based on configuration...
    backup: Adapter 1: nat
    backup: Adapter 2: intnet
==> backup: Forwarding ports...
    backup: 22 (guest) => 2201 (host) (adapter 1)
==> backup: Running 'pre-boot' VM customizations...
==> backup: Booting VM...
==> backup: Waiting for machine to boot. This may take a few minutes...
    backup: SSH address: 127.0.0.1:2201
    backup: SSH username: vagrant
    backup: SSH auth method: private key
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Remote connection disconnect. Retrying...
    backup: Warning: Connection reset. Retrying...
    backup: Warning: Remote connection disconnect. Retrying...
    backup:
    backup: Vagrant insecure key detected. Vagrant will automatically replace
    backup: this with a newly generated keypair for better security.
    backup:
    backup: Inserting generated public key within guest...
    backup: Removing insecure key from the guest if it's present...
    backup: Key inserted! Disconnecting and reconnecting using new SSH key...
==> backup: Machine booted and ready!
==> backup: Checking for guest additions in VM...
    backup: The guest additions on this VM do not match the installed version of
    backup: VirtualBox! In most cases this is fine, but in rare cases it can
    backup: prevent things such as shared folders from working properly. If you see
    backup: shared folder errors, please make sure the guest additions within the
    backup: virtual machine match the version of VirtualBox you have installed on
    backup: your host and reload your VM.
    backup:
    backup: Guest Additions Version: 6.1.38
    backup: VirtualBox Version: 7.0
==> backup: Setting hostname...
==> backup: Configuring and enabling network interfaces...
==> backup: Running provisioner: ansible...
    backup: Running ansible-playbook...

PLAY [Развернуть PostgreSQL и резервное копирование] ***************************

TASK [Создать каталог настроек системного резолвера] ***************************
changed: [backup]

TASK [Настроить DNS VirtualBox NAT для установки пакетов] **********************
changed: [backup]

TASK [Применить DNS до загрузки пакетов] ***************************************

RUNNING HANDLER [Перечитать DNS] ***********************************************
changed: [backup]

TASK [Установить зависимости APT и поддержку переключения пользователя] ********
changed: [backup]

TASK [Установить ключ репозитория PGDG] ****************************************
changed: [backup]

TASK [Подключить архив PGDG для Ubuntu 20.04] **********************************
changed: [backup]

TASK [Установить postgresql-common] ********************************************
changed: [backup]

TASK [Отключить автоматическое создание пакетного кластера] ********************
changed: [backup]

TASK [Установить PostgreSQL 16 и клиентские утилиты] ***************************
changed: [backup]

TASK [Создать каталог конфигурации] ********************************************
changed: [backup]

TASK [Создать родительский каталог PGDATA] *************************************
skipping: [backup]

TASK [Установить конфигурацию кластера и правила доступа] **********************
skipping: [backup] => (item=postgresql.conf)
skipping: [backup] => (item=pg_hba.conf)
skipping: [backup]

TASK [Установить настройки потоковой репликации] *******************************
skipping: [backup]

TASK [Установить пароль подключения реплики с правами 0600] ********************
skipping: [backup]

TASK [Подготовить PGDATA и опубликовать после успешного создания] **************
skipping: [backup]

TASK [Установить unit PostgreSQL] **********************************************
skipping: [backup]

TASK [Применить конфигурацию PostgreSQL] ***************************************
skipping: [backup]

TASK [Включить PostgreSQL] *****************************************************
skipping: [backup]

TASK [Дождаться готовности PostgreSQL] *****************************************
skipping: [backup]

TASK [Создать роли репликации, постоянный слот и контрольную таблицу] **********
skipping: [backup]

TASK [Создать пользователя для бэкапов] ****************************************
changed: [backup]

TASK [Создать закрытый каталог бэкапов] ****************************************
changed: [backup]

TASK [Установить пароль роли бэкапа с правами 0600] ****************************
changed: [backup]

TASK [Задать адрес primary для сервиса бэкапов] ********************************
changed: [backup]

TASK [Установить скрипты бэкапа и пробного восстановления] *********************
changed: [backup] => (item=otus-pg-backup)
changed: [backup] => (item=otus-pg-restore-check)

TASK [Установить сервис и таймер бэкапов] **************************************
changed: [backup] => (item=otus-pg-backup.service)
changed: [backup] => (item=otus-pg-backup.timer)

TASK [Включить ежедневное резервное копирование] *******************************
changed: [backup]

PLAY RECAP *********************************************************************
backup                     : ok=17   changed=17   unreachable=0    failed=0    skipped=9    rescued=0    ignored=0

Current machine states:

node1                     running (virtualbox)
node2                     running (virtualbox)
backup                    running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
root@nfsc:~/postgresql-lab-focal#

```


## репликацию и восстановление

```bash
root@nfsc:~/postgresql-lab-focal# (
  set -o pipefail
  bash ./verify.sh | tee "$HOME/postgresql-check.txt"
)
node2: streaming через node2_slot, получен маркер 98bdf6cc-26cc-43ab-a252-7914c2ba23d0
backup successfully verified
Восстановление 20261120T181429Z-0cs5hDo2 подтверждено. Маркер: 98bdf6cc-26cc-43ab-a252-7914c2ba23d0
root@nfsc:~/postgresql-lab-focal#

```


ручная проверка:

```bash
root@nfsc:~/postgresql-lab-focal# vagrant ssh node1 --no-tty -c "sudo -u postgres psql -h /run/otus-postgresql -d postgres -c 'SELECT slot_name, slot_type, active, wal_status FROM pg_replication_slots;'"
 slot_name  | slot_type | active | wal_status
------------+-----------+--------+------------
 node2_slot | physical  | t      | reserved
(1 row)

root@nfsc:~/postgresql-lab-focal# vagrant ssh node2 --no-tty -c "sudo -u postgres psql -h /run/otus-postgresql -d postgres -c 'SELECT pg_is_in_recovery(); SHOW transaction_read_only;'"
 pg_is_in_recovery
-------------------
 t
(1 row)

 transaction_read_only
-----------------------
 on
(1 row)

root@nfsc:~/postgresql-lab-focal# vagrant ssh node2 --no-tty -c "sudo -u postgres psql -h /run/otus-postgresql -d postgres -c 'SELECT status, slot_name, sender_host FROM pg_stat_wal_receiver;'"
  status   | slot_name  |  sender_host
-----------+------------+---------------
 streaming | node2_slot | 192.168.57.11
(1 row)

root@nfsc:~/postgresql-lab-focal#
```

## расписание и журналы

```bash
root@nfsc:~/postgresql-lab-focal# vagrant ssh backup --no-tty -c 'systemctl list-timers otus-pg-backup.timer'
NEXT                        LEFT    LAST                        PASSED  UNIT                 ACTIVATES
Sat 2026-11-21 02:00:00 UTC 7h left Fri 2026-11-20 02:00:12 UTC 16h ago otus-pg-backup.timer otus-pg-backup.service

1 timers listed.
Pass --all to see loaded but inactive timers, too.
root@nfsc:~/postgresql-lab-focal# vagrant ssh backup --no-tty -c 'sudo journalctl -u otus-pg-backup.service -n 30 --no-pager'
-- Logs begin at Tue 2026-11-17 19:54:34 UTC, end at Fri 2026-11-20 18:17:04 UTC. --
Nov 18 02:00:12 backup systemd[1]: Starting Verified physical backup of the OTUS PostgreSQL primary...
Nov 18 02:00:26 backup otus-pg-backup[8914]: backup successfully verified
Nov 18 02:00:27 backup otus-pg-backup[8898]: Проверенный бэкап: /var/lib/pgbackup/backups/20261118T020026Z-pYOEiaR0
Nov 18 02:00:27 backup systemd[1]: otus-pg-backup.service: Succeeded.
Nov 18 02:00:27 backup systemd[1]: Finished Verified physical backup of the OTUS PostgreSQL primary.
Nov 19 02:00:12 backup systemd[1]: Starting Verified physical backup of the OTUS PostgreSQL primary...
Nov 19 02:00:21 backup otus-pg-backup[10053]: backup successfully verified
Nov 19 02:00:21 backup otus-pg-backup[10040]: Проверенный бэкап: /var/lib/pgbackup/backups/20261119T020021Z-Mn31z75j
Nov 19 02:00:21 backup systemd[1]: otus-pg-backup.service: Succeeded.
Nov 19 02:00:21 backup systemd[1]: Finished Verified physical backup of the OTUS PostgreSQL primary.
Nov 20 02:00:12 backup systemd[1]: Starting Verified physical backup of the OTUS PostgreSQL primary...
Nov 20 02:00:22 backup otus-pg-backup[11262]: backup successfully verified
Nov 20 02:00:22 backup otus-pg-backup[11247]: Проверенный бэкап: /var/lib/pgbackup/backups/20261120T020022Z-iof1T9xH
Nov 20 02:00:22 backup systemd[1]: otus-pg-backup.service: Succeeded.
Nov 20 02:00:22 backup systemd[1]: Finished Verified physical backup of the OTUS PostgreSQL primary.
Nov 20 18:14:18 backup systemd[1]: Starting Verified physical backup of the OTUS PostgreSQL primary...
Nov 20 18:14:29 backup otus-pg-backup[12119]: backup successfully verified
Nov 20 18:14:29 backup otus-pg-backup[12106]: Проверенный бэкап: /var/lib/pgbackup/backups/20261120T181429Z-0cs5hDo2
Nov 20 18:14:29 backup systemd[1]: otus-pg-backup.service: Succeeded.
Nov 20 18:14:29 backup systemd[1]: Finished Verified physical backup of the OTUS PostgreSQL primary.
root@nfsc:~/postgresql-lab-focal#

```

```bash

root@nfsc:~/postgresql-lab-focal# vagrant ssh backup --no-tty -c 'sudo systemctl start otus-pg-backup.service && sudo -u pgbackup /usr/local/bin/otus-pg-restore-check latest'
backup successfully verified
Восстановление 20261120T181750Z-yZ9D00RP подтверждено. Маркер: initial
root@nfsc:~/postgresql-lab-focal#

```
