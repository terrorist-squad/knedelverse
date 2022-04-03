+++
date = "2020-02-13"
title = "Synology-Nas: 我怎样才能运行任务或crons？"
difficulty = "level-1"
tags = ["synology", "diskstation", "task", "cronjob", "cron", "aufgabe"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-task/index.zh.md"
+++
你想在Synology NAS中设置自动任务吗？请点击 "控制面板 "中的 "任务调度器"。
{{< gallery match="images/1/*.png" >}}

## 设定的时间和重复次数
在 "任务规划器 "中，可以创建新的 "任务"，即准cron作业。时间和重复次数在此设定。
{{< gallery match="images/2/*.png" >}}

## 脚本
目标脚本存储在 "任务设置 "下。在我的案例中，创建了一个压缩档案。你应该自己测试这个功能。
{{< gallery match="images/3/*.png" >}}
