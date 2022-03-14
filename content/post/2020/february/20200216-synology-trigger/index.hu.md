+++
date = "2020-02-16"
title = "Synology-Nas: Gitlab triggerek beállítása"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
A Gitlab csővezeték automatikus indításához létre kell hozni egy úgynevezett trigger-t. A projektbeállításokban annyi trigger-t hozhat létre, amennyit csak akar.
{{< gallery match="images/1/*.png" >}}
Ezek a triggerek így néznek ki. Természetesen a (helyőrzőket) ki kell cserélni.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}