+++
date = "2021-09-05"
title = "De grandes choses avec les conteneurs : le serveur multimédia Logitech sur la station de disque Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.fr.md"
+++
Dans ce tutoriel, vous apprendrez à installer un serveur multimédia Logitech sur le Diskstation Synology.
{{< gallery match="images/1/*.jpg" >}}

## Étape 1 : Préparer le dossier Logitechmediaserver
je crée un nouveau répertoire appelé "logitechmediaserver" dans le répertoire Docker.
{{< gallery match="images/2/*.png" >}}

## Étape 2 : installer l'image Logitechmediaserver
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "logitechmediaserver". Je sélectionne l'image docker "lmscommunity/logitechmediaserver" et je clique ensuite sur le tag "latest".
{{< gallery match="images/3/*.png" >}}
Je double-clique sur mon image Logitechmediaserver. Ensuite, je clique sur "Paramètres avancés" et j'active là aussi le "Redémarrage automatique".
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Chemin de montage|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/musique|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Je choisis l'onglet "Volume" et je clique sur "Ajouter un dossier". Là, je crée trois dossiers:Voir :
{{< gallery match="images/5/*.png" >}}
J'attribue des ports fixes pour le conteneur "Logitechmediaserver". Sans ports fixes, il se pourrait que le "serveur Logitechmediaserver" fonctionne sur un autre port après un redémarrage.
{{< gallery match="images/6/*.png" >}}
Pour finir, je saisis encore une variable d'environnement. La variable "TZ" le fuseau horaire "Europe/Berlin".
{{< gallery match="images/7/*.png" >}}
Après ces réglages, le serveur Logitechmediaserver peut être démarré ! Ensuite, on peut appeler le serveur Logitechmediaserver via l'adresse Ip de la station Synology et le port attribué, par exemple http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}

