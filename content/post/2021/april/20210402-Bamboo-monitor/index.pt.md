+++
date = "2021-04-04"
title = "Coisas legais com o Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-Bamboo-monitor/index.pt.md"
+++
Como posso criar um monitor de construção para Bamboo, Jenkins ou Gitlab? Eu resolvo isso até esta noite! Eu já escrevi um [Tutorial para Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Tutorial para Gitlab-Issue-Boards") semelhante.
{{< gallery match="images/1/*.jpg" >}}
A base para este tutorial é o Raspberry Imager e o sistema operacional "Raspberry Pi OS Lite". Após a instalação do sistema operacional, o cartão SD pode ser inserido no Raspberry. No meu caso, este é um Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Passo 1: Instalar o Matchbox/Window Manager
Para operar um Raspberry em modo quiosque, é necessário um gerenciador de janelas e um navegador. Estes são instalados com o seguinte comando:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Passo 2: Eu crio um usuário do painel
Com o seguinte comando eu crio um novo usuário chamado "painel de controle":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Passo 3: Configuração xServer e Window Manager
Todos os passos seguintes devem ser realizados na sessão do usuário do "painel de instrumentos". Eu mudo para a sessão com "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Botões/Função
Quero que o meu Raspberry seja operável em modo quiosque. Para isso, guardo dois comandos-chave, Ctrl Alt X para o terminal e Alt C para fechar o terminal. No terminal você pode consultar o IP atual com ifconfig, desligar o Raspberry com sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
A disposição chave neste caso é a seguinte:
```

##  Cortes curtos na operação de janela
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Sessão
As seguintes linhas também devem ser inseridas num ficheiro "$ vim ~/.xsession". Este script verifica se o painel de instrumentos está acessível. Se não for alcançável, espera 10 segundos. Naturalmente, os endereços/IP devem ser ajustados.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
É muito importante que o script seja executável:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Co-configuração da interface
As seguintes linhas configuram a interface web. O navegador é maximizado e a barra de status é escondida.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Conteúdo:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Pronto
A sessão do "painel de instrumentos" pode ser deixada:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) comportamento.js e texto de rolagem
Este Javascript controla o comportamento do conselho. Se a construção ou teste falhar, um grande ticker é exibido. Desta forma posso ver erros mesmo à distância.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Conteúdo:
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
É claro que você pode incorporar qualquer comportamento que você quiser, como reiniciar testes fracassados.
## 4. Autologue para a sessão X
O próximo passo é definir o login automático. Este arquivo é adaptado para este fim:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
O "painel de controle" do usuário de login é inserido aqui e o gerenciador do display é desativado:
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
O sistema pode então ser reinicializado.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Pronto
