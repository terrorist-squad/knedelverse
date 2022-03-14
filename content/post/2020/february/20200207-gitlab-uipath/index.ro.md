+++
date = "2020-02-07"
title = "Orchestrați roboții uiPath Windows Robots cu Gitlab"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-gitlab-uipath/index.ro.md"
+++
UiPath este un standard consacrat în domeniul automatizării robotizate a proceselor. Cu uiPath, puteți dezvolta un robot/robot bazat pe software care să se ocupe de procesarea complexă a datelor sau de sarcini complexe de clic pentru dumneavoastră. Dar poate un astfel de robot să fie controlat și cu Gitlab?răspunsul scurt este "da". Și cum anume puteți vedea aici. Pentru următorii pași, aveți nevoie de drepturi de administrare și de o anumită experiență în uiPath, Windows și Gitlab.
## Pasul 1: Primul lucru pe care trebuie să-l faceți este să instalați un Gitlab runner.
1.1.) Creați un nou utilizator Gitlab pentru sistemul de operare țintă. Faceți clic pe "Settings" (Setări) > "Family and other users" (Familie și alți utilizatori) și apoi pe "Add another person to this PC" (Adăugați o altă persoană la acest PC).
{{< gallery match="images/1/*.png" >}}
1.2.) Vă rugăm să faceți clic pe "Nu cunosc acreditările pentru această persoană" și apoi pe "Adaugă utilizator fără cont Microsoft" pentru a crea un utilizator local.
{{< gallery match="images/2/*.png" >}}
1.3.) În următorul dialog puteți selecta liber numele de utilizator și parola:
{{< gallery match="images/3/*.png" >}}

## Pasul 2: Activarea serviciului de conectare
Dacă doriți să folosiți un utilizator local separat pentru Gitlab Runner pentru Windows, atunci trebuie să "Activați conectarea ca serviciu". Pentru a face acest lucru, accesați meniul Windows > "Politica locală de securitate". Acolo, selectați "Local Policy" (Politică locală) > "Assign User Rights" (Atribuire drepturi de utilizator) în partea stângă și "Logon as Service" (Conectare ca serviciu) în partea dreaptă.
{{< gallery match="images/4/*.png" >}}
Apoi adăugați noul utilizator.
{{< gallery match="images/5/*.png" >}}

## Pasul 3: Înregistrați Gitlab Runner
Programul de instalare pentru Windows pentru Gitlab Runner poate fi găsit pe următoarea pagină: https://docs.gitlab.com/runner/install/windows.html . Am creat un nou dosar în unitatea "C" și am pus programul de instalare acolo.
{{< gallery match="images/6/*.png" >}}
3.1.) Folosesc comanda "CMD" ca "Administrator" pentru a deschide o nouă consolă și pentru a trece la un director "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Acolo am apelat următoarea comandă. După cum puteți vedea, aici introduc și numele de utilizator și parola utilizatorului Gitlab.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Acum, Gitlab runner poate fi înregistrat. Dacă folosiți un certificat auto-semnat pentru instalarea Gitlab, trebuie să furnizați certificatul cu atributul "-tls-ca-file=". Apoi introduceți adresa URL Gitlab și token-ul de înregistrare.
{{< gallery match="images/8/*.png" >}}
3.2.) După înregistrarea cu succes, runner-ul poate fi pornit cu comanda "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Grozav! Gitlab Runner este funcțional și utilizabil.
{{< gallery match="images/10/*.png" >}}

## Pasul 4: Instalați Git
Deoarece Gitlab runner funcționează cu Git versioning, trebuie instalat și Git pentru Windows:
{{< gallery match="images/11/*.png" >}}

## Pasul 5: Instalați UiPath
Instalarea UiPath este cea mai ușoară parte a acestui tutorial. Conectați-vă ca utilizator Gitlab și instalați ediția comunitară. Desigur, puteți instala imediat toate programele de care robotul dumneavoastră are nevoie, de exemplu: Office 365.
{{< gallery match="images/12/*.png" >}}

## Pasul 6: Creați proiectul și conducta Gitlab
Acum vine marele final al acestui tutorial. Creez un nou proiect Gitlab și verific în fișierele proiectului meu uiPath.
{{< gallery match="images/13/*.png" >}}
6.1.) În plus, creez un nou fișier ".gitlab-ci.yml" cu următorul conținut:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Robotul meu software pentru Windows este executat direct după ce a fost trimis pe ramura principală:
{{< gallery match="images/14/*.png" >}}
