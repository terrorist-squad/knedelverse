+++
date = "2020-02-16"
title = "Synology-Nas: Gitlabのトリガーを設定する"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Gitlabのパイプラインを自動的に起動するためには、いわゆるトリガーを作成する必要があります。プロジェクト設定でトリガーをいくつでも作成することができます。
{{< gallery match="images/1/*.png" >}}
これらのトリガーは次のようなものです。もちろん、（プレースホルダーの）入れ替えは必要です。
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}
