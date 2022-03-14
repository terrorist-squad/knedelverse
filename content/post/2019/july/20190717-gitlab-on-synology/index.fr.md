+++
date = "2019-07-17"
title = "Synology Nas : Installer Gitlab ?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.fr.md"
+++
Je montre ici comment j'ai installé Gitlab et un Gitlab-Runner sur mon Synology-Nas. Tout d'abord, l'application GitLab doit être installée en tant que paquet Synology. Cherchez "Gitlab" dans le "Centre de paquets" et cliquez sur "Installer".   
{{< gallery match="images/1/*.*" >}}
Le service écoute chez moi le port "30000". Si tout s'est bien passé, j'appelle mon Gitlab avec http://SynologyHostName:30000 et je vois cette image :
{{< gallery match="images/2/*.*" >}}
Lors de la première connexion, on me demande le futur mot de passe "admin". Et c'est tout ! Je peux maintenant organiser des projets. Il est maintenant possible d'installer un runner Gitlab.  
{{< gallery match="images/3/*.*" >}}
