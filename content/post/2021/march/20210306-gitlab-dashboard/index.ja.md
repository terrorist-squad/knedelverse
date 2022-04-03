+++
date = "2021-03-06"
title = "RaspberryPiZeroWとJavascriptとGitLabで作るイシューダッシュボード"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210306-gitlab-dashboard/index.ja.md"
+++
Raspberry Noobsでインストールするのは簡単です。必要なものは、RaspberryZeroWと空のSDカードだけです。
## ステップ1：Noobsインストーラー
Noobsのインストーラは、https://www.raspberrypi.org/downloads/noobs/ からダウンロードしてください。
## ステップ2：SDカード
空のSDカードにこのZIPアーカイブを解凍してください。
{{< gallery match="images/1/*.png" >}}
完了！これで、RaspberryPiZeroとテレビを接続することができました。その後、インストールメニューが表示されます。
{{< gallery match="images/2/*.jpg" >}}
NoobsLiteがカードに搭載されている場合、まずWLAN接続を確立する必要があります。そして、「Rasbian Lite」を選択し、「インストール」をクリックします。Rasbian Liteは、デスクトップがないサーバー版です。起動後、パッケージ管理の更新が必要です。
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
その後、以下のパッケージがインストールされている必要があります。
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
また、ダッシュボード表示用のユーザーも作成する必要があります。
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Dashboard」ユーザーでログインする。
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
X-Sessionを作成する -Script.カーソルキーでこの行に移動し、「i」キーで挿入モードに変更することができますね。
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
次に「Esc」キーを押してコマンドモードを変更し、「:wq」で「書き込み」、「終了」します。また、このスクリプトには、以下の権利が必要です。
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
このスクリプトでは、ブラウザの設定(/home/dashboard/uzbl.conf)を見ています。この構成は次のようなものです。
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
ハーフタイム！もう少しで完成です。次に、ユーザーの行動をシミュレートするためのJavascriptが必要です。Gitlabのユーザーを別に作成することが重要です。このユーザーは、プロジェクトにおいて「報告者」として管理することができます。
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
これで、ログアウトできます。etc/default/nodm "のDisplayManagerの設定を変更してください。ここでは、「NODM_USER」を「dashboard」に、「NODM_ENABLED」を「true」に変更する必要があります。
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
ここで、「sudo reboot」で再起動すると、以下のようなダッシュボードが表示されます。
{{< gallery match="images/3/*.jpg" >}}
