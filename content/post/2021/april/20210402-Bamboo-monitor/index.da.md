+++
date = "2021-04-04"
title = "Fede ting med Atlassian: Pimp min Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-Bamboo-monitor/index.da.md"
+++
Hvordan kan jeg oprette en build monitor til Bamboo, Jenkins eller Gitlab? Jeg skal nok finde ud af det i aften! Jeg har allerede skrevet en lignende [Vejledning til Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Vejledning til Gitlab-Issue-Boards").
{{< gallery match="images/1/*.jpg" >}}
Grundlaget for denne vejledning er Raspberry Imager og styresystemet "Raspberry Pi OS Lite". Efter installationen af operativsystemet kan SD-kortet sættes i hindbærret. I mit tilfælde er det en Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Trin 1: Installer Matchbox/Window Manager
For at betjene en Raspberry i kiosktilstand kræves der en window manager og en browser. Disse installeres med følgende kommando:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Trin 2: Jeg opretter en dashboard-bruger
Med følgende kommando opretter jeg en ny bruger kaldet "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Trin 3: Konfiguration af xServer og Window Manager
Alle de følgende trin skal udføres i brugersessionen "dashboard". Jeg skifter til sessionen med "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Knapper/funktion
Jeg vil have min Raspberry til at kunne fungere i kiosktilstand. For at gøre dette gemmer jeg to nøglekommandoer, Ctrl Alt X til terminalen og Alt C til at lukke terminalen. I terminalen kan du forespørge den aktuelle IP med ifconfig, lukke hindbærrene ned med sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Nøgleopstillingen i dette tilfælde er som følger:
```

##  Genveje til betjening af vinduer
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - session
De følgende linjer skal også indtastes i en fil "$ vim ~/.xsession". Dette script kontrollerer, om instrumentbrættet er tilgængeligt. Hvis den ikke kan nås, venter den 10 sekunder. Selvfølgelig skal adressen/IP-adressen justeres.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Det er meget vigtigt, at scriptet er eksekverbart:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Samkonfiguration af grænseflader
De følgende linjer konfigurerer webgrænsefladen. Browseren er maksimeret, og statuslinjen er skjult.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Indhold:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Klar
"Dashboard"-sessionen kan forlades:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behaviour.js og rullende tekst
Dette Javascript styrer bestyrelsens adfærd. Hvis opbygningen eller testen mislykkes, vises en stor ticker. På denne måde kan jeg se fejl selv på afstand.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Indhold:
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
Du kan naturligvis indbygge enhver adfærd, du ønsker, f.eks. at genstarte fejlslagne tests.
## 4. autolog til X-sessionen
Det næste skridt er at indstille automatisk login. Denne fil er tilpasset til dette formål:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Login-brugeren "dashboard" indtastes her, og display manager deaktiveres:
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
Systemet kan derefter genstartes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Klar
