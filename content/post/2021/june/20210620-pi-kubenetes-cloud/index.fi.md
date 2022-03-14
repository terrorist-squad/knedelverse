+++
date = "2021-06-20"
title = "Hienoja asioita konttien kanssa: Kubenetes-klusteri ja NFS-tallennustila"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.fi.md"
+++
Tänään olen asentamassa uutta Kubenetes-klusteria ja tekemistä riittää!
{{< gallery match="images/1/*.jpg" >}}
Olen tilannut näitä komponentteja sitä varten:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x tuuletin, kaksi: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Vadelma 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x virtalähteet: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x 600 kpl Dupont-tulppasarja: https://amzn.to/3kcfYqQ
- 1x vihreä LED sarjavastuksella: https://amzn.to/3EQgXVp
- 1x sininen LED sarjavastuksella: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blanking piece Musta: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x lampun kanta: https://amzn.to/3H0UZkG
## Mennään!

{{< youtube ulzMoX-fpvc >}}
Olen luonut oman kuvan asennusta varten Raspian Lite -asennuksen pohjalta. Käyttäjä/julkinen avaimeni on jo tallennettu tähän kuvaan, ja tiedosto "/boot/config.txt" on mukautettu LEDejäni varten.
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

## Palvelin 1 - Kiinnitä levyke
Asennan ensin NFS-palvelun palvelimelle 1. Tätä tallennustilaa voidaan käyttää myöhemmin konttiklusterissani. Liitin USB-kiintolevyn "Server 1" -asemaan ja alustin sen EXT4-formaattiin seuraavien ohjeiden avulla: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Sitten loin USB-levylle liitäntäpisteen:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Olen syöttänyt uuden tiedostojärjestelmän tiedostoon "/etc/fstab" seuraavasti:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Asetukset voidaan tarkistaa komennolla "sudo mount -a". Nyt USB-levyn pitäisi olla asennettuna osoitteeseen "/media/usb-disk".
##  Asenna NFS
Tämä paketti tarvitaan NFS:ää varten:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
> Lisäksi USB-levylle luotiin uusi kansio.
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Tällöin tiedostoa "/etc/exports" on muokattava. Polku, käyttäjätunnus ja ryhmätunnus syötetään sinne:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
> Nyt asetus voidaan tehdä seuraavasti.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Miten voin liittää NFS:n?
Voin asentaa aseman seuraavasti:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Tai kirjoita pysyvästi tiedostoon "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Tässäkin tapauksessa voin käyttää komentoa "sudo mount -a".
## Asenna Kubernetes
Seuraavat komennot on suoritettava palvelimilla 1, 2 ja 3. Asennetaan ensin Docker ja lisätään käyttäjä "PI" Docker-ryhmään.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Tämän jälkeen swap-kokoasetus nollataan kaikilla palvelimilla. Tämä tarkoittaa, että muokkaan tiedostoa "/etc/dphys-swapfile" ja asetan attribuutin "CONF_SWAPSIZE" arvoksi "0".
{{< gallery match="images/4/*.png" >}}
>Lisäksi "/boot/cmdline.txt"-tiedostossa olevia "Control-Group"-asetuksia on muutettava:
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Katso:
{{< gallery match="images/5/*.png" >}}
>Nyt kaikkien Raspberrys-levyjen pitäisi käynnistyä uudelleen kerran, ja ne ovat valmiita Kubernetes-asennukseen.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Uudelleenkäynnistyksen jälkeen asennan nämä paketit palvelimelle 1, palvelimelle 2 ja palvelimelle 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Vain palvelin 1
Nyt Kubenetes master voidaan alustaa.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Kun alustaminen on onnistunut, hyväksyn asetukset. Muistan näytetyn "kubeadm join" -komennon työläissolmujen yhdistämiseksi.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Valitettavasti verkolle on nyt tehtävä jotain.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Komennon "kubectl get nodes" pitäisi nyt näyttää "Master" tilassa "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Lisää solmuja
Nyt tarvitsemme "kubeadm join" -komennon Kubenetesin alustuksesta. Syötän tämän komennon palvelimille "Server 2" ja "Server 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Jos nyt annan komennon "kubectl get nodes" palvelimelta 1 uudelleen, nämä solmut näkyvät todennäköisesti tilassa "Not Ready". Tässäkin tapauksessa on kyse verkko-ongelmasta, joka myös isännällä oli. Suoritan edellisen komennon uudelleen, mutta tällä kertaa lisään "f"-merkin force.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Tämän jälkeen kaikki solmut ovat valmiina käyttöön.
{{< gallery match="images/6/*.png" >}}

## Pieni testikanta (Palvelin 1/Kubenetes-Master)
Kirjoitan itselleni pienen testikäytön ja tarkistan toiminnot. Luon tiedoston "nginx.yml", jonka sisältö on seuraava:
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
Nyt minä aloitan varusmiespalvelun:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Hienoa!
{{< gallery match="images/7/*.png" >}}
Luon palvelun ja voin kutsua konttiani.
{{< gallery match="images/8/*.png" >}}
Laajennan kerran 20 "replikaatioon":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Katso:
{{< gallery match="images/9/*.png" >}}

## Siivoa testivarasto
Siivotakseni tilanteen poistan varoituksen ja palvelun uudelleen.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Katso:
{{< gallery match="images/10/*.png" >}}
