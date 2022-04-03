+++
date = "2020-02-07"
title = "Orchestrace robotů uiPath Windows pomocí Gitlabu"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-gitlab-uipath/index.cs.md"
+++
UiPath je zavedeným standardem v oblasti automatizace robotických procesů. Pomocí uiPath můžete vyvinout softwarového robota/bota, který se za vás postará o složité zpracování dat nebo o úlohy klikání. Lze však takového robota ovládat i pomocí Gitlabu?Stručná odpověď zní "ano". A jak přesně, se můžete podívat zde. K následujícím krokům potřebujete administrátorská práva a určité zkušenosti s uiPath, Windows a Gitlabem.
## Krok 1: Nejprve je třeba nainstalovat spouštěč Gitlab.
1.1.) Vytvořte nového uživatele Gitlabu pro cílový operační systém. Klikněte na "Nastavení" > "Rodina a další uživatelé" a poté na "Přidat další osobu k tomuto počítači".
{{< gallery match="images/1/*.png" >}}
1.2.) Klikněte na "Neznám pověření pro tuto osobu" a poté na "Přidat uživatele bez účtu Microsoft" a vytvořte místního uživatele.
{{< gallery match="images/2/*.png" >}}
1.3.) V následujícím dialogu můžete libovolně zvolit uživatelské jméno a heslo:
{{< gallery match="images/3/*.png" >}}

## Krok 2: Aktivace přihlášení ke službě
Pokud chcete pro svůj program Gitlab Runner pro systém Windows používat samostatného místního uživatele, musíte "Aktivovat přihlašování jako službu". Za tímto účelem přejděte do nabídky systému Windows > "Místní zásady zabezpečení". Tam vyberte "Místní zásady" > "Přiřadit uživatelská práva" na levé straně a "Přihlášení jako služba" na pravé straně.
{{< gallery match="images/4/*.png" >}}
Poté přidejte nového uživatele.
{{< gallery match="images/5/*.png" >}}

## Krok 3: Registrace programu Gitlab Runner
Instalační program systému Windows pro Gitlab Runner naleznete na následující stránce: https://docs.gitlab.com/runner/install/windows.html . Vytvořil jsem novou složku na disku C a umístil do ní instalační program.
{{< gallery match="images/6/*.png" >}}
3.1.) Pomocí příkazu "CMD" jako "Administrator" otevřu novou konzoli a přejdu do adresáře "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Tam zavolám následující příkaz. Jak vidíte, zadávám zde také uživatelské jméno a heslo uživatele Gitlab.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Nyní je možné zaregistrovat běhový modul Gitlab. Pokud pro instalaci Gitlabu používáte certifikát podepsaný vlastním podpisem, musíte certifikát opatřit atributem "-tls-ca-file=". Poté zadejte url adresu Gitlabu a token registru.
{{< gallery match="images/8/*.png" >}}
3.2.) Po úspěšné registraci lze spouštěč spustit příkazem "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Skvělé! Váš Gitlab Runner je spuštěn a použitelný.
{{< gallery match="images/10/*.png" >}}

## Krok 4: Instalace systému Git
Vzhledem k tomu, že spouštěč Gitlab pracuje s verzováním systému Git, musí být nainstalován také systém Git pro Windows:
{{< gallery match="images/11/*.png" >}}

## Krok 5: Instalace aplikace UiPath
Instalace UiPath je nejjednodušší částí tohoto návodu. Přihlaste se jako uživatel Gitlabu a nainstalujte komunitní verzi. Samozřejmě můžete ihned nainstalovat veškerý software, který váš robot potřebuje, například: Office 365.
{{< gallery match="images/12/*.png" >}}

## Krok 6: Vytvoření projektu a potrubí Gitlab
Nyní přichází velké finále tohoto návodu. Vytvořím nový projekt Gitlab a zkontroluji soubory projektu uiPath.
{{< gallery match="images/13/*.png" >}}
6.1.) Kromě toho vytvořím nový soubor ".gitlab-ci.yml" s následujícím obsahem:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Můj softwarový robot pro Windows se spustí přímo po odevzdání do hlavní větve:
{{< gallery match="images/14/*.png" >}}
Automatické spuštění robota lze spravovat pomocí možnosti "Plány". Velkou výhodou této kombinace je, že "robotické" projekty a výsledky projektů (artefakty) lze centrálně kontrolovat, verzovat a spravovat pomocí Gitlabu s ostatními "nerobotickými" projekty.
