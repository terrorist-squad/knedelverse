+++
date = "2020-02-16"
title = "Synology-Nas: Konfigurowanie wyzwalaczy Gitlab"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Aby automatycznie uruchamiać potok Gitlab, należy utworzyć tzw. wyzwalacz. W ustawieniach projektu można utworzyć dowolną liczbę wyzwalaczy.
{{< gallery match="images/1/*.png" >}}
Wyzwalacze te wyglądają następująco. Oczywiście należy zastąpić (placeholders).
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}
