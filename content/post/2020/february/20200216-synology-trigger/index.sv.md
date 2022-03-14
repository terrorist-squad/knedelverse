+++
date = "2020-02-16"
title = "Synology-Nas: Konfigurera Gitlab-triggers"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
För att kunna utlösa en Gitlab-pipeline automatiskt måste en så kallad trigger skapas. Du kan skapa så många utlösare som du vill i projektinställningarna.
{{< gallery match="images/1/*.png" >}}
Dessa utlösare ser ut så här. Naturligtvis måste (platshållarna) ersättas.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}