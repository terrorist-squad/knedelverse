+++
date = "2020-02-16"
title = "Synology-Nas: Setting up Gitlab Triggers"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++

In order to trigger a Gitlab pipeline automatically, a so-called trigger must be created. You can create as many triggers as you want in the project - settings.
{{< gallery match="images/1/*.png" >}}

These triggers look like this. Of course, the (placeholders) must be replaced.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!
{{< gallery match="images/1/*.png" >}}