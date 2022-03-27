+++
date = "2022-03-21"
title = "Velike stvari z zabojniki: nadzorna plošča KPI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.sl.md"
+++
Zlasti v dobi Corona z decentraliziranim delom so na vseh lokacijah zelo potrebne najnovejše informacije. Sam sem vzpostavil že nešteto informacijskih sistemov in rad bi vam predstavil odlično programsko opremo, imenovano Smashing. govornik: https://smashing.github.io/Das Projekt Smashing je pod imenom Dashing prvotno razvilo podjetje Shopify za predstavitev poslovnih podatkov. Seveda pa ne morete prikazati le poslovnih podatkov. Razvijalci z vsega sveta so za Gitlab, Jenkins, Bamboo, Jira itd. razvili ploščice Smashing, tako imenovane gradnike, glej:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch kako z njimi delate?
## Korak 1: Ustvarite osnovno sliko
Najprej ustvarim preprosto sliko Docker, ki že vključuje Ruby in Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
To je prva vsebina, ki jo zapišem v datoteko Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Nato ustvarim sliko Docker s tem ukazom:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Tako je videti pri meni:
{{< gallery match="images/1/*.png" >}}

## Korak 2: Ustvarite nadzorno ploščo
Zdaj lahko ustvarim novo nadzorno ploščo z naslednjim ukazom:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Potem mora biti mapa "dashboard" v projektu Dashing videti takole:
{{< gallery match="images/2/*.png" >}}
Zelo dobro! Zdaj moram znova posodobiti datoteko Docker. Nova vsebina je naslednja:
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
Poleg tega je treba prilagoditi tudi datoteko Gemfile v mapi "dashboard":
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Ponovim ukaz za sestavljanje:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Zdaj lahko prvič zaženem novo nadzorno ploščo in do nje dostopam na naslovu http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
Tako je videti:
{{< gallery match="images/3/*.png" >}}
