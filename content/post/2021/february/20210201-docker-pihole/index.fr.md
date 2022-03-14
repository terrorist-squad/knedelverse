+++
date = "2021-02-01"
title = "Du grand avec les conteneurs : Pihole sur le diskstation de Synology"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.fr.md"
+++
Aujourd'hui, je montre comment installer un service Pihole sur le disque dur Synology et le connecter à la Fritzbox.
## Étape 1 : Préparer Synology
La première chose à faire est d'activer le login SSH sur le Diskstation. Pour cela, il faut aller dans le "Panneau de configuration" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Ensuite, on peut se connecter via "SSH", le port indiqué et le mot de passe de l'administrateur (les utilisateurs de Windows utilisent Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Je me connecte via Terminal, winSCP ou Putty et je laisse cette console ouverte pour plus tard.
## Étape 2 : Créer un dossier Pihole
Je crée un nouveau répertoire appelé "pihole" dans le répertoire Docker.
{{< gallery match="images/3/*.png" >}}
Ensuite, je passe dans le nouveau répertoire et crée deux dossiers "etc-pihole" et "etc-dnsmasq.d" :
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Il faut maintenant placer le fichier composite Docker suivant, nommé "pihole.yml", dans le répertoire Pihole :
```
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
    environment:
      TZ: 'Europe/Berlin'
      WEBPASSWORD: 'password'
    volumes:
      - './etc-pihole/:/etc/pihole/'
      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped

```
Le conteneur peut maintenant être démarré :
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
J'appelle le serveur Pihole avec l'adresse IP de Synology et mon port de conteneur et je me connecte avec le mot de passe WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Maintenant, l'adresse DNS peut être modifiée dans la Fritzbox sous "Réseau domestique" > "Réseau" > "Paramètres réseau".
{{< gallery match="images/5/*.png" >}}