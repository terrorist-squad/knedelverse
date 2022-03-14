+++
date = "2021-05-30"
title = "Téléchargeur Udemy sur la station de disque Synology"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.fr.md"
+++
Dans ce tutoriel, vous apprendrez comment télécharger des cours "udemy" pour une utilisation hors ligne.
## Etape 1 : Préparer le dossier Udemy
je crée un nouveau répertoire appelé "udemy" dans le répertoire Docker.
{{< gallery match="images/1/*.png" >}}

## Étape 2 : Installer l'image d'Ubuntu
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "ubunutu". Je sélectionne l'image docker "ubunutu" et je clique ensuite sur le tag "latest".
{{< gallery match="images/2/*.png" >}}
Je double-clique sur mon image Ubuntu. Ensuite, je clique sur "Paramètres avancés" et j'active là aussi le "redémarrage automatique".
{{< gallery match="images/3/*.png" >}}
Je choisis l'onglet "Volume" et je clique sur "Ajouter un dossier". Là, je crée un nouveau dossier avec ce chemin de montage "/download".
{{< gallery match="images/4/*.png" >}}
Le conteneur peut maintenant être démarré
{{< gallery match="images/5/*.png" >}}

## Étape 4 : installer le téléchargeur Udemy
Je clique sur "Conteneur" dans la fenêtre du docker Synology et je double-clique sur mon "conteneur Udemy". Ensuite, je clique sur l'onglet "Terminal" et je saisis les commandes suivantes.
{{< gallery match="images/6/*.png" >}}

##  Les ordres :

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Captures d'écran :
{{< gallery match="images/7/*.png" >}}

## Etape 4 : Mettre en service le téléchargeur Udemy
J'ai maintenant besoin d'un "jeton d'accès". Je visite Udemy avec mon navigateur Firfox et j'ouvre Firebug. Je clique sur l'onglet "Mémoire web" et je copie le "jeton d'accès".
{{< gallery match="images/8/*.png" >}}
Je crée un nouveau fichier dans mon conteneur :
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Ensuite, je peux télécharger les cours que j'ai déjà achetés :
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Voir
{{< gallery match="images/9/*.png" >}}
