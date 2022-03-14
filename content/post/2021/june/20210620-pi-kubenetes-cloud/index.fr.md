+++
date = "2021-06-20"
title = "Du grand avec les conteneurs : cluster Kubenetes et stockage NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.fr.md"
+++
Aujourd'hui, j'installe un nouveau cluster Kubenetes et il y a beaucoup à faire !
{{< gallery match="images/1/*.jpg" >}}
J'ai commandé ces composants pour cela :
- 1x WDBU6Y0050BBK WD Elements portable 5TB : https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html ?
- 3x ventilateurs, dual : https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html ?
- 1x Raspberry 4 / 4GB Ram : https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html ?
- 2x Raspberry 4 / 8GB Ram : https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html ?
- 3x blocs d'alimentation : https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x montage en rack : https://amzn.to/3H8vOg7
- 1x 600 connecteurs Dupont kit : https://amzn.to/3kcfYqQ
- 1x LED verte avec résistance en série : https://amzn.to/3EQgXVp
- 1x LED bleue avec résistance en série : https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Obturateur noir : https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x culot de lampe : https://amzn.to/3H0UZkG
## C'est parti !

{{< youtube ulzMoX-fpvc >}}
Pour l'installation, j'ai créé ma propre image basée sur l'installation de Raspian Lite. Dans celle-ci, mon utilisateur/clé publique est déjà enregistré et le fichier "/boot/config.txt" est adapté à mes LEDs.
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

## Serveur 1 - Monter le disque
Tout d'abord, j'installe un service NFS sur le "serveur 1". Ce stockage pourra être utilisé plus tard pour mon cluster de conteneurs. J'ai connecté le disque dur USB au "serveur 1" et l'ai formaté en EXT4 en suivant les instructions : https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Ensuite, j'ai créé un point de montage pour le disque USB :
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
J'ai ajouté le nouveau système de fichiers au fichier "/etc/fstab" comme suit :
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Le réglage peut être vérifié avec "sudo mount -a". Le disque USB devrait maintenant être monté sous "/media/usb-platte".
##  Installer NFS
Pour NFS, ce paquet est nécessaire :
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>En outre, un nouveau dossier a été créé sur le disque USB
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Il faut ensuite éditer le fichier "/etc/exports". Le chemin d'accès, l'ID d'utilisateur et l'ID de groupe doivent y être inscrits :
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Il est maintenant possible de reprendre le réglage comme suit.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Comment monter le NFS ?
Je peux monter le volume comme suit :
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Ou l'ajouter de manière permanente au fichier "/etc/fstab" :
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Ici aussi, je peux utiliser "sudo mount -a".
## Installer Kubernetes
Les commandes suivantes doivent être exécutées sur le serveur 1, le serveur 2 et le serveur 3. Tout d'abord, nous installons Docker et ajoutons l'utilisateur "PI" dans le groupe Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Après cela, le réglage de la taille d'échange est mis à zéro sur tous les serveurs. Cela signifie que je modifie le fichier "/etc/dphys-swapfile" et que je règle l'attribut "CONF_SWAPSIZE" sur "0".
{{< gallery match="images/4/*.png" >}}
>En outre, les paramètres "Control-Group" doivent être adaptés dans le fichier "/boot/cmdline.txt" :
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Voir
{{< gallery match="images/5/*.png" >}}
>Maintenant, tous les Raspberry doivent redémarrer une fois et sont prêts pour l'installation de Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Après le redémarrage, j'installe ces paquets sur le serveur 1, le serveur 2 et le serveur 3 :
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Serveur 1 uniquement
Le maître Kubenetes peut maintenant être initialisé.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Après une initialisation réussie, j'accepte les paramètres. Je retiens la commande "kubeadm join" affichée pour la connexion des nœuds de travail.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Maintenant, il faut malheureusement encore faire quelque chose pour le réseau.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>La commande "kubectl get nodes" devrait maintenant afficher le "maître" à l'état "prêt".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Ajouter des nœuds
Maintenant, nous avons besoin de la commande "kubeadm join" de l'initialisation de Kubenetes. J'entre cette commande sur "serveur 2" et "serveur 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Si j'entre à nouveau la commande "kubectl get nodes" à partir de "Server 1", ces nœuds m'apparaissent probablement dans l'état "Not Ready". Ici aussi, il y a le problème de réseau que le maître avait également. J'exécute à nouveau la commande de tout à l'heure, mais cette fois-ci j'ajoute un "f" pour force.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Après cela, je vois tous les nœuds prêts à l'emploi.
{{< gallery match="images/6/*.png" >}}

## Petit déploiement de test (serveur 1/maître Kubenetes)
J'écris un petit déploiement de test et je vérifie les fonctions. Je crée un fichier "nginx.yml" avec le contenu suivant :
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
Maintenant, je lance le déploiement :
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Génial !
{{< gallery match="images/7/*.png" >}}
Je crée un service et je peux appeler mon conteneur.
{{< gallery match="images/8/*.png" >}}
Je mets à l'échelle une fois pour 20 "réplicas" :
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Voir
{{< gallery match="images/9/*.png" >}}

## Nettoyer le déploiement de test
Pour faire le ménage, je supprime à nouveau le déploiement et le service.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Voir
{{< gallery match="images/10/*.png" >}}
