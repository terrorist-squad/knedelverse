+++
date = "2020-02-16"
title = "Synology-Nas: Nastavení spouštěčů Gitlabu"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Pro automatické spuštění pipeline Gitlab je třeba vytvořit tzv. spouštěč. V nastavení projektu můžete vytvořit libovolný počet spouštěčů.
{{< gallery match="images/1/*.png" >}}
Tyto spouštěče vypadají následovně. Samozřejmě je třeba nahradit (zástupné) znaky.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}