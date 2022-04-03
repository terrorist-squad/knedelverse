+++
date = "2021-06-20"
title = "Grandi cose con i container: cluster Kubenetes e storage NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.it.md"
+++
Oggi sto installando un nuovo cluster Kubenetes e c'è molto da fare!
{{< gallery match="images/1/*.jpg" >}}
Ho ordinato questi componenti per esso:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x fan, dual: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x alimentatori: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x 600 pezzi Dupont plug kit: https://amzn.to/3kcfYqQ
- 1x LED verde con resistenza in serie: https://amzn.to/3EQgXVp
- 1x LED blu con resistenza in serie: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Pezzo di soppressione nero: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x base della lampada: https://amzn.to/3H0UZkG
## Andiamo!

{{< youtube ulzMoX-fpvc >}}
Ho creato la mia immagine per l'installazione basata sull'installazione di Raspian Lite. La mia chiave utente/pubblica è già memorizzata in questa immagine e il file "/boot/config.txt" è stato adattato per i miei LED.
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

## Server 1 - Montare il disco
Per prima cosa, installo un servizio NFS sul "Server 1". Questo storage può essere usato in seguito per il mio cluster di container. Ho collegato il disco rigido USB al "Server 1" e l'ho formattato EXT4 con l'aiuto di queste istruzioni: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Poi ho creato un punto di montaggio per il disco USB:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Ho inserito il nuovo file system nel file "/etc/fstab" come segue:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
L'impostazione può essere controllata con "sudo mount -a". Ora il disco USB dovrebbe essere montato sotto "/media/usb-disk".
##  Installare NFS
Questo pacchetto è richiesto per NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>Inoltre, è stata creata una nuova cartella sul disco USB
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Poi il file "/etc/exports" deve essere modificato. Il percorso, l'ID utente e l'ID gruppo sono inseriti lì:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Ora l'impostazione può essere adottata come segue.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Come posso montare l'NFS?
Posso montare il volume come segue:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Oppure inserire permanentemente nel file "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Anche qui, posso usare "sudo mount -a".
## Installare Kubernetes
I seguenti comandi devono essere eseguiti sul server 1, server 2 e server 3. Prima installiamo Docker e aggiungiamo l'utente "PI" al gruppo Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Dopodiché, l'impostazione della dimensione dello swap è azzerata su tutti i server. Questo significa che modifico il file "/etc/dphys-swapfile" e imposto l'attributo "CONF_SWAPSIZE" a "0".
{{< gallery match="images/4/*.png" >}}
>Inoltre, le impostazioni "Control-Group" nel file "/boot/cmdline.txt" devono essere regolate:
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Vedere:
{{< gallery match="images/5/*.png" >}}
>Ora tutti i Raspberry dovrebbero riavviarsi una volta e sono pronti per l'installazione di Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Dopo il riavvio, installo questi pacchetti sul server 1, server 2 e server 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Solo il server 1
Ora il master Kubenetes può essere inizializzato.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Dopo l'inizializzazione riuscita, accetto le impostazioni. Ricordo il comando visualizzato "kubeadm join" per collegare i nodi lavoratori.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Ora, purtroppo, bisogna fare qualcosa per la rete.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Il comando "kubectl get nodes" dovrebbe ora mostrare il "Master" in stato "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Aggiungere nodi
Ora abbiamo bisogno del comando "kubeadm join" dall'inizializzazione di Kubenetes. Inserisco questo comando su "Server 2" e "Server 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Se ora inserisco di nuovo il comando "kubectl get nodes" dal "Server 1", questi nodi sono probabilmente visualizzati nello stato "Not Ready". Anche qui c'è il problema della rete che aveva anche il maestro. Eseguo nuovamente il comando di prima, ma questa volta aggiungo una "f" per forza.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Dopo di che, vedo tutti i nodi pronti per l'uso.
{{< gallery match="images/6/*.png" >}}

## Piccola distribuzione di test (Server 1/Kubenetes-Master)
Mi scrivo un piccolo deployment di prova e controllo le funzioni. Creo un file "nginx.yml" con il seguente contenuto:
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
Ora inizio il deplyment:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Grande!
{{< gallery match="images/7/*.png" >}}
Creo un servizio e posso richiamare il mio contenitore.
{{< gallery match="images/8/*.png" >}}
Una volta ho scalato fino a 20 "repliche":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Vedi:
{{< gallery match="images/9/*.png" >}}

## Ripulire il depliant dei test
Per riordinare, cancello di nuovo il deplyment e il servizio.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Vedi:
{{< gallery match="images/10/*.png" >}}

