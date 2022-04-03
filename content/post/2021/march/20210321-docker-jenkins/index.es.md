+++
date = "2021-03-21"
title = "Grandes cosas con contenedores: ejecutar Jenkins en el Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.es.md"
+++

## Paso 1: Preparar el Synology
En primer lugar, se debe activar el inicio de sesión SSH en el DiskStation. Para ello, vaya al "Panel de control" > "Terminal
{{< gallery match="images/1/*.png" >}}
A continuación, puede iniciar la sesión a través de "SSH", el puerto especificado y la contraseña de administrador (los usuarios de Windows utilizan Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Me conecto a través de Terminal, winSCP o Putty y dejo esta consola abierta para más tarde.
## Paso 2: Preparar la carpeta Docker
Creo un nuevo directorio llamado "jenkins" en el directorio de Docker.
{{< gallery match="images/3/*.png" >}}
Luego cambio al nuevo directorio y creo una nueva carpeta "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
También creo un archivo llamado "jenkins.yml" con el siguiente contenido. La parte frontal del puerto "8081:" se puede ajustar.
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
    container_name: jenkins
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker

```

## Paso 3: Inicio
En este paso también puedo hacer un buen uso de la consola. Inicio el servidor Jenkins a través de Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Después de eso, puedo llamar a mi servidor Jenkins con la IP de la estación de disco y el puerto asignado desde el "Paso 2".
{{< gallery match="images/4/*.png" >}}

## Paso 4: Configuración

{{< gallery match="images/5/*.png" >}}
De nuevo, uso la consola para leer la contraseña inicial:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Ver:
{{< gallery match="images/6/*.png" >}}
He seleccionado la "Instalación recomendada".
{{< gallery match="images/7/*.png" >}}

## Paso 5: Mi primer trabajo
Me conecto y creo mi trabajo Docker.
{{< gallery match="images/8/*.png" >}}
Como puedes ver, ¡todo funciona de maravilla!
{{< gallery match="images/9/*.png" >}}
