+++
date = "2021-03-06"
title = "Tablica błędów z RaspberryPiZeroW, Javascriptem i GitLabem"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210306-gitlab-dashboard/index.pl.md"
+++
Instalacja z Raspberry Noobs jest dziecinnie prosta! Wszystko, czego potrzebujesz, to RaspberryZeroW i pusta karta SD.
## Krok 1: Instalator dla noobów
Pobierz instalator Noobs z witryny https://www.raspberrypi.org/downloads/noobs/.
## Krok 2: Karta SD
Rozpakuj to archiwum zip na pustą kartę SD.
{{< gallery match="images/1/*.png" >}}
Gotowe! Teraz możesz podłączyć RaspberryPiZero do telewizora. Zostanie wyświetlone menu instalacyjne.
{{< gallery match="images/2/*.jpg" >}}
Jeśli na karcie znajduje się program NoobsLite, należy najpierw nawiązać połączenie z siecią WLAN. Następnie wybierz "Rasbian Lite" i kliknij "Zainstaluj". Rasbian Lite to wersja serwerowa bez pulpitu. Po uruchomieniu komputera należy zaktualizować zarządzanie pakietami.
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
Następnie należy zainstalować następujące pakiety:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
Należy także utworzyć użytkownika do wyświetlania tablicy rozdzielczej.
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Zaloguj się jako użytkownik "Dashboard":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Utwórz sesję X -Script. Mogę przechodzić do tego wiersza za pomocą klawiszy kursora i przechodzić do trybu wstawiania za pomocą klawisza "i".
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
Zawartość
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
Następnie naciśnij klawisz "Esc", aby zmienić tryb poleceń, a potem ":wq" dla "write" i "quit". Ponadto ten skrypt wymaga następujących uprawnień:
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
W tym skrypcie widoczna jest konfiguracja przeglądarki (/home/dashboard/uzbl.conf). Ta konfiguracja wygląda następująco:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
Połowa czasu! Już prawie skończyłeś. Teraz potrzebny jest skrypt Javascript, za pomocą którego można symulować zachowanie użytkownika. Ważne jest, aby utworzyć osobnego użytkownika Gitlab. Użytkownik ten może być zarządzany jako "reporter" w projektach.
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
Teraz możesz się wylogować. Należy zmienić ustawienie opcji DisplayManager w pliku "/etc/default/nodm". W tym miejscu należy zmienić wartość "NODM_USER" na "dashboard", a "NODM_ENABLED" na "true".
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
Po ponownym uruchomieniu komputera za pomocą polecenia "sudo reboot" pojawi się następujący pulpit:
{{< gallery match="images/3/*.jpg" >}}
