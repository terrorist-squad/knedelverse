+++
date = "2021-04-25T09:28:11+01:00"
title = "Brève histoire : Actualiser automatiquement les conteneurs avec Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.fr.md"
+++
Lorsque l'on utilise des conteneurs Docker sur son Diskstation, on souhaite bien sûr qu'ils soient toujours à jour. Watchtower met à jour les images et les conteneurs de manière autonome. On peut ainsi profiter des dernières fonctionnalités et de la sécurité des données la plus récente. Aujourd'hui, je vous montre comment installer un Watchtower sur le disque dur Synology.
## Étape 1 : Préparer Synology
La première chose à faire est d'activer le login SSH sur le Diskstation. Pour cela, il faut aller dans le "Panneau de configuration" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Ensuite, on peut se connecter via "SSH", le port indiqué et le mot de passe de l'administrateur (les utilisateurs de Windows utilisent Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Je me connecte via Terminal, winSCP ou Putty et je laisse cette console ouverte pour plus tard.
## Étape 2 : Installer la tour de guet
Pour cela, j'utilise la console :
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Ensuite, Watchtower fonctionne toujours en arrière-plan.
{{< gallery match="images/3/*.png" >}}

