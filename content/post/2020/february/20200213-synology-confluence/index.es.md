+++
date = "2020-02-13"
title = "Synology-Nas: Confluence como sistema wiki"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.es.md"
+++
Si desea instalar Atlassian Confluence en un NAS de Synology, ha llegado al lugar adecuado.
## Paso 1
En primer lugar, abro la aplicación Docker en la interfaz de Synology y, a continuación, voy al subapartado "Registro". Allí busco "Confluence" y hago clic en la primera imagen "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Paso 2
Después de la descarga de la imagen, ésta está disponible como imagen. Docker distingue entre 2 estados, contenedor "estado dinámico" e imagen/imagen (estado fijo). Antes de que podamos crear un contenedor a partir de la imagen, hay que realizar algunos ajustes.
## Reinicio automático
Hago doble clic en mi imagen de Confluence.
{{< gallery match="images/2/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo el "Reinicio automático".
{{< gallery match="images/3/*.png" >}}

## Puertos
Asigno puertos fijos para el contenedor de Confluence. Sin puertos fijos, Confluence podría funcionar en un puerto diferente después de un reinicio.
{{< gallery match="images/4/*.png" >}}

## Memoria
Creo una carpeta física y la monto en el contenedor (/var/atlassian/application-data/confluence/). Esta configuración facilita la realización de copias de seguridad y la restauración de datos.
{{< gallery match="images/5/*.png" >}}
Después de estos ajustes, se puede iniciar Confluence.
{{< gallery match="images/6/*.png" >}}