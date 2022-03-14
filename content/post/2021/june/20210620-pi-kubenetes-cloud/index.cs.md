+++
date = "2021-06-20"
title = "Skvělé věci s kontejnery: cluster Kubenetes a úložiště NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210620-pi-kubenetes-cloud/index.cs.md"
+++
Dnes instaluji nový cluster Kubenetes a je toho hodně!
{{< gallery match="images/1/*.jpg" >}}
Objednal jsem pro něj tyto komponenty:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x ventilátor, duální: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x napájecí zdroj: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x montáž do stojanu: https://amzn.to/3H8vOg7
- 1x sada 600 kusů zátek Dupont: https://amzn.to/3kcfYqQ
- 1x zelená LED se sériovým odporem: https://amzn.to/3EQgXVp
- 1x modrá LED se sériovým odporem: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 záslepka Černá: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x patice lampy: https://amzn.to/3H0UZkG
## Jdeme na to!

{{< youtube ulzMoX-fpvc >}}
Vytvořil jsem vlastní obraz pro instalaci na základě instalace Raspian Lite. Můj uživatelský/veřejný klíč je již uložen v tomto obraze a soubor "/boot/config.txt" byl upraven pro mé LED.
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

## Server 1 - Připojení disku
Nejprve nainstaluji službu NFS na "Server 1". Toto úložiště lze později použít pro můj kontejnerový cluster. Připojil jsem pevný disk USB k "Serveru 1" a naformátoval ho EXT4 pomocí těchto pokynů: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/.
{{< gallery match="images/3/*.jpg" >}}
Poté jsem vytvořil přípojný bod pro disk USB:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Nový souborový systém jsem zadal do souboru "/etc/fstab" takto:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Nastavení lze zkontrolovat příkazem "sudo mount -a". Nyní by měl být disk USB připojen do složky "/media/usb-disk".
##  Instalace systému NFS
Tento balíček je vyžadován pro systém NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>Na disku USB byla navíc vytvořena nová složka.
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Poté je třeba upravit soubor "/etc/exports". Zde se zadává cesta, ID uživatele a ID skupiny:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Nyní lze nastavení přijmout takto.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Jak mohu připojit systém NFS?
Svazek mohu připojit následujícím způsobem:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Nebo zadejte trvale do souboru "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
I zde mohu použít příkaz "sudo mount -a".
## Instalace služby Kubernetes
Následující příkazy musí být provedeny na serveru 1, serveru 2 a serveru 3. Nejprve nainstalujeme Docker a přidáme uživatele "PI" do skupiny Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Poté se nastavení velikosti swapu na všech serverech vynuluje. To znamená, že upravím soubor "/etc/dphys-swapfile" a nastavím atribut "CONF_SWAPSIZE" na "0".
{{< gallery match="images/4/*.png" >}}
>Dále je třeba upravit nastavení "Control-Group" v souboru "/boot/cmdline.txt":
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Viz:
{{< gallery match="images/5/*.png" >}}
>Nyní by se měly všechny maliny jednou restartovat a poté jsou připraveny na instalaci Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Po restartu nainstaluji tyto balíčky na server 1, server 2 a server 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Pouze server 1
Nyní lze inicializovat hlavní modul Kubenetes.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Po úspěšné inicializaci přijímám nastavení. Vzpomínám si na zobrazený příkaz "kubeadm join" pro připojení pracovních uzlů.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Nyní je bohužel nutné pro síť něco udělat.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Příkaz "kubectl get nodes" by nyní měl zobrazit "Master" ve stavu "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Přidání uzlů
Nyní potřebujeme příkaz "kubeadm join" z inicializace Kubenetes. Tento příkaz zadám na "Serveru 2" a "Serveru 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Pokud nyní zadám příkaz "kubectl get nodes" ze "Serveru 1" znovu, tyto uzly se pravděpodobně zobrazí ve stavu "Not Ready". I zde se objevuje problém se sítí, který měl i mistr. Znovu spustím předchozí příkaz, ale tentokrát přidám písmeno "f" jako force.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Poté se zobrazí všechny uzly připravené k použití.
{{< gallery match="images/6/*.png" >}}

## Malé testovací zařízení (Server 1/Kubenetes-Master)
Napíšu si malé testovací nasazení a zkontroluji funkce. Vytvořím soubor "nginx.yml" s následujícím obsahem:
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
Nyní začínám s depilací:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Skvělé!
{{< gallery match="images/7/*.png" >}}
Vytvořím službu a mohu vyvolat svůj kontejner.
{{< gallery match="images/8/*.png" >}}
Jednou škáluju až na 20 "replik":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Podívejte se na:
{{< gallery match="images/9/*.png" >}}

## Vyčištění zkušebního provozu
Abych to uklidil, odstraním deplyment a službu znovu.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Podívejte se na:
{{< gallery match="images/10/*.png" >}}
