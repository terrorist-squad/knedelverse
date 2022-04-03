+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner w kontenerze Docker"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.pl.md"
+++
Jak zainstalować program uruchamiający Gitlab jako kontener Docker na serwerze Synology NAS?
## Krok 1: Wyszukaj obraz Dockera
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję Gitlab. Wybieram obraz Dockera "gitlab/gitlab-runner", a następnie wybieram tag "bleeding".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Uruchomienie obrazu:

##  Problem z hostami
Moja synologia-gitlab-insterlation zawsze identyfikuje się tylko za pomocą nazwy hosta. Ponieważ pobrałem oryginalny pakiet Synology Gitlab z centrum pakietów, nie można później zmienić tego zachowania.  Jako obejście problemu mogę dołączyć własny plik hosts. Widać tu, że nazwa hosta "peter" należy do adresu IP 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Ten plik jest po prostu przechowywany na serwerze Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Krok 3: Skonfiguruj GitLab Runner
Klikam na zdjęcie mojego biegacza:
{{< gallery match="images/3/*.png" >}}
Włączam ustawienie "Włącz automatyczne ponowne uruchamianie":
{{< gallery match="images/4/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i wybieram zakładkę "Wolumin":
{{< gallery match="images/5/*.png" >}}
Klikam na Dodaj plik i dołączam mój plik hosts poprzez ścieżkę "/etc/hosts". Ten krok jest konieczny tylko wtedy, gdy nie można rozwiązać nazw hostów.
{{< gallery match="images/6/*.png" >}}
Akceptuję ustawienia i klikam przycisk Dalej.
{{< gallery match="images/7/*.png" >}}
Teraz zainicjowany obraz znajduje się w obszarze Container:
{{< gallery match="images/8/*.png" >}}
Wybieram kontener (w moim przypadku gitlab-gitlab-runner2) i klikam na "Szczegóły". Następnie klikam zakładkę "Terminal" i tworzę nową sesję bash. W tym miejscu wpisuję polecenie "gitlab-runner register". Do rejestracji potrzebne są informacje, które można znaleźć w mojej instalacji GitLab pod adresem http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Jeśli potrzebujesz więcej pakietów, możesz je zainstalować za pomocą polecenia "apt-get update", a następnie "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Następnie mogę włączyć bieżnik do swoich projektów i wykorzystać go:
{{< gallery match="images/11/*.png" >}}
