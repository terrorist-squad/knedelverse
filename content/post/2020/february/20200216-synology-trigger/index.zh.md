+++
date = "2020-02-16"
title = "Synology-Nas: 设置 Gitlab 触发器"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
为了自动触发Gitlab流水线，必须创建一个所谓的触发器。你可以在项目设置中创建任意多的触发器。
{{< gallery match="images/1/*.png" >}}
这些触发器看起来像这样。当然，（占位符）必须被替换。
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}