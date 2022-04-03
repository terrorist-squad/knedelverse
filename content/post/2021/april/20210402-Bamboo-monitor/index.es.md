+++
date = "2021-04-0q"
title = "Cosas geniales con Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.es.md"
+++
¿Cómo puedo crear un monitor de construcción para Bamboo, Jenkins o Gitlab? ¡Lo resolveré esta noche! Ya he escrito un [Tutorial para los Issue Boards de Gitlab]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Tutorial para los Issue Boards de Gitlab") similar.
{{< gallery match="images/1/*.jpg" >}}
La base de este tutorial es el Raspberry Imager y el sistema operativo "Raspberry Pi OS Lite". Después de la instalación del sistema operativo, se puede insertar la tarjeta SD en la Raspberry. En mi caso, se trata de una Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Paso 1: Instalar Matchbox/Window Manager
Para operar una Raspberry en modo quiosco, se requiere un gestor de ventanas y un navegador. Se instalan con el siguiente comando:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Paso 2: Creo un usuario de tablero de mandos
Con el siguiente comando creo un nuevo usuario llamado "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Paso 3: Configuración de xServer y Window Manager
Todos los pasos siguientes deben realizarse en la sesión de usuario del "tablero". Cambio a la sesión con "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Botones/Función
Quiero que mi Raspberry sea operable en modo kiosco. Para ello, almaceno dos comandos de teclas, Ctrl Alt X para el terminal y Alt C para cerrar el terminal. En el terminal, puede consultar la IP actual con ifconfig, apagar la Raspberry con sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
La disposición de las llaves en este caso es la siguiente:
```

##  Atajos en el funcionamiento de las ventanas
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Sesión
Las siguientes líneas también deben introducirse en un archivo "$ vim ~/.xsession". Este script comprueba si el panel de control es accesible. Si no está localizable, espera 10 segundos. Por supuesto, hay que ajustar la dirección/IP.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Es muy importante que el script sea ejecutable:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Co-configuración de la interfaz
Las siguientes líneas configuran la interfaz web. El navegador está maximizado y la barra de estado está oculta.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Contenido:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Listo
Se puede dejar la sesión del "tablero":
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behaviour.js y el texto desplazado
Este Javascript controla el comportamiento del tablero. Si la construcción o la prueba fallan, se muestra un gran teletipo. Así puedo ver los errores incluso a distancia.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Contenido:
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
Por supuesto, puede incorporar cualquier comportamiento que desee, como reiniciar las pruebas fallidas.
## 4. autologue en la sesión X
El siguiente paso es establecer el inicio de sesión automático. Este archivo está adaptado para ello:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Aquí se introduce el usuario de inicio de sesión "dashboard" y se desactiva el gestor de pantalla:
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
A continuación, se puede reiniciar el sistema.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Listo
Cada dasboard debe reiniciarse una vez al día. He creado un cron para esto.
