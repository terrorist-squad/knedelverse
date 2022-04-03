+++
date = "2021-05-30"
title = "Crea tu propia página de la Darknet"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.es.md"
+++
Navegar por la Darknet como visitante es bastante sencillo. Pero, ¿cómo puedo alojar una página de Onion? Te enseñaré a crear tu propia página de la Darknet.
## Paso 1: ¿Cómo puedo navegar por la Darknet?
Utilizo un escritorio de Ubuntu para una mejor ilustración. Allí instalo los siguientes paquetes:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Luego edito el archivo "/etc/privoxy/config" e introduzco lo siguiente ($ sudo vim /etc/privoxy/config). Puedes averiguar la IP del ordenador con "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Ver:
{{< gallery match="images/1/*.png" >}}
Para asegurar que Tor y Privoxy se ejecuten también en el arranque del sistema, aún necesitamos introducirlos en el autoarranque:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Ahora se pueden iniciar los servicios:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Introduzco la dirección del proxy en mi Firefox, desactivo "Javascript" y visito la "página de prueba de Tor". Si todo ha funcionado, ahora puedo visitar sitios TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Paso 2: ¿Cómo puedo alojar un sitio de la Darknet?
Primero, instalo un servidor HTTP:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Entonces cambio la configuración de NGINX (vim /etc/nginx/nginx.conf) y desactivo estas características:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Ver:
{{< gallery match="images/3/*.png" >}}
Ahora hay que reiniciar el servidor NGINX de nuevo:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
También hay que hacer un cambio en la configuración de Tor. Comento las siguientes líneas "HiddenServiceDir" y "HiddenServicePort" en el archivo "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Después de eso, también reinicio este servicio:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Listo
En "/var/lib/tor/hidden_servic/hostname" encuentro mi dirección Darknet/Onion. Ahora todos los contenidos bajo /var/www/html están disponibles en el Darkent.
{{< gallery match="images/5/*.png" >}}
