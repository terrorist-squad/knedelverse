+++
date = "2021-03-06"
title = "Issue Dashboard kanssa RaspberryPiZeroW, Javascript ja GitLab"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210306-gitlab-dashboard/index.fi.md"
+++
Asennus Raspberry Noobsilla on lastenleikkiä! Tarvitset vain RaspberryZeroW:n ja tyhjän SD-kortin.
## Vaihe 1: Noobs Installer
Lataa Noobs-asennusohjelma osoitteesta https://www.raspberrypi.org/downloads/noobs/.
## Vaihe 2: SD-kortti
Pura tämä zip-arkisto tyhjälle SD-kortille.
{{< gallery match="images/1/*.png" >}}
Valmis! Nyt voit liittää RaspberryPiZeron televisioon. Tämän jälkeen näet asennusvalikon.
{{< gallery match="images/2/*.jpg" >}}
Jos kortilla on NoobsLite, sinun on ensin muodostettava WLAN-yhteys. Valitse sitten "Rasbian Lite" ja napsauta "Asenna". Rasbian Lite on palvelinversio ilman työpöytää. Käynnistyksen jälkeen paketinhallinta on päivitettävä.
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
Tämän jälkeen on asennettava seuraavat paketit:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
Kojelaudan näyttöä varten on myös luotava käyttäjä.
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Kirjaudu sisään "Dashboard"-käyttäjänä:
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Luo X-Session -Script. Voin siirtyä tälle riville kursorinäppäimillä ja vaihtaa insert-tilaan i-näppäimellä.
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
Sisältö
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
Paina sitten "Esc"-näppäintä vaihtaaksesi komentotilaa ja sitten ":wq" "write" ja "quit". Lisäksi tämä komentosarja vaatii seuraavat oikeudet:
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
Tässä skriptissä näet selaimen asetukset (/home/dashboard/uzbl.conf). Tämä kokoonpano näyttää seuraavalta:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
Puoliaika! Olet melkein valmis. Nyt tarvitset Javascriptin, jolla voit simuloida käyttäjän käyttäytymistä. On tärkeää, että luot erillisen Gitlab-käyttäjän. Tätä käyttäjää voidaan hallita "raportoijana" projekteissa.
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
Nyt voit kirjautua ulos. Vaihda DisplayManager-asetusta kohdassa "/etc/default/nodm". Tässä sinun on muutettava "NODM_USER" muotoon "dashboard" ja "NODM_ENABLED" muotoon "true".
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
Jos nyt käynnistät järjestelmän uudelleen komennolla "sudo reboot", näet seuraavan kojelaudan:
{{< gallery match="images/3/*.jpg" >}}