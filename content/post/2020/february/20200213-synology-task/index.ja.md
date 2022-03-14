+++
date = "2020-02-13"
title = "Synology-Nas：タスクやcronを実行するにはどうすればいいですか？"
difficulty = "level-1"
tags = ["synology", "diskstation", "task", "cronjob", "cron", "aufgabe"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-task/index.ja.md"
+++
Synology NASに自動タスクを設定しますか？コントロールパネル」の「タスクスケジューラー」をクリックしてください。
{{< gallery match="images/1/*.png" >}}

## 設定した回数と反復回数
タスクプランナー」では、新しい「タスク」を擬似的なクーロンジョブとして作成できます。ここでは、時間と繰り返しが設定されています。
{{< gallery match="images/2/*.png" >}}

## スクリプト
対象となるスクリプトは「タスク設定」に格納されています。私の場合は、ZIPアーカイブが作成されます。この機能は自分で試してみてください。
{{< gallery match="images/3/*.png" >}}