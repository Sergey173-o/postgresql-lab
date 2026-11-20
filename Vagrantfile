# -*- mode: ruby -*-
# Поднимает основной сервер, горячую реплику и отдельную ВМ для бэкапов.
nodes = {
  "node1"  => "192.168.57.11",
  "node2"  => "192.168.57.12",
  "backup" => "192.168.57.13"
}

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  config.vm.box_version = "4.3.12"
  config.vm.box_check_update = false
  config.vm.boot_timeout = 900
  config.vm.synced_folder ".", "/vagrant", disabled: true

  nodes.each do |name, address|
    config.vm.define name do |vm|
      vm.vm.hostname = name
      vm.vm.network "private_network", ip: address, virtualbox__intnet: "otus-postgres"

      vm.vm.provider "virtualbox" do |vb|
        vb.cpus = 1
        vb.memory = 1024
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end

      vm.vm.provision "ansible" do |ansible|
        ansible.playbook = "ansible/provision.yml"
        ansible.extra_vars = { "pg_nodes" => nodes }
      end
    end
  end
end

# Версия 1 · 2026-11-16 · Три ВМ Ubuntu 22.04 и внутренняя сеть VirtualBox.
# Версия 2 · 2026-11-17 · Переход на Ubuntu 20.04 из VPN-лаборатории.
