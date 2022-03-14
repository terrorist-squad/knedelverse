+++
date = "2020-02-16"
title = "Synology-Nas: настройка триггеров Gitlab"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Для автоматического запуска конвейера Gitlab необходимо создать так называемый триггер. В настройках проекта вы можете создать столько триггеров, сколько захотите.
{{< gallery match="images/1/*.png" >}}
Эти триггеры выглядят следующим образом. Разумеется, их необходимо заменить (placeholders).
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}