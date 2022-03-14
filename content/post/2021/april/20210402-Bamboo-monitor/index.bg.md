+++
date = "2021-04-04"
title = "Готини неща с Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.bg.md"
+++
Как мога да създам монитор за изграждане за Bamboo, Jenkins или Gitlab? Ще го разбера до довечера! Вече написах подобен [Урок за Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Урок за Gitlab-Issue-Boards").
{{< gallery match="images/1/*.jpg" >}}
Основата на този урок е Raspberry Imager и операционната система "Raspberry Pi OS Lite". След инсталирането на операционната система SD картата може да бъде поставена в Raspberry. В моя случай това е Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Стъпка 1: Инсталиране на Matchbox/Window Manager
За да работите с Raspberry в режим на киоск, са необходими мениджър на прозорци и браузър. Те се инсталират със следната команда:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Стъпка 2: Създавам потребител на таблото за управление
Със следната команда създавам нов потребител, наречен "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Стъпка 3: Конфигуриране на xServer и Window Manager
Всички следващи стъпки трябва да се извършат в потребителската сесия "табло за управление". Преминавам към сесията с "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Бутони/функции
Искам моята Raspberry да може да работи в режим на киоск. За да направя това, запазвам две клавишни команди: Ctrl Alt X за терминала и Alt C за затваряне на терминала. В терминала можете да направите запитване за текущия IP адрес с ifconfig, да изключите малината със sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Разположението на ключовете в този случай е следното:
```

##  Съкращения за работа с прозорци
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Сесия
Следните редове трябва да бъдат въведени и във файла "$ vim ~/.xsession". Този скрипт проверява дали таблото за управление е достъпно. Ако не е достижима, тя изчаква 10 секунди. Разбира се, адресът/IP адресът трябва да се коригира.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Много е важно скриптът да е изпълним:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Съконфигуриране на интерфейса
Следващите редове конфигурират уеб интерфейса. Браузърът е увеличен до максимум и лентата на състоянието е скрита.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Съдържание:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Готов
Сесията "табло за управление" може да бъде оставена:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behavior.js и превъртане на текста
Този Javascript контролира поведението на дъската. Ако сглобяването или тестът се провалят, се показва голям индикатор. По този начин мога да видя грешките дори от разстояние.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Съдържание:
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
Разбира се, можете да вградите всяко желано поведение, като например рестартиране на неуспешни тестове.
## 4. автолог в X-сесията
Следващата стъпка е да настроите автоматичното влизане в системата. Този файл е адаптиран за тази цел:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Тук се въвежда потребителят за вход "dashboard" и се деактивира мениджърът на дисплея:
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
След това системата може да бъде рестартирана.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Готов
