+++
date = "2020-02-13"
title = "Synology-Nas : Installer Calibre Web comme bibliothèque d'ebooks"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.fr.md"
+++
Comment installer Calibre-Web en tant que conteneur Docker sur mon Synology-Nas ? Attention : cette méthode d'installation est obsolète et n'est pas compatible avec le logiciel Calibre actuel. Veuillez consulter ce nouveau tutoriel:[De grandes choses avec les conteneurs : faire fonctionner Calibre avec Docker-Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "De grandes choses avec les conteneurs : faire fonctionner Calibre avec Docker-Compose"). Ce tutoriel est destiné à tous les professionnels de Synology-DS.
## Étape 1 : Créer un dossier
Tout d'abord, je crée un dossier pour la bibliothèque Calibre.  Je vais dans le "Panneau de configuration" -> "Dossier partagé" et je crée un nouveau dossier "Livres".
{{< gallery match="images/1/*.png" >}}

##  Étape 2 : Créer une bibliothèque Calibre
Je copie maintenant une bibliothèque existante ou "[cette bibliothèque d'exemple vide](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" dans le nouveau répertoire. J'ai moi-même copié la bibliothèque existante de l'application de bureau.
{{< gallery match="images/2/*.png" >}}

## Étape 3 : Trouver une image Docker
Je clique sur l'onglet "Registre" dans la fenêtre du docker Synology et je recherche "Calibre". Je sélectionne l'image docker "janeczku/calibre-web" et je clique ensuite sur le tag "latest".
{{< gallery match="images/3/*.png" >}}
Après le téléchargement de l'image, celle-ci est disponible sous forme d'image. Docker fait la distinction entre deux états, le conteneur "état dynamique" et l'image/image (état fixe). Avant de créer un conteneur à partir de l'image, il faut encore procéder à quelques réglages.
## Etape 4 : Mettre l'image en service :
Je double-clique sur mon image Calibre.
{{< gallery match="images/4/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et j'active le "Redémarrage automatique". Je sélectionne l'onglet "Volume" et clique sur "Ajouter un dossier". Là, je crée un nouveau dossier de base de données avec ce chemin de montage "/calibre".
{{< gallery match="images/5/*.png" >}}
J'attribue des ports fixes pour le conteneur Calibre. Sans ports fixes, il se peut que Calibre soit exécuté sur un autre port après un redémarrage.
{{< gallery match="images/6/*.png" >}}
Une fois ces réglages effectués, Calibre peut être lancé !
{{< gallery match="images/7/*.png" >}}
J'appelle maintenant mon IP Synology avec le port Calibre attribué et je vois l'image suivante. Comme "Location of Calibre Database", j'indique "/calibre". Les autres paramètres sont une question de goût.
{{< gallery match="images/8/*.png" >}}
Le login par défaut est "admin" avec le mot de passe "admin123".
{{< gallery match="images/9/*.png" >}}
C'est terminé ! Bien sûr, je peux maintenant aussi connecter l'application de bureau via mon "dossier de livres". J'échange la bibliothèque dans mon application et je sélectionne ensuite mon dossier Nas.
{{< gallery match="images/10/*.png" >}}
A peu près comme ça :
{{< gallery match="images/11/*.png" >}}
Si je modifie maintenant les méta-informations dans l'application de bureau, elles sont aussi automatiquement mises à jour dans l'application web.
{{< gallery match="images/12/*.png" >}}