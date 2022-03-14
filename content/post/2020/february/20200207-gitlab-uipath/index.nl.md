+++
date = "2020-02-07"
title = "Orkestreer uiPath Windows Robots met Gitlab"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-gitlab-uipath/index.nl.md"
+++
UiPath is een gevestigde standaard in robotprocesautomatisering. Met uiPath kunt u een softwarematige robot/bot ontwikkelen die complexe gegevensverwerking of kliktaken voor u uitvoert. Maar kan zo'n robot ook met Gitlab bestuurd worden? Het korte antwoord is "ja". En hoe precies kunt u hier zien. Voor de volgende stappen heb je beheerdersrechten nodig en enige ervaring met uiPath, Windows en Gitlab.
## Stap 1: Het eerste wat je moet doen is een Gitlab runner installeren.
1.1.) Maak een nieuwe Gitlab gebruiker aan voor je doel besturingssysteem. Klik op "Instellingen" > "Familie en andere gebruikers" en dan op "Nog een persoon aan deze PC toevoegen".
{{< gallery match="images/1/*.png" >}}
1.2.) Klik op "I don't know the credentials for this person" en vervolgens op "Add user without Microsoft account" om een lokale gebruiker aan te maken.
{{< gallery match="images/2/*.png" >}}
1.3.) In de volgende dialoog kunt u vrij de gebruikersnaam en het wachtwoord kiezen:
{{< gallery match="images/3/*.png" >}}

## Stap 2: Activeer service logon
Als je een aparte, lokale gebruiker voor je Windows Gitlab Runner wilt gebruiken, dan moet je "Login als een service activeren". Ga hiervoor naar het Windows-menu > "Lokaal beveiligingsbeleid". Selecteer daar "Lokaal Beleid" > "Gebruikersrechten toewijzen" aan de linkerkant en "Aanmelden als Service" aan de rechterkant.
{{< gallery match="images/4/*.png" >}}
Voeg dan de nieuwe gebruiker toe.
{{< gallery match="images/5/*.png" >}}

## Stap 3: Gitlab Runner registreren
Het Windows installatieprogramma voor de Gitlab Runner kan gevonden worden op de volgende pagina: https://docs.gitlab.com/runner/install/windows.html . Ik heb een nieuwe map gemaakt op mijn "C" schijf en de installer daar gezet.
{{< gallery match="images/6/*.png" >}}
3.1.) Ik gebruik het commando "CMD" als "Administrator" om een nieuwe console te openen en ga naar een directory "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Daar roep ik het volgende commando op. Zoals je kunt zien, voer ik hier ook de gebruikersnaam en het wachtwoord van de Gitlab gebruiker in.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Nu kan de Gitlab runner geregistreerd worden. Als je een zelf-ondertekend certificaat gebruikt voor je Gitlab installatie, moet je het certificaat voorzien van het attribuut "-tls-ca-file=". Voer dan de Gitlab url en het registry token in.
{{< gallery match="images/8/*.png" >}}
3.2.) Na de succesvolle registratie kan de runner gestart worden met het commando "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Geweldig. Je Gitlab Runner werkt en is bruikbaar.
{{< gallery match="images/10/*.png" >}}

## Stap 4: Git installeren
Omdat een Gitlab runner met Git versiebeheer werkt, moet Git voor Windows ook geïnstalleerd zijn:
{{< gallery match="images/11/*.png" >}}

## Stap 5: Installeer UiPath
De UiPath installatie is het gemakkelijkste deel van deze handleiding. Log in als Gitlab gebruiker en installeer de community editie. Natuurlijk kunt u alle software die uw robot nodig heeft meteen installeren, bijvoorbeeld: Office 365.
{{< gallery match="images/12/*.png" >}}

## Stap 6: Gitlab project en pijplijn aanmaken
Nu komt de grote finale van deze tutorial. Ik maak een nieuw Gitlab project aan en kijk in mijn uiPath project bestanden.
{{< gallery match="images/13/*.png" >}}
6.1.) Daarnaast maak ik een nieuw bestand ".gitlab-ci.yml" met de volgende inhoud:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Mijn Windows software robot wordt uitgevoerd direct na het committen naar de master branch:
{{< gallery match="images/14/*.png" >}}
