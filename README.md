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
[bargee@barge ~]$ cat /var/log/rio-server.log
time="2018-10-23T20:19:02Z" level=info msg="Starting Rio a3cf940a"
time="2018-10-23T20:19:10Z" level=info msg="Creating CRD gateways.networking.istio.io"
time="2018-10-23T20:19:10Z" level=info msg="Creating CRD virtualservices.networking.istio.io"
time="2018-10-23T20:19:10Z" level=info msg="Waiting for CRD gateways.networking.istio.io to become available"
time="2018-10-23T20:19:11Z" level=info msg="Done waiting for CRD gateways.networking.istio.io to become available"
time="2018-10-23T20:19:11Z" level=info msg="Waiting for CRD virtualservices.networking.istio.io to become available"
time="2018-10-23T20:19:11Z" level=info msg="Done waiting for CRD virtualservices.networking.istio.io to become available"
time="2018-10-23T20:19:11Z" level=info msg="Creating CRD listenconfigs.space.cattle.io"
time="2018-10-23T20:19:11Z" level=info msg="Creating CRD services.rio.cattle.io"
time="2018-10-23T20:19:11Z" level=info msg="Creating CRD configs.rio.cattle.io"
time="2018-10-23T20:19:11Z" level=info msg="Creating CRD routesets.rio.cattle.io"
time="2018-10-23T20:19:11Z" level=info msg="Waiting for CRD listenconfigs.space.cattle.io to become available"
time="2018-10-23T20:19:11Z" level=info msg="Creating CRD volumes.rio.cattle.io"
time="2018-10-23T20:19:11Z" level=info msg="Creating CRD stacks.rio.cattle.io"
time="2018-10-23T20:19:12Z" level=info msg="Done waiting for CRD listenconfigs.space.cattle.io to become available"
time="2018-10-23T20:19:12Z" level=info msg="Listening on :7443"
time="2018-10-23T20:19:12Z" level=info msg="Listening on :7080"
time="2018-10-23T20:19:12Z" level=info msg="Client token is available at /var/lib/rancher/rio/server/client-token"
time="2018-10-23T20:19:12Z" level=info msg="Node token is available at /var/lib/rancher/rio/server/node-token"
time="2018-10-23T20:19:12Z" level=info msg="To use CLI: rio login -s https://192.168.0.7:7443 -t R1034cf73f8b6279e2b379117923b2a1265b99788997dc82aa0daf81f036eed38c8::admin:267b469a0bb1cefb8be01a7a85ff4e99"
time="2018-10-23T20:19:12Z" level=info msg="To join node to cluster: rio agent -s https://192.168.0.7:7443 -t R1034cf73f8b6279e2b379117923b2a1265b99788997dc82aa0daf81f036eed38c8::node:e815c493ce5b4e7241cfe00a4cec80d6"
time="2018-10-23T20:19:14Z" level=info msg="Agent starting, logging to /var/lib/rancher/rio/agent/agent.log"
```

And then at another terminal,

```
$ make ssh
Welcome to Barge 2.10.1, Docker version 1.10.3, build 20f81dd
[bargee@barge ~]$ rio login -s https://192.168.0.7:7443 -t R1034cf73f8b6279e2b379117923b2a1265b99788997dc82aa0daf81f036eed38c8::admin:267b469a0bb1cefb8be01a7a85ff4e99
INFO[0001] Log in successful
[bargee@barge ~]$ rio ps -c
NAME                                          IMAGE                      CREATED              NODE      IP          STATE     DETAIL
coredns/coredns/57fd7dc489-424jc              k8s.gcr.io/coredns:1.1.3   About a minute ago   barge     10.42.0.4   running
istio/istio-citadel/66d5c755c8-2985k          istio/citadel:1.0.0        About a minute ago   barge     10.42.0.3   running
istio/istio-pilot/8db7845cf-9v4hm/discovery   istio/pilot:1.0.0          About a minute ago   barge     10.42.0.2   running
```
