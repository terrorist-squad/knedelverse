+++
date = "2021-03-06"
title = "Issue Dashboard met RaspberryPiZeroW, Javascript en GitLab"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210306-gitlab-dashboard/index.nl.md"
+++
Installatie met Raspberry Noobs is kinderspel! Alles wat je nodig hebt is een RaspberryZeroW en een lege SD kaart.
## Stap 1: Noobs Installer
Download de Noobs installer van https://www.raspberrypi.org/downloads/noobs/.
## Stap 2: SD-kaart
Pak dit zip-archief uit op de lege SD-kaart.
{{< gallery match="images/1/*.png" >}}
Klaar! Nu kun je de RaspberryPiZero op de TV aansluiten. U krijgt dan het installatiemenu te zien.
{{< gallery match="images/2/*.jpg" >}}
Als u NoobsLite op de kaart hebt, moet u eerst een WLAN-verbinding tot stand brengen. Selecteer dan "Rasbian Lite" en klik op "Installeren". Rasbian Lite is de server versie zonder desktop. Na het opstarten moet het pakketbeheer worden bijgewerkt.
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
Daarna moeten de volgende pakketten worden geïnstalleerd:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
Er moet ook een gebruiker worden aangemaakt voor de dashboardweergave.
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Log in als een "Dashboard" gebruiker:
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Maak een X-Session -Script. Ik kan naar deze regel gaan met de cursortoetsen en overschakelen naar de invoegmodus met de "i"-toets.
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
Inhoud
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
Druk vervolgens op de "Esc"-toets om de commandomodus te wijzigen en vervolgens op ":wq" voor "write" en "quit". Bovendien heeft dit script de volgende rechten nodig:
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
In dit script zie je een browser configuratie (/home/dashboard/uzbl.conf). Deze configuratie ziet er als volgt uit:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
Rust! Je bent bijna klaar. Nu heb je een Javascript nodig waarmee je gebruikersgedrag kunt simuleren. Het is belangrijk dat je een aparte Gitlab gebruiker aanmaakt. Deze gebruiker kan worden beheerd als een "reporter" in projecten.
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
Nu kun je uitloggen. Verander de DisplayManager instelling onder "/etc/default/nodm". Hier moet u de "NODM_USER" wijzigen in "dashboard" en "NODM_ENABLED" in "true".
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
Als je nu reboot met "sudo reboot", zal je het volgende dashboard zien:
{{< gallery match="images/3/*.jpg" >}}