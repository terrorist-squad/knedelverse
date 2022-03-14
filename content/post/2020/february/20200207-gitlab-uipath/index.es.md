+++
date = "2020-02-07"
title = "Orquestación de robots uiPath Windows con Gitlab"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-gitlab-uipath/index.es.md"
+++
UiPath es un estándar establecido en la automatización de procesos robóticos. Con uiPath, puede desarrollar un robot basado en software que se encargue de tareas complejas de procesamiento de datos o clics por usted. Pero, ¿se puede controlar un robot de este tipo con Gitlab? la respuesta corta es "sí". Y cómo exactamente se puede ver aquí. Para los siguientes pasos, necesitas derechos de administración y algo de experiencia en uiPath, Windows y Gitlab.
## Paso 1: Lo primero que hay que hacer es instalar un corredor de Gitlab.
1.1.) Cree un nuevo usuario de Gitlab para su sistema operativo de destino. Haz clic en "Configuración" > "Familia y otros usuarios" y luego en "Añadir otra persona a este PC".
{{< gallery match="images/1/*.png" >}}
1.2.) Haga clic en "No conozco las credenciales de esta persona" y luego en "Añadir usuario sin cuenta Microsoft" para crear un usuario local.
{{< gallery match="images/2/*.png" >}}
1.3.) En el siguiente diálogo puede seleccionar libremente el nombre de usuario y la contraseña:
{{< gallery match="images/3/*.png" >}}

## Paso 2: Activar el inicio de sesión del servicio
Si desea utilizar un usuario local independiente para su Gitlab Runner de Windows, debe "Activar el inicio de sesión como servicio". Para ello, vaya al menú de Windows > "Política de seguridad local". Allí, seleccione "Política local" > "Asignar derechos de usuario" en el lado izquierdo y "Iniciar sesión como servicio" en el lado derecho.
{{< gallery match="images/4/*.png" >}}
A continuación, añada el nuevo usuario.
{{< gallery match="images/5/*.png" >}}

## Paso 3: Registrar Gitlab Runner
El instalador de Windows para el Gitlab Runner se encuentra en la siguiente página: https://docs.gitlab.com/runner/install/windows.html . Creé una nueva carpeta en la unidad "C" y puse el instalador allí.
{{< gallery match="images/6/*.png" >}}
3.1.) Utilizo el comando "CMD" como "Administrador" para abrir una nueva consola y cambiar a un directorio "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Allí llamo al siguiente comando. Como puedes ver, aquí también introduzco el nombre de usuario y la contraseña del usuario de Gitlab.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Ahora se puede registrar el corredor de Gitlab. Si utiliza un certificado autofirmado para su instalación de Gitlab, tiene que proporcionar el certificado con el atributo "-tls-ca-file=". A continuación, introduzca la url de Gitlab y el token de registro.
{{< gallery match="images/8/*.png" >}}
3.2.) Una vez registrado con éxito, el corredor puede iniciarse con el comando "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
¡Genial! Su Gitlab Runner está en funcionamiento y utilizable.
{{< gallery match="images/10/*.png" >}}

## Paso 4: Instalar Git
Dado que un corredor de Gitlab trabaja con el versionado de Git, también debe instalarse Git para Windows:
{{< gallery match="images/11/*.png" >}}

## Paso 5: Instalar UiPath
La instalación de UiPath es la parte más sencilla de este tutorial. Inicie sesión como usuario de Gitlab e instale la edición comunitaria. Por supuesto, puede instalar todo el software que su robot necesita de inmediato, por ejemplo: Office 365.
{{< gallery match="images/12/*.png" >}}

## Paso 6: Crear el proyecto y el pipeline de Gitlab
Ahora viene el gran final de este tutorial. Creo un nuevo proyecto Gitlab y compruebo en mis archivos de proyecto uiPath.
{{< gallery match="images/13/*.png" >}}
6.1.) Además, creo un nuevo archivo ".gitlab-ci.yml" con el siguiente contenido:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Mi robot de software de Windows se ejecuta directamente después de comprometerse con la rama maestra:
{{< gallery match="images/14/*.png" >}}
