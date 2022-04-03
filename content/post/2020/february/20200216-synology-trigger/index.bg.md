+++
date = "2020-02-16"
title = "Synology-Nas: Настройка на тригери в Gitlab"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
За да се задейства автоматично тръбопровод на Gitlab, трябва да се създаде т.нар. тригер. В настройките на проекта можете да създадете толкова тригери, колкото искате.
{{< gallery match="images/1/*.png" >}}
Тези тригери изглеждат по следния начин. Разбира се, (заместителите) трябва да бъдат заменени.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}
