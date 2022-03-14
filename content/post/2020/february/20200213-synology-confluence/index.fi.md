+++
date = "2020-02-13"
title = "Synology-Nas: Confluence wiki-järjestelmänä"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-confluence/index.fi.md"
+++
Jos haluat asentaa Atlassian Confluence -palvelun Synology NAS -laitteeseen, olet oikeassa paikassa.
## Vaihe 1
Ensin avaan Docker-sovelluksen Synologyn käyttöliittymässä ja siirryn sitten "Rekisteröinti"-alasvetokohtaan. Siellä etsin "Confluence" ja klikkaan ensimmäistä kuvaa "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Vaihe 2
Kuvan lataamisen jälkeen kuva on käytettävissä kuvana. Dockerissa erotetaan kaksi tilaa, kontti "dynaaminen tila" ja kuva/image (kiinteä tila). Ennen kuin voimme luoda säiliön kuvasta, on tehtävä muutamia asetuksia.
## Automaattinen uudelleenkäynnistys
Kaksoisnapsautan Confluence-kuvaani.
{{< gallery match="images/2/*.png" >}}
Sitten klikkaan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys".
{{< gallery match="images/3/*.png" >}}

## Satamat
Määritän Confluence-säiliölle kiinteät portit. Ilman kiinteitä portteja Confluence saattaa toimia eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/4/*.png" >}}

## Muisti
Luon fyysisen kansion ja kiinnitän sen konttiin (/var/atlassian/application-data/confluence/). Tämä asetus helpottaa tietojen varmuuskopiointia ja palauttamista.
{{< gallery match="images/5/*.png" >}}
Näiden asetusten jälkeen Confluence voidaan käynnistää!
{{< gallery match="images/6/*.png" >}}