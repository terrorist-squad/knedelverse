+++
date = "2020-02-07"
title = "Orkiestracja robotów uiPath Windows Robots za pomocą Gitlab"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-gitlab-uipath/index.pl.md"
+++
UiPath jest uznanym standardem w dziedzinie automatyzacji procesów zrobotyzowanych. Za pomocą uiPath można opracować programowe roboty, które wykonują złożone zadania związane z przetwarzaniem danych lub klikaniem. Ale czy taki robot może być sterowany za pomocą programu Gitlab? Krótka odpowiedź brzmi "tak". A jak dokładnie, można zobaczyć tutaj. Do wykonania poniższych czynności potrzebne są prawa administratora oraz pewne doświadczenie w zakresie uiPath, Windows i Gitlab.
## Krok 1: Pierwszą rzeczą, którą należy zrobić, jest zainstalowanie programu uruchamiającego Gitlab.
1.1.) Utwórz nowego użytkownika Gitlab dla docelowego systemu operacyjnego. Kliknij na "Ustawienia" > "Rodzina i inni użytkownicy", a następnie na "Dodaj kolejną osobę do tego komputera".
{{< gallery match="images/1/*.png" >}}
1.2.) Kliknij przycisk "Nie znam poświadczeń dla tej osoby", a następnie "Dodaj użytkownika bez konta Microsoft", aby utworzyć użytkownika lokalnego.
{{< gallery match="images/2/*.png" >}}
1.3.) W następnym oknie dialogowym można dowolnie wybrać nazwę użytkownika i hasło:
{{< gallery match="images/3/*.png" >}}

## Krok 2: Aktywacja usługi logowania
Jeśli chcesz używać osobnego, lokalnego użytkownika dla Gitlab Runnera w systemie Windows, musisz "Aktywować logowanie jako usługę". W tym celu należy przejść do menu Windows > "Lokalne zasady zabezpieczeń". W tym celu należy wybrać "Zasady lokalne" > "Przydziel uprawnienia użytkownika" po lewej stronie i "Logowanie jako usługa" po prawej stronie.
{{< gallery match="images/4/*.png" >}}
Następnie dodaj nowego użytkownika.
{{< gallery match="images/5/*.png" >}}

## Krok 3: Zarejestruj Gitlab Runner
Instalator systemu Windows dla programu Gitlab Runner można znaleźć na następującej stronie: https://docs.gitlab.com/runner/install/windows.html . Utworzyłem nowy folder na dysku "C" i umieściłem w nim instalator.
{{< gallery match="images/6/*.png" >}}
3.1.) Używam polecenia "CMD" jako "Administrator", aby otworzyć nową konsolę i przejść do katalogu "cd C:™gitlab-runner".
{{< gallery match="images/7/*.png" >}}
W tym celu wywołuję następujące polecenie. Jak widać, podaję tu także nazwę użytkownika i hasło użytkownika Gitlab.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Teraz można zarejestrować program uruchamiający Gitlab. Jeśli w instalacji Gitlab używasz samopodpisanego certyfikatu, musisz podać certyfikat z atrybutem "-tls-ca-file=". Następnie wprowadź adres url Gitlab i token rejestru.
{{< gallery match="images/8/*.png" >}}
3.2.) Po udanej rejestracji można uruchomić runner za pomocą polecenia "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Świetnie! Twój program Gitlab Runner jest gotowy do pracy i nadaje się do użytku.
{{< gallery match="images/10/*.png" >}}

## Krok 4: Zainstaluj Git
Ponieważ program uruchamiający Gitlab pracuje z wersjonowaniem Git, musi być również zainstalowany Git dla Windows:
{{< gallery match="images/11/*.png" >}}

## Krok 5: Zainstaluj UiPath
Instalacja UiPath jest najłatwiejszą częścią tego podręcznika. Zaloguj się jako użytkownik Gitlab i zainstaluj edycję społecznościową. Oczywiście można od razu zainstalować całe oprogramowanie, którego potrzebuje robot, na przykład Office 365.
{{< gallery match="images/12/*.png" >}}

## Krok 6: Utwórz projekt i potok w Gitlabie
Teraz nadszedł wielki finał tego poradnika. Tworzę nowy projekt w serwisie Gitlab i sprawdzam pliki projektu uiPath.
{{< gallery match="images/13/*.png" >}}
6.1.) Dodatkowo tworzę nowy plik ".gitlab-ci.yml" o następującej zawartości:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Mój robot programowy dla systemu Windows jest wykonywany bezpośrednio po przejściu do gałęzi nadrzędnej:
{{< gallery match="images/14/*.png" >}}
Automatycznym uruchamianiem robota można zarządzać za pomocą opcji "Harmonogramy". Ogromną zaletą tego połączenia jest to, że "zrobotyzowane" projekty i ich rezultaty (artefakty) mogą być centralnie kontrolowane, wersjonowane i zarządzane przez Gitlab wraz z innymi "niezrobotyzowanymi" projektami.
