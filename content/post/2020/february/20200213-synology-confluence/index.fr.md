+++
date = "2020-02-13"
title = "Synology-Nas : Confluence comme système wiki"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.fr.md"
+++
Si vous souhaitez installer Atlassian Confluence sur un Synology NAS, vous êtes au bon endroit.
## Étape 1
Tout d'abord, j'ouvre l'application Docker dans l'interface Synology et je vais ensuite dans le sous-menu "Registration". Là, je cherche "Confluence" et je clique sur la première image "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Étape 2
Après le téléchargement de l'image, celle-ci est disponible sous forme d'image. Docker fait la distinction entre deux états, le conteneur "état dynamique" et l'image/image (état fixe). Avant de créer un conteneur à partir de l'image, il faut encore procéder à quelques réglages.
## Redémarrage automatique
Je double-clique sur mon image Confluence.
{{< gallery match="images/2/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et j'active le "Redémarrage automatique".
{{< gallery match="images/3/*.png" >}}

## Ports
J'attribue des ports fixes pour le conteneur Confluence. Sans ports fixes, il se peut que Confluence s'exécute sur un autre port après un redémarrage.
{{< gallery match="images/4/*.png" >}}

## Mémoire
Je crée un dossier physique et je le monte dans le conteneur (/var/atlassian/application-data/confluence/). Cette configuration facilite la sauvegarde et la restauration des données.
{{< gallery match="images/5/*.png" >}}
Une fois ces réglages effectués, Confluence peut être lancé !
{{< gallery match="images/6/*.png" >}}
