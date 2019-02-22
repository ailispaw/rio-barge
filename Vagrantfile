# A dummy plugin for Barge to set hostname and network correctly at the very first `vagrant up`
module VagrantPlugins
  module GuestLinux
    class Plugin < Vagrant.plugin("2")
      guest_capability("linux", "change_host_name") { Cap::ChangeHostName }
      guest_capability("linux", "configure_networks") { Cap::ConfigureNetworks }
    end
  end
end

RIO_VERSION = "v0.0.4-rc6"

Vagrant.configure(2) do |config|
  config.vm.define "rio-barge"

  config.vm.box = "ailispaw/barge"

  config.vm.provider :virtualbox do |vb|
    vb.cpus   = 2
    vb.memory = 2048
    vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
  end

  config.vm.synced_folder ".", "/vagrant", id: "vagrant"

  config.vm.provision :shell do |sh|
    sh.inline = <<-EOT
      set -e

      echo "Installing rio..."
      wget -qO- https://github.com/rancher/rio/releases/download/#{RIO_VERSION}/rio-#{RIO_VERSION}-linux-amd64.tar.gz | tar xz
      mv rio-#{RIO_VERSION}-linux-amd64/rio /opt/bin/
      rm -rf rio-#{RIO_VERSION}-linux-amd64

      cp /vagrant/rio-server /etc/init.d/rio-server
      cd /etc/init.d
      ln -s rio-server S70rio-server
    EOT
  end
end
