# Rio on Barge with Vagrant/VirtualBox

[Rio](https://github.com/rancher/rio)

> Rio is a user oriented end-to-end container solution with a focus on keeping containers simple and combating the current trend of complexity.

This repo creates the Standalone mode Rio environment on [Barge](https://github.com/bargees/barge-os) with [Vagrant](https://www.vagrantup.com/) locally and instantly.

## Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Provision a VM for Rio

```
$ make provision
```

It will provision a VM with `vagrant up` and install the `rio` binary, and then halt it to set the first network interface bridged to the public.

## Start the VM

```
$ make up
```

It will boot up the VM.

## Start the Rio server

```
$ make ssh
Welcome to Barge 2.10.1, Docker version 1.10.3, build 20f81dd
[bargee@barge ~]$ sudo rio server
INFO[0000] Starting Rio a3cf940a
INFO[0008] Creating CRD gateways.networking.istio.io
INFO[0008] Creating CRD virtualservices.networking.istio.io
INFO[0008] Waiting for CRD gateways.networking.istio.io to become available
INFO[0008] Done waiting for CRD gateways.networking.istio.io to become available
INFO[0008] Waiting for CRD virtualservices.networking.istio.io to become available
INFO[0009] Done waiting for CRD virtualservices.networking.istio.io to become available
INFO[0009] Creating CRD listenconfigs.space.cattle.io
INFO[0009] Creating CRD services.rio.cattle.io
INFO[0009] Creating CRD configs.rio.cattle.io
INFO[0009] Creating CRD routesets.rio.cattle.io
INFO[0009] Waiting for CRD listenconfigs.space.cattle.io to become available
INFO[0009] Creating CRD volumes.rio.cattle.io
INFO[0009] Creating CRD stacks.rio.cattle.io
INFO[0009] Done waiting for CRD listenconfigs.space.cattle.io to become available
INFO[0010] Listening on :7443
INFO[0010] Listening on :7080
INFO[0010] Client token is available at /var/lib/rancher/rio/server/client-token
INFO[0010] Node token is available at /var/lib/rancher/rio/server/node-token
INFO[0010] To use CLI: rio login -s https://192.168.0.7:7443 -t R107d2fa73064c45d08cfe91f8187777d7b1dcd72910407050a5273c68f29cef24a::admin:bad0ec221906668b87591ec5e5469afd
INFO[0010] To join node to cluster: rio agent -s https://192.168.0.7:7443 -t R107d2fa73064c45d08cfe91f8187777d7b1dcd72910407050a5273c68f29cef24a::node:cf4451827d94b702596deeea4f5feda5
INFO[0011] Agent starting, logging to /var/lib/rancher/rio/agent/agent.log
```

And then at another terminal,

```
$ make ssh
Welcome to Barge 2.10.1, Docker version 1.10.3, build 20f81dd
[bargee@barge ~]$ rio login -s https://192.168.0.7:7443 -t R107d2fa73064c45d08cfe91f8187777d7b1dcd72910407050a5273c68f29cef24a::admin:bad0ec221906668b87591ec5e5469afd
INFO[0000] Log in successful
[bargee@barge ~]$ rio ps -c
NAME                                          IMAGE                      CREATED         NODE      IP          STATE     DETAIL
coredns/coredns/57fd7dc489-7l2wz              k8s.gcr.io/coredns:1.1.3   2 minutes ago   barge     10.42.0.4   running
istio/istio-citadel/66d5c755c8-4kktj          istio/citadel:1.0.0        2 minutes ago   barge     10.42.0.3   running
istio/istio-pilot/8db7845cf-hbm49/discovery   istio/pilot:1.0.0          2 minutes ago   barge     10.42.0.6   running
```
