+++
date = "2021-03-06"
title = "Dashboard s RaspberryPiZeroW, Javascriptem a GitLabem"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210306-gitlab-dashboard/index.cs.md"
+++
Instalace s Raspberry Noobs je hračka! Potřebujete pouze RaspberryZeroW a prázdnou kartu SD.
## Krok 1: Instalační program Noobs
Stáhněte si instalační program Noobs ze stránek https://www.raspberrypi.org/downloads/noobs/.
## Krok 2: Karta SD
Rozbalte tento archiv zip na prázdnou kartu SD.
{{< gallery match="images/1/*.png" >}}
Hotovo! Nyní můžete připojit RaspberryPiZero k televizoru. Poté se zobrazí nabídka instalace.
{{< gallery match="images/2/*.jpg" >}}
Pokud máte na kartě NoobsLite, musíte nejprve navázat připojení k síti WLAN. Poté vyberte "Rasbian Lite" a klikněte na "Instalovat". Rasbian Lite je serverová verze bez pracovní plochy. Po zavedení systému je třeba aktualizovat správu balíčků.
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
Poté je třeba nainstalovat následující balíčky:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
Uživatel musí být vytvořen také pro zobrazení na přístrojové desce.
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Přihlaste se jako uživatel "Dashboard":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Vytvoření X-Session -Script. Na tento řádek mohu přejít pomocí kurzorových kláves a klávesou "i" přejít do režimu vkládání.
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
Obsah
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
Poté stiskněte klávesu "Esc" pro změnu příkazového režimu a poté ":wq" pro "write" a "quit". Kromě toho tento skript vyžaduje následující práva:
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
V tomto skriptu vidíte konfiguraci prohlížeče (/home/dashboard/uzbl.conf). Tato konfigurace vypadá následovně:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
Poločas! Jste téměř hotovi. Nyní potřebujete Javascript, pomocí kterého můžete simulovat chování uživatele. Je důležité, abyste si vytvořili samostatného uživatele Gitlabu. Tento uživatel může být v projektech spravován jako "reportér".
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
Nyní se můžete odhlásit. Změňte prosím nastavení DisplayManager v položce "/etc/default/nodm". Zde musíte změnit "NODM_USER" na "dashboard" a "NODM_ENABLED" na "true".
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
Pokud nyní restartujete počítač příkazem "sudo reboot", zobrazí se následující ovládací panel:
{{< gallery match="images/3/*.jpg" >}}