+++
date = "2020-02-16"
title = "Synology-Nas: Gitlab triggers instellen"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Om een Gitlab pijplijn automatisch te triggeren, moet een zogenaamde trigger aangemaakt worden. U kunt zoveel triggers aanmaken als u wilt in de projectinstellingen.
{{< gallery match="images/1/*.png" >}}
Deze triggers zien er als volgt uit. Natuurlijk moeten de plaatshouders worden vervangen.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}