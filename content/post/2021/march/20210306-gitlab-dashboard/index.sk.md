+++
date = "2021-03-06"
title = "Ovládací panel problémov s RaspberryPiZeroW, Javascriptom a GitLabom"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210306-gitlab-dashboard/index.sk.md"
+++
Inštalácia s Raspberry Noobs je detská hra! Potrebujete len RaspberryZeroW a prázdnu kartu SD.
## Krok 1: Inštalačný program Noobs
Stiahnite si inštalačný program Noobs zo stránky https://www.raspberrypi.org/downloads/noobs/.
## Krok 2: Karta SD
Rozbaľte tento archív zip na prázdnu kartu SD.
{{< gallery match="images/1/*.png" >}}
Hotovo! Teraz môžete pripojiť RaspberryPiZero k televízoru. Potom sa zobrazí ponuka inštalácie.
{{< gallery match="images/2/*.jpg" >}}
Ak máte na karte NoobsLite, musíte najprv vytvoriť pripojenie WLAN. Potom vyberte "Rasbian Lite" a kliknite na "Inštalovať". Rasbian Lite je serverová verzia bez pracovnej plochy. Po spustení systému je potrebné aktualizovať správu balíkov.
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
Potom je potrebné nainštalovať nasledujúce balíky:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
Používateľ musí byť vytvorený aj pre zobrazenie prístrojovej dosky.
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Prihláste sa ako používateľ "Dashboard":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Vytvorenie relácie X-Session -Script. Na tento riadok môžem prejsť pomocou kurzorových klávesov a do režimu vkladania sa prepnem pomocou klávesu "i".
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
Potom stlačte kláves "Esc", aby ste zmenili režim príkazu, a potom ":wq" pre "write" a "quit". Okrem toho tento skript vyžaduje nasledujúce práva:
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
V tomto skripte sa zobrazuje konfigurácia prehliadača (/home/dashboard/uzbl.conf). Táto konfigurácia vyzerá takto:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
Polčas! Už ste takmer hotoví. Teraz potrebujete Javascript, pomocou ktorého môžete simulovať správanie používateľa. Je dôležité, aby ste si vytvorili samostatného používateľa služby Gitlab. Tento používateľ môže byť v projektoch spravovaný ako "reportér".
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
Teraz sa môžete odhlásiť. Zmeňte nastavenie DisplayManager v položke "/etc/default/nodm". Tu musíte zmeniť "NODM_USER" na "dashboard" a "NODM_ENABLED" na "true".
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
Ak teraz reštartujete počítač príkazom "sudo reboot", zobrazí sa nasledujúci panel:
{{< gallery match="images/3/*.jpg" >}}