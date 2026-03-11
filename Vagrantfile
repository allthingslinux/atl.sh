# -*- mode: ruby -*-
# atl.sh — local dev VM for Ansible testing
# Usage: vagrant up && just deploy dev
# Prerequisite: ssh-keygen -f .ssh/dev_key -t ed25519 -N "" (creates key pair for root SSH)

Vagrant.configure("2") do |config|
  unless File.exist?(".ssh/dev_key.pub")
    raise "Missing .ssh/dev_key.pub. Create it with: mkdir -p .ssh && ssh-keygen -f .ssh/dev_key -t ed25519 -N \"\""
  end

  config.vm.box = "debian/trixie64"
  config.vm.hostname = "atl-sh-dev"

  config.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "127.0.0.1", id: "ssh"

  config.vm.provider "libvirt" do |v|
    v.memory = 4096
    v.cpus = 4
  end

  # Provision root SSH access for Ansible
  config.vm.provision "file", source: ".ssh/dev_key.pub", destination: "/tmp/authorized_keys.pub"
  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p /root/.ssh
    mv /tmp/authorized_keys.pub /root/.ssh/authorized_keys
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    systemctl reload sshd 2>/dev/null || service ssh reload 2>/dev/null || true
  SHELL
end
