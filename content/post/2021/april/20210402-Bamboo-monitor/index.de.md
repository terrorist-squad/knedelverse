+++
date = "2021-04-04"
title = "Cooles mit Atlassian: Pimp my Bamboo-Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.de.md"
+++

Wie kann man einen Build-Monitor für Bamboo, Jenkins oder Gitlab erstellen? Bis heute Abend finde ich es raus! Ich habe bereits ein ähnliches [Tutorial für Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Tutorial für Gitlab-Issue-Boards") geschrieben.
{{< gallery match="images/1/*.jpg" >}}




Die Basis für dieses Tutorials ist der Raspberry-Imager und das „Raspberry Pi OS Lite“-Betriebssystem. Nach der Betriebssystem-Installation kann die SD-Karte in den Raspberry gesteckt werden. In meinem Fall ist das ein Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Schritt 1: Matchbox/Window-Manager installieren
Um einen Raspberry im Kiosk-Modus zu betreiben, wird ein Window-Manager und ein Browser benötigt. Diese werden mit folgendem Befehl installiert:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim
{{</ terminal >}}

## Schritt 2: Ich erstelle einen Dashboard-Nutzer
Mit dem folgenden Befehl erstelle ich einen neuen Nutzer namens „dashboard“:
{{< terminal >}}
sudo adduser dashboard
{{</ terminal >}}

## Schritt 3: Konfiguration xServer und Window-Manager
Alle folgenden Schritte müssen in der „dashboard“-Nutzersession durchgeführt werden. Mit „su“ wechsel ich in die Session:
{{< terminal >}}
sudo su dashboard
{{</ terminal >}}

### 3.1. ) Tasten/Funktion
Mein Raspberry soll auch im Kiosk-Modus bedienbar sein. Dazu hinterlege ich zwei Tasten-Befehle, Strg+Alt+X für Terminal und Alt+C zum Schließen des Terminals. Im Terminal kann man die aktuelle IP mit ifconfig abfragen, den Raspberry mit sudo shutdown -h now herunterfahren usw…..
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig
{{</ terminal >}}

Das Tastenlayout in diesem Fall sieht wie folgt aus:
```
### Window operation short cuts
<Alt>c=close
<ctrl><alt>x=!xterm
```

### 3.2. ) X – Session
Auch die folgenden Zeilen müssen in einer Datei „$ vim ~/.xsession“ eingetragen werden. Dieses Script prüft, ob das Dashboard erreichbar ist. Wenn es nicht erreichbar ist, wird 10 Sekunden gewartet. Natürlich muss die Adresse/IP angepasst werden.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done
```

Ganz wichtig ist, dass das Script ausführbar ist:
{{< terminal >}}
sudo chmod 755 ~/.xsession
{{</ terminal >}}

### 3.3. ) Interface-Kofiguration
Mit den folgenden Zeilen wird das Web-Interface konfiguriert. Der Browser wird maximiert und die Statusbar wird ausgeblendet. 
{{< terminal >}}
vim ~/uzbl.conf
{{</ terminal >}}

Inhalt:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js
```

### 3.4.) Fertig
Die „dashboard“-Session kann verlassen werden:
{{< terminal >}}
exit
{{</ terminal >}}

### 3.5.) verhalten.js und Lauftext
Mit diesem Javascript wird das Board-Verhalten gesteuert. Wenn Build bzw. Test fehlschlagen, wird ein großer Ticker eingeblendet. So kann ich Fehler auch von Weitem sehen.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf
{{</ terminal >}}

Inhalt:
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
Natürlich kann man jedes gewünschte Verhalten einbauen, zum Beispiel das erneute Starten von fehlgeschlagenen Tests.

## 4. Autologin in die X-Session
Als Nächstes wird der automatische Login eingestellt. Dafür wird diese Datei angepasst: 
{{< terminal >}}
sudo vim /etc/default/nodm
{{</ terminal >}}

Hier wird der Login User „dashboard“ eingetragen und der Displaymanager deaktiviert:
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

Danach kann das System rebootet werden.

{{< terminal >}}
sudo reboot
{{</ terminal >}}

## Fertig
Jedes Dasboard sollte einmal pro Tag neu gestartet werden. Ich habe mir einen Cron dafür angelegt. 