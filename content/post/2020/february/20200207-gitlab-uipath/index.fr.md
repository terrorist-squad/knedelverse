+++
date = "2020-02-07"
title = "Orchestrer des robots uiPath-Windows avec Gitlab"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-gitlab-uipath/index.fr.md"
+++
UiPath est un standard établi dans le domaine de l'automatisation des processus robotiques. Avec uiPath, vous pouvez développer un robot basé sur un logiciel qui vous décharge des tâches complexes de traitement des données ou de clics. Mais un tel robot peut-il être piloté avec Gitlab ? Réponse courte : "oui". Et comment exactement, vous le voyez ici. Pour les étapes suivantes, vous avez besoin, en plus des droits d'administration, d'un peu d'expérience avec uiPath, Windows et Gitlab.
## Étape 1 : La première chose à faire est d'installer un runner Gitlab.
1.1.) Créez un nouvel utilisateur Gitlab pour votre système d'exploitation cible. Veuillez cliquer sur "Paramètres" > "Famille et autres utilisateurs", puis sur "Ajouter une autre personne à ce PC".
{{< gallery match="images/1/*.png" >}}
1.2.) Veuillez cliquer sur "Je ne connais pas les informations de connexion pour cette personne", puis sur "Ajouter un utilisateur sans compte Microsoft" pour créer un utilisateur local.
{{< gallery match="images/2/*.png" >}}
1.3.) Dans la boîte de dialogue suivante, vous pouvez choisir librement le nom d'utilisateur et le mot de passe :
{{< gallery match="images/3/*.png" >}}

## Étape 2 : Activer la connexion de service
Si vous souhaitez utiliser un utilisateur local séparé pour votre programme d'exécution de Gitlab Windows, vous devez activer la "connexion en tant que service". Pour cela, allez dans le menu Windows > "Stratégie de sécurité locale". Là, sélectionnez sur le côté gauche "Stratégies locales" > "Attribuer des droits d'utilisateur" et sur le côté droit "Se connecter en tant que service".
{{< gallery match="images/4/*.png" >}}
Ensuite, ajoutez le nouvel utilisateur.
{{< gallery match="images/5/*.png" >}}

## Étape 3 : Enregistrer le Gitlab-Runner
La page suivante contient l'installateur Windows pour le runner Gitlab : https://docs.gitlab.com/runner/install/windows.html . J'ai créé un nouveau dossier dans le "lecteur C" et y ai placé l'installateur.
{{< gallery match="images/6/*.png" >}}
3.1.) J'utilise la commande "CMD" en tant qu'"administrateur" pour créer une nouvelle console et changer de répertoire "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
J'y appelle la commande suivante. Comme on peut le voir, j'y indique également le nom d'utilisateur et le mot de passe de l'utilisateur Gitlab.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Le runner Gitlab peut maintenant être enregistré. Si vous utilisez un certificat auto-signé pour votre installation Gitlab, vous devez inclure le certificat avec l'attribut "-tls-ca-file=". Ensuite, saisissez l'URL de Gitlab et le jeton d'enregistrement.
{{< gallery match="images/8/*.png" >}}
3.2.) Une fois l'enregistrement réussi, le runner peut être démarré avec la commande "gitlab-runner-windows-386.exe start" :
{{< gallery match="images/9/*.png" >}}
C'est génial ! Votre Gitlab-Runner fonctionne et est désormais utilisable.
{{< gallery match="images/10/*.png" >}}

## Étape 4 : installer Git
Comme un runner Gitlab fonctionne avec le versionnement Git, Git pour Windows doit également être installé :
{{< gallery match="images/11/*.png" >}}

## Étape 5 : Installer UiPath
L'installation d'UiPath est la partie la plus simple de ce tutoriel. Connectez-vous en tant qu'utilisateur Gitlab et installez l'édition communautaire. Vous pouvez bien sûr installer tout de suite tous les logiciels dont votre robot a besoin, par exemple : Office 365.
{{< gallery match="images/12/*.png" >}}

## Étape 6 : Créer un projet Gitlab et un pipeline
Voici maintenant la grande finale de ce tutoriel. Je crée un nouveau projet Gitlab et je vérifie mes fichiers de projet uiPath.
{{< gallery match="images/13/*.png" >}}
6.1.) En outre, je crée un nouveau fichier ".gitlab-ci.yml" avec le contenu suivant :
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Mon robot logiciel Windows s'exécute directement après le commit dans la branche maître :
{{< gallery match="images/14/*.png" >}}
