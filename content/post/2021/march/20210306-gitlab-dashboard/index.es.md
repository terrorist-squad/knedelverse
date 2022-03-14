+++
date = "2021-03-06"
title = "Panel de control de incidencias con RaspberryPiZeroW, Javascript y GitLab"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210306-gitlab-dashboard/index.es.md"
+++
La instalación con Raspberry Noobs es un juego de niños. Todo lo que necesitas es una RaspberryZeroW y una tarjeta SD en blanco.
## Paso 1: Instalador de Noobs
Descargue el instalador de Noobs de https://www.raspberrypi.org/downloads/noobs/.
## Paso 2: Tarjeta SD
Descomprima este archivo zip en la tarjeta SD vacía.
{{< gallery match="images/1/*.png" >}}
¡Hecho! Ahora puedes conectar la RaspberryPiZero al televisor. A continuación, verá el menú de instalación.
{{< gallery match="images/2/*.jpg" >}}
Si tienes NoobsLite en la tarjeta, primero debes establecer una conexión WLAN. A continuación, seleccione "Rasbian Lite" y haga clic en "Instalar". Rasbian Lite es la versión de servidor sin escritorio. Tras el arranque, hay que actualizar la gestión de paquetes.
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
A continuación, hay que instalar los siguientes paquetes:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
También hay que crear un usuario para la visualización del cuadro de mandos.
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Conéctese como usuario del "Tablero":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Crear una sesión X -Script. Puedo cambiar a esta línea con las teclas del cursor y cambiar al modo de inserción con la tecla "i".
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
Contenido
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
A continuación, pulse la tecla "Esc" para cambiar el modo de comando y luego ":wq" para "escribir" y "salir". Además, este script requiere los siguientes derechos:
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
En este script se ve la configuración del navegador (/home/dashboard/uzbl.conf). Esta configuración tiene el siguiente aspecto:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
¡Medio tiempo! Ya casi has terminado. Ahora necesitas un Javascript con el que puedas simular el comportamiento del usuario. Es importante que crees un usuario de Gitlab independiente. Este usuario puede ser gestionado como "reportero" en los proyectos.
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
Ahora puedes cerrar la sesión. Por favor, cambie la configuración de DisplayManager en "/etc/default/nodm". Aquí debes cambiar el "NODM_USER" a "dashboard" y "NODM_ENABLED" a "true".
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
Si ahora reinicia con "sudo reboot", verá el siguiente tablero:
{{< gallery match="images/3/*.jpg" >}}