+++
date = "2020-02-07"
title = "uiPathのWindowsロボットをGitlabでオーケストレーションする"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-gitlab-uipath/index.ja.md"
+++
UiPathはロボティック・プロセス・オートメーションのスタンダードとして確立されています。uiPathを使えば、複雑なデータ処理やクリック作業を代行してくれるソフトウェアベースのロボット・ボットを開発することができます。しかし、このようなロボットをGitlabで制御することは可能でしょうか？その答えは「イエス」です。具体的には、こちらをご覧ください。以下の手順では、管理者権限と、uiPath、Windows、Gitlabの経験が必要です。
## Step 1: まず最初に、Gitlabのランナーをインストールします。
1.1.)対象となるOSのGitlabユーザーを新規に作成します。設定」→「家族とその他のユーザー」から「このPCに別の人を追加する」をクリックしてください。
{{< gallery match="images/1/*.png" >}}
1.2.)この人の認証情報がわかりません」をクリックし、「Microsoftアカウントを持たないユーザーの追加」をクリックして、ローカルユーザーを作成してください。
{{< gallery match="images/2/*.png" >}}
1.3.)次のダイアログでは、ユーザー名とパスワードを自由に選択できます。
{{< gallery match="images/3/*.png" >}}

## ステップ2：サービスログオンの有効化
Windows の Gitlab ランナーに別のローカルユーザーを使用したい場合は、「Activate logon as a service」を実行してください。そのためには、Windowsメニュー＞「ローカルセキュリティポリシー」を選択します。そこで、左側の「ローカルポリシー」→「ユーザー権限の割り当て」、右側の「サービスとしてのログオン」を選択します。
{{< gallery match="images/4/*.png" >}}
そして、新しいユーザーを追加します。
{{< gallery match="images/5/*.png" >}}

## ステップ3: Gitlabランナーの登録
Gitlab ランナーの Windows 版インストーラーは、次のページにあります。https://docs.gitlab.com/runner/install/windows.html .C "ドライブに新しいフォルダを作り、そこにインストーラーを入れました。
{{< gallery match="images/6/*.png" >}}
3.1.)CMD "というコマンドを "Administrator "として使い、新しいコンソールを開き、"cd C:\gitlab-runner "というディレクトリに変更します。
{{< gallery match="images/7/*.png" >}}
そこで次のようなコマンドを呼び出します。見ての通り、ここではGitlabユーザーのユーザー名とパスワードも入力しています。
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.)これで、Gitlab ランナーの登録が完了しました。Gitlabのインストールに自己署名証明書を使用する場合は、証明書に"-tls-ca-file="という属性を付ける必要があります。そして、GitlabのURLとレジストリトークンを入力します。
{{< gallery match="images/8/*.png" >}}
3.2.)登録が完了すると、"gitlab-runner-windows-386.exe start "というコマンドでランナを起動することができます。
{{< gallery match="images/9/*.png" >}}
最高ですね。あなたのGitlabランナーが起動し、使用できるようになりました。
{{< gallery match="images/10/*.png" >}}

## ステップ4：Gitのインストール
GitlabのランナーはGitのバージョン管理を行うため、Git for Windowsもインストールする必要があります。
{{< gallery match="images/11/*.png" >}}

## Step 5: UiPathのインストール
UiPathのインストールは、このチュートリアルの中で最も簡単な部分です。Gitlabのユーザーとしてログインし、コミュニティ・エディションをインストールします。もちろん、ロボットが必要とするすべてのソフトウェア、例えばOffice 365などをすぐにインストールすることもできます。
{{< gallery match="images/12/*.png" >}}

## Step 6: Gitlabプロジェクトとパイプラインの作成
さて、いよいよこのチュートリアルのグランドフィナーレです。新しいGitlabプロジェクトを作成し、uiPathのプロジェクトファイルをチェックします。
{{< gallery match="images/13/*.png" >}}
6.1.)さらに、次のような内容のファイル「.gitlab-ci.yml」を新たに作成します。
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
私のWindowsソフトのロボットは、masterブランチにコミットした後、そのまま実行されます。
{{< gallery match="images/14/*.png" >}}
