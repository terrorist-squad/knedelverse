+++
date = "2021-04-04"
title = "Lucruri interesante cu Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-Bamboo-monitor/index.ro.md"
+++
Cum pot crea un monitor de construcție pentru Bamboo, Jenkins sau Gitlab? Până diseară o să mă descurc! Am scris deja un [Tutorial pentru Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Tutorial pentru Gitlab-Issue-Boards") similar.
{{< gallery match="images/1/*.jpg" >}}
Baza pentru acest tutorial este Raspberry Imager și sistemul de operare "Raspberry Pi OS Lite". După instalarea sistemului de operare, cardul SD poate fi introdus în Zmeura. În cazul meu, este vorba de un Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Pasul 1: Instalați Matchbox/Window Manager
Pentru a opera un Zmeura în modul chioșc, sunt necesare un manager de ferestre și un browser. Acestea se instalează cu următoarea comandă:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Pasul 2: Creez un utilizator de tablou de bord
Cu următoarea comandă creez un nou utilizator numit "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Pasul 3: Configurarea xServer și Window Manager
Toți pașii următori trebuie să fie efectuați în sesiunea de utilizator "dashboard". Trec în sesiune cu "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Butoane/Funcție
Vreau ca Zmeura mea să fie operabilă în modul chioșc. Pentru a face acest lucru, am stocat două comenzi de taste, Ctrl Alt X pentru terminal și Alt C pentru a închide terminalul. În terminal puteți interoga IP-ul curent cu ifconfig, opriți Zmeura cu sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
În acest caz, structura cheii este următoarea:
```

##  Scurtături de operare a ferestrelor
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Sesiune
Următoarele rânduri trebuie, de asemenea, să fie introduse într-un fișier "$ vim ~/.xsession". Acest script verifică dacă tabloul de bord este accesibil. În cazul în care nu poate fi contactat, se așteaptă 10 secunde. Bineînțeles, adresa/IP trebuie ajustată.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Este foarte important ca scriptul să fie executabil:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Co-configurarea interfeței
Următoarele linii configurează interfața web. Browserul este maximizat, iar bara de stare este ascunsă.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Conținut:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Gata
Sesiunea "tablou de bord" poate fi părăsită:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behaviour.js și textul derulant
Acest Javascript controlează comportamentul plăcii. În cazul în care construcția sau testul eșuează, se afișează un ticker mare. În acest fel, pot vedea erorile chiar și de la distanță.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Conținut:
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
Desigur, puteți include orice comportament doriți, cum ar fi repornirea testelor eșuate.
## 4. autologarea în sesiunea X
Următorul pas este să setați autentificarea automată. Acest fișier este adaptat în acest scop:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Aici se introduce utilizatorul de autentificare "dashboard" și se dezactivează managerul de afișare:
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
Sistemul poate fi apoi repornit.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Gata
