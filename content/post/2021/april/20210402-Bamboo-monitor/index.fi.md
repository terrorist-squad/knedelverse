+++
date = "2021-04-04"
title = "Siistejä asioita Atlassianin kanssa: Pimp my Bamboo Monitor -ohjelmisto"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-Bamboo-monitor/index.fi.md"
+++
Miten voin luoda rakennusseurannan Bamboota, Jenkinsiä tai Gitlabia varten? Selvitän sen illalla! Olen jo kirjoittanut samanlaisen [Gitlab-Issue-Boardsin opetusohjelma]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Gitlab-Issue-Boardsin opetusohjelma").
{{< gallery match="images/1/*.jpg" >}}
Tämän opetusohjelman perustana on Raspberry Imager ja "Raspberry Pi OS Lite" -käyttöjärjestelmä. Käyttöjärjestelmän asennuksen jälkeen SD-kortti voidaan asettaa Raspberryyn. Minun tapauksessani tämä on Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Vaihe 1: Asenna Matchbox/Window Manager
Raspberryn käyttäminen kioskitilassa edellyttää ikkunanhallintaa ja selainta. Nämä asennetaan seuraavalla komennolla:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Vaihe 2: Luon kojelautakäyttäjän
Seuraavalla komennolla luon uuden käyttäjän nimeltä "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Vaihe 3: Konfigurointi xServer ja Window Manager
Kaikki seuraavat vaiheet on suoritettava kojelaudan käyttäjäistunnossa. Siirryn istuntoon "su" -nimellä:
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Painikkeet/toiminnot
Haluan vadelmani olevan käytettävissä kioskitilassa. Tätä varten tallennan kaksi näppäinkomentoa: Ctrl Alt X terminaalin avaamiseksi ja Alt C terminaalin sulkemiseksi. Terminaalissa voit kysyä nykyistä IP-osoitetta ifconfigilla, sammuttaa vadelman sudo shutdown -h nyt jne..... avulla.
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Tässä tapauksessa avainten asettelu on seuraava:
```

##  Ikkunan käytön oikotiet
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - istunto
Seuraavat rivit on myös kirjoitettava tiedostoon "$ vim ~/.xsession". Tämä komentosarja tarkistaa, onko kojelauta käytettävissä. Jos se ei ole tavoitettavissa, se odottaa 10 sekuntia. Osoite/IP-osoite on tietenkin mukautettava.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
On erittäin tärkeää, että komentosarja on suoritettavissa:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Liitännän yhteiskonfigurointi
Seuraavat rivit määrittävät web-käyttöliittymän. Selain on maksimoitu ja tilarivi on piilotettu.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Sisältö:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Valmis
Kojelautaistunto voidaan jättää:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behavior.js ja vierivä teksti
Tämä Javascript ohjaa levyn käyttäytymistä. Jos rakentaminen tai testaus epäonnistuu, näytössä näkyy suuri juokseva merkki. Näin voin nähdä virheet jopa kaukaa.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Sisältö:
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
Voit tietysti lisätä haluamasi käyttäytymisen, kuten epäonnistuneiden testien uudelleenkäynnistämisen.
## 4. autologue X-istuntoon
Seuraava vaihe on automaattisen kirjautumisen asettaminen. Tämä tiedosto on mukautettu tätä tarkoitusta varten:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Tässä syötetään kirjautumiskäyttäjä "kojelauta" ja näytönhallinta poistetaan käytöstä:
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
Tämän jälkeen järjestelmä voidaan käynnistää uudelleen.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Valmis
