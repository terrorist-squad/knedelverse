+++
date = "2021-03-21"
title = "De grandes choses avec les conteneurs : faire fonctionner Jenkins sur le DS de Synology"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.fr.md"
+++

## Étape 1 : Préparer Synology
La première chose à faire est d'activer le login SSH sur le Diskstation. Pour cela, il faut aller dans le "Panneau de configuration" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Ensuite, on peut se connecter via "SSH", le port indiqué et le mot de passe de l'administrateur (les utilisateurs de Windows utilisent Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Je me connecte via Terminal, winSCP ou Putty et je laisse cette console ouverte pour plus tard.
## Étape 2 : Préparer le dossier Docker
Je crée un nouveau répertoire appelé "jenkins" dans le répertoire Docker.
{{< gallery match="images/3/*.png" >}}
Je passe ensuite dans le nouveau répertoire et crée un nouveau dossier "data" :
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Je crée également un fichier appelé "jenkins.yml" avec le contenu suivant. Pour le port, la partie avant "8081 :" peut être adaptée.
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
    container_name: jenkins
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker

```

## Étape 3 : Démarrage
Pour cette étape également, je peux utiliser la console à bon escient. Je démarre le serveur Jenkins via Docker-Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Ensuite, je peux appeler mon serveur Jenkins avec l'IP de la station de disques et le port attribué à l'"étape 2".
{{< gallery match="images/4/*.png" >}}

## Étape 4 : Mise en place

{{< gallery match="images/5/*.png" >}}
Ici aussi, j'utilise la console pour lire le mot de passe initial :
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Voir
{{< gallery match="images/6/*.png" >}}
J'ai choisi l'"installation recommandée".
{{< gallery match="images/7/*.png" >}}

## Étape 5 : Mon premier emploi
Je me connecte et je crée mon job Docker.
{{< gallery match="images/8/*.png" >}}
Comme on peut le voir, tout fonctionne très bien !
{{< gallery match="images/9/*.png" >}}
