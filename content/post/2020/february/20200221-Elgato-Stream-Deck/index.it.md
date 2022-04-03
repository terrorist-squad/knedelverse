+++
date = "2020-02-07"
title = "Breve storia: script Bash con Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.it.md"
+++
Se volete includere uno script bash in Elgato Stream Deck, avete prima bisogno di uno script bash.
## Passo 1: creare uno script Bash:
Creo un file chiamato "say-hallo.sh" con il seguente contenuto:
```
#!/bin/bash
say "hallo"

```

## Passo 2: Impostare i diritti
Il seguente comando rende il file eseguibile:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Passo 3: includere lo script Bash nel mazzo
3.1) Ora l'app Stream Deck può essere aperta:
{{< gallery match="images/1/*.png" >}}
3.2) Poi trascino l'azione "Open System" su un pulsante.
{{< gallery match="images/2/*.png" >}}
3.3) Ora posso scegliere il mio script bash:
{{< gallery match="images/3/*.png" >}}

## Passo 4: Fatto!
Il nuovo pulsante è ora utilizzabile.
