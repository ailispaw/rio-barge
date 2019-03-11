# Rio on Barge with Vagrant/VirtualBox

[Rio](https://github.com/rancher/rio)

> Rio is a user oriented end-to-end container solution with a focus on keeping containers simple and combating the current trend of complexity.

This repo creates the Standalone mode Rio environment on [Barge](https://github.com/bargees/barge-os) with [Vagrant](https://www.vagrantup.com/) locally and instantly.

## Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Boot up

```
$ vagrant up
```

## Login to the Rio server

```
$ vagrant ssh master
Welcome to Barge 2.12.0, rio version v0.0.4-rc6
[bargee@master ~]$ kubectl get nodes -o wide
NAME     STATUS   ROLES    AGE   VERSION         INTERNAL-IP    EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION   CONTAINER-RUNTIME
master   Ready    <none>   7s    v1.12.2-lite4   192.168.0.54   <none>        Barge 2.12.0   4.14.105-barge   containerd://1.1.4
```

## Try an example

https://github.com/rancher/rio/blob/master/README.md#rio-stage-options-service_id_name

```
[bargee@master ~]$ rio run -p 80/http --name test/svc --scale=3 ibuildthecloud/demo:v1
test-3739a4f2:svc
[bargee@master ~]$ rio ps
NAME       IMAGE                    CREATED          SCALE     STATE     ENDPOINT                                         EXTERNAL   DETAIL
test/svc   ibuildthecloud/demo:v1   59 seconds ago   3         active    https://svc-test-km4l9.vt3gnv.lb.rancher.cloud
[bargee@master ~]$ wget -qO- http://svc-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World
[bargee@master ~]$ rio stage --image=ibuildthecloud/demo:v3 test/svc:v3
test-3739a4f2:svc-v3
[bargee@master ~]$ rio ps
NAME          IMAGE                    CREATED          SCALE     STATE     ENDPOINT                                            EXTERNAL   DETAIL
test/svc:v3   ibuildthecloud/demo:v3   11 seconds ago   3         active    https://svc-v3-test-km4l9.vt3gnv.lb.rancher.cloud
test/svc      ibuildthecloud/demo:v1   5 minutes ago    3         active    https://svc-test-km4l9.vt3gnv.lb.rancher.cloud
[bargee@master ~]$ wget -qO- http://svc-v3-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World v3
[bargee@master ~]$ rio export test
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
[bargee@master ~]$ rio weight test/svc:v3=50%
test-3739a4f2:svc-v3
[bargee@master ~]$ wget -qO- http://svc-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World v3
[bargee@master ~]$ wget -qO- http://svc-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World
[bargee@master ~]$ rio promote test/svc:v3
test-3739a4f2:svc-v3
[bargee@master ~]$ wget -qO- http://svc-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World v3
[bargee@master ~]$ wget -qO- http://svc-test-km4l9.vt3gnv.lb.rancher.cloud
Hello World v3
```
