+++
date = "2019-07-17"
title = "Synology Nas: Gitlabをインストールしますか？"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.ja.md"
+++
ここでは、Synology NASにGitlabとGitlabランナーをインストールした方法を紹介します。まず、GitLabアプリケーションをSynologyパッケージとしてインストールする必要があります。パッケージセンター」で「Gitlab」を検索し、「インストール」をクリックします。   
{{< gallery match="images/1/*.*" >}}
私の場合、サービスはポート「30000」をリッスンします。すべてがうまくいくと、http://SynologyHostName:30000 で Gitlab を呼び出すと、このような画像が表示されます。
{{< gallery match="images/2/*.*" >}}
初回のログイン時に、今後の「admin」パスワードを求められます。そうだったんですね。これで、プロジェクトを整理できるようになりました。これで、Gitlab ランナーがインストールできました。  
{{< gallery match="images/3/*.*" >}}
