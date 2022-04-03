+++
date = "2022-04-02"
title = "Grandes cosas con contenedores: Instalación de Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.es.md"
+++
Con Jitsi puedes crear y desplegar una solución de videoconferencia segura. Hoy muestro cómo instalar un servicio Jitsi en un servidor, referencia: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Paso 1: Crear la carpeta "jitsi
Creo un nuevo directorio llamado "jitsi" para la instalación.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Paso 2: Configuración
Ahora copio la configuración estándar y la adapto.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Ver:
{{< gallery match="images/1/*.png" >}}
Para utilizar contraseñas fuertes en las opciones de seguridad del archivo .env, se debe ejecutar el siguiente script bash una vez.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Ahora crearé algunas carpetas más para Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
A continuación, se puede iniciar el servidor Jitsi.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
¡Después de eso puedes usar el servidor Jitsi!
{{< gallery match="images/2/*.png" >}}

