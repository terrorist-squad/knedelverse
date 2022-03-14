+++
date = "2020-02-16"
title = "Synology-Nas: Configurarea declanșatoarelor Gitlab"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Pentru a declanșa automat un pipeline Gitlab, trebuie creat un așa-numit trigger. Puteți crea oricâte declanșatoare doriți în setările proiectului.
{{< gallery match="images/1/*.png" >}}
Aceste declanșatoare arată în felul următor. Bineînțeles, trebuie înlocuite (placeholders).
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}