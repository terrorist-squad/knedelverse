+++
date = "2021-04-04"
title = "Cool stuff with Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.en.md"
+++
How to create a build monitor for Bamboo, Jenkins or Gitlab? I'll figure it out by tonight! I have already written a similar [Tutorial for Gitlab Issue Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Tutorial for Gitlab Issue Boards").
{{< gallery match="images/1/*.jpg" >}}
The basis for this tutorial is the Raspberry Imager and the "Raspberry Pi OS Lite" operating system. After the OS installation, the SD card can be inserted into the Raspberry. In my case this is a Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Step 1: Install Matchbox/Window Manager
To run a Raspberry in kiosk mode, a window manager and browser are required. These are installed with the following command:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Step 2: I create a dashboard user
With the following command I create a new user named "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Step 3: Configuration xServer and Window Manager
All the following steps must be done in the "dashboard" user session. With "su" I change into the session:
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Keys/Function
My Raspberry should also be operable in kiosk mode. For this I store two key commands, Ctrl Alt X for terminal and Alt C to close the terminal. In the terminal you can query the current IP with ifconfig, shut down the Raspberry with sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
The key layout in this case is as follows:
```

##  Window operation short cuts
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Session
Also the following lines must be entered in a file "$ vim ~/.xsession". This script checks if the dashboard is reachable. If it is not reachable, it waits 10 seconds. Of course the address/IP has to be adjusted.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
It is very important that the script is executable:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Interface configuration
The following lines configure the web interface. The browser is maximized and the status bar is hidden.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Content:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Ready
The "dashboard" session can be left:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behave.js and scrolling text
This javascript is used to control the board behavior. If build or test fails, a big ticker is shown. So I can see errors even from a distance.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Content:
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
Of course, you can include any behavior you want, such as restarting failed tests.
## 4. autologue into the X-session
The next step is to set the automatic login. This file is adapted for this purpose:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Here the login user "dashboard" is entered and the display manager is deactivated:
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
After that, the system can be rebooted.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Ready
