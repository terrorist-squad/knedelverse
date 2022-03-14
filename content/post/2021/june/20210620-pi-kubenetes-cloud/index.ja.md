+++
date = "2021-06-20"
title = "コンテナの優れた点：KubenetesクラスタとNFSストレージ"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.ja.md"
+++
今日は新しいKubenetesクラスターをインストールしていますが、やることがたくさんあります。
{{< gallery match="images/1/*.jpg" >}}
そのためにこれらの部品を注文しました。
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3xファン、デュアル： https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3xパワーサプライユニット: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x ラックマウント: https://amzn.to/3H8vOg7
- 1x 600 pieces Dupont plug kit: https://amzn.to/3kcfYqQ
- 1x グリーンLED（直列抵抗付き）: https://amzn.to/3EQgXVp
- 1x 青色LED（直列抵抗付き）: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blanking piece Black: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1xランプベース: https://amzn.to/3H0UZkG
## 頑張ろう!

{{< youtube ulzMoX-fpvc >}}
Raspian Liteのインストールをベースに、インストール用のイメージを独自に作成しました。私のユーザー/公開鍵はすでにこのイメージに保存されており、「/boot/config.txt」ファイルは私のLED用に調整されています。
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

## サーバー1 - ディスクのマウント
まず、「サーバー1」にNFSサービスをインストールします。このストレージは、後で私のコンテナクラスタに使用することができます。USBハードディスクを「サーバー1」に接続し、以下の説明を参考にEXT4でフォーマットしました。https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
そして、USBディスクのマウントポイントを作成しました。
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
新しいファイルシステムを「/etc/fstab」ファイルに以下のように入力しました。
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
この設定は「sudo mount -a」で確認できます。これで、USBディスクが「/media/usb-disk」にマウントされるはずです。
## NFSのインストール
このパッケージはNFSに必要です。
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>さらに、USBディスク上に新しいフォルダが作成されました。
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>続いて、「/etc/exports」ファイルを編集する必要があります。そこにパス、ユーザーID、グループIDを入力します。
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>これで、以下のような設定が可能になります。
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
## NFSをマウントするにはどうすればいいですか？
以下のようにボリュームをマウントできます。
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
または、「/etc/fstab」ファイルに永久に入力してください。
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
ここでも、「sudo mount -a」が使えます。
## Kubernetesのインストール
以下のコマンドをサーバー1、サーバー2、サーバー3で実行する必要があります。まず、Dockerをインストールし、ユーザー「PI」をDockerグループに追加します。
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>その後、すべてのサーバーでスワップサイズの設定がゼロになります。つまり、「/etc/dphys-swapfile」ファイルを編集して、「CONF_SWAPSIZE」という属性を「0」に設定するのです。
{{< gallery match="images/4/*.png" >}}
>また、「/boot/cmdline.txt」ファイルの「Control-Group」の設定を調整する必要があります。
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
見てください。
{{< gallery match="images/5/*.png" >}}
>これで、すべてのRaspberryが一度再起動し、Kubernetesをインストールする準備が整いました。
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>再起動後、これらのパッケージをサーバー1、サーバー2、サーバー3にインストールします。
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # サーバー1のみ
これでKubenetesのマスターが初期化されました。
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
初期化に成功した後、設定を受け入れます。ワーカーノードを接続するための「kubeadm join」コマンドが表示されていたのを覚えています。
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
今は残念ながら、ネットワークのために何かをしなければなりません。
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>kubectl get nodes "コマンドを実行すると、"Master "が "Ready "状態で表示されるようになりました。
{{< gallery match="images/6/*.png" >}}

## Kubernetes - ノードの追加
ここで、Kubenetesの初期化にあった「kubeadm join」コマンドが必要になります。このコマンドを「サーバー2」と「サーバー3」に入力します。
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
ここで再び「サーバー1」から「kubectl get nodes」というコマンドを入力すると、これらのノードはおそらく「Not Ready」というステータスで表示される。ここにも、マスターが抱えていたネットワークの問題がある。再度、先ほどのコマンドを実行しますが、今度はforceの "f "を追加します。
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>その後、すべてのノードが使用可能な状態になっているのがわかります。
{{< gallery match="images/6/*.png" >}}

## 小規模なテスト設備（Server 1/Kubenetes-Master）
自分で小さなテストデプロイメントを書いて、機能をチェックします。以下の内容の「nginx.yml」ファイルを作成します。
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
今、私はデプリーションを始めています。
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>素晴らしいですね。
{{< gallery match="images/7/*.png" >}}
サービスを作成し、自分のコンテナを呼び出すことができます。
{{< gallery match="images/8/*.png" >}}
私は一度、20個の「レプリカ」にスケールアップしています。
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>ご覧ください。
{{< gallery match="images/9/*.png" >}}

## テスト部門のクリーンアップ
整理するために、deplymentとserviceを再度削除します。
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>ご覧ください。
{{< gallery match="images/10/*.png" >}}
