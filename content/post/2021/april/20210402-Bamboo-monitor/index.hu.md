+++
date = "2021-04-0q"
title = "Király dolgok az Atlassian segítségével: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.hu.md"
+++
Hogyan hozhatok létre egy build monitort a Bamboo, Jenkins vagy Gitlab számára? Ma estére kitalálom! Már írtam egy hasonló [Tutorial a Gitlab-Issue-Boards számára]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Tutorial a Gitlab-Issue-Boards számára")-t.
{{< gallery match="images/1/*.jpg" >}}
A bemutató alapja a Raspberry Imager és a "Raspberry Pi OS Lite" operációs rendszer. Az operációs rendszer telepítése után az SD-kártya behelyezhető a Raspberrybe. Az én esetemben ez egy Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## 1. lépés: A Matchbox/Window Manager telepítése
A Raspberry kioszk üzemmódban történő működtetéséhez egy ablakkezelőre és egy böngészőre van szükség. Ezek telepítése a következő paranccsal történik:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## 2. lépés: Létrehozok egy műszerfal felhasználót
A következő paranccsal létrehozok egy új felhasználót "dashboard" néven:
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## 3. lépés: Az xServer és az ablakkezelő konfigurálása
A következő lépéseket a "műszerfal" felhasználói munkamenetben kell végrehajtani. Átváltok a "su" munkamenetre:
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Gombok/Funkciók
Azt akarom, hogy a Málnám kioszk üzemmódban is működőképes legyen. Ehhez két billentyűparancsot tárolok: Ctrl Alt X a terminálhoz és Alt C a terminál bezárásához. A terminálban lekérdezheti az aktuális IP-t az ifconfig segítségével, a málna leállítása a sudo shutdown -h now stb..... segítségével.
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
A kulcsok elrendezése ebben az esetben a következő:
```

##  Ablakműködtetés rövidítések
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Munkamenet
A következő sorokat is be kell írni a "$ vim ~/.xsession" fájlba. Ez a szkript ellenőrzi, hogy a műszerfal elérhető-e. Ha nem érhető el, 10 másodpercet vár. Természetesen a címet/IP-t is be kell állítani.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Nagyon fontos, hogy a szkript végrehajtható legyen:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Interfész társ-konfiguráció
A következő sorok a webes felületet konfigurálják. A böngésző maximalizálva van, és az állapotsor el van rejtve.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Tartalom:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Kész
A "műszerfal" munkamenet elhagyható:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behaviour.js és gördülő szöveg
Ez a Javascript vezérli a tábla viselkedését. Ha az építés vagy a teszt sikertelen, egy nagyméretű ketyegő jelenik meg. Így még távolról is látom a hibákat.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Tartalom:
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
Természetesen bármilyen viselkedést beépíthet, például a sikertelen tesztek újraindítását.
## 4. autológue az X-ülésbe
A következő lépés az automatikus bejelentkezés beállítása. Ez a fájl erre a célra lett átalakítva:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
A "műszerfal" bejelentkező felhasználó itt kerül beírásra, és a kijelzőkezelőt kikapcsoljuk:
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
Ezután a rendszer újraindítható.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Kész
Minden dasboardot naponta egyszer újra kell indítani. Létrehoztam egy cron programot erre a célra.
