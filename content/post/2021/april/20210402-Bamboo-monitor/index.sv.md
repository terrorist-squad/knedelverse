+++
date = "2021-04-0q"
title = "Coola saker med Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.sv.md"
+++
Hur kan jag skapa en byggövervakare för Bamboo, Jenkins eller Gitlab? Jag kommer att komma på det i kväll! Jag har redan skrivit ett liknande [Handledning för Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Handledning för Gitlab-Issue-Boards").
{{< gallery match="images/1/*.jpg" >}}
Grunden för den här handledningen är Raspberry Imager och operativsystemet "Raspberry Pi OS Lite". Efter att ha installerat operativsystemet kan SD-kortet sättas in i Raspberry. I mitt fall är det en Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Steg 1: Installera Matchbox/Window Manager
För att använda en Raspberry i kioskläge krävs en fönsterhanterare och en webbläsare. Dessa installeras med följande kommando:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Steg 2: Jag skapar en dashboard-användare
Med följande kommando skapar jag en ny användare som heter "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Steg 3: Konfiguration av xServer och Window Manager
Alla följande steg måste utföras i användarsessionen "instrumentpanel". Jag byter till sessionen med "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Knappar/Funktion
Jag vill att min Raspberry ska kunna användas i kioskläge. För att göra detta lagrar jag två tangentkommandon: Ctrl Alt X för terminalen och Alt C för att stänga terminalen. I terminalen kan du fråga efter den aktuella IP:n med ifconfig, stänga av hallonet med sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Nyckelindelningen i detta fall är följande:
```

##  Kortversioner av fönsteroperationer
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Session
Följande rader måste också skrivas in i en fil "$ vim ~/.xsession". Det här skriptet kontrollerar om instrumentpanelen är tillgänglig. Om den inte går att nå väntar den 10 sekunder. Självklart måste adressen/IP-adressen justeras.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Det är mycket viktigt att skriptet är körbart:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Samkonfigurering av gränssnitt
Följande rader konfigurerar webbgränssnittet. Webbläsaren är maximerad och statusfältet är dolt.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Innehåll:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Redo
Sessionen "instrumentpanel" kan lämnas:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behaviour.js och rullande text
Denna Javascript kontrollerar styrelsens beteende. Om byggandet eller testet misslyckas visas en stor ticker. På så sätt kan jag se fel även på avstånd.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Innehåll:
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
Naturligtvis kan du bygga in vilket beteende som helst, t.ex. att starta om misslyckade tester.
## 4. autolog till X-sessionen
Nästa steg är att ställa in den automatiska inloggningen. Denna fil är anpassad för detta ändamål:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Här anges inloggningsanvändaren "dashboard" och displayhanteraren avaktiveras:
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
Systemet kan sedan startas om.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Redo
Varje dasboard ska startas om en gång om dagen. Jag har skapat en cron för detta.
