+++
date = "2021-04-25T09:28:11+01:00"
title = "Historia corta: Actualizar automáticamente los contenedores con Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.es.md"
+++
Si ejecuta contenedores Docker en su estación de disco, naturalmente querrá que estén siempre actualizados. Watchtower actualiza automáticamente las imágenes y los contenedores. De este modo, podrá disfrutar de las últimas funciones y de la seguridad de datos más actualizada. Hoy os mostraré cómo instalar una Watchtower en la estación de disco Synology.
## Paso 1: Preparar el Synology
En primer lugar, se debe activar el inicio de sesión SSH en el DiskStation. Para ello, vaya al "Panel de control" > "Terminal
{{< gallery match="images/1/*.png" >}}
A continuación, puede iniciar la sesión a través de "SSH", el puerto especificado y la contraseña de administrador (los usuarios de Windows utilizan Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Me conecto a través de Terminal, winSCP o Putty y dejo esta consola abierta para más tarde.
## Paso 2: Instalar Watchtower
Para ello utilizo la consola:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Después, la Atalaya siempre se ejecuta en segundo plano.
{{< gallery match="images/3/*.png" >}}
