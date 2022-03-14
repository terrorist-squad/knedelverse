+++
date = "2020-02-13"
title = "Synology-Nas: ¿Cómo puedo ejecutar tareas o crons?"
difficulty = "level-1"
tags = ["synology", "diskstation", "task", "cronjob", "cron", "aufgabe"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-task/index.es.md"
+++
¿Desea configurar tareas automáticas en el Synology NAS? Haga clic en el "Programador de tareas" en el "Panel de control".
{{< gallery match="images/1/*.png" >}}

## Tiempos y repeticiones establecidos
En el "planificador de tareas", se pueden crear nuevas "tareas" casi cron jobs. Aquí se establecen los tiempos y las repeticiones.
{{< gallery match="images/2/*.png" >}}

## Guión
El script de destino se almacena en "Configuración de la tarea". En mi caso, se crea un archivo zip. Debería probar esta función usted mismo.
{{< gallery match="images/3/*.png" >}}