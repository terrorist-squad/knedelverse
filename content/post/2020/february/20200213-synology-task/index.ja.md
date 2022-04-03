+++
date = "2020-02-13"
title = "Synology-Nas: タスクやクーロンを実行するにはどうしたらいいですか？"
difficulty = "level-1"
tags = ["synology", "diskstation", "task", "cronjob", "cron", "aufgabe"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-task/index.ja.md"
+++
Synology NAS に自動タスクを設定しますか？コントロールパネル」の中の「タスクスケジューラ」をクリックしてください。
{{< gallery match="images/1/*.png" >}}

## 設定回数と繰り返し回数
タスクプランナー」では、クーロンジョブのような新しい「タスク」を作成することができます。回数や繰り返しはこちらで設定します。
{{< gallery match="images/2/*.png" >}}

## スクリプト
対象スクリプトは、「タスク設定」に格納されています。私の場合、ZIPアーカイブが作成されます。この機能はご自身でテストしてください。
{{< gallery match="images/3/*.png" >}}
