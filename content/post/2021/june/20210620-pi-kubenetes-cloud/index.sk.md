+++
date = "2021-06-20"
title = "Veľké veci s kontajnermi: Kubenetes cluster a ukladanie NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.sk.md"
+++
Dnes inštalujem nový cluster Kubenetes a mám toho veľa na práci!
{{< gallery match="images/1/*.jpg" >}}
Objednal som si preň tieto komponenty:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x ventilátor, duálny: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x napájacie jednotky: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x montáž do stojana: https://amzn.to/3H8vOg7
- 1x 600 kusov súpravy zátok Dupont: https://amzn.to/3kcfYqQ
- 1x zelená LED so sériovým odporom: https://amzn.to/3EQgXVp
- 1x modrá LED so sériovým odporom: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Zaslepovací kus Čierna: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x základňa lampy: https://amzn.to/3H0UZkG
## Poďme!

{{< youtube ulzMoX-fpvc >}}
Vytvoril som vlastný obraz pre inštaláciu na základe inštalácie Raspian Lite. Môj používateľský/verejný kľúč je už uložený v tomto obraze a súbor "/boot/config.txt" bol prispôsobený pre moje LED.
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

## Server 1 - pripojenie disku
Najprv nainštalujem službu NFS na server 1. Toto úložisko sa môže neskôr použiť pre môj kontajnerový klaster. Pripojil som pevný disk USB k "Serveru 1" a naformátoval ho EXT4 pomocou týchto pokynov: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Potom som vytvoril prípojný bod pre disk USB:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Nový súborový systém som zadal do súboru "/etc/fstab" takto:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Nastavenie môžete skontrolovať pomocou príkazu "sudo mount -a". Teraz by mal byť disk USB pripojený pod "/media/usb-disk".
##  Inštalácia systému NFS
Tento balík je potrebný pre systém NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
> Okrem toho bol na disku USB vytvorený nový priečinok
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Potom je potrebné upraviť súbor "/etc/exports". Zadáva sa tu cesta, ID používateľa a ID skupiny:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Najnovšie nastavenie je možné prijať takto.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Ako môžem pripojiť systém NFS?
Zväzok môžem pripojiť takto:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Alebo zadajte natrvalo do súboru "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Aj tu môžem použiť "sudo mount -a".
## Inštalácia služby Kubernetes
Nasledujúce príkazy sa musia vykonať na serveri 1, serveri 2 a serveri 3. Najprv nainštalujeme aplikáciu Docker a pridáme používateľa "PI" do skupiny Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Po tomto nastavení sa veľkosť swapu na všetkých serveroch vynuluje. To znamená, že upravím súbor "/etc/dphys-swapfile" a nastavím atribút "CONF_SWAPSIZE" na "0".
{{< gallery match="images/4/*.png" >}}
> Okrem toho je potrebné upraviť nastavenia "Control-Group" v súbore "/boot/cmdline.txt":
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Pozri:
{{< gallery match="images/5/*.png" >}}
>Nynie by sa mali všetky maliny raz reštartovať a potom sú pripravené na inštaláciu Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Po reštarte nainštalujem tieto balíky na server 1, server 2 a server 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Len server 1
Teraz je možné inicializovať hlavný modul Kubenetes.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Po úspešnej inicializácii akceptujem nastavenia. Pamätám si zobrazený príkaz "kubeadm join" na pripojenie pracovných uzlov.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Teraz je, žiaľ, potrebné niečo urobiť pre sieť.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Príkaz "kubectl get nodes" by mal teraz zobraziť "Master" v stave "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Pridanie uzlov
Teraz potrebujeme príkaz "kubeadm join" z inicializácie Kubenetes. Tento príkaz zadám na "Serveri 2" a "Serveri 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Ak teraz opäť zadám príkaz "kubectl get nodes" zo "Servera 1", tieto uzly sa pravdepodobne zobrazia v stave "Not Ready". Aj tu sa vyskytuje problém siete, ktorý mal aj majster. Znova spustím príkaz z predchádzajúceho postupu, ale tentoraz pridám písmeno "f" ako force.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Potom vidím všetky uzly pripravené na použitie.
{{< gallery match="images/6/*.png" >}}

## Malé testovacie nasadenie (Server 1/Kubenetes-Master)
Napíšem si malé testovacie nasadenie a skontrolujem funkcie. Vytvorím súbor "nginx.yml" s nasledujúcim obsahom:
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
Teraz začínam deplyment:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Skvelé!
{{< gallery match="images/7/*.png" >}}
Vytvorím službu a môžem vyvolať svoj kontajner.
{{< gallery match="images/8/*.png" >}}
Raz škálujem na 20 "replik":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Pozrite si:
{{< gallery match="images/9/*.png" >}}

## Vyčistiť testovacie deplyment
Ak chcete upratať, odstráňte deplyment a službu znova.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Pozrite si:
{{< gallery match="images/10/*.png" >}}

