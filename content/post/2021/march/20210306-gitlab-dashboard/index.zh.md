+++
date = "2021-03-06"
title = "使用RaspberryPiZeroW、Javascript和GitLab的问题仪表板"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210306-gitlab-dashboard/index.zh.md"
+++
用Raspberry Noobs进行安装是小儿科!你只需要一个RaspberryZeroW和一张空白SD卡。
## 第1步：Noobs安装程序
从https://www.raspberrypi.org/downloads/noobs/ 下载Noobs安装程序。
## 第2步：SD卡
在空的SD卡上解压这个压缩文件。
{{< gallery match="images/1/*.png" >}}
完成了!现在你可以把RaspberryPiZero连接到电视上。然后你会看到安装菜单。
{{< gallery match="images/2/*.jpg" >}}
如果你的卡上有NoobsLite，你必须首先建立一个WLAN连接。然后选择 "Rasbian Lite "并点击 "安装"。Rasbian Lite是没有桌面的服务器版本。启动后，必须更新软件包管理。
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
之后，必须安装以下软件包。
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
还必须为仪表板显示创建一个用户。
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
以 "仪表板 "用户身份登录。
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
创建一个X-Session -Script。我可以用光标键换到这一行，用 "i "键换到插入模式。
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
内容
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
然后按 "Esc "键改变命令模式，然后按":wq "表示 "写 "和 "退出"。此外，这个脚本需要以下权限。
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
在这个脚本中，你可以看到一个浏览器配置（/home/dashboard/uzbl.conf）。这个配置看起来像这样。
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
半场结束!你几乎已经完成了。现在你需要一个Javascript，用它来模拟用户行为。创建一个独立的Gitlab用户是很重要的。这个用户可以作为项目中的 "报告人 "进行管理。
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
现在你可以注销了。请修改"/etc/default/nodm "下的DisplayManager设置。这里你必须把 "NODM_USER "改为 "dashboard"，"NODM_ENABLED "改为 "true"。
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
如果你现在用 "sudo reboot "重新启动，你会看到以下仪表板。
{{< gallery match="images/3/*.jpg" >}}
