+++
date = "2020-02-13"
title = "Synology-Nas: Confluence come sistema wiki"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.it.md"
+++
Se vuoi installare Atlassian Confluence su un NAS Synology, allora sei nel posto giusto.
## Passo 1
Per prima cosa, apro l'app Docker nell'interfaccia Synology e poi vado alla sottovoce "Registrazione". Lì cerco "Confluence" e clicco sulla prima immagine "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Passo 2
Dopo il download dell'immagine, l'immagine è disponibile come immagine. Docker distingue tra 2 stati, container "stato dinamico" e immagine/immagine (stato fisso). Prima di poter creare un contenitore dall'immagine, devono essere fatte alcune impostazioni.
## Riavvio automatico
Faccio doppio clic sulla mia immagine di Confluence.
{{< gallery match="images/2/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo il "Riavvio automatico".
{{< gallery match="images/3/*.png" >}}

## Porte
Assegno porte fisse per il contenitore Confluence. Senza porte fisse, Confluence potrebbe funzionare su una porta diversa dopo un riavvio.
{{< gallery match="images/4/*.png" >}}

## Memoria
Creo una cartella fisica e la monto nel contenitore (/var/atlassian/application-data/confluence/). Questa impostazione facilita il backup e il ripristino dei dati.
{{< gallery match="images/5/*.png" >}}
Dopo queste impostazioni, Confluence può essere avviato!
{{< gallery match="images/6/*.png" >}}
