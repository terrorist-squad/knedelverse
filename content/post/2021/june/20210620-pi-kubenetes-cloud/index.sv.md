+++
date = "2021-06-20"
title = "Stora saker med containrar: Kubenetes kluster och NFS-lagring"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210620-pi-kubenetes-cloud/index.sv.md"
+++
Idag installerar jag ett nytt Kubenetes-kluster och det finns mycket att göra!
{{< gallery match="images/1/*.jpg" >}}
Jag har beställt dessa komponenter till den:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x fläkt, dubbel: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x nätaggregat: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x rackmontering: https://amzn.to/3H8vOg7
- 1x 600 bitar Dupont plug kit: https://amzn.to/3kcfYqQ
- 1x grön lysdiod med seriemotstånd: https://amzn.to/3EQgXVp
- 1x blå lysdiod med seriemotstånd: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blanking piece Svart: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x lampfot: https://amzn.to/3H0UZkG
## Kom igen!

{{< youtube ulzMoX-fpvc >}}
Jag har skapat en egen avbildning för installationen som bygger på Raspian Lite-installationen. Min användarnyckel/offentliga nyckel är redan lagrad i den här avbildningen och filen "/boot/config.txt" har anpassats för mina lysdioder.
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

## Server 1 - Montera disk
Först installerar jag en NFS-tjänst på "Server 1". Detta lagringsutrymme kan senare användas för mitt containerkluster. Jag anslöt USB-hårddisken till "Server 1" och formaterade den EXT4 med hjälp av dessa instruktioner: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Sedan skapade jag en monteringspunkt för USB-disken:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Jag har angett det nya filsystemet i filen "/etc/fstab" på följande sätt:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Du kan kontrollera inställningen med "sudo mount -a". Nu ska USB-disken monteras under "/media/usb-disk".
##  Installera NFS
Det här paketet krävs för NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>Dessutom skapades en ny mapp på USB-disken.
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Därefter måste filen "/etc/exports" redigeras. Sökvägen, användar-ID och grupp-ID anges där:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Inställningen kan nu göras på följande sätt.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Hur kan jag montera NFS?
Jag kan montera volymen på följande sätt:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Eller ange permanent i filen "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Även här kan jag använda "sudo mount -a".
## Installera Kubernetes
Följande kommandon måste utföras på server 1, server 2 och server 3. Först installerar vi Docker och lägger till användaren "PI" i Docker-gruppen.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Efter det är inställningen för swapstorlek noll på alla servrar. Detta innebär att jag redigerar filen "/etc/dphys-swapfile" och ställer in attributet "CONF_SWAPSIZE" till "0".
{{< gallery match="images/4/*.png" >}}
>Dessutom måste inställningarna för "Control-Group" i filen "/boot/cmdline.txt" justeras:
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Se:
{{< gallery match="images/5/*.png" >}}
>Nu ska alla Raspberrys starta om en gång och är redo för Kubernetes-installationen.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Efter omstarten installerar jag dessa paket på server 1, server 2 och server 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Endast server 1
Nu kan Kubenetes master initieras.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Efter den lyckade initialiseringen godkänner jag inställningarna. Jag minns det visade kommandot "kubeadm join" för att ansluta arbetarnoderna.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Nu måste tyvärr något göras för nätverket.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Kommandot "kubectl get nodes" bör nu visa "Master" i status "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Lägg till noder
Nu behöver vi kommandot "kubeadm join" från Kubenetes initialisering. Jag anger det här kommandot på "Server 2" och "Server 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Om jag nu anger kommandot "kubectl get nodes" från "Server 1" igen visas dessa noder förmodligen i statusen "Not Ready". Även här finns det nätverksproblem som även befälhavaren hade. Jag kör kommandot från tidigare igen, men den här gången lägger jag till ett "f" för force.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Efter det ser jag att alla noder är redo att användas.
{{< gallery match="images/6/*.png" >}}

## Liten testutläggning (Server 1/Kubenetes-Master)
Jag skriver själv en liten testinstallation och kontrollerar funktionerna. Jag skapar en fil "nginx.yml" med följande innehåll:
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
Nu börjar jag med avvecklingen:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Great!
{{< gallery match="images/7/*.png" >}}
Jag skapar en tjänst och kan kalla upp min behållare.
{{< gallery match="images/8/*.png" >}}
Jag skalar upp en gång till 20 "repliker":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Se:
{{< gallery match="images/9/*.png" >}}

## Rensa upp testutredningen
För att städa upp raderar jag deplymentet och tjänsten igen.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Se:
{{< gallery match="images/10/*.png" >}}
