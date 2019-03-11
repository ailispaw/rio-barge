# A dummy plugin for Barge to set hostname and network correctly at the very first `vagrant up`
module VagrantPlugins
  module GuestLinux
    class Plugin < Vagrant.plugin("2")
      guest_capability("linux", "change_host_name") { Cap::ChangeHostName }
      guest_capability("linux", "configure_networks") { Cap::ConfigureNetworks }
    end
  end
end

RIO_VERSION     = "v0.0.4-rc6"
NETWORK_ADAPTOR = "en0: Wi-Fi (Wireless)"
NUM_OF_NODES    = 2

Vagrant.configure(2) do |config|
  config.vm.box = "ailispaw/barge"
  config.vm.network :public_network, bridge: NETWORK_ADAPTOR, use_dhcp_assigned_default_route: true
  config.vm.synced_folder ".", "/vagrant", id: "vagrant"
  config.vm.provider :virtualbox do |vb|
    vb.cpus   = 2
    vb.memory = 2048
  end

  config.vm.provision :shell, run: "always" do |sh|
    sh.inline = <<-EOT
      # Ensure the default gateway is eth1
      route del default dev eth0 2>/dev/null || true
    EOT
  end

  config.vm.provision :shell do |sh|
    sh.inline = <<-EOT
      set -e

      # Stop Docker
      /etc/init.d/docker stop
      rm -f /etc/init.d/S60docker

      bash /vagrant/scripts/init2.sh
      cat /vagrant/scripts/init2.sh >> /etc/init.d/init.sh

      echo "Installing rio..."
      mkdir -p /vagrant/dl
      if [ ! -f "/vagrant/dl/rio-#{RIO_VERSION}-linux-amd64.tar.gz" ]; then
        wget -nv https://github.com/rancher/rio/releases/download/#{RIO_VERSION}/rio-#{RIO_VERSION}-linux-amd64.tar.gz -O /vagrant/dl/rio-#{RIO_VERSION}-linux-amd64.tar.gz
      fi
      tar xzf /vagrant/dl/rio-#{RIO_VERSION}-linux-amd64.tar.gz
      mv rio-#{RIO_VERSION}-linux-amd64/rio /opt/bin/
      rm -rf rio-#{RIO_VERSION}-linux-amd64

      source /etc/os-release
      echo "Welcome to ${PRETTY_NAME}, $(rio --version)" > /etc/motd
    EOT
  end

  config.vm.define "master" do |node|
    node.vm.hostname = "master.rio.local"
    node.vm.provision :shell do |sh|
      sh.inline = <<-EOT
        cd /etc/init.d
        cp /vagrant/scripts/rio-server rio-server
        ln -s rio-server S70rio-server
        /etc/init.d/rio-server start

        ifconfig eth1 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\\.){3}[0-9]*).*/\\2/p' > /vagrant/master-ip

        CLIENT_TOKEN="/var/lib/rancher/rio/server/client-token"
        while [ ! -f ${CLIENT_TOKEN} ]; do
          sleep 1
        done
        cp ${CLIENT_TOKEN} /vagrant/client-token

        NODE_TOKEN="/var/lib/rancher/rio/server/node-token"
        while [ ! -f ${NODE_TOKEN} ]; do
          sleep 1
        done
        cp ${NODE_TOKEN} /vagrant/node-token
      EOT
    end

    node.vm.provision :shell do |sh|
      sh.privileged = false
      sh.inline = <<-EOT
        rio login -s https://$(cat /vagrant/master-ip):7443 -t $(cat /vagrant/client-token)

        echo 'alias kubectl="rio kubectl"' >> ~/.bashrc
        echo 'alias ctr="sudo rio ctr"' >> ~/.bashrc

        rio kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl >/dev/null
      EOT
    end
  end

  (1..NUM_OF_NODES).each do |i|
    config.vm.define "node-%02d" % i do |node|
      node.vm.hostname = "node-%02d.rio.local" % i
      node.vm.provision :shell do |sh|
        sh.inline = <<-EOT
          echo "SERVER_URL=\\"https://$(cat /vagrant/master-ip):7443\\"" > /etc/default/rio-agent
          echo "NODE_TOKEN=\\"$(cat /vagrant/node-token)\\"" >> /etc/default/rio-agent

          cd /etc/init.d
          cp /vagrant/scripts/rio-agent rio-agent
          ln -s rio-agent S71rio-agent
          /etc/init.d/rio-agent start
        EOT
      end
    end
  end
end
