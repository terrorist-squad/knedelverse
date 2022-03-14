+++
date = "2020-02-16"
title = "Synology-Nas: Nastavitev sprožilcev Gitlab"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Če želite samodejno sprožiti cevovod Gitlab, je treba ustvariti tako imenovani sprožilec. V nastavitvah projekta lahko ustvarite poljubno število sprožilcev.
{{< gallery match="images/1/*.png" >}}
Ti sprožilci so videti takole. Seveda je treba (nadomestne) datoteke zamenjati.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}