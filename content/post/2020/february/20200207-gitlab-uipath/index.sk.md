+++
date = "2020-02-07"
title = "Orchestrácia robotov uiPath Windows pomocou Gitlabu"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-gitlab-uipath/index.sk.md"
+++
UiPath je etablovaným štandardom v oblasti automatizácie robotických procesov. Pomocou uiPath môžete vyvinúť softvérového robota/bota, ktorý sa za vás postará o komplexné spracovanie údajov alebo úlohy klikania. Ale dá sa takýto robot ovládať aj pomocou Gitlabu?Stručná odpoveď je "áno". A ako presne, si môžete pozrieť tu. Na nasledujúce kroky potrebujete administrátorské práva a určité skúsenosti s uiPath, Windows a Gitlab.
## Krok 1: Najskôr je potrebné nainštalovať spúšťač Gitlab.
1.1.) Vytvorte nového používateľa služby Gitlab pre cieľový operačný systém. Kliknite na "Nastavenia" > "Rodina a iní používatelia" a potom na "Pridať ďalšiu osobu k tomuto počítaču".
{{< gallery match="images/1/*.png" >}}
1.2.) Kliknutím na položku "Nepoznám poverenia pre túto osobu" a potom na položku "Pridať používateľa bez konta Microsoft" vytvorte miestneho používateľa.
{{< gallery match="images/2/*.png" >}}
1.3.) V nasledujúcom dialógu môžete ľubovoľne vybrať používateľské meno a heslo:
{{< gallery match="images/3/*.png" >}}

## Krok 2: Aktivácia prihlásenia k službe
Ak chcete používať samostatného lokálneho používateľa pre svoj program Windows Gitlab Runner, musíte "Aktivovať prihlasovanie ako službu". Ak to chcete urobiť, prejdite do ponuky systému Windows > "Miestne zásady zabezpečenia". Tam vyberte "Miestne zásady" > "Prideliť práva používateľa" na ľavej strane a "Prihlásenie ako služba" na pravej strane.
{{< gallery match="images/4/*.png" >}}
Potom pridajte nového používateľa.
{{< gallery match="images/5/*.png" >}}

## Krok 3: Registrácia programu Gitlab Runner
Inštalačný program systému Windows pre Gitlab Runner nájdete na nasledujúcej stránke: https://docs.gitlab.com/runner/install/windows.html . Vytvoril som nový priečinok na disku "C" a vložil doň inštalačný program.
{{< gallery match="images/6/*.png" >}}
3.1.) Pomocou príkazu "CMD" ako "Administrator" otvorím novú konzolu a zmením adresár na "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Tam zavolám nasledujúci príkaz. Ako vidíte, zadávam tu aj používateľské meno a heslo používateľa Gitlab.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Teraz je možné zaregistrovať spúšťač Gitlab. Ak pre inštaláciu Gitlabu používate certifikát s vlastným podpisom, musíte certifikát poskytnúť s atribútom "-tls-ca-file=". Potom zadajte url adresu služby Gitlab a token registra.
{{< gallery match="images/8/*.png" >}}
3.2.) Po úspešnej registrácii je možné spustiť runner príkazom "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Skvelé! Váš Gitlab Runner je spustený a použiteľný.
{{< gallery match="images/10/*.png" >}}

## Krok 4: Inštalácia systému Git
Keďže Gitlab runner pracuje s verziovaním Git, musí byť nainštalovaný aj Git pre Windows:
{{< gallery match="images/11/*.png" >}}

## Krok 5: Inštalácia aplikácie UiPath
Inštalácia UiPath je najjednoduchšou časťou tohto návodu. Prihláste sa ako používateľ služby Gitlab a nainštalujte komunitnú verziu. Samozrejme, môžete hneď nainštalovať všetok softvér, ktorý váš robot potrebuje, napríklad: Office 365.
{{< gallery match="images/12/*.png" >}}

## Krok 6: Vytvorenie projektu a potrubia Gitlab
Teraz prichádza veľké finále tohto návodu. Vytvorím nový projekt Gitlab a skontrolujem v projektových súboroch uiPath.
{{< gallery match="images/13/*.png" >}}
6.1.) Okrem toho vytvorím nový súbor ".gitlab-ci.yml" s nasledujúcim obsahom:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Môj softvérový robot pre systém Windows sa spustí priamo po odovzdaní do hlavnej vetvy:
{{< gallery match="images/14/*.png" >}}
Automatické spustenie robota možno spravovať prostredníctvom možnosti "Plány". Veľkou výhodou tejto kombinácie je, že "robotické" projekty a výsledky projektov (artefakty) môžu byť centrálne kontrolované, verzované a spravované systémom Gitlab spolu s inými "nerobotickými" projektmi.
