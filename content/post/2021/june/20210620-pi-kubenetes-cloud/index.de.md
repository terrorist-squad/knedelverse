+++
date = "2021-06-20"
title = "Großartiges mit Containern: Kubenetes-Cluster und NFS-Speicher"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210620-pi-kubenetes-cloud/index.de.md"
+++

Heute installiere ich ein neues Kubenetes-Cluster und es gibt viel zu tun!
{{< gallery match="images/1/*.jpg" >}}

Ich habe mir dafür diese Komponenten bestellt:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?&trstct=vrt_pdn&nbc=1
- 3x Lüfter, dual: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?&trstct=pos_0&nbc=1
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?&trstct=pol_14&nbc=1
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?&trstct=pol_14&nbc=1 
- 3x Netzteile: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x 600 Stück Dupont Stecker kit: https://amzn.to/3kcfYqQ
- 1x grüne LED mit Vorwiderstand: https://amzn.to/3EQgXVp
- 1x blaue LED mit Vorwiderstand: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blindstück Schwarz: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x Lampensockel: https://amzn.to/3H0UZkG

## Los geht's!
{{< youtube ulzMoX-fpvc >}}
Ich habe mir für die Installation ein eigenes Image auf Basis der Raspian-Lite-Installation erstellt. In diesem ist bereits mein Nutzer/Public-Key hinterlegt und die "/boot/config.txt"-Datei für meine LEDs angepasst.
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

## Server 1 - Platte mounten
Als erstes installiere ich einen NFS-DIenst auf "Server 1". Dieser Speicher kann später für mein Container-Cluster verwendet werden. Ich habe die USB-Festplatte an "Server 1" angeschlossen und mit Hilfe dieser Anleitung EXT4-formatiert: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}

Danach habe ich mir einen Mountpoint für die USB-Platte erstellt:
{{< terminal >}}
sudo mkdir /media/usb-platte
{{</ terminal >}}

Ich habe das neue Filesystem wie folgt in "/etc/fstab"-Datei eingetragen: 
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2
```
Die Einstellung kann mit "sudo mount -a" geprüft werden. Nun sollte die USB-Platte unter "/media/usb-platte" eingehangen sein.


### NFS installieren 
Für NFS wird dieses Paket benötigt:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y
{{</ terminal >}}
>
Zusätzlich wurde auf der USB-Platte ein neuer Ordner erstellt
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;
{{</ terminal >}}
>
>Danach muss die "/etc/exports"-Datei editiert werden. Dort wird der Pfad, die User-ID und die Gruppen-ID eingetragen:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)
```
>
Nun kann die Einstellung wie folgt übernommen werden.
{{< terminal >}}
sudo exportfs -ra
{{</ terminal >}}
>
### Wie kann ich den NFS-Mounten?
Ich kann das Volume wie folgt mounten:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs
{{</ terminal >}}
Oder dauerhaft in "/etc/fstab"-Datei eintragen:
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0
```
Auch hier kann ich "sudo mount -a" gebrauchen.

## Kubernetes installieren
Die folgenden Befehle müssen auf Server 1, Server 2 und Server 3 ausgeführt werden. Zunächst installieren wir Docker und fügen den Nutzer "PI" in die Docker-Gruppe ein.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker
{{</ terminal >}}
>
Danach wird die Swap-Size-Einstellung auf allen Servern genullt. Das heißt, dass ich die "/etc/dphys-swapfile"-Datei bearbeite und das Attribut "CONF_SWAPSIZE" auf "0" setze.
{{< gallery match="images/4/*.png" >}}
>
Außerdem müssen die "Control-Group"-Einstellungen in der "/boot/cmdline.txt"-Datei angepasst werden:
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1
```
Siehe:
{{< gallery match="images/5/*.png" >}}
>
Jetzt sollten alle Raspberry einmal rebooten und sind danach für die Kubernetes-Installation bereit. 
{{< terminal >}}
sudo reboot
{{</ terminal >}}
>
Nach dem Reboot installiere ich diese Pakete auf Server 1, Server 2 und Server 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm
{{</ terminal >}}
>
#### Nur Server 1
Jetzt kann der Kubenetes-Master initialisiert werden.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16
{{</ terminal >}}
Nach der erfolgreichen Initialisierung übernehme ich die Einstellungen. Den angezeigte "kubeadm join"-Befehl merke ich mich für das Anschließen der Worker-Nodes.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
{{</ terminal >}}
Nun muss leider noch etwas fürs Netzwerk gemacht werden. 
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet
{{</ terminal >}}
>
Der Befehl "kubectl get nodes" sollte nun den "Master" im Status "Ready" anzeigen.
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Nodes hinzufügen
Jetzt brauchen wir den "kubeadm join"-Befehl aus der Kubenetes-Initialisierung. Ich geben diesen Befehl auf "Server 2" uns "Server 3" ein.
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa
{{</ terminal >}}

Wenn ich jetzt wieder den Befehl "kubectl get nodes" aus "Server 1" eingebe, dann werden mir diese Nodes vermutlich im Status "Not Ready" angezeigt. Auch hier gibt es das Netzwerk-Problem, dass auch der Master hatte. 
Ich führe noch einmal Befehl von vorhin aus, aber diesmal hänge ich ein "f" für force an.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
{{</ terminal >}}
>
Danach sehe ich alle Nodes einsatzbereit.
{{< gallery match="images/6/*.png" >}}

## Kleines Test-Deplyment (Server 1/Kubenetes-Master)
Ich schreibe mir ein kleines Test-Deployment und prüfe die Funktionen. Ich erstelle mir eine "nginx.yml"-Datei mit folgendem Inhalt:
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

Jetzt starte ich das Deplyment:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments
{{</ terminal >}}
>
Großartig!
{{< gallery match="images/7/*.png" >}}

Ich erstelle einen Service und kann meinen Container aufrufen. 
{{< gallery match="images/8/*.png" >}}

Ich skaliere einmal auf 20 "Replicas" hoch:
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20
{{</ terminal >}}
>
Siehe:
{{< gallery match="images/9/*.png" >}}

## Test-Deplyment aufräumen
Zum aufräumen lösche ich das Deplyment und den Service wieder.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx
{{</ terminal >}}
>
Siehe:
{{< gallery match="images/10/*.png" >}}
