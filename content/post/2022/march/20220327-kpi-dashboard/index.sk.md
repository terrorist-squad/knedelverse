+++
date = "2022-03-21"
title = "Veľké veci s kontajnermi: KPI Dashboard"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.sk.md"
+++
Najmä v ére Corona s decentralizovanou prácou sú aktuálne informácie na všetkých miestach veľmi potrebné. Sám som už vytvoril nespočetné množstvo informačných systémov a rád by som vám predstavil skvelý softvér s názvom Smashing.Prednášajúci: https://smashing.github.io/Das Projekt Smashing bol pôvodne vyvinutý pod názvom Dashing spoločnosťou Shopify na prezentáciu obchodných údajov. Samozrejme však nemôžete zobrazovať len obchodné údaje. Vývojári z celého sveta vyvinuli dlaždice Smashing, tzv. widgety, pre Gitlab, Jenkins, Bamboo, Jira atď., pozri:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch ako sa s nimi pracuje?
## Krok 1: Vytvorenie základného obrazu
Najprv vytvorím jednoduchý obraz Docker, ktorý už obsahuje Ruby a Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Toto je prvý obsah, ktorý zapíšem do súboru Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Potom vytvorím obraz Docker pomocou tohto príkazu:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Takto to vyzerá pre mňa:
{{< gallery match="images/1/*.png" >}}

## Krok 2: Vytvorenie prístrojovej dosky
Teraz môžem vytvoriť nový ovládací panel pomocou nasledujúceho príkazu:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Potom by mal priečinok "dashboard" v projekte Dashing vyzerať takto:
{{< gallery match="images/2/*.png" >}}
Veľmi dobre! Teraz musím znovu aktualizovať súbor Docker. Nový obsah je tento:
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
Okrem toho je potrebné upraviť aj súbor Gemfile v priečinku "dashboard":
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Zopakujem príkaz na zostavenie:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Teraz môžem prvýkrát spustiť svoj nový prístrojový panel a získať k nemu prístup na adrese http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
A takto to vyzerá:
{{< gallery match="images/3/*.png" >}}
