+++
date = "2021-04-0q"
title = "Leuke dingen met Atlassian: Pimp mijn Bamboo-monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.nl.md"
+++
Hoe kan ik een buildmonitor voor Bamboo, Jenkins of Gitlab maken? Ik zal het vanavond uitzoeken! Ik heb al een soortgelijke [Handleiding voor Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Handleiding voor Gitlab-Issue-Boards") geschreven.
{{< gallery match="images/1/*.jpg" >}}
De basis voor deze tutorial is de Raspberry Imager en het "Raspberry Pi OS Lite" besturingssysteem. Na het installeren van het besturingssysteem kan de SD-kaart in de Raspberry worden gestoken. In mijn geval is dat een Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Stap 1: Installeer Matchbox/Window Manager
Om een Raspberry in kioskmodus te laten werken, zijn een window manager en een browser nodig. Deze worden geïnstalleerd met het volgende commando:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Stap 2: Ik maak een dashboard gebruiker
Met het volgende commando maak ik een nieuwe gebruiker aan met de naam "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Stap 3: Configuratie xServer en Window Manager
Alle volgende stappen moeten worden uitgevoerd in de "dashboard" gebruikerssessie. Ik ga over naar de sessie met "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Knoppen/Functie
Ik wil dat mijn Raspberry bruikbaar is in kiosk modus. Om dit te doen, sla ik twee toetscommando's op, Ctrl Alt X voor de terminal en Alt C om de terminal te sluiten. In de terminal, kan je het huidige IP opvragen met ifconfig, de Raspberry afsluiten met sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
De sleutelindeling is in dit geval als volgt:
```

##  Snelle vensterbediening
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Session
De volgende regels moeten ook worden ingevoerd in een bestand "$ vim ~/.xsession". Dit script controleert of het dashboard toegankelijk is. Als hij niet bereikbaar is, wacht hij 10 seconden. Natuurlijk moet het adres/IP worden aangepast.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Het is zeer belangrijk dat het script uitvoerbaar is:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Interface co-configuratie
De volgende regels configureren de webinterface. De browser is gemaximaliseerd en de statusbalk is verborgen.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Inhoud:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Klaar
De "dashboard" sessie kan verlaten worden:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behaviour.js en scrollende tekst
Dit Javascript regelt het gedrag van het bord. Als het bouwen of de test mislukt, wordt er een grote ticker getoond. Op deze manier kan ik fouten zien, zelfs van een afstand.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Inhoud:
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
Natuurlijk kun je elk gedrag inbouwen dat je wilt, zoals het opnieuw starten van mislukte tests.
## 4. autologue in de X-sessie
De volgende stap is het instellen van de automatische aanmelding. Dit bestand is voor dit doel aangepast:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Hier wordt de login-gebruiker "dashboard" ingevoerd en wordt de display-manager gedeactiveerd:
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
Het systeem kan dan opnieuw worden opgestart.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Klaar
Elk dasboard moet één keer per dag opnieuw worden opgestart. Ik heb hier een cron voor gemaakt.
