+++
date = "2020-02-07"
title = "Orchestroi uiPath Windows -robotit Gitlabilla"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-gitlab-uipath/index.fi.md"
+++
UiPath on robottiprosessien automatisoinnin vakiintunut standardi. uiPathin avulla voit kehittää ohjelmistopohjaisen robotin/robotin, joka huolehtii puolestasi monimutkaisista tietojenkäsittely- tai napsautustehtävistä. Mutta voiko tällaista robottia ohjata myös Gitlabilla?Lyhyt vastaus on "kyllä". Ja miten se tarkalleen ottaen tapahtuu, näet täältä. Seuraavissa vaiheissa tarvitset järjestelmänvalvojan oikeudet ja hieman uiPath-, Windows- ja Gitlab-kokemusta.
## Vaihe 1: Asenna ensin Gitlab-runner.
1.1.) Luo uusi Gitlab-käyttäjä kohdekäyttöjärjestelmääsi. Napsauta "Asetukset" > "Perhe ja muut käyttäjät" ja sitten "Lisää toinen henkilö tähän tietokoneeseen".
{{< gallery match="images/1/*.png" >}}
1.2.) Napsauta "En tiedä tämän henkilön tunnistetietoja" ja sitten "Lisää käyttäjä ilman Microsoft-tiliä" luodaksesi paikallisen käyttäjän.
{{< gallery match="images/2/*.png" >}}
1.3.) Seuraavassa valintaikkunassa voit valita vapaasti käyttäjänimen ja salasanan:
{{< gallery match="images/3/*.png" >}}

## Vaihe 2: Aktivoi palveluun kirjautuminen
Jos haluat käyttää erillistä, paikallista käyttäjää Windows Gitlab Runner -käyttöjärjestelmääsi varten, sinun on aktivoitava kirjautuminen palveluna. Voit tehdä tämän valitsemalla Windows-valikosta > "Paikallinen suojauskäytäntö". Valitse sieltä vasemmalla puolella "Paikallinen käytäntö" > "Käyttäjäoikeuksien määrittäminen" ja oikealla puolella "Kirjautuminen palveluna".
{{< gallery match="images/4/*.png" >}}
Lisää sitten uusi käyttäjä.
{{< gallery match="images/5/*.png" >}}

## Vaihe 3: Rekisteröi Gitlab Runner
Gitlab Runnerin Windows-asennusohjelma löytyy seuraavalta sivulta: https://docs.gitlab.com/runner/install/windows.html . Loin uuden kansion C-asemalle ja laitoin asennusohjelman sinne.
{{< gallery match="images/6/*.png" >}}
3.1.) Käytän komentoa "CMD" järjestelmänvalvojana avatakseni uuden konsolin ja vaihtaakseni hakemistoon "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Siellä kutsun seuraavaa komentoa. Kuten näet, syötän myös Gitlab-käyttäjän käyttäjätunnuksen ja salasanan tähän.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Nyt Gitlab-runner voidaan rekisteröidä. Jos käytät Gitlab-asennuksessasi itse allekirjoitettua varmentetta, sinun on annettava varmenteelle attribuutti "-tls-ca-file=". Kirjoita sitten Gitlabin url-osoite ja rekisteritunniste.
{{< gallery match="images/8/*.png" >}}
3.2.) Onnistuneen rekisteröinnin jälkeen runner voidaan käynnistää komennolla "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Hienoa! Gitlab Runner on toiminnassa ja käyttökelpoinen.
{{< gallery match="images/10/*.png" >}}

## Vaihe 4: Asenna Git
Koska Gitlab-runner toimii Git-versioinnin kanssa, myös Git for Windows on asennettava:
{{< gallery match="images/11/*.png" >}}

## Vaihe 5: Asenna UiPath
UiPathin asennus on tämän ohjeen helpoin osa. Kirjaudu sisään Gitlab-käyttäjänä ja asenna community edition. Voit tietenkin asentaa kaikki robotin tarvitsemat ohjelmistot heti, esimerkiksi Office 365:n.
{{< gallery match="images/12/*.png" >}}

## Vaihe 6: Luo Gitlab-projekti ja putki
Nyt tulee tämän opetusohjelman suuri finaali. Luon uuden Gitlab-projektin ja tarkistan uiPath-projektitiedostot.
{{< gallery match="images/13/*.png" >}}
6.1.) Lisäksi luon uuden tiedoston ".gitlab-ci.yml", jonka sisältö on seuraava:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Windows-ohjelmistorobottini suoritetaan suoraan sen jälkeen, kun se on siirretty master-haaraan:
{{< gallery match="images/14/*.png" >}}
Robotin automaattista käynnistystä voidaan hallita "Aikataulut"-vaihtoehdon kautta. Tämän yhdistelmän suurena etuna on, että "robottihankkeita" ja hankkeen tuloksia (artefakteja) voidaan valvoa, versioida ja hallita keskitetysti Gitlabissa muiden "ei-robottihankkeiden" kanssa.
