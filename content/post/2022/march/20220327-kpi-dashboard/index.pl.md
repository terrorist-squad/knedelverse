+++
date = "2022-03-21"
title = "Wspaniałe rzeczy z kontenerami: pulpit nawigacyjny KPI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.pl.md"
+++
Szczególnie w erze Corona, gdzie praca jest zdecentralizowana, aktualne informacje są bardzo potrzebne we wszystkich miejscach. Ja sam stworzyłem już niezliczone systemy informacyjne i chciałbym przedstawić świetne oprogramowanie o nazwie Smashing.Mówca: https://smashing.github.io/Das Projekt Smashing został pierwotnie opracowany pod nazwą Dashing przez firmę Shopify do prezentacji danych biznesowych. Ale oczywiście nie można wyświetlać tylko danych biznesowych. Programiści z całego świata opracowali kafelki Smashing, tzw. widżety, dla Gitlab, Jenkins, Bamboo, Jira itp., patrz: https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch jak z nimi pracować?
## Krok 1: Utwórz obraz podstawowy
Najpierw tworzę prosty obraz Dockera, który zawiera już Ruby i Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Jest to pierwsza treść, którą wpisuję do pliku Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Następnie tworzę obraz Dockera za pomocą tego polecenia:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Oto jak to wygląda w moim przypadku:
{{< gallery match="images/1/*.png" >}}

## Krok 2: Tworzenie pulpitu nawigacyjnego
Teraz mogę utworzyć nową tablicę rozdzielczą za pomocą następującego polecenia:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Po wykonaniu tych czynności folder "dashboard" w projekcie Dashing powinien wyglądać następująco:
{{< gallery match="images/2/*.png" >}}
Bardzo dobrze! Teraz muszę ponownie zaktualizować plik Dockerfile. Nowa treść jest następująca:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
 
COPY dashboard/ /code/
 
RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
gem install bundler && \
apt-get clean
 
RUN cd /code/ && \
bundle
 
RUN chown -R www-data:www-data  /code/

USER www-data
WORKDIR /code/

EXPOSE 3030

CMD ["/usr/local/bin/bundle", "exec", "puma", "config.ru"]

```
Ponadto należy również dostosować plik Gemfile znajdujący się w folderze "dashboard":
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Powtarzam polecenie budowania:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Teraz mogę po raz pierwszy uruchomić mój nowy pulpit nawigacyjny i uzyskać do niego dostęp na stronie http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
A tak to wygląda:
{{< gallery match="images/3/*.png" >}}
