+++
date = "2020-02-16"
title = "Synology-Nas: Instalação de Gatilhos Gitlab"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Para acionar automaticamente um gasoduto Gitlab, deve ser criado um chamado gatilho. É possível criar quantos acionadores se desejar nas configurações do projeto.
{{< gallery match="images/1/*.png" >}}
Estes gatilhos parecem-se com isto. Naturalmente, os (lugares reservados) devem ser substituídos.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}