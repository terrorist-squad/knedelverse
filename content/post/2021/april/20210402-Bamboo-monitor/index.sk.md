+++
date = "2021-04-04"
title = "Parádne veci s Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-Bamboo-monitor/index.sk.md"
+++
Ako môžem vytvoriť monitor zostavenia pre Bamboo, Jenkins alebo Gitlab? Do večera na to prídem! Už som napísal podobný [Výukový program pre Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Výukový program pre Gitlab-Issue-Boards").
{{< gallery match="images/1/*.jpg" >}}
Základom tohto návodu je Raspberry Imager a operačný systém "Raspberry Pi OS Lite". Po inštalácii operačného systému môžete do Raspberry vložiť kartu SD. V mojom prípade je to Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Krok 1: Inštalácia aplikácie Matchbox/Správca okien
Na prevádzku Raspberry v režime kiosku je potrebný správca okien a prehliadač. Tie sa inštalujú pomocou nasledujúceho príkazu:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Krok 2: Vytvorím používateľa ovládacieho panela
Nasledujúcim príkazom vytvorím nového používateľa s názvom "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Krok 3: Konfigurácia xServeru a Správcu okien
Všetky nasledujúce kroky sa musia vykonať v relácii používateľa "dashboard". Prepnem na reláciu s "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Tlačidlá/funkcie
Chcem, aby moja Raspberry mohla fungovať v režime kiosku. Na tento účel som uložil dva príkazy klávesov, Ctrl Alt X pre terminál a Alt C na zatvorenie terminálu. V termináli sa môžete opýtať na aktuálnu IP pomocou ifconfig, vypnúť Raspberry pomocou sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Rozloženie kľúča je v tomto prípade nasledovné:
```

##  Skrátené operácie s oknami
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - zasadnutie
V súbore "$ vim ~/.xsession" musia byť zadané aj nasledujúce riadky. Tento skript skontroluje, či je prístrojový panel prístupný. Ak nie je dosiahnuteľný, počká 10 sekúnd. Samozrejme, je potrebné upraviť adresu/IP.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Je veľmi dôležité, aby bol skript spustiteľný:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Spolukonfigurácia rozhrania
Nasledujúce riadky konfigurujú webové rozhranie. Prehliadač je maximalizovaný a stavový riadok je skrytý.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Obsah:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Pripravené
Revíziu "prístrojovej dosky" môžete ponechať:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behavior.js a rolovanie textu
Tento Javascript riadi správanie dosky. Ak zostavenie alebo test zlyhajú, zobrazí sa veľký symbol. Takto môžem vidieť chyby aj z väčšej vzdialenosti.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Obsah:
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
Samozrejme, môžete do neho zabudovať ľubovoľné správanie, napríklad reštartovanie neúspešných testov.
## 4. autologue do relácie X
Ďalším krokom je nastavenie automatického prihlásenia. Tento súbor je prispôsobený na tento účel:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Tu sa zadá prihlasovací používateľ "dashboard" a deaktivuje sa správca zobrazenia:
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
Systém sa potom môže reštartovať.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Pripravené
