+++
date = "2021-03-06"
title = "RaspberryPiZeroW、Javascript、GitLabを使った課題ダッシュボード"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210306-gitlab-dashboard/index.ja.md"
+++
Raspberry Noobsでのインストールは子供の遊びです。必要なのは、RaspberryZeroWと空のSDカードだけです。
## ステップ1：Noobsインストーラー
https://www.raspberrypi.org/downloads/noobs/ から Noobs のインストーラーをダウンロードします。
## Step 2: SDカード
このZIPアーカイブを空のSDカードに解凍します。
{{< gallery match="images/1/*.png" >}}
できました。これで、RaspberryPiZeroをテレビに接続することができます。すると、インストールメニューが表示されます。
{{< gallery match="images/2/*.jpg" >}}
カードにNoobsLiteを搭載している場合は、まずWLAN接続を行う必要があります。そして、「Rasbian Lite」を選択し、「インストール」をクリックします。Rasbian Liteは、デスクトップを持たないサーバー版です。起動後、パッケージ管理を更新する必要があります。
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
その後、以下のパッケージをインストールする必要があります。
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
また、ダッシュボードの表示用にユーザーを作成する必要があります。
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
ダッシュボード "ユーザーとしてログインします。
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Create an X-Session -Script.カーソルキーでこの行に変更し、「i」キーで挿入モードに変更することができます。
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
コンテンツ
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
その後、「Esc」キーを押してコマンドモードを変更し、「:wq」で「書き込み」、「quit」とします。また、このスクリプトには以下の権限が必要です。
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
このスクリプトでは、ブラウザの設定（/home/dashboard/uzbl.conf）が表示されています。この設定は次のようになります。
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
ハーフタイム!もうすぐ完成ですね。さて、ユーザーの行動をシミュレートできるJavascriptが必要です。Gitlabのユーザーを別途作成することが重要です。このユーザーは、プロジェクトにおいて「レポーター」として管理することができます。
```
var gitlabUrl = 'http://git-lab-url:port';
var gitlabUser = 'userName';
var gitlabPassword = 'userPasswort';

/*--------------------------Timer--------------------------*/

var Timer = function(intervallInMsec)
{
  this.caller = new Array();
  this.intervall = window.setInterval(
    this.call.bind(this),
    intervallInMsec
  );
};

Timer.prototype.append = function(callFunction)
{
  this.caller.push(callFunction);
};

Timer.prototype.remove = function(callFunction)
{
  var index = this.caller.indexOf(callFunction);
  if (index > -1) 
  {
    this.caller.splice(index, 1);
  }
};

Timer.prototype.call = function()
{
  for(
    var callerIndex = 0, callerLenght = this.caller.length;
    callerIndex < callerLenght;
    callerIndex++
  ) {
    this.caller[ callerIndex ].call();
  }
};

/* login verhalten */
var timer = new Timer(1000);
timer.append(
  function()
  {
    if (jQuery('#user_login').length > 0)
    {
      jQuery('#user_login').val(gitlabUser);
      jQuery('#user_password').val(gitlabPassword);
      jQuery('.btn-save').click();
    }
  }
);

/* wallboard aufrufen */
timer.append(
  function()
  {
    if (jQuery('.js-projects-list-holder').length > 0)
    {
      window.location.href = window.gitlabUrl + '/dashboard/issues?state=opened&utf8=✓&assignee_id=0';
    }
  }
);
/* reload verhalten */
timer.append(
  function()
  {
    if (jQuery('.issues-filters').length > 0)
    {
      window.location.href = window.gitlabUrl + '/dashboard/issues?state=opened&utf8=✓&assignee_id=0';
    }
  }
);


```
これで、ログアウトできます。etc/default/nodm "にあるDisplayManagerの設定を変更してください。ここでは、"NODM_USER "を "dashboard "に、"NODM_ENABLED "を "true "に変更する必要があります。
```
# nodm configuration

# Set NODM_ENABLED to something different than 'false' to enable nodm
NODM_ENABLED=true

# User to autologin for
NODM_USER=dashboard

# First vt to try when looking for free VTs
NODM_FIRST_VT=7

# X session
NODM_XSESSION=/etc/X11/Xsession

# Options for nodm itself
NODM_OPTIONS=

# Options for the X server.
#
# Format: [/usr/bin/<Xserver>] [:<disp>] <Xserver-options>
#
# The Xserver executable and the display name can be omitted, but should
# be placed in front, if nodm's defaults shall be overridden.
NODM_X_OPTIONS='-nolisten tcp'

# If an X session will run for less than this time in seconds, nodm will wait an
# increasing bit of time before restarting the session
NODM_MIN_SESSION_TIME=60

# Timeout (in seconds) to wait for X to be ready to accept connections. If X is
# not ready before this timeout, it is killed and restarted.
NODM_X_TIMEOUT=300

```
ここで「sudo reboot」で再起動すると、以下のようなダッシュボードが表示されます。
{{< gallery match="images/3/*.jpg" >}}