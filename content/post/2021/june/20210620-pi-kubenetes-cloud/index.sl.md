+++
date = "2021-06-20"
title = "Velike stvari z zabojniki: Kubenetesova gruča in shranjevanje NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210620-pi-kubenetes-cloud/index.sl.md"
+++
Danes nameščam novo gručo Kubenetes in čaka me veliko dela!
{{< gallery match="images/1/*.jpg" >}}
Naročil sem te komponente zanj:
- 1x WDBU6Y0050BBK WD Elements prenosni 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x ventilator, dvojni: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x napajalne enote: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x namestitev v omaro: https://amzn.to/3H8vOg7
- 1x 600 kosov kompleta vtičev Dupont: https://amzn.to/3kcfYqQ
- 1x zelena LED dioda s serijskim uporom: https://amzn.to/3EQgXVp
- 1x modra LED dioda s serijskim uporom: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blanking piece Black: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x podstavek za svetilko: https://amzn.to/3H0UZkG
## Gremo!

{{< youtube ulzMoX-fpvc >}}
Ustvaril sem lastno sliko za namestitev, ki temelji na namestitvi Raspian Lite. Moj uporabniški/javni ključ je že shranjen v tej sliki, datoteka "/boot/config.txt" pa je bila prilagojena za moje diode LED.
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

## Strežnik 1 - Namestitev diska
Najprej v strežnik 1 namestim storitev NFS. To skladišče lahko pozneje uporabim za svojo gručo vsebnikov. Trdi disk USB sem priključil na "strežnik 1" in ga formatiral EXT4 s pomočjo teh navodil: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Nato sem ustvaril priključno točko za disk USB:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
V datoteko "/etc/fstab" sem vnesel nov datotečni sistem, kot sledi:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Nastavitev lahko preverite s "sudo mount -a". Zdaj mora biti disk USB nameščen pod "/media/usb-disk".
##  Namestitev sistema NFS
Ta paket je potreben za sistem NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
> Poleg tega je bila na disku USB ustvarjena nova mapa
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Potem je treba urediti datoteko "/etc/exports". Vnesite pot, ID uporabnika in ID skupine:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Nadal lahko nastavitev sprejmete na naslednji način.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Kako lahko namestim sistem NFS?
Zvezek lahko namestim na naslednji način:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Ali vnesite trajno v datoteko "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Tudi tu lahko uporabim "sudo mount -a".
## Namestitev sistema Kubernetes
Naslednje ukaze je treba izvesti v strežniku 1, strežniku 2 in strežniku 3. Najprej namestimo Docker in uporabnika PI dodamo v skupino Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Po tem se nastavitev velikosti izmenjevalnika v vseh strežnikih izniči. To pomeni, da uredim datoteko "/etc/dphys-swapfile" in nastavim atribut "CONF_SWAPSIZE" na "0".
{{< gallery match="images/4/*.png" >}}
> Poleg tega je treba prilagoditi nastavitve "Control-Group" v datoteki "/boot/cmdline.txt":
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Oglejte si:
{{< gallery match="images/5/*.png" >}}
>Tudi se morajo vse maline enkrat znova zagnati in so pripravljene za namestitev Kubernetesa.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Po ponovnem zagonu namestim te pakete v strežnik 1, strežnik 2 in strežnik 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Samo strežnik 1
Zdaj lahko inicializirate glavni strežnik Kubenetes.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Po uspešni inicializaciji sprejmem nastavitve. Spomnim se prikazanega ukaza "kubeadm join" za povezovanje delovnih vozlišč.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Žal je zdaj treba nekaj storiti za omrežje.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Ukaz "kubectl get nodes" mora zdaj prikazati "Master" v stanju "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Dodajanje vozlišč
Zdaj potrebujemo ukaz "kubeadm join" iz inicializacije Kubenetesa. Ta ukaz vnesem v strežnik 2 in strežnik 3.
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Če zdaj ponovno vnesem ukaz "kubectl get nodes" iz strežnika 1, se ta vozlišča verjetno prikažejo v stanju "Not Ready". Tudi tu se pojavi težava z omrežjem, ki jo je imel tudi mojster. Ponovno zaženem prejšnji ukaz, vendar tokrat dodam črko "f" za force.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Po tem so vsa vozlišča pripravljena za uporabo.
{{< gallery match="images/6/*.png" >}}

## Majhna testna namestitev (strežnik 1/Kubenetes-Master)
Sam napišem majhno testno namestitev in preverim funkcije. Ustvarim datoteko "nginx.yml" z naslednjo vsebino:
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
Sedaj začnem z depiliranjem:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Veliko!
{{< gallery match="images/7/*.png" >}}
Ustvarim storitev in lahko prikličem svoj vsebnik.
{{< gallery match="images/8/*.png" >}}
Enkrat povečam na 20 "replik":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Glejte:
{{< gallery match="images/9/*.png" >}}

## Očistite testno deplimentacijo
Za pospravljanje znova izbrišem nadomestilo in storitev.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Glejte:
{{< gallery match="images/10/*.png" >}}
