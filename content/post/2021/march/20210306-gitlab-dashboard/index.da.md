+++
date = "2021-03-06"
title = "Issue Dashboard med RaspberryPiZeroW, Javascript og GitLab"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210306-gitlab-dashboard/index.da.md"
+++
Installation med Raspberry Noobs er en leg for børn! Alt du skal bruge er en RaspberryZeroW og et tomt SD-kort.
## Trin 1: Noobs Installer
Download Noobs-installationsprogrammet fra https://www.raspberrypi.org/downloads/noobs/.
## Trin 2: SD-kort
Pak zip-arkivet ud på det tomme SD-kort.
{{< gallery match="images/1/*.png" >}}
Færdig! Nu kan du tilslutte RaspberryPiZero til tv'et. Derefter vises installationsmenuen.
{{< gallery match="images/2/*.jpg" >}}
Hvis du har NoobsLite på kortet, skal du først oprette en WLAN-forbindelse. Vælg derefter "Rasbian Lite", og klik på "Install". Rasbian Lite er serverversionen uden skrivebord. Efter opstart skal pakkehåndteringen opdateres.
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
Herefter skal følgende pakker installeres:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
Der skal også oprettes en bruger til visning af instrumentbrættet.
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Log ind som en "Dashboard"-bruger:
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Opret en X-Session -Script. Jeg kan skifte til denne linje med markørtasterne og skifte til indsætningstilstand med "i"-tasten.
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
Indhold
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
Tryk derefter på "Esc"-tasten for at ændre kommandomodus og derefter på ":wq" for "write" og "quit". Desuden kræver dette script følgende rettigheder:
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
I dette script kan du se en browserkonfiguration (/home/dashboard/uzbl.conf). Denne konfiguration ser således ud:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
Halvleg! Du er næsten færdig. Nu har du brug for et Javascript, som du kan simulere brugerens adfærd med. Det er vigtigt, at du opretter en separat Gitlab-bruger. Denne bruger kan administreres som "reporter" i projekter.
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
Nu kan du logge ud. Ændre DisplayManager-indstillingen under "/etc/default/nodm". Her skal du ændre "NODM_USER" til "dashboard" og "NODM_ENABLED" til "true".
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
Hvis du nu genstarter med "sudo reboot", vil du se følgende instrumentbræt:
{{< gallery match="images/3/*.jpg" >}}
