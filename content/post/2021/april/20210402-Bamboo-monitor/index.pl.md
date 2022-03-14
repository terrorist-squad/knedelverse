+++
date = "2021-04-04"
title = "Fajne rzeczy z Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.pl.md"
+++
Jak mogę utworzyć monitor kompilacji dla Bamboo, Jenkinsa lub Gitlab? Rozgryzę to do wieczora! Napisałem już podobne [Tutorial dla Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Tutorial dla Gitlab-Issue-Boards").
{{< gallery match="images/1/*.jpg" >}}
Podstawą tego tutorialu jest Raspberry Imager oraz system operacyjny "Raspberry Pi OS Lite". Po zainstalowaniu systemu operacyjnego, kartę SD można włożyć do Raspberry. W moim przypadku jest to Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Krok 1: Zainstaluj Matchbox/Window Manager
Do obsługi Raspberry w trybie kiosku wymagany jest menedżer okien i przeglądarka. Instaluje się je za pomocą następującego polecenia:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Krok 2: Tworzę użytkownika dashboardu
Za pomocą poniższego polecenia tworzę nowego użytkownika o nazwie "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Krok 3: Konfiguracja xServer i Window Manager
Wszystkie poniższe czynności muszą zostać wykonane w sesji użytkownika "dashboard". Przechodzę na sesję za pomocą "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1.) Przyciski/funkcje
Chcę, aby moja Malina działała w trybie kiosku. Aby to zrobić, przechowuję dwie komendy klawiszowe, Ctrl Alt X dla terminala i Alt C do zamknięcia terminala. W terminalu możesz zapytać o aktualne IP za pomocą ifconfig, wyłączyć Raspberry za pomocą sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Układ klucza w tym przypadku jest następujący:
```

##  Skróty w obsłudze okien
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Sesja
Poniższe linie muszą być również wpisane do pliku "$ vim ~/.xsession". Ten skrypt sprawdza, czy tablica rozdzielcza jest dostępna. Jeśli nie jest osiągalny, odczekuje 10 sekund. Oczywiście, adres/IP musi być dostosowany.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Bardzo ważne jest, aby skrypt był wykonywalny:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Współkonfiguracja interfejsu
Poniższe linie konfigurują interfejs sieciowy. Przeglądarka jest zmaksymalizowana, a pasek stanu jest ukryty.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Treść:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Gotowe
Sesję "dashboard" można opuścić:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behavior.js i przewijanie tekstu
Ten Javascript steruje zachowaniem tablicy. Jeśli budowa lub test zakończy się niepowodzeniem, wyświetlany jest duży ticker. W ten sposób mogę dostrzec błędy nawet z daleka.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Treść:
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
Oczywiście, możesz wbudować dowolne zachowanie, takie jak ponowne uruchamianie nieudanych testów.
## 4. autologowanie do sesji X
Kolejnym krokiem jest ustawienie automatycznego logowania. Ten plik jest przystosowany do tego celu:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Tutaj wpisuje się użytkownika logowania "dashboard" i dezaktywuje się menedżera wyświetlania:
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
Następnie można ponownie uruchomić system.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Gotowe
