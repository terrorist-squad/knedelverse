+++
date = "2020-02-28"
title = "Suuria asioita konttien avulla: Papermerge DMS:n käyttäminen Synology NAS:ssa"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.fi.md"
+++
Papermerge on nuori asiakirjahallintajärjestelmä (DMS), joka pystyy automaattisesti jakamaan ja käsittelemään asiakirjoja. Tässä opetusohjelmassa näytän, miten asensin Papermergen Synology-levyasemalleni ja miten DMS toimii.
## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Vaihe 1: Luo kansio
Ensin luon kansion paperin yhdistämistä varten. Menen "System Control" -> "Shared Folder" ja luon uuden kansion nimeltä "Document Archive".
{{< gallery match="images/1/*.png" >}}
Vaihe 2: Etsi Docker-kuvaKlikkaan Synology Docker -ikkunan "Registration"-välilehteä ja etsin "Papermerge". Valitsen Docker-kuvan "linuxserver/papermerge" ja napsautan sitten tagia "latest".
{{< gallery match="images/2/*.png" >}}
Kuvan lataamisen jälkeen kuva on käytettävissä kuvana. Dockerissa erotetaan kaksi tilaa, kontti "dynaaminen tila" ja kuva/image (kiinteä tila). Ennen kuin voimme luoda säiliön kuvasta, on tehtävä muutamia asetuksia.
## Vaihe 3: Ota kuva käyttöön:
Kaksoisnapsautan paperin yhdistämiskuvaa.
{{< gallery match="images/3/*.png" >}}
Sitten klikkaan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys". Valitsen välilehden "Volume" ja napsautan "Add folder". Siellä luon uuden tietokantakansion, jossa on tämä liitäntäpolku "/data".
{{< gallery match="images/4/*.png" >}}
Tallennan tänne myös toisen kansion, jonka liitän liitäntäpolkuun "/config". Sillä ei ole väliä, missä tämä kansio on. On kuitenkin tärkeää, että se kuuluu Synologyn admin-käyttäjälle.
{{< gallery match="images/5/*.png" >}}
Määritän kiinteät portit Papermerge-säiliölle. Ilman kiinteitä portteja voi olla, että Papermerge-palvelin toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/6/*.png" >}}
Lopuksi annan kolme ympäristömuuttujaa. Muuttuja "PUID" on käyttäjän tunnus ja "PGID" on ylläpitäjäkäyttäjäni ryhmän tunnus. Voit selvittää PGID/PUID-tunnuksen SSH:n kautta komennolla "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Näiden asetusten jälkeen Papermerge-palvelin voidaan käynnistää! Sen jälkeen Papermergea voidaan kutsua Synology-aseman Ip-osoitteen ja osoitetun portin, esimerkiksi http://192.168.21.23:8095, kautta.
{{< gallery match="images/8/*.png" >}}
Oletuskirjautuminen on admin ja salasana admin.
## Miten Papermerge toimii?
Papermerge analysoi asiakirjojen ja kuvien tekstiä. Papermerge käyttää Goolgen julkaisemaa tesseract-nimistä OCR/"optinen merkintunnistus"-kirjastoa.
{{< gallery match="images/9/*.png" >}}
Loin kansion nimeltä "Everything with Lorem" testatakseni automaattista asiakirjojen määritystä. Sitten napsautin yhdessä uuden tunnistuskuvion valikkokohdassa "Automates".
{{< gallery match="images/10/*.png" >}}
Kaikki uudet asiakirjat, jotka sisältävät sanan "Lorem", sijoitetaan kansioon "Kaikki Loremilla" ja merkitään "has-lorem". On tärkeää käyttää pilkkua tunnisteiden välissä, muuten tunniste ei asetu. Jos lataat vastaavan asiakirjan, se merkitään ja lajitellaan.
{{< gallery match="images/11/*.png" >}}