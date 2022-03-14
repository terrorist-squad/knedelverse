+++
date = "2020-02-07"
title = "Orkiestracja robotów uiPath Windows Robots za pomocą Gitlab"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-gitlab-uipath/index.pl.md"
+++
UiPath jest uznanym standardem w automatyzacji procesów robotycznych. Dzięki uiPath można opracować robota/robot oparty na oprogramowaniu, który zajmuje się złożonym przetwarzaniem danych lub zadaniami kliknięć dla użytkownika. Ale czy taki robot może być również kontrolowany za pomocą Gitlaba? Krótka odpowiedź brzmi "tak". A jak dokładnie, można zobaczyć tutaj. Do wykonania poniższych kroków potrzebne są prawa administratora i pewne doświadczenie w zakresie uiPath, Windows i Gitlab.
## Krok 1: Pierwszą rzeczą, którą należy zrobić jest zainstalowanie programu uruchamiającego Gitlab.
1.1.) Utwórz nowego użytkownika Gitlab dla docelowego systemu operacyjnego. Proszę kliknąć na "Ustawienia" > "Rodzina i inni użytkownicy", a następnie na "Dodaj kolejną osobę do tego komputera".
{{< gallery match="images/1/*.png" >}}
1.2.) Proszę kliknąć na "Nie znam poświadczeń dla tej osoby", a następnie na "Dodaj użytkownika bez konta Microsoft", aby utworzyć użytkownika lokalnego.
{{< gallery match="images/2/*.png" >}}
1.3.) W następnym oknie dialogowym można dowolnie wybrać nazwę użytkownika i hasło:
{{< gallery match="images/3/*.png" >}}

## Krok 2: Aktywacja logowania do usługi
Jeśli chcesz używać osobnego, lokalnego użytkownika dla Twojego Windows Gitlab Runner, musisz "Aktywować logowanie jako usługę". Aby to zrobić, przejdź do menu Windows > "Lokalne zasady bezpieczeństwa". Tam wybieramy po lewej stronie "Zasady lokalne" > "Przypisz uprawnienia użytkownika", a po prawej "Zaloguj się jako usługa".
{{< gallery match="images/4/*.png" >}}
Następnie dodaj nowego użytkownika.
{{< gallery match="images/5/*.png" >}}

## Krok 3: Zarejestruj Gitlab Runner
Instalator Gitlab Runner dla systemu Windows można znaleźć na następującej stronie: https://docs.gitlab.com/runner/install/windows.html . Utworzyłem nowy folder w moim dysku "C" i umieściłem tam instalator.
{{< gallery match="images/6/*.png" >}}
3.1.) Używam polecenia "CMD" jako "Administrator", aby otworzyć nową konsolę i zmienić katalog na "cd C:™gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Tam wywołuję następujące polecenie. Jak widać, podaję tutaj również nazwę użytkownika i hasło użytkownika Gitlab.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Teraz można zarejestrować program uruchamiający Gitlab. Jeśli do instalacji Gitlaba używasz samodzielnie podpisanego certyfikatu, musisz podać certyfikat z atrybutem "-tls-ca-file=". Następnie wprowadź adres url Gitlab i token rejestru.
{{< gallery match="images/8/*.png" >}}
3.2.) Po udanej rejestracji można uruchomić runner za pomocą polecenia "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Świetnie! Twój Gitlab Runner działa i jest gotowy do użycia.
{{< gallery match="images/10/*.png" >}}

## Krok 4: Zainstaluj Git
Ponieważ Gitlab Runner pracuje z wersjonowaniem Git, musi być również zainstalowany Git dla Windows:
{{< gallery match="images/11/*.png" >}}

## Krok 5: Zainstaluj UiPath
Instalacja UiPath jest najłatwiejszą częścią tego poradnika. Zaloguj się jako użytkownik Gitlab i zainstaluj edycję społecznościową. Oczywiście, możesz od razu zainstalować wszystkie programy, których potrzebuje Twój robot, na przykład: Office 365.
{{< gallery match="images/12/*.png" >}}

## Krok 6: Tworzenie projektu i rurociągu w Gitlabie
Teraz nadchodzi wielki finał tego tutorialu. Tworzę nowy projekt Gitlab i sprawdzam w moich plikach projektu uiPath.
{{< gallery match="images/13/*.png" >}}
6.1.) Dodatkowo, tworzę nowy plik ".gitlab-ci.yml" z następującą zawartością:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Mój robot programowy Windows jest wykonywany bezpośrednio po commitowaniu do gałęzi master:
{{< gallery match="images/14/*.png" >}}
