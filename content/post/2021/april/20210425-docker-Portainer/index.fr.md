+++
date = "2021-04-25T09:28:11+01:00"
title = "De grandes choses avec les conteneurs : Portainer comme alternative à Docker GUI de Synology"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.fr.md"
+++

## Étape 1 : Préparer Synology
La première chose à faire est d'activer le login SSH sur le Diskstation. Pour cela, il faut aller dans le "Panneau de configuration" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Ensuite, on peut se connecter via "SSH", le port indiqué et le mot de passe de l'administrateur (les utilisateurs de Windows utilisent Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Je me connecte via Terminal, winSCP ou Putty et je laisse cette console ouverte pour plus tard.
## Étape 2 : créer un dossier portainer
Je crée un nouveau répertoire appelé "portainer" dans le répertoire Docker.
{{< gallery match="images/3/*.png" >}}
Ensuite, je vais dans le répertoire portainer avec la console et j'y crée un dossier et un nouveau fichier appelé "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Voici le contenu du fichier "portainer.yml" :
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
Vous trouverez d'autres images Docker utiles pour une utilisation à domicile dans le [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Étape 3 : Démarrage de Portainer
Pour cette étape aussi, je peux utiliser la console. Je démarre le serveur portainer via Docker-Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Ensuite, je peux appeler mon serveur Portainer avec l'IP du Diskstation et le port attribué à partir de "l'étape 2". Je saisis mon mot de passe administrateur et je choisis la variante locale.
{{< gallery match="images/4/*.png" >}}
Comme on peut le voir, tout fonctionne très bien !
{{< gallery match="images/5/*.png" >}}
