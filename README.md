# Rio on Barge with Vagrant/VirtualBox

[Rio](https://github.com/rancher/rio)

> Rio is a user oriented end-to-end container solution with a focus on keeping containers simple and combating the current trend of complexity.

This repo creates the Rio environment on [Barge](https://github.com/bargees/barge-os) with [Vagrant](https://www.vagrantup.com/) locally and instantly.

## Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Boot up

It will create one Rio server node with its agent and two agent nodes by default.

Note) You may need to change NETWORK_ADAPTOR variable in Vagrantfile for your network.

```
$ vagrant up
```

## Login to the Rio server

```
$ vagrant ssh master
Welcome to Barge 2.12.0, rio version v0.0.4-rc6
[bargee@master ~]$ kubectl get nodes -o wide
NAME      STATUS   ROLES    AGE   VERSION         INTERNAL-IP    EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION   CONTAINER-RUNTIME
master    Ready    <none>   55s   v1.12.2-lite4   192.168.0.58   <none>        Barge 2.12.0   4.14.105-barge   containerd://1.1.4
node-01   Ready    <none>   38s   v1.12.2-lite4   192.168.0.59   <none>        Barge 2.12.0   4.14.105-barge   containerd://1.1.4
node-02   Ready    <none>   21s   v1.12.2-lite4   192.168.0.60   <none>        Barge 2.12.0   4.14.105-barge   containerd://1.1.4
```

## Try an example

https://github.com/rancher/rio/blob/master/README.md#rio-stage-options-service_id_name

```
[bargee@master ~]$ rio run -p 80/http --name test/svc --scale=3 ibuildthecloud/demo:v1
test-70dc44f5:svc
[bargee@master ~]$ rio ps
NAME       IMAGE                    CREATED          SCALE     STATE     ENDPOINT                                         EXTERNAL   DETAIL
test/svc   ibuildthecloud/demo:v1   39 seconds ago   3         active    https://svc-test-hwbbt.nbmpln.lb.rancher.cloud
[bargee@master ~]$ wget -qO- http://svc-test-hwbbt.nbmpln.lb.rancher.cloud
Hello World
[bargee@master ~]$ rio stage --image=ibuildthecloud/demo:v3 test/svc:v3
test-70dc44f5:svc-v3
[bargee@master ~]$ rio ps
NAME          IMAGE                    CREATED          SCALE     STATE     ENDPOINT                                            EXTERNAL   DETAIL
test/svc:v3   ibuildthecloud/demo:v3   50 seconds ago   3         active    https://svc-v3-test-hwbbt.nbmpln.lb.rancher.cloud
test/svc      ibuildthecloud/demo:v1   2 minutes ago    3         active    https://svc-test-hwbbt.nbmpln.lb.rancher.cloud
[bargee@master ~]$ kubectl get pods -n test-70dc44f5 -o wide
NAME                     READY   STATUS    RESTARTS   AGE     IP          NODE      NOMINATED NODE
svc-7984fcbd54-ksgbg     2/2     Running   0          2m27s   10.42.0.7   master    <none>
svc-7984fcbd54-nd874     2/2     Running   0          2m27s   10.42.2.2   node-02   <none>
svc-7984fcbd54-vb2rt     2/2     Running   0          2m27s   10.42.1.2   node-01   <none>
svc-v3-5b64dc86d-fr2sn   2/2     Running   0          42s     10.42.2.3   node-02   <none>
svc-v3-5b64dc86d-lt74d   2/2     Running   0          42s     10.42.1.3   node-01   <none>
svc-v3-5b64dc86d-s54j5   2/2     Running   0          42s     10.42.0.8   master    <none>
[bargee@master ~]$ wget -qO- http://svc-v3-test-hwbbt.nbmpln.lb.rancher.cloud
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
test-70dc44f5:svc-v3
[bargee@master ~]$ wget -qO- http://svc-test-hwbbt.nbmpln.lb.rancher.cloud
Hello World v3
[bargee@master ~]$ wget -qO- http://svc-test-hwbbt.nbmpln.lb.rancher.cloud
Hello World
[bargee@master ~]$ rio promote test/svc:v3
test-70dc44f5:svc-v3
[bargee@master ~]$ wget -qO- http://svc-test-hwbbt.nbmpln.lb.rancher.cloud
Hello World v3
[bargee@master ~]$ wget -qO- http://svc-test-hwbbt.nbmpln.lb.rancher.cloud
Hello World v3
```
