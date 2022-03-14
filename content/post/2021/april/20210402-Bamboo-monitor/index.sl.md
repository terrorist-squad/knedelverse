+++
date = "2021-04-04"
title = "Kul stvari z družbo Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-Bamboo-monitor/index.sl.md"
+++
Kako lahko ustvarim nadzornik gradnje za Bamboo, Jenkins ali Gitlab? Do večera bom to ugotovil! Napisal sem že podobno [Vadnica za Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Vadnica za Gitlab-Issue-Boards").
{{< gallery match="images/1/*.jpg" >}}
Osnova za to vadnico je Raspberry Imager in operacijski sistem "Raspberry Pi OS Lite". Po namestitvi operacijskega sistema lahko kartico SD vstavite v Raspberry. V mojem primeru je to Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Korak 1: Namestitev programa Matchbox/Window Manager
Za upravljanje maline v načinu kioska sta potrebna upravitelj oken in brskalnik. Namestite jih z naslednjim ukazom:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Korak 2: Ustvarim uporabnika nadzorne plošče
Z naslednjim ukazom ustvarim novega uporabnika z imenom "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Korak 3: Konfiguracija xServerja in Upravitelja oken
Vse naslednje korake je treba izvesti v seji uporabnika "nadzorna plošča". Spremenim se v sejo s "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Gumbi/funkcije
Želim, da moja malina deluje v načinu kioska. V ta namen shranim dva ukaza, Ctrl Alt X za terminal in Alt C za zaprtje terminala. V terminalu lahko poizvedujete po trenutnem IP s ifconfig, izklopite Raspberry s sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Razporeditev ključev je v tem primeru naslednja:
```

##  Bližnjice za delovanje oken
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - seja
V datoteko "$ vim ~/.xsession" je treba vnesti tudi naslednje vrstice. Ta skripta preveri, ali je nadzorna plošča dostopna. Če ni dosegljiv, počaka 10 sekund. Seveda je treba prilagoditi naslov/IP.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Zelo pomembno je, da je skripta izvršljiva:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Sočasna konfiguracija vmesnika
Naslednje vrstice konfigurirajo spletni vmesnik. Brskalnik je povečan in vrstica stanja je skrita.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Vsebina:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Pripravljen
Sejo "nadzorne plošče" lahko zapustite:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behaviour.js in pomikanje besedila
Ta Javascript nadzoruje obnašanje plošče. Če sestava ali test ne uspe, se prikaže velik kljukec. Tako lahko napake vidim že od daleč.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Vsebina:
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
Seveda lahko vgradite poljubno vedenje, na primer ponovni zagon neuspešnih testov.
## 4. avtologiranje v sejo X
Naslednji korak je nastavitev samodejne prijave. Ta datoteka je prilagojena za ta namen:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Tu se vnese uporabnik za prijavo "dashboard" in deaktivira upravitelj zaslona:
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
Sistem lahko nato ponovno zaženete.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Pripravljen
