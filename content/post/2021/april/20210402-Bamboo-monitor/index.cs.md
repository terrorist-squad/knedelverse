+++
date = "2021-04-04"
title = "Skvělé věci s Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.cs.md"
+++
Jak mohu vytvořit monitor sestavení pro Bamboo, Jenkins nebo Gitlab? Do večera na to přijdu! Podobný [Výukový program pro Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Výukový program pro Gitlab-Issue-Boards") jsem již napsal.
{{< gallery match="images/1/*.jpg" >}}
Základem tohoto návodu je Raspberry Imager a operační systém "Raspberry Pi OS Lite". Po instalaci operačního systému lze do Raspberry vložit kartu SD. V mém případě je to Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Krok 1: Instalace aplikace Matchbox/Správce oken
K provozu počítače Raspberry v režimu kiosku je zapotřebí správce oken a prohlížeč. Ty se instalují pomocí následujícího příkazu:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Krok 2: Vytvořím uživatele ovládacího panelu
Následujícím příkazem vytvořím nového uživatele s názvem "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Krok 3: Konfigurace xServeru a Správce oken
Všechny následující kroky je třeba provést v relaci uživatele "dashboard". Přepínám na relaci s "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Tlačítka/funkce
Chci, aby moje Raspberry bylo provozuschopné v režimu kiosku. Za tímto účelem ukládám dva klávesové příkazy, Ctrl Alt X pro terminál a Alt C pro zavření terminálu. V terminálu se můžete zeptat na aktuální IP pomocí ifconfig, vypnout Malina pomocí sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Rozložení klíče je v tomto případě následující:
```

##  Zkratky pro ovládání oken
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - zasedání
V souboru "$ vim ~/.xsession" musí být také zadány následující řádky. Tento skript zkontroluje, zda je přístrojový panel přístupný. Pokud není dosažitelný, čeká 10 sekund. Adresu/IP je samozřejmě nutné upravit.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Je velmi důležité, aby byl skript spustitelný:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Společná konfigurace rozhraní
Následující řádky konfigurují webové rozhraní. Prohlížeč je maximalizován a stavový řádek je skrytý.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Obsah:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Připraveno
Relace "přístrojové desky" může být ponechána:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behavior.js a rolovací text
Tento Javascript řídí chování desky. Pokud sestavení nebo test selžou, zobrazí se velké zaškrtávací znaménko. Takto mohu vidět chyby i na dálku.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Obsah:
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
Samozřejmě můžete zabudovat libovolné chování, například restartování neúspěšných testů.
## 4. autologue do relace X
Dalším krokem je nastavení automatického přihlášení. Tento soubor je pro tento účel upraven:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Zde se zadá přihlašovací uživatel "dashboard" a deaktivuje se správce zobrazení:
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
Poté lze systém restartovat.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Připraveno
