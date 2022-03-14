+++
date = "2020-02-07"
title = "Orkestrer uiPath Windows-robotter med Gitlab"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-gitlab-uipath/index.da.md"
+++
UiPath er en etableret standard inden for automatisering af robotprocesser. Med uiPath kan du udvikle en softwarebaseret robot/robot, der tager sig af komplekse databehandlinger eller klikopgaver for dig. Men kan en sådan robot også styres med Gitlab?Det korte svar er "ja". Og hvordan, kan du se her. For at kunne udføre de følgende trin skal du have administratorrettigheder og en vis erfaring med uiPath, Windows og Gitlab.
## Trin 1: Det første, du skal gøre, er at installere en Gitlab runner.
1.1.) Opret en ny Gitlab-bruger til dit måloperativsystem. Klik på "Indstillinger" > "Familie og andre brugere" og derefter på "Tilføj en anden person til denne pc".
{{< gallery match="images/1/*.png" >}}
1.2.) Klik på "I don't know the credentials for this person" (Jeg kender ikke legitimationsoplysningerne for denne person) og derefter på "Add user without Microsoft account" (Tilføj bruger uden Microsoft-konto) for at oprette en lokal bruger.
{{< gallery match="images/2/*.png" >}}
1.3.) I den følgende dialog kan du frit vælge brugernavn og adgangskode:
{{< gallery match="images/3/*.png" >}}

## Trin 2: Aktiver servicelogon
Hvis du vil bruge en separat, lokal bruger til din Windows Gitlab Runner, skal du "Aktiver logon som en tjeneste". Du kan gøre dette ved at gå til Windows-menuen > "Lokal sikkerhedspolitik". Vælg der "Lokal politik" > "Tildel brugerrettigheder" i venstre side og "Logon som tjeneste" i højre side.
{{< gallery match="images/4/*.png" >}}
Tilføj derefter den nye bruger.
{{< gallery match="images/5/*.png" >}}

## Trin 3: Registrer Gitlab Runner
Windows-installationsprogrammet til Gitlab Runner findes på følgende side: https://docs.gitlab.com/runner/install/windows.html . Jeg oprettede en ny mappe på mit "C"-drev og lagde installationsprogrammet der.
{{< gallery match="images/6/*.png" >}}
3.1.) Jeg bruger kommandoen "CMD" som "Administrator" til at åbne en ny konsol og skifter til en mappe "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Der kalder jeg følgende kommando. Som du kan se, indtaster jeg også Gitlab-brugerens brugernavn og adgangskode her.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Nu kan Gitlab-løberen registreres. Hvis du bruger et selv-signeret certifikat til din Gitlab-installation, skal du angive certifikatet med attributten "-tls-ca-file=". Indtast derefter Gitlab-url'en og registreringstokenet.
{{< gallery match="images/8/*.png" >}}
3.2.) Når registreringen er lykkedes, kan runneren startes med kommandoen "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Fantastisk! Din Gitlab Runner er oppe og kører og kan bruges.
{{< gallery match="images/10/*.png" >}}

## Trin 4: Installer Git
Da en Gitlab runner arbejder med Git-versionering, skal Git for Windows også installeres:
{{< gallery match="images/11/*.png" >}}

## Trin 5: Installer UiPath
UiPath-installationen er den letteste del af denne vejledning. Log ind som Gitlab-bruger, og installer community-udgaven. Du kan selvfølgelig installere al den software, som din robot har brug for med det samme, f.eks. Office 365.
{{< gallery match="images/12/*.png" >}}

## Trin 6: Opret Gitlab-projekt og pipeline
Nu kommer den store finale i denne vejledning. Jeg opretter et nyt Gitlab-projekt og tjekker i mine uiPath-projektfiler.
{{< gallery match="images/13/*.png" >}}
6.1.) Derudover opretter jeg en ny fil ".gitlab-ci.yml" med følgende indhold:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Min Windows-softwarerobot udføres direkte efter at jeg har lagt den ind i mastergrenen:
{{< gallery match="images/14/*.png" >}}
