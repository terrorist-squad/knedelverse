+++
date = "2019-07-17"
title = "Synology Nas: Gitlab をインストールしますか？"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.ja.md"
+++
ここでは、Synology NASにGitlabとGitlab Runnerをインストールする方法を紹介する。まず、GitLabアプリケーションをSynologyのパッケージとしてインストールする必要があります。Package Centre "で "Gitlab "を検索し、"Install "をクリックしてください。   
{{< gallery match="images/1/*.*" >}}
このサービスは、私の場合、ポート "30000 "をリッスンします。すべてがうまくいったとき、http://SynologyHostName:30000 で Gitlab を呼び出すと、このような絵が表示されます。
{{< gallery match="images/2/*.*" >}}
初めてログインするときに、未来の「admin」パスワードを要求される。そうだったんですか！？プロジェクトの整理ができるようになりました。これでGitlabのランナーがインストールできるようになりました。  
{{< gallery match="images/3/*.*" >}}

