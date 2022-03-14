+++
date = "2020-02-16"
title = "Synology-Nas: Nastavenie spúšťačov Gitlabu"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Na automatické spustenie pipeline Gitlab je potrebné vytvoriť tzv. spúšťač. V nastaveniach projektu môžete vytvoriť ľubovoľný počet spúšťačov.
{{< gallery match="images/1/*.png" >}}
Tieto spúšťače vyzerajú takto. Samozrejme, (zástupné) symboly sa musia nahradiť.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}