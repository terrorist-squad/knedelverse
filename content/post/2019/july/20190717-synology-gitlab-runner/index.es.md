+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner en Docker Container"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.es.md"
+++
¿Cómo puedo instalar un corredor de Gitlab como un contenedor Docker en mi NAS de Synology?
## Paso 1: Buscar la imagen Docker
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco Gitlab. Selecciono la imagen Docker "gitlab/gitlab-runner" y luego selecciono la etiqueta "bleeding".
{{< gallery match="images/1/*.png" >}}

## Paso 2: Poner la imagen en funcionamiento:

##  Problema de los anfitriones
Mi synology-gitlab-insterlation siempre se identifica por el nombre de host solamente. Como tomé el paquete original de Synology Gitlab del centro de paquetes, este comportamiento no se puede cambiar después.  Como solución, puedo incluir mi propio archivo de hosts. Aquí puede ver que el nombre del host "peter" pertenece a la dirección IP Nas 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Este archivo se almacena simplemente en el Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Paso 3: Configurar el GitLab Runner
Hago clic en la imagen de mi corredor:
{{< gallery match="images/3/*.png" >}}
Activo el ajuste "Activar el reinicio automático":
{{< gallery match="images/4/*.png" >}}
Luego hago clic en "Configuración avanzada" y selecciono la pestaña "Volumen":
{{< gallery match="images/5/*.png" >}}
Hago clic en Añadir archivo e incluyo mi archivo de hosts a través de la ruta "/etc/hosts". Este paso sólo es necesario si los nombres de host no se pueden resolver.
{{< gallery match="images/6/*.png" >}}
Acepto la configuración y hago clic en siguiente.
{{< gallery match="images/7/*.png" >}}
Ahora encuentro la imagen inicializada en Container:
{{< gallery match="images/8/*.png" >}}
Selecciono el contenedor (gitlab-gitlab-runner2 para mí) y hago clic en "Detalles". Luego hago clic en la pestaña "Terminal" y creo una nueva sesión de bash. Aquí introduzco el comando "gitlab-runner register". Para el registro, necesito información que pueda encontrar en mi instalación de GitLab bajo http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Si necesita más paquetes, puede instalarlos mediante "apt-get update" y luego "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Después puedo incluir el corredor en mis proyectos y utilizarlo:
{{< gallery match="images/11/*.png" >}}