+++
date = "2021-04-18"
title = "De grandes choses avec les conteneurs : faire fonctionner Docspell DMS sur le Diskstation de Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.fr.md"
+++
Docspell est un système de gestion de documents pour la station de disques Synology. Grâce à Docspell, les documents peuvent être indexés, recherchés et trouvés beaucoup plus rapidement. Aujourd'hui, je montre comment installer un service Docspell sur le Diskstation de Synology.
## Étape 1 : Préparer Synology
La première chose à faire est d'activer le login SSH sur le Diskstation. Pour cela, il faut aller dans le "Panneau de configuration" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Ensuite, on peut se connecter via "SSH", le port indiqué et le mot de passe de l'administrateur (les utilisateurs de Windows utilisent Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Je me connecte via Terminal, winSCP ou Putty et je laisse cette console ouverte pour plus tard.
## Étape 2 : Créer un dossier Docspel
Je crée un nouveau répertoire appelé "docspell" dans le répertoire Docker.
{{< gallery match="images/3/*.png" >}}
Il faut maintenant télécharger le fichier suivant et le décompresser dans le répertoire : https://github.com/eikek/docspell/archive/refs/heads/master.zip . Pour cela, j'utilise la console :
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Ensuite, j'édite le fichier "docker/docker-compose.yml" et j'y inscris mes adresses Synology sous "consumedir" et "db" :
{{< gallery match="images/4/*.png" >}}
Ensuite, je peux lancer le fichier Compose :
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Après quelques minutes, je peux accéder à mon serveur Docspell avec l'IP de la station de disques et le port attribué/7878.
{{< gallery match="images/5/*.png" >}}
