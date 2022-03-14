+++
date = "2021-06-20"
title = "Lucruri grozave cu containere: cluster Kubenetes și stocare NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210620-pi-kubenetes-cloud/index.ro.md"
+++
Astăzi instalez un nou cluster Kubenetes și sunt multe de făcut!
{{< gallery match="images/1/*.jpg" >}}
Am comandat aceste componente pentru el:
- 1x WDBU6Y000050BBK WD Elements portabil 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- Ventilator 3x, dublu: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x surse de alimentare: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x 600 de piese Dupont kit de conectare Dupont: https://amzn.to/3kcfYqQ
- 1x LED verde cu rezistor de serie: https://amzn.to/3EQgXVp
- 1x LED albastru cu rezistor de serie: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Piesă de obturare Negru: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x bază de lampă: https://amzn.to/3H0UZkG
## Să mergem!

{{< youtube ulzMoX-fpvc >}}
Mi-am creat propria imagine pentru instalare pe baza instalației Raspian Lite. Cheia mea de utilizator/public este deja stocată în această imagine, iar fișierul "/boot/config.txt" a fost adaptat pentru LED-urile mele.
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

## Server 1 - Montați discul
Mai întâi, instalez un serviciu NFS pe "Server 1". Acest spațiu de stocare poate fi utilizat ulterior pentru clusterul meu de containere. Am conectat hard disk-ul USB la "Server 1" și l-am formatat EXT4 cu ajutorul acestor instrucțiuni: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Apoi am creat un punct de montare pentru discul USB:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Am introdus noul sistem de fișiere în fișierul "/etc/fstab" după cum urmează:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Setarea poate fi verificată cu "sudo mount -a". Acum, discul USB ar trebui să fie montat sub "/media/usb-disk".
##  Instalați NFS
Acest pachet este necesar pentru NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>În plus, a fost creat un nou folder pe discul USB
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Apoi trebuie editat fișierul "/etc/exports". Aici se introduc calea, ID-ul utilizatorului și ID-ul grupului:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Acum setarea poate fi adoptată după cum urmează.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Cum pot monta NFS?
Pot monta volumul după cum urmează:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Sau introduceți permanent în fișierul "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Și aici pot folosi "sudo mount -a".
## Instalați Kubernetes
Următoarele comenzi trebuie să fie executate pe serverul 1, serverul 2 și serverul 3. În primul rând, instalăm Docker și adăugăm utilizatorul "PI" la grupul Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>După aceasta, setarea dimensiunii swap este zero pe toate serverele. Aceasta înseamnă că editez fișierul "/etc/dphys-swapfile" și setez atributul "CONF_SWAPSIZE" la "0".
{{< gallery match="images/4/*.png" >}}
>În plus, setările "Control-Group" din fișierul "/boot/cmdline.txt" trebuie ajustate:
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
A se vedea:
{{< gallery match="images/5/*.png" >}}
>Acum, toate camerele Raspberry ar trebui să repornească o dată și sunt gata pentru instalarea Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>După repornire, instalez aceste pachete pe serverul 1, serverul 2 și serverul 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Numai serverul 1
Acum masterul Kubenetes poate fi inițializat.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
După ce inițializarea a fost realizată cu succes, accept setările. Îmi amintesc comanda afișată "kubeadm join" pentru conectarea nodurilor de lucru.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Acum, din păcate, trebuie să se facă ceva pentru rețea.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Comanda "kubectl get nodes" ar trebui să arate acum "Master" în starea "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Adăugați noduri
Acum avem nevoie de comanda "kubeadm join" din inițializarea Kubenetes. Introduc această comandă pe "Server 2" și "Server 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Dacă acum introduc din nou comanda "kubectl get nodes" de pe "Server 1", aceste noduri sunt probabil afișate în starea "Not Ready". Și aici există problema rețelei pe care a avut-o și maestrul. Rulez din nou comanda de mai înainte, dar de data aceasta adaug un "f" pentru forță.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>După aceasta, văd toate nodurile gata de utilizare.
{{< gallery match="images/6/*.png" >}}

## Depozit mic de testare (Server 1/Kubenetes-Master)
Scriu eu însumi un mic test de implementare și verific funcțiile. Creez un fișier "nginx.yml" cu următorul conținut:
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
Acum încep depunerea:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Grav!
{{< gallery match="images/7/*.png" >}}
Creez un serviciu și pot apela containerul meu.
{{< gallery match="images/8/*.png" >}}
Am crescut o dată la 20 de "replici":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Vezi:
{{< gallery match="images/9/*.png" >}}

## Curățați departamentul de testare
Pentru a face ordine, am șters din nou depozitul și serviciul.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Vezi:
{{< gallery match="images/10/*.png" >}}
