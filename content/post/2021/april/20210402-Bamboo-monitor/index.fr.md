+++
date = "2021-04-04"
title = "Des trucs cools avec Atlassian : Pimp my Bamboo-Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-Bamboo-monitor/index.fr.md"
+++
Comment créer un moniteur de build pour Bamboo, Jenkins ou Gitlab ? Je le trouverai d'ici ce soir ! J'ai déjà écrit un [Tutoriel sur les tableaux d'affichage Gitlab]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Tutoriel sur les tableaux d'affichage Gitlab") similaire.
{{< gallery match="images/1/*.jpg" >}}
La base de ce tutoriel est le Raspberry-Imager et le système d'exploitation "Raspberry Pi OS Lite". Après l'installation du système d'exploitation, la carte SD peut être insérée dans le Raspberry. Dans mon cas, il s'agit d'un Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Étape 1 : Installer le Matchbox/Window-Manager
Pour faire fonctionner un Raspberry en mode kiosque, un gestionnaire de fenêtres et un navigateur sont nécessaires. Ceux-ci sont installés à l'aide de la commande suivante :
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Étape 2 : Je crée un utilisateur de tableau de bord
Avec la commande suivante, je crée un nouvel utilisateur nommé "dashboard" :
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Étape 3 : Configuration du xServer et du gestionnaire de fenêtres
Toutes les étapes suivantes doivent être effectuées dans la session utilisateur "dashboard". Avec "su", je change de session :
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Boutons/fonction
Mon Raspberry doit également pouvoir être utilisé en mode kiosque. Pour cela, j'enregistre deux commandes de touches, Ctrl Alt X pour le terminal et Alt C pour fermer le terminal. Dans le terminal, on peut demander l'IP actuelle avec ifconfig, éteindre le Raspberry avec sudo shutdown -h now, etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Dans ce cas, la disposition des touches se présente comme suit :
```

##  Opération fenêtre coupes courtes
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Session
Les lignes suivantes doivent également être inscrites dans un fichier "$ vim ~/.xsession". Ce script vérifie si le tableau de bord est accessible. S'il n'est pas accessible, il attend 10 secondes. Bien entendu, l'adresse/IP doit être adaptée.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Il est très important que le script soit exécutable :
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Configuration de l'interface
Les lignes suivantes permettent de configurer l'interface web. Le navigateur est maximisé et la barre d'état est masquée.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Contenu :
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Prêt
La session "dashboard" peut être quittée :
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5) verhalten.js et texte défilant
Ce javascript permet de contrôler le comportement du forum. Si le build ou le test échoue, un grand ticker s'affiche. Je peux ainsi voir les erreurs de loin.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Contenu :
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
Il est bien sûr possible d'intégrer tout comportement souhaité, par exemple relancer les tests qui ont échoué.
## 4. autologue dans la session X
La prochaine étape consiste à configurer le login automatique. Pour cela, ce fichier sera adapté :
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
L'utilisateur de connexion "dashboard" est saisi ici et le gestionnaire d'affichage est désactivé :
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
Le système peut ensuite être redémarré.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Prêt
