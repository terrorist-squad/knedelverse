+++
date = "2021-03-06"
title = "Приборная панель с RaspberryPiZeroW, Javascript и GitLab"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210306-gitlab-dashboard/index.ru.md"
+++
Установка с Raspberry Noobs - это детская игра! Все, что вам нужно, это RaspberryZeroW и чистая SD-карта.
## Шаг 1: Установщик для новичков
Загрузите программу установки Noobs с сайта https://www.raspberrypi.org/downloads/noobs/.
## Шаг 2: SD-карта
Распакуйте этот zip-архив на пустую SD-карту.
{{< gallery match="images/1/*.png" >}}
Готово! Теперь вы можете подключить RaspberryPiZero к телевизору. После этого появится меню установки.
{{< gallery match="images/2/*.jpg" >}}
Если на карте установлен NoobsLite, сначала необходимо установить соединение WLAN. Затем выберите "Rasbian Lite" и нажмите "Установить". Rasbian Lite - это серверная версия без рабочего стола. После загрузки необходимо обновить управление пакетами.
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
После этого необходимо установить следующие пакеты:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
Для отображения приборной панели также должен быть создан пользователь.
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Войдите в систему как пользователь "Dashboard":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Создать X-сессию -Сценарий. Я могу перейти на эту строку с помощью клавиш управления курсором и переключиться в режим вставки с помощью клавиши "i".
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
Содержание
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
Затем нажмите клавишу "Esc" для изменения командного режима, а затем ":wq" для "записи" и "выхода". Кроме того, этот сценарий требует следующих прав:
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
В этом сценарии вы видите конфигурацию браузера (/home/dashboard/uzbl.conf). Эта конфигурация выглядит следующим образом:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
Перерыв! Вы почти закончили. Теперь вам нужен Javascript, с помощью которого вы сможете имитировать поведение пользователя. Важно, чтобы вы создали отдельного пользователя Gitlab. Этим пользователем можно управлять как "репортером" в проектах.
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
Теперь вы можете выйти из системы. Пожалуйста, измените настройки DisplayManager в разделе "/etc/default/nodm". Здесь вы должны изменить "NODM_USER" на "dashboard" и "NODM_ENABLED" на "true".
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
Если теперь вы перезагрузитесь с помощью команды "sudo reboot", вы увидите следующую приборную панель:
{{< gallery match="images/3/*.jpg" >}}
