+++
date = "2021-06-20"
title = "コンテナですごいこと：KubenetesクラスタとNFSストレージ"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.ja.md"
+++
今日は新しいKubenetesクラスタをインストールするのですが、やることがたくさんあります。
{{< gallery match="images/1/*.jpg" >}}
そのために、これらの部品を注文しました。
- 1x WDBU6Y0050BBK WD Elements portable 5TB：https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x ファン、デュアル： https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram：https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x 電源ユニット： https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x ラックマウント: https://amzn.to/3H8vOg7
- 1x 600 pieces Dupont plug kit: https://amzn.to/3kcfYqQ
- 直列抵抗付き緑色LED1個：https://amzn.to/3EQgXVp
- 直列抵抗付き青色LED 1個：https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blanking piece Black: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x ランプベース: https://amzn.to/3H0UZkG
## さあ、行こう！

{{< youtube ulzMoX-fpvc >}}
Raspian Liteのインストールをベースに、インストール用のイメージを独自に作成しました。私のユーザー/公開鍵はすでにこのイメージに保存されており、「/boot/config.txt」ファイルは私のLEDに適合するように作られています。
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

## サーバー1 - マウントディスク
まず、「Server 1」にNFSサービスをインストールする。このストレージは、後で私のコンテナ・クラスタに使用することができます。USBハードディスクを「サーバー1」に接続し、以下の説明を参考にEXT4でフォーマットしてみました。https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/。
{{< gallery match="images/3/*.jpg" >}}
そして、USBディスクのマウントポイントを作成しました。
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
新しいファイルシステムを「/etc/fstab」ファイルに以下のように入力しました。
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
sudo mount -a」で設定を確認できます。これで、USBディスクが「/media/usb-disk」以下にマウントされるはずです。
## NFSのインストール
このパッケージは、NFSに必要です。
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>さらに、USBディスクに新しいフォルダが作成されました
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>次に、"/etc/exports "ファイルを編集する必要があります。そこには、パス、ユーザーID、グループIDが入力されています。
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>これで、以下のように設定を採用することができます。
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
## NFSをマウントするにはどうしたらいいですか？
以下のように、ボリュームをマウントすることができます。
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
または、"/etc/fstab" ファイルに永久に入力します。
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
ここでも「sudo mount -a」が使える。
## Kubernetesのインストール
サーバー1、サーバー2、サーバー3では、以下のコマンドを実行する必要があります。まず、Dockerをインストールし、ユーザー「PI」をDockerグループに追加します。
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>その後、すべてのサーバーでスワップサイズの設定がゼロになります。つまり、「/etc/dphys-swapfile」ファイルを編集して、「CONF_SWAPSIZE」属性を「0」に設定するのです。
{{< gallery match="images/4/*.png" >}}
>また、「/boot/cmdline.txt」ファイルの「Control-Group」設定も調整する必要があります。
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
ご覧ください。
{{< gallery match="images/5/*.png" >}}
>これですべてのRaspberryが一度再起動し、Kubernetesをインストールする準備が整いました。
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
これでKubenetesのマスターが初期化できるようになりました。
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
初期化に成功した後、設定を受け入れる。ワーカーノードを接続するために表示される「kubeadm join」コマンドを覚えています。
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
さて、残念なことに、ネットワークのために何かしなければならないことがあります。
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>コマンド "kubectl get nodes" で "Master" が "Ready" 状態であることが表示されるようになりました。
{{< gallery match="images/6/*.png" >}}

## Kubernetes - ノードの追加
ここで、Kubenetesの初期化で出てきた「kubeadm join」コマンドを用意します。このコマンドを「サーバー2」と「サーバー3」に入力します。
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
ここで再度「Server 1」から「kubectl get nodes」コマンドを入力すると、これらのノードはおそらく「Not Ready」というステータスで表示されます。ここにも、マスターが抱えていたネットワークの問題がある。もう一度、先ほどのコマンドを実行しますが、今度はforceの「f」を追加します。
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>その後、すべてのノードが使用可能な状態になっているのがわかります。
{{< gallery match="images/6/*.png" >}}

## 小規模テスト運用（サーバー1/Kubenetes-Master）
自分で小さなテストデプロイメントを書いて、機能を確認します。以下の内容で「nginx.yml」ファイルを作成します。
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
今、私はディプリーションを開始します。
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>グレート!
{{< gallery match="images/7/*.png" >}}
サービスを作成し、コンテナを呼び出すことができるんだ。
{{< gallery match="images/8/*.png" >}}
20個の「レプリカ」まで一旦スケールアップしています。
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>ご覧ください。
{{< gallery match="images/9/*.png" >}}

## テストデプリメントのクリーンアップ
片付けるために、deplymentとserviceを再度削除します。
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>ご覧ください。
{{< gallery match="images/10/*.png" >}}

