+++
date = "2021-04-0q"
title = "阿特拉斯公司的酷事：为我的竹子监视器做宣传"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.zh.md"
+++
如何为Bamboo、Jenkins或Gitlab创建一个构建监视器？我今晚就能想出办法来!我已经写过一个类似的[Gitlab问题板教程]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Gitlab问题板教程")。
{{< gallery match="images/1/*.jpg" >}}
本教程的基础是Raspberry Imager和 "Raspberry Pi OS Lite "操作系统。安装完操作系统后，可以将SD卡插入树莓中。在我的例子中，这是一个Raspberry Pi Zero。
{{< gallery match="images/2/*.*" >}}

## 第1步：安装火柴盒/窗口管理器
要在信息亭模式下操作树莓，需要一个窗口管理器和一个浏览器。这些都是用以下命令安装的。
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## 第2步：我创建一个仪表板用户
通过以下命令，我创建了一个名为 "dashboard "的新用户。
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## 第3步：配置xServer和窗口管理器
以下所有步骤必须在 "仪表板 "用户会话中进行。我改用 "su "的会话。
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

## 3.1. ) 按钮/功能
我希望我的Raspberry可以在kiosk模式下操作。为了做到这一点，我存储了两个按键命令，Ctrl Alt X用于终端，Alt C用于关闭终端。在终端，你可以用ifconfig查询当前IP，用sudo shutdown -h now etc..... 关闭树莓。
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
这种情况下的关键布局如下。
```

## 窗口操作的捷径
<Alt>c=close
<ctrl><alt>x=!xterm

```

## 3.2. ) X - 会议
以下几行也必须在文件"$ vim ~/.xsession "中输入。这个脚本检查仪表板是否可以访问。如果它无法到达，它将等待10秒。当然，必须调整地址/IP。
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
脚本是可执行的，这一点非常重要。
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

## 3.3. )接口共同配置
下面几行是对网络界面的配置。浏览器被最大化，状态栏被隐藏。
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
内容。
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

## 3.4.)准备就绪
可以离开 "仪表板 "会议。
{{< terminal >}}
exit

{{</ terminal >}}

## 3.5.) 行为.js和滚动文本
这个Javascript控制董事会的行为。如果构建或测试失败，会显示一个大的刻度线。这样我即使在远处也能看到错误。
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
内容。
```
var bamboobUrl = 'https://ip:port';
var bambooUser = 'nutzer';
var bambooPassword = 'password';
var ticker = jQuery('<marquee direction="left" scrollamount="5" scrolldelay="2" style="display:none;background:#962526;position:fixed;bottom:0;left:0;width:100%;line-height:100px;font-size:80px;"></marquee>');

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

var timer = new Timer(10000);
jQuery('body').append(ticker);

/* login verhalten */
timer.append(
  function()
  {
    if (jQuery('#loginForm_os_username').length > 0)
    {
      jQuery('#loginForm_os_username').val(bambooUser);
      jQuery('#loginForm_os_password').val(bambooPassword);
      jQuery('#loginForm_save').click();
    }
    else if (jQuery('.aui-dropdown2-trigger-group').length > 0)
    {
      window.location.href = window.gitlabUrl + '/telemetry.action';
    }
  }
);

/* roter ticker */
timer.append(
  function()
  {
    if (jQuery('.Failed').length > 0)
    {
      var failedJobs = new Array();

      jQuery.each(
        jQuery('.Failed'),
        function() {
          failedJobs.push( jQuery(this).children('.plan-name').text() + ' (' + jQuery(this).find('time').text() + ')');
        }
      );
      var text = 'Fehlerhafte Jobs: ' + failedJobs.join(' | ');
      if( jQuery(ticker).text() !== text) 
      {
          jQuery(ticker).html('<span>' + text + '</span>');
          jQuery(ticker).show();
      }
      
    }
    else
    {
        jQuery(ticker).hide();
    }
  }
);


```
当然，你可以建立你想要的任何行为，例如重新启动失败的测试。
## 4. 自身进入X-session
下一步是设置自动登录。本文件就是为此目的而改编的。
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
在这里输入登录用户 "dashboard"，显示管理器被停用。
```
# nodm configuration
# Set NODM_ENABLED to something different than 'false' to enable nodm
NODM_ENABLED=true # <-- hier muss true hin

# User to autologin for
NODM_USER=dashboard # <-- hier muss dashboard hin

# First vt to try when looking for free VTs
NODM_FIRST_VT=7
# X session
NODM_XSESSION=/etc/X11/Xsession
# Options for the X server
NODM_X_OPTIONS='-nolisten tcp'
... usw

```
然后可以重新启动系统。
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## 准备就绪
每个dasboard应该每天重新启动一次。我已经为此创建了一个cron。
