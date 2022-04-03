+++
date = "2020-02-16"
title = "Synology-Nas: Configuración de los activadores de Gitlab"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Para desencadenar un pipeline de Gitlab de forma automática, hay que crear un llamado trigger. Puedes crear tantos activadores como quieras en la configuración del proyecto.
{{< gallery match="images/1/*.png" >}}
Estos desencadenantes tienen este aspecto. Por supuesto, los (marcadores de posición) deben ser reemplazados.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}
