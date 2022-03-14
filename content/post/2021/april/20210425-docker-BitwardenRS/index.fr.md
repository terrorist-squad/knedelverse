+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS sur le poste de disque Synology"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-BitwardenRS/index.fr.md"
+++
Bitwarden est un service gratuit et open source de gestion des mots de passe qui stocke les informations confidentielles, telles que les informations d'identification des sites web, dans un coffre-fort crypté. Aujourd'hui, je vous montre comment installer un BitwardenRS sur le disque dur Synology.
## Étape 1 : Préparer le dossier BitwardenRS
Je crée un nouveau répertoire appelé "bitwarden" dans le répertoire Docker.
{{< gallery match="images/1/*.png" >}}

## Étape 2 : installer BitwardenRS
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "bitwarden". Je sélectionne l'image docker "bitwardenrs/server" et je clique ensuite sur le tag "latest".
{{< gallery match="images/2/*.png" >}}
Je double-clique sur mon image bitwardenrs. Ensuite, je clique sur "Paramètres avancés" et j'active là aussi le "Redémarrage automatique".
{{< gallery match="images/3/*.png" >}}
Je choisis l'onglet "Volume" et je clique sur "Ajouter un dossier". Là, je crée un nouveau dossier avec ce chemin de montage "/data".
{{< gallery match="images/4/*.png" >}}
J'attribue des ports fixes pour le conteneur "bitwardenrs". Sans ports fixes, il se pourrait que le "serveur bitwardenrs" tourne sur un autre port après un redémarrage. Le premier port du conteneur peut être supprimé. L'autre port doit être mémorisé.
{{< gallery match="images/5/*.png" >}}
Le conteneur peut maintenant être démarré. J'appelle le serveur bitwardenrs avec l'adresse IP de Synology et mon port de conteneur 8084.
{{< gallery match="images/6/*.png" >}}

## Étape 3 : Configurer HTTPS
Je clique sur "Panneau de configuration" > "Reverse Proxy" et "Créer".
{{< gallery match="images/7/*.png" >}}
Ensuite, je peux accéder au serveur bitwardenrs avec l'adresse IP de Synology et mon port proxy 8085, de manière cryptée.
{{< gallery match="images/8/*.png" >}}