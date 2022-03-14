+++
date = "2021-03-06"
title = "Issue Dashboard RaspberryPiZeroW, Javascript és GitLab segítségével"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210306-gitlab-dashboard/index.hu.md"
+++
A telepítés a Raspberry Noobs-szal gyerekjáték! Mindössze egy RaspberryZeroW-ra és egy üres SD-kártyára van szükséged.
## 1. lépés: Noobs telepítő
Töltse le a Noobs telepítőjét a https://www.raspberrypi.org/downloads/noobs/ oldalról.
## 2. lépés: SD kártya
Csomagolja ki ezt a zip-archívumot az üres SD-kártyára.
{{< gallery match="images/1/*.png" >}}
Kész! Most már csatlakoztathatja a RaspberryPiZero-t a TV-hez. Ezután megjelenik a telepítési menü.
{{< gallery match="images/2/*.jpg" >}}
Ha a kártyán van NoobsLite, akkor először WLAN-kapcsolatot kell létrehoznia. Ezután válassza ki a "Rasbian Lite"-ot, és kattintson a "Telepítés" gombra. A Rasbian Lite a kiszolgáló verzió, asztali gép nélkül. A rendszerindítás után a csomagkezelést frissíteni kell.
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
Ezt követően a következő csomagokat kell telepíteni:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
A műszerfal megjelenítéséhez is létre kell hozni egy felhasználót.
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Jelentkezzen be "Dashboard" felhasználóként:
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Hozzon létre egy X-Session -Scriptet. A kurzorbillentyűkkel tudok erre a sorra váltani, és az "i" billentyűvel tudok beszúrási módba váltani.
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
Tartalom
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
Ezután nyomja meg az "Esc" billentyűt a parancsmód megváltoztatásához, majd a ":wq" billentyűt az "írás" és a "kilépés" parancsokhoz. Ezen kívül a forgatókönyvhöz a következő jogok szükségesek:
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
Ebben a szkriptben a böngésző konfigurációja látható (/home/dashboard/uzbl.conf). Ez a konfiguráció így néz ki:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
Félidő! Majdnem kész vagy. Most szükséged van egy Javascriptre, amellyel szimulálni tudod a felhasználói viselkedést. Fontos, hogy hozzon létre egy külön Gitlab felhasználót. Ez a felhasználó "riporterként" kezelhető a projektekben.
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
Most már kijelentkezhet. Kérjük, módosítsa a DisplayManager beállítását az "/etc/default/nodm" alatt. Itt a "NODM_USER"-t "dashboard"-ra és a "NODM_ENABLED"-et "true"-ra kell változtatni.
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
Ha most újraindítod a "sudo reboot" paranccsal, a következő műszerfalat fogod látni:
{{< gallery match="images/3/*.jpg" >}}