+++
date = "2021-06-20"
title = "Nagyszerű dolgok konténerekkel: Kubenetes fürt és NFS tárolás"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.hu.md"
+++
Ma egy új Kubenetes fürtöt telepítek, és sok a tennivaló!
{{< gallery match="images/1/*.jpg" >}}
Megrendeltem hozzá ezeket az alkatrészeket:
- 1x WDBU6Y0050BBK WD Elements hordozható 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x ventilátor, kettős: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x tápegység: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x 600 darab Dupont dugókészlet: https://amzn.to/3kcfYqQ
- 1x zöld LED soros ellenállással: https://amzn.to/3EQgXVp
- 1x kék LED soros ellenállással: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blanking piece Fekete: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x lámpabúra: https://amzn.to/3H0UZkG
## Gyerünk!

{{< youtube ulzMoX-fpvc >}}
A Raspian Lite telepítés alapján létrehoztam a saját telepítési képemet. A felhasználói/nyilvános kulcsom már eleve ebben a képben van tárolva, és a "/boot/config.txt" fájl az én LED-jeimhez lett igazítva.
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

## Server 1 - Lemez csatlakoztatása
Először is, telepítek egy NFS szolgáltatást az "1. kiszolgálóra". Ez a tároló később a konténer fürtömhöz használható. Csatlakoztattam az USB merevlemezt a "Server 1"-hez, és az alábbi utasítások segítségével formáztam EXT4-re: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Ezután létrehoztam egy csatolási pontot az USB lemezhez:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Az új fájlrendszert az "/etc/fstab" fájlba a következőképpen írtam be:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
A beállítás a "sudo mount -a" paranccsal ellenőrizhető. Most az USB-lemezt a "/media/usb-disk" címre kell csatlakoztatni.
##  NFS telepítése
Ez a csomag szükséges az NFS-hez:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
> Ezenkívül egy új mappát hoztunk létre az USB lemezen.
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Ezután az "/etc/exports" fájlt kell szerkeszteni. Az elérési útvonal, a felhasználói azonosító és a csoport azonosítója itt kerül megadásra:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Az alábbi módon fogadható el a beállítás.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Hogyan tudom csatlakoztatni az NFS-t?
A kötetet a következőképpen tudom csatlakoztatni:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Vagy adja meg véglegesen az "/etc/fstab" fájlban:
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Itt is használhatom a "sudo mount -a" parancsot.
## Kubernetes telepítése
A következő parancsokat az 1-es, 2-es és 3-as kiszolgálón kell végrehajtani. Először telepítjük a Dockert, és hozzáadjuk a "PI" felhasználót a Docker csoporthoz.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Ezután a swap méret beállítása minden kiszolgálón nullázódik. Ez azt jelenti, hogy szerkesztem az "/etc/dphys-swapfile" fájlt, és a "CONF_SWAPSIZE" attribútumot "0"-ra állítom.
{{< gallery match="images/4/*.png" >}}
>Ezeken kívül a "/boot/cmdline.txt" fájlban a "Control-Group" beállításokat is ki kell igazítani:
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Lásd:
{{< gallery match="images/5/*.png" >}}
> Most minden Raspberrynek egyszer újra kell indulnia, és készen áll a Kubernetes telepítésére.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Az újraindítás után telepítem ezeket a csomagokat az 1-es, 2-es és 3-as szerverre:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Csak az 1-es szerver
Most már inicializálható a Kubenetes master.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
A sikeres inicializálás után elfogadom a beállításokat. Emlékszem a megjelenített "kubeadm join" parancsra a munkás csomópontok összekapcsolásához.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Most sajnos valamit tenni kell a hálózatért.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>A "kubectl get nodes" parancsnak mostantól a "Master"-t "Ready" státuszban kell mutatnia.
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Csomópontok hozzáadása
Most szükségünk van a "kubeadm join" parancsra a Kubenetes inicializálásból. Ezt a parancsot a "Server 2" és a "Server 3" szervereken adom meg.
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Ha most újra megadom a "kubectl get nodes" parancsot az "1. kiszolgálóról", ezek a csomópontok valószínűleg a "Not Ready" státuszban jelennek meg. Itt is fennáll az a hálózati probléma, amellyel a mester is küzdött. Újra lefuttatom az előző parancsot, de ezúttal egy "f"-et adok hozzá a force szóhoz.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Ezután az összes csomópont készen áll a használatra.
{{< gallery match="images/6/*.png" >}}

## Kis teszt telepítés (Server 1/Kubenetes-Master)
Írok magamnak egy kis teszt telepítést és ellenőrzöm a funkciókat. Létrehozok egy "nginx.yml" fájlt a következő tartalommal:
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
Most kezdem a deplymentet:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Nagyszerű!
{{< gallery match="images/7/*.png" >}}
Létrehozok egy szolgáltatást, és meg tudom hívni a konténeremet.
{{< gallery match="images/8/*.png" >}}
Egyszer 20 "replikára" méretezem fel:
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>See:
{{< gallery match="images/9/*.png" >}}

## Tiszta tesztelés
A rendrakáshoz újra törlöm a függőséget és a szolgáltatást.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>See:
{{< gallery match="images/10/*.png" >}}
