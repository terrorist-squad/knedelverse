+++
date = "2021-06-20"
title = "Geweldige dingen met containers: Kubenetes cluster en NFS opslag"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.nl.md"
+++
Vandaag installeer ik een nieuw Kubenetes cluster en er is veel te doen!
{{< gallery match="images/1/*.jpg" >}}
Ik heb deze onderdelen ervoor besteld:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x ventilator, dubbel: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x voedingseenheden: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x 600 stuks Dupont plug kit: https://amzn.to/3kcfYqQ
- 1x groene LED met serieweerstand: https://amzn.to/3EQgXVp
- 1x blauwe LED met serieweerstand: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blanking stuk Zwart: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x lampvoet: https://amzn.to/3H0UZkG
## Laten we gaan!

{{< youtube ulzMoX-fpvc >}}
Ik heb mijn eigen image gemaakt voor de installatie, gebaseerd op de Raspian Lite installatie. Mijn gebruikers/publieke sleutel is al opgeslagen in dit image en het "/boot/config.txt" bestand is aangepast voor mijn leds.
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

## Server 1 - Monteer schijf
Eerst installeer ik een NFS service op "Server 1". Deze opslag kan later gebruikt worden voor mijn container cluster. Ik sloot de USB harde schijf aan op "Server 1" en formatteerde hem EXT4 met behulp van deze instructies: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Daarna heb ik een koppelpunt gemaakt voor de USB schijf:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Ik heb het nieuwe bestandssysteem als volgt in het bestand "/etc/fstab" ingevoerd:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
De instelling kan worden gecontroleerd met "sudo mount -a". Nu zou de USB schijf aangekoppeld moeten zijn onder "/media/usb-disk".
##  Installeer NFS
Dit pakket is nodig voor NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>Er werd ook een nieuwe map aangemaakt op de USB-schijf
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Dan moet het "/etc/exports" bestand worden bewerkt. Het pad, de gebruikers-ID en de groeps-ID worden daar ingevoerd:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Nu kan de instelling als volgt worden overgenomen.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Hoe kan ik de NFS mounten?
Ik kan het volume als volgt mounten:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Of voer het permanent in "/etc/fstab" bestand in:
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Ook hier kan ik "sudo mount -a" gebruiken.
## Installeer Kubernetes
De volgende commando's moeten worden uitgevoerd op server 1, server 2 en server 3. Eerst installeren we Docker en voegen de gebruiker "PI" toe aan de Docker groep.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Daarna wordt de swap grootte op alle servers op nul gezet. Dit betekent dat ik het "/etc/dphys-swapfile" bestand bewerk en het attribuut "CONF_SWAPSIZE" op "0" zet.
{{< gallery match="images/4/*.png" >}}
>Daarnaast moeten de "Control-Group" instellingen in het "/boot/cmdline.txt" bestand worden aangepast:
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Zie:
{{< gallery match="images/5/*.png" >}}
>Nu zouden alle Raspberrys één keer moeten herstarten en zijn dan klaar voor de Kubernetes installatie.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Na de reboot, installeer ik deze pakketten op server 1, server 2 en server 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Alleen server 1
Nu kan de Kubenetes master geïnitialiseerd worden.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Na de succesvolle initialisatie, accepteer ik de instellingen. Ik herinner me het getoonde "kubeadm join" commando om de werkknooppunten te verbinden.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Nu, helaas, moet er iets gedaan worden voor het netwerk.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Het commando "kubectl get nodes" zou nu de "Master" in "Ready" status moeten laten zien.
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Knooppunten toevoegen
Nu hebben we het "kubeadm join" commando nodig van de Kubenetes initialisatie. Ik voer dit commando in op "Server 2" en "Server 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Als ik nu het commando "kubectl get nodes" van "Server 1" opnieuw ingeef, worden deze nodes waarschijnlijk weergegeven in de status "Not Ready". Ook hier is er het netwerkprobleem dat de meester ook had. Ik voer het commando opnieuw uit, maar deze keer voeg ik een "f" toe voor force.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Daarna, zie ik alle nodes klaar voor gebruik.
{{< gallery match="images/6/*.png" >}}

## Klein testdepot (Server 1/Kubenetes-Master)
Ik schrijf zelf een kleine testomgeving en controleer de functies. Ik maak een "nginx.yml" bestand met de volgende inhoud:
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
Nu begin ik met de deplyment:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Geweldig.
{{< gallery match="images/7/*.png" >}}
Ik maak een service en kan mijn container oproepen.
{{< gallery match="images/8/*.png" >}}
Ik schaal een keer op naar 20 "replica's":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Zie:
{{< gallery match="images/9/*.png" >}}

## Test deplyment opruimen
Om op te ruimen, verwijder ik het deplyment en de service weer.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Zie:
{{< gallery match="images/10/*.png" >}}
