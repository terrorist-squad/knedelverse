+++
date = "2021-06-20"
title = "Μεγάλα πράγματα με κοντέινερ: συστάδα Kubenetes και αποθήκευση NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210620-pi-kubenetes-cloud/index.el.md"
+++
Σήμερα εγκαθιστώ ένα νέο σύμπλεγμα Kubenetes και έχω πολλά να κάνω!
{{< gallery match="images/1/*.jpg" >}}
Έχω παραγγείλει αυτά τα εξαρτήματα:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x ανεμιστήρας, διπλός: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x μονάδες τροφοδοσίας: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x Σετ βυσμάτων Dupont 600 τεμαχίων: https://amzn.to/3kcfYqQ
- 1x πράσινο LED με αντίσταση σειράς: https://amzn.to/3EQgXVp
- 1x μπλε LED με αντίσταση σειράς: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Τεμάχιο κάλυψης Μαύρο: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x βάση λαμπτήρα: https://amzn.to/3H0UZkG
## Πάμε!

{{< youtube ulzMoX-fpvc >}}
Έχω δημιουργήσει τη δική μου εικόνα για την εγκατάσταση με βάση την εγκατάσταση Raspian Lite. Το χρήστης/δημόσιο κλειδί μου είναι ήδη αποθηκευμένο σε αυτή την εικόνα και το αρχείο "/boot/config.txt" έχει προσαρμοστεί για τα LED μου.
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

## Διακομιστής 1 - Τοποθέτηση δίσκου
Πρώτον, εγκαθιστώ μια υπηρεσία NFS στον "Server 1". Αυτός ο αποθηκευτικός χώρος μπορεί να χρησιμοποιηθεί αργότερα για τη συστάδα εμπορευματοκιβωτίων μου. Σύνδεσα τον σκληρό δίσκο USB στον "Server 1" και τον μορφοποίησα EXT4 με τη βοήθεια αυτών των οδηγιών: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Στη συνέχεια δημιούργησα ένα σημείο προσάρτησης για το δίσκο USB:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Έχω εισάγει το νέο σύστημα αρχείων στο αρχείο "/etc/fstab" ως εξής:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Η ρύθμιση μπορεί να ελεγχθεί με την εντολή "sudo mount -a". Τώρα ο δίσκος USB θα πρέπει να είναι προσαρτημένος στο "/media/usb-disk".
##  Εγκατάσταση NFS
Αυτό το πακέτο απαιτείται για το NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
> Επιπλέον, δημιουργήθηκε ένας νέος φάκελος στο δίσκο USB
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Τότε πρέπει να επεξεργαστείτε το αρχείο "/etc/exports". Εκεί εισάγονται η διαδρομή, το αναγνωριστικό χρήστη και το αναγνωριστικό ομάδας:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Τώρα η ρύθμιση μπορεί να υιοθετηθεί ως εξής.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Πώς μπορώ να προσαρτήσω το NFS;
Μπορώ να προσαρτήσω τον τόμο ως εξής:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Ή εισάγετε μόνιμα στο αρχείο "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Και εδώ μπορώ να χρησιμοποιήσω το "sudo mount -a".
## Εγκαταστήστε το Kubernetes
Οι ακόλουθες εντολές πρέπει να εκτελεστούν στους διακομιστές 1, 2 και 3. Πρώτα εγκαθιστούμε το Docker και προσθέτουμε τον χρήστη "PI" στην ομάδα Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Μετά από αυτό, η ρύθμιση μεγέθους swap μηδενίζεται σε όλους τους διακομιστές. Αυτό σημαίνει ότι επεξεργάζομαι το αρχείο "/etc/dphys-swapfile" και ορίζω το χαρακτηριστικό "CONF_SWAPSIZE" σε "0".
{{< gallery match="images/4/*.png" >}}
>Επιπλέον, πρέπει να προσαρμοστούν οι ρυθμίσεις "Control-Group" στο αρχείο "/boot/cmdline.txt":
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Βλέπε:
{{< gallery match="images/5/*.png" >}}
>Τώρα όλα τα Raspberrys θα πρέπει να επανεκκινήσουν μία φορά και είναι έτοιμα για την εγκατάσταση του Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Μετά την επανεκκίνηση, εγκαθιστώ αυτά τα πακέτα στους διακομιστές 1, 2 και 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Μόνο ο διακομιστής 1
Τώρα ο Kubenetes master μπορεί να αρχικοποιηθεί.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Μετά την επιτυχή αρχικοποίηση, αποδέχομαι τις ρυθμίσεις. Θυμάμαι την εμφανιζόμενη εντολή "kubeadm join" για τη σύνδεση των κόμβων εργασίας.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Τώρα, δυστυχώς, κάτι πρέπει να γίνει για το δίκτυο.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Η εντολή "kubectl get nodes" θα πρέπει τώρα να εμφανίζει τον "Master" σε κατάσταση "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Προσθήκη κόμβων
Τώρα χρειαζόμαστε την εντολή "kubeadm join" από την αρχικοποίηση του Kubenetes. Εισάγω αυτή την εντολή στον "Server 2" και στον "Server 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Αν τώρα εισαγάγω ξανά την εντολή "kubectl get nodes" από τον "Server 1", αυτοί οι κόμβοι εμφανίζονται πιθανώς στην κατάσταση "Not Ready". Και εδώ, επίσης, υπάρχει το πρόβλημα του δικτύου που είχε και ο πλοίαρχος. Εκτελώ ξανά την εντολή από πριν, αλλά αυτή τη φορά προσθέτω ένα "f" για force.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Μετά από αυτό, βλέπω όλους τους κόμβους έτοιμους για χρήση.
{{< gallery match="images/6/*.png" >}}

## Μικρή δοκιμαστική εγκατάσταση (Server 1/Kubenetes-Master)
Γράφω μια μικρή δοκιμαστική ανάπτυξη και ελέγχω τις λειτουργίες. Δημιουργώ ένα αρχείο "nginx.yml" με το ακόλουθο περιεχόμενο:
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
Τώρα αρχίζω την εξάρτηση:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Καλά!
{{< gallery match="images/7/*.png" >}}
Δημιουργώ μια υπηρεσία και μπορώ να καλέσω το δοχείο μου.
{{< gallery match="images/8/*.png" >}}
Ανεβάζω την κλίμακα μία φορά σε 20 "αντίγραφα":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Βλέπε:
{{< gallery match="images/9/*.png" >}}

## Εκκαθάριση του test deplyment
Για να συμμαζέψω, διαγράφω ξανά το deplyment και την υπηρεσία.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Βλέπε:
{{< gallery match="images/10/*.png" >}}
