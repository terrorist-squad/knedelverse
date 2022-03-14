+++
date = "2020-02-16"
title = "Synology-Nas : Configuration des déclencheurs Gitlab"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Pour déclencher automatiquement un pipeline Gitlab, il faut créer un déclencheur. Vous pouvez créer autant de déclencheurs que vous le souhaitez dans les paramètres du projet.
{{< gallery match="images/1/*.png" >}}
Ces déclencheurs ressemblent à ceci. Of course, the (placeholders) must be replaced.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}