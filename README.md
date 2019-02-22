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
Welcome to Barge 2.11.2, Docker version 1.10.3, build 20f81dd
[bargee@barge ~]$ cat /var/log/rio-server.log
time="2019-02-22T00:47:44Z" level=info msg="Starting Rio v0.0.4-rc6"
time="2019-02-22T00:47:45Z" level=info msg="Creating CRD listenconfigs.project.rio.cattle.io"
time="2019-02-22T00:47:45Z" level=info msg="Creating CRD services.rio.cattle.io"
time="2019-02-22T00:47:45Z" level=info msg="Creating CRD publicdomains.project.rio.cattle.io"
time="2019-02-22T00:47:45Z" level=info msg="Creating CRD configs.rio.cattle.io"
time="2019-02-22T00:47:45Z" level=info msg="Creating CRD features.project.rio.cattle.io"
time="2019-02-22T00:47:45Z" level=info msg="Creating CRD routesets.rio.cattle.io"
time="2019-02-22T00:47:45Z" level=info msg="Creating CRD settings.project.rio.cattle.io"
time="2019-02-22T00:47:45Z" level=info msg="Creating CRD volumes.rio.cattle.io"
time="2019-02-22T00:47:45Z" level=info msg="Creating CRD stacks.rio.cattle.io"
time="2019-02-22T00:47:45Z" level=info msg="Creating CRD externalservices.rio.cattle.io"
time="2019-02-22T00:47:46Z" level=info msg="Creating CRD gateways.networking.istio.io"
time="2019-02-22T00:47:46Z" level=info msg="Creating CRD virtualservices.networking.istio.io"
time="2019-02-22T00:47:47Z" level=info msg="Creating CRD destinationrules.networking.istio.io"
time="2019-02-22T00:47:47Z" level=info msg="Creating CRD serviceentries.networking.istio.io"
time="2019-02-22T00:47:47Z" level=info msg="Creating CRD servicescalerecommendations.rio-autoscale.cattle.io"
time="2019-02-22T00:47:48Z" level=info msg="Starting feature stack"
time="2019-02-22T00:47:48Z" level=info msg="Starting feature letsencrypt"
time="2019-02-22T00:47:48Z" level=info msg="Listening on :7443"
time="2019-02-22T00:47:48Z" level=info msg="Listening on :7080"
time="2019-02-22T00:47:48Z" level=info msg="Client token is available at /var/lib/rancher/rio/server/client-token"
time="2019-02-22T00:47:48Z" level=info msg="Node token is available at /var/lib/rancher/rio/server/node-token"
time="2019-02-22T00:47:48Z" level=info msg="To use CLI: rio login -s https://192.168.0.9:7443 -t R10c330e754df949ac42c0f242faf85641d40e76d3400a713f60ca7fd41f8d32adc::admin:f3388348ce30284e58916d692ae477cf"
time="2019-02-22T00:47:48Z" level=info msg="To join node to cluster: rio agent -s https://192.168.0.9:7443 -t R10c330e754df949ac42c0f242faf85641d40e76d3400a713f60ca7fd41f8d32adc::node:e8cae53bf26965a9b60956b250e8bad3"
time="2019-02-22T00:47:49Z" level=info msg="Agent starting, logging to /var/lib/rancher/rio/agent/agent.log"
time="2019-02-22T00:47:49Z" level=info msg="Starting feature rdns"
time="2019-02-22T00:47:49Z" level=info msg="Starting feature routing"
time="2019-02-22T00:47:51Z" level=info msg="Handling backend connection request [barge]"
[bargee@barge ~]$ rio login -s https://192.168.0.9:7443 -t R10c330e754df949ac42c0f242faf85641d40e76d3400a713f60ca7fd41f8d32adc::admin:f3388348ce30284e58916d692ae477cf
INFO[0000] Log in successful
[bargee@barge ~]$ rio kubectl get nodes
NAME    STATUS   ROLES    AGE   VERSION
barge   Ready    <none>   21s   v1.12.2-lite4
```

## Try an example

https://github.com/rancher/rio/blob/master/README.md#rio-stage-options-service_id_name

```
[bargee@barge ~]$ rio run -p 80/http --name test/svc --scale=3 ibuildthecloud/demo:v1
test-3739a4f2:svc
[bargee@barge ~]$ rio ps
NAME       IMAGE                    CREATED          SCALE     STATE     ENDPOINT                                         EXTERNAL   DETAIL
test/svc   ibuildthecloud/demo:v1   59 seconds ago   3         active    https://svc-test-km4l9.vt3gnv.lb.rancher.cloud
[bargee@barge ~]$ wget -qO- http://svc-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World
[bargee@barge ~]$ rio stage --image=ibuildthecloud/demo:v3 test/svc:v3
test-3739a4f2:svc-v3
[bargee@barge ~]$ rio ps
NAME          IMAGE                    CREATED          SCALE     STATE     ENDPOINT                                            EXTERNAL   DETAIL
test/svc:v3   ibuildthecloud/demo:v3   11 seconds ago   3         active    https://svc-v3-test-km4l9.vt3gnv.lb.rancher.cloud
test/svc      ibuildthecloud/demo:v1   5 minutes ago    3         active    https://svc-test-km4l9.vt3gnv.lb.rancher.cloud
[bargee@barge ~]$ wget -qO- http://svc-v3-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World v3
[bargee@barge ~]$ rio export test
services:
  svc:
    image: ibuildthecloud/demo:v1
    ports:
    - 80/http
    revisions:
      v3:
        image: ibuildthecloud/demo:v3
        ports:
        - 80/http
        scale: 3
    scale: 3
[bargee@barge ~]$ rio weight test/svc:v3=50%
test-3739a4f2:svc-v3
[bargee@barge ~]$ wget -qO- http://svc-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World v3
[bargee@barge ~]$ wget -qO- http://svc-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World
[bargee@barge ~]$ rio promote test/svc:v3
test-3739a4f2:svc-v3
[bargee@barge ~]$ wget -qO- http://svc-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World v3
[bargee@barge ~]$ wget -qO- http://svc-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World v3
```
