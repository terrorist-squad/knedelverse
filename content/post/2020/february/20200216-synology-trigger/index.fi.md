+++
date = "2020-02-16"
title = "Synology-Nas: Gitlab-triggereiden määrittäminen"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Jotta Gitlab-putken voi käynnistää automaattisesti, on luotava niin sanottu trigger. Voit luoda projektin asetuksissa niin monta laukaisinta kuin haluat.
{{< gallery match="images/1/*.png" >}}
Nämä laukaisimet näyttävät tältä. (Paikannimet) on tietenkin korvattava.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}