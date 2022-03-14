+++
date = "2021-06-20"
title = "容器的伟大之处：Kubenetes集群和NFS存储"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.zh.md"
+++
今天我正在安装一个新的Kubenetes集群，有很多事情要做。
{{< gallery match="images/1/*.jpg" >}}
我已经为它订购了这些部件。
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x风扇，双：https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2xRaspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3个电源单元: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x 机架式：https://amzn.to/3H8vOg7
- 1x 600件杜邦插头套件：https://amzn.to/3kcfYqQ
- 1x绿色LED，带串联电阻：https://amzn.to/3EQgXVp
- 1x蓝色LED，带串联电阻：https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blanking piece 黑色: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1个灯座：https://amzn.to/3H0UZkG
## 我们走吧!

{{< youtube ulzMoX-fpvc >}}
我在Raspian Lite安装的基础上创建了自己的安装镜像。我的用户/公钥已经存储在这个镜像中，"/boot/config.txt "文件已经为我的LED做了调整。
```
# meine Server brauchen kein HDMI, WLAN und Bluetooth
dtoverlay=disable-bt
dtoverlay=disable-wifi
disable_splash=1
hdmi_blanking=1
hdmi_ignore_hotplug=1
hdmi_ignore_composite=1
 
 
# Status-LEDs an GPIO weiterleiten
dtoverlay=act-led,gpio=21
dtparam=act_led_trigger=cpu0

```

## 服务器1 - 安装磁盘
首先，我在 "服务器1 "上安装一个NFS服务。这个存储以后可以用于我的容器集群。我将USB硬盘连接到 "服务器1"，并在这些说明的帮助下格式化了EXT4：https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
然后我为U盘创建了一个挂载点。
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
我在"/etc/fstab "文件中输入了新的文件系统，如下所示。
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
可以用 "sudo mount -a "检查该设置。现在U盘应该被挂载在"/media/usb-disk "下。
## 安装NFS
这个软件包是NFS所需要的。
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>此外，在U盘上创建了一个新的文件夹。
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>然后必须编辑"/etc/exports "文件。在这里输入路径、用户ID和组ID。
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>现在可以采用如下设置。
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
## 我怎样才能装载NFS？
我可以按以下方式装载该卷。
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
或者在"/etc/fstab "文件中永久输入。
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
在这里，我也可以使用 "sudo mount -a"。
## 安装Kubernetes
以下命令必须在服务器1、服务器2和服务器3上执行。首先，我们安装Docker并将用户 "PI "添加到Docker组。
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>此后，所有服务器上的交换量设置都被清零。这意味着我编辑"/etc/dphys-swapfile "文件，将属性 "CONF_SWAPSIZE "设置为 "0"。
{{< gallery match="images/4/*.png" >}}
>此外，"/boot/cmdline.txt "文件中的 "控制组 "设置必须调整。
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
见。
{{< gallery match="images/5/*.png" >}}
>现在，所有树莓果应该重新启动一次，然后为Kubernetes安装做好准备。
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>重启后，我在服务器1、服务器2和服务器3上安装这些软件包。
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # 仅限服务器1
现在，Kubenetes主站可以被初始化。
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
初始化成功后，我接受了设置。我记得显示的 "kubeadm join "命令用于连接工作节点。
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
现在，不幸的是，必须为网络做一些事情。
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>命令 "kubectl get nodes "现在应该显示 "Master "处于 "Ready "状态。
{{< gallery match="images/6/*.png" >}}

## Kubernetes - 添加节点
现在我们需要Kubenetes初始化中的 "kubeadm join "命令。我在 "服务器2 "和 "服务器3 "上输入这个命令。
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
如果我现在再次从 "服务器1 "输入 "kubectl get nodes "命令，这些节点可能显示为 "Not Ready "状态。在这里，也有主人也有的网络问题。我再次运行之前的命令，但这次我添加了一个 "f "表示强制。
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>之后，我看到所有的节点都可以使用了。
{{< gallery match="images/6/*.png" >}}

## 小规模测试部署（服务器1/Kubenetes-Master）。
我自己写了一个小的测试部署并检查功能。我创建了一个 "nginx.yml "文件，内容如下。
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx
spec:
 selector:
   matchLabels:
     run: my-nginx
 replicas: 2
 template:
   metadata:
     labels:
       run: my-nginx
   spec:
     containers:
     - name: my-nginx
       image: nginx
       ports:
       - containerPort: 80

```
现在，我开始着手处理这个问题。
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>很好!
{{< gallery match="images/7/*.png" >}}
我创建了一个服务，可以调用我的容器。
{{< gallery match="images/8/*.png" >}}
我曾将规模扩大到20个 "副本"。
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>见。
{{< gallery match="images/9/*.png" >}}

## 清理测试部门
为了整顿，我再次删除了该部门和该服务。
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>见。
{{< gallery match="images/10/*.png" >}}
