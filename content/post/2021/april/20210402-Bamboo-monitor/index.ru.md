+++
date = "2021-04-0q"
title = "Крутые штуки с Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.ru.md"
+++
Как создать монитор сборки для Bamboo, Jenkins или Gitlab? Я разберусь с этим к вечеру! Я уже писал аналогичный [Учебник для Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Учебник для Gitlab-Issue-Boards").
{{< gallery match="images/1/*.jpg" >}}
Основой для этого учебника является Raspberry Imager и операционная система "Raspberry Pi OS Lite". После установки операционной системы SD-карту можно вставить в Raspberry. В моем случае это Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Шаг 1: Установите Matchbox/Window Manager
Для работы Raspberry в режиме киоска необходимы оконный менеджер и браузер. Они устанавливаются с помощью следующей команды:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Шаг 2: Я создаю пользователя приборной панели
С помощью следующей команды я создаю нового пользователя под именем "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Шаг 3: Конфигурация xServer и Window Manager
Все следующие шаги должны выполняться в сеансе пользователя "приборной панели". Я перехожу в сеанс с помощью команды "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Кнопки/функции
Я хочу, чтобы моя Raspberry могла работать в режиме киоска. Для этого я сохраняю две ключевые команды: Ctrl Alt X для терминала и Alt C для закрытия терминала. В терминале вы можете запросить текущий IP с помощью ifconfig, выключить Raspberry с помощью sudo shutdown -h now etc......
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Схема расположения ключей в этом случае выглядит следующим образом:
```

##  Краткие инструкции по эксплуатации окон
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - сессия
Следующие строки также должны быть введены в файл "$ vim ~/.xsession". Этот сценарий проверяет, доступна ли приборная панель. Если он недоступен, он ждет 10 секунд. Конечно, адрес/IP должен быть скорректирован.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Очень важно, чтобы скрипт был исполняемым:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Совместное конфигурирование интерфейсов
Следующие строки настраивают веб-интерфейс. Браузер максимизирован, а строка состояния скрыта.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Содержание:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Готовый
Сессию "приборной панели" можно оставить:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behavior.js и прокрутка текста
Этот Javascript управляет поведением платы. Если сборка или тест завершились неудачно, отображается большой тикер. Таким образом, я могу видеть ошибки даже на расстоянии.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Содержание:
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
Конечно, вы можете встроить любое поведение, которое вам нужно, например, перезапуск неудачных тестов.
## 4. автолог в X-сессию
Следующим шагом будет настройка автоматического входа в систему. Данный файл адаптирован для этой цели:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Здесь вводится логин пользователя "dashboard" и деактивируется менеджер дисплеев:
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
После этого систему можно перезагрузить.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Готовый
Каждый дасборд следует перезапускать один раз в день. Для этого я создал cron.
