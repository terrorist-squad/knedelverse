+++
date = "2020-02-07"
title = "Historia corta: Guiones de Bash con Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.es.md"
+++
Si quiere incluir un script bash en el Elgato Stream Deck, primero necesita un script bash.
## Paso 1: Crear un script Bash:
Creo un archivo llamado "say-hallo.sh" con el siguiente contenido:
```
#!/bin/bash
say "hallo"

```

## Paso 2: Establecer los derechos
El siguiente comando hace que el archivo sea ejecutable:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Paso 3: Incluir el script Bash en la cubierta
3.1) Ahora se puede abrir la aplicación Stream Deck:
{{< gallery match="images/1/*.png" >}}
3.2) Luego arrastro la acción "Abrir sistema" a un botón.
{{< gallery match="images/2/*.png" >}}
3.3) Ahora puedo elegir mi script bash:
{{< gallery match="images/3/*.png" >}}

## Paso 4: ¡hecho!
