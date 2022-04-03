+++
date = "2020-02-16"
title = "Synology-Nas: Opsætning af Gitlab-triggere"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
For at udløse en Gitlab-pipeline automatisk skal der oprettes en såkaldt udløser. Du kan oprette så mange udløsere, som du vil, i projektindstillingerne.
{{< gallery match="images/1/*.png" >}}
Disse udløsere ser således ud. Selvfølgelig skal (pladsholdere) erstattes.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}
