+++
date = "2020-02-07"
title = "GitlabでuiPathのWindowsロボットをオーケストレートする"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-gitlab-uipath/index.ja.md"
+++
UiPathは、ロボティック・プロセス・オートメーションのスタンダードとして確立しています。uiPathを使えば、複雑なデータ処理やクリック作業を代行するソフトウェアベースのロボット/ボットを開発することができます。しかし、そのようなロボットもGitlabで制御することができるのでしょうか。簡単に言えば「イエス」です。そして、具体的にどうなのかは、こちらをご覧ください。以下の手順では、管理者権限と、uiPath、Windows、Gitlabの経験が必要です。
## ステップ1：まず、Gitlabのランナーをインストールすることです。
1.1.)ターゲットOS用の新しいGitlabユーザーを作成します。設定」→「家族と他のユーザー」の順にクリックし、「このPCに別の人を追加する」をクリックしてください。
{{< gallery match="images/1/*.png" >}}
1.2.)をクリックし、「Microsoftアカウントなしでユーザーを追加する」をクリックして、ローカルユーザーを作成してください。
{{< gallery match="images/2/*.png" >}}
1.3.)次のダイアログで、ユーザー名とパスワードを自由に選択することができます。
{{< gallery match="images/3/*.png" >}}

## ステップ2：サービスログオンの有効化
WindowsのGitlab Runnerで別のローカルユーザーを使いたい場合は、「Activate logon as service」を行う必要があります。そのためには、Windowsのメニューから「ローカルセキュリティポリシー」を選択します。そこで、左側の「ローカルポリシー」→「ユーザー権限の割り当て」、右側の「サービスとしてのログオン」を選択します。
{{< gallery match="images/4/*.png" >}}
次に、新しいユーザーを追加します。
{{< gallery match="images/5/*.png" >}}

## ステップ3：Gitlab Runnerを登録する
Gitlab RunnerのWindowsインストーラーは、次のページにあります： https://docs.gitlab.com/runner/install/windows.html .C」ドライブに新しいフォルダを作成し、そこにインストーラーを入れました。
{{< gallery match="images/6/*.png" >}}
3.1.)Administrator」で「CMD」コマンドを使い、新しいコンソールを開き、「cd C: \gitlab-runner」ディレクトリに移動します。
{{< gallery match="images/7/*.png" >}}
そこで、次のようなコマンドを呼び出す。ご覧の通り、ここではGitlabのユーザーのユーザー名とパスワードも入力しています。
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.)これでGitlabランナーの登録ができました。Gitlabのインストールに自己署名証明書を使用する場合、証明書に"-tls-ca-file="属性を付けて提供する必要があります。次に、GitlabのURLとレジストリトークンを入力します。
{{< gallery match="images/8/*.png" >}}
3.2.)登録に成功すると、「gitlab-runner-windows-386.exe start」コマンドでランナーを起動することができるようになります。
{{< gallery match="images/9/*.png" >}}
素晴らしいGitlab Runnerが起動し、使用できるようになりました。
{{< gallery match="images/10/*.png" >}}

## ステップ4：Gitのインストール
GitlabランナーはGitのバージョン管理で動作するため、Git for Windowsもインストールする必要があります。
{{< gallery match="images/11/*.png" >}}

## ステップ5：UiPathのインストール
UiPathのインストールは、このチュートリアルの中で最も簡単な部分です。Gitlabのユーザーとしてログインし、コミュニティ版をインストールします。もちろん、Office 365など、ロボットに必要なソフトをすぐにインストールすることも可能です。
{{< gallery match="images/12/*.png" >}}

## ステップ6：Gitlabプロジェクトとパイプラインの作成
さて、このチュートリアルのグランドフィナーレを迎えます。Gitlabのプロジェクトを新規に作成し、uiPathのプロジェクトファイルをチェックインします。
{{< gallery match="images/13/*.png" >}}
6.1.)さらに、以下の内容で「.gitlab-ci.yml」というファイルを新規に作成します。
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
私のWindowsソフトウェアロボットは、masterブランチにコミットした後、直接実行されます。
{{< gallery match="images/14/*.png" >}}
ロボットの自動起動は、「スケジュール」オプションで管理することができます。この組み合わせの大きなメリットは、「ロボット型」のプロジェクトやプロジェクトの成果物（アーティファクト）を、他の「非ロボット型」プロジェクトと一緒にGitlabで一元管理、バージョン管理、運用できることです。
