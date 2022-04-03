+++
date = "2021-06-20"
title = "Store ting med containere: Kubenetes klynge og NFS-lagring"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.da.md"
+++
I dag installerer jeg en ny Kubenetes-klynge, og der er meget at gøre!
{{< gallery match="images/1/*.jpg" >}}
Jeg har bestilt disse komponenter til den:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x blæser, dobbelt: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x strømforsyningsenheder: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x 600 stk. Dupont plug kit: https://amzn.to/3kcfYqQ
- 1x grøn LED med seriemodstand: https://amzn.to/3EQgXVp
- 1x blå LED med seriemodstand: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blanking piece Sort: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x lampefod: https://amzn.to/3H0UZkG
## Lad os komme af sted!

{{< youtube ulzMoX-fpvc >}}
Jeg har lavet mit eget image til installationen baseret på Raspian Lite-installationen. Min bruger/offentlige nøgle er allerede gemt i dette image, og filen "/boot/config.txt" er blevet tilpasset til mine lysdioder.
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

## Server 1 - Monter disk
Først installerer jeg en NFS-tjeneste på "Server 1". Denne lagring kan senere bruges til min containerklynge. Jeg tilsluttede USB-harddisken til "Server 1" og formaterede den med EXT4 ved hjælp af disse instruktioner: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Derefter oprettede jeg et monteringspunkt for USB-disken:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Jeg har indtastet det nye filsystem i filen "/etc/fstab" på følgende måde:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Indstillingen kan kontrolleres med "sudo mount -a". Nu skal USB-disken monteres under "/media/usb-disk".
##  Installer NFS
Denne pakke er nødvendig for NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
> Desuden blev der oprettet en ny mappe på USB-disken
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Derpå skal filen "/etc/exports" redigeres. Her angives stien, bruger-id'et og gruppe-id'et:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Indstillingen kan nu indstilles på følgende måde.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Hvordan kan jeg montere NFS'en?
Jeg kan montere disken som følger:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Eller indtast permanent i filen "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Også her kan jeg bruge "sudo mount -a".
## Installer Kubernetes
Følgende kommandoer skal udføres på server 1, server 2 og server 3. Først installerer vi Docker og tilføjer brugeren "PI" til Docker-gruppen.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Efter dette er indstillingen for swap-størrelse nulstillet på alle servere. Det betyder, at jeg redigerer filen "/etc/dphys-swapfile" og sætter attributten "CONF_SWAPSIZE" til "0".
{{< gallery match="images/4/*.png" >}}
>Dertil kommer, at "Control-Group"-indstillingerne i filen "/boot/cmdline.txt" skal justeres:
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Se:
{{< gallery match="images/5/*.png" >}}
>Nu skal alle Raspberrys genstarte en gang og er derefter klar til Kubernetes-installationen.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Efter genstart installerer jeg disse pakker på server 1, server 2 og server 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Kun server 1
Nu kan Kubenetes master initialiseres.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Efter den vellykkede initialisering accepterer jeg indstillingerne. Jeg husker den viste "kubeadm join"-kommando til at forbinde arbejderknudepunkterne.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Nu skal der desværre gøres noget for netværket.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Kommandoen "kubectl get nodes" skulle nu vise "Master" i status "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Tilføj knudepunkter
Nu skal vi bruge kommandoen "kubeadm join" fra Kubenetes initialisering. Jeg indtaster denne kommando på "Server 2" og "Server 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Hvis jeg nu indtaster kommandoen "kubectl get nodes" fra "Server 1" igen, vises disse knudepunkter sandsynligvis i status "Not Ready" (ikke klar). Også her er der det netværksproblem, som skibsføreren også havde. Jeg kører kommandoen fra før igen, men denne gang tilføjer jeg et "f" for force.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
> Derefter kan jeg se alle noder klar til brug.
{{< gallery match="images/6/*.png" >}}

## Lille testudlevering (Server 1/Kubenetes-Master)
Jeg skriver selv en lille testimplementering og kontrollerer funktionerne. Jeg opretter en "nginx.yml"-fil med følgende indhold:
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
Nu starter jeg afleveringen:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Glimrende!
{{< gallery match="images/7/*.png" >}}
Jeg opretter en tjeneste og kan kalde min container.
{{< gallery match="images/8/*.png" >}}
Jeg opskalerer en gang til 20 "replikaer":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Se:
{{< gallery match="images/9/*.png" >}}

## Oprydning af testopgaver
For at rydde op, sletter jeg deplymentet og tjenesten igen.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Se:
{{< gallery match="images/10/*.png" >}}

