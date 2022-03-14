+++
date = "2021-03-06"
title = "Issue-Dashboard mit RaspberryPiZeroW, Javascript und GitLab"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210306-gitlab-dashboard/index.de.md"
+++

Die Installation mit Raspberry-Noobs ist kinderleicht! Alles was Sie brauchen ist ein RaspberryZeroW und eine leere SD-Karte.

## Schritt 1: Noobs-Installer
Laden Sie den Noobs-Installer von https://www.raspberrypi.org/downloads/noobs/ herunter.

## Schritt 2: SD-Karte
Entpacken Sie dieses Zip-Archiv auf der leeren SD-Karte.
{{< gallery match="images/1/*.png" >}}

Fertig! Nun können Sie den RaspberryPiZero am Fernseher anschließen. Anschließend sehen Sie das Installations-Menü.
{{< gallery match="images/2/*.jpg" >}}

Wenn Sie NoobsLite auf der Karte haben, dann müssen Sie zunächst eine WLAN – Verbindung herstellen. Bitte wählen Sie anschließend „Rasbian Lite“ aus und klicken auf „Install“. Rasbian Lite ist die Server – Variante ohne Desktop. Nach dem Booten muss die Paketverwaltung aktualisiert werden.
{{< terminal >}}
sudo apt-get update
{{</ terminal >}}

Danach müssen die folgenden Pakete installiert werden:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim
{{</ terminal >}}

Außerdem muss ein Nutzer für die Dashboard-Anzeige angelegt werden.
{{< terminal >}}
sudo adduser dashboard
{{</ terminal >}}

Loggen Sie sich als “Dashboard”-Nutzer ein:
{{< terminal >}}
sudo su dashboard
{{</ terminal >}}

Erstellen Sie ein X-Session -Script. Ich kann mit den Cursor-Tasten in diese Zeile wechseln und mit der „i"-Taste in den Insert-Modus wechseln.
{{< terminal >}}
sudo vim ~/.xsession
{{</ terminal >}}

Inhalt
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done
```

Danach drücken Sie die „Esc“-Taste um den Befehls-Modus zu wechseln und dann „:wq“ für „write“ und „quit". Außerdem benötigt dieses Script die folgenden Rechte:
{{< terminal >}}
chmod 755 ~/.xsession
{{</ terminal >}}

In diesem Script sehen Sie eine Browser-Konfiguration (/home/dashboard/uzbl.conf). Diese Konfiguration sieht wie folgt aus:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js
```

Halbzeit! Sie sind fast fertig. Nun brauchen Sie ein Javascript, mit diesen Sie ein Nutzerverhalten simulieren können. Wichtig ist, dass Sie einen separaten Gitlab-Nutzer anlegen. Dieser Nutzer kann als “Reporter” in Projekten geführt werden.
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

Nun können Sie sich ausloggen. Bitte ändern Sie noch die DisplayManager- Einstellung unter “/etc/default/nodm”. Hier müssen Sie den “NODM_USER” zu “dashboard” und “NODM_ENABLED” zu “true” ändern.
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

Wenn Sie jetzt mit “sudo reboot” rebooten, dann sehen Sie folgendes Dashboard:
{{< gallery match="images/3/*.jpg" >}}