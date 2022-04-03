+++
date = "2022-03-21"
title = "Nagyszerű dolgok konténerekkel: KPI műszerfal"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.hu.md"
+++
Különösen a Corona-korszakban, a decentralizált munkavégzéssel a naprakész információkra minden helyszínen nagy szükség van. Jómagam már számtalan információs rendszert állítottam fel, és szeretnék bemutatni egy nagyszerű szoftvert, a Smashing.Speaker: https://smashing.github.io/Das A Smashing projektet eredetileg Dashing néven fejlesztette ki a Shopify cég az üzleti számok bemutatására. De természetesen nem lehet csak üzleti számokat megjeleníteni. A világ minden tájáról érkező fejlesztők fejlesztették ki a Smashing csempéket, úgynevezett widgeteket a Gitlab, Jenkins, Bamboo, Jira stb. számára, lásd:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch hogyan dolgozhatsz vele?
## 1. lépés: Alapkép létrehozása
Először létrehozok egy egyszerű Docker-képet, amely már tartalmazza a Rubyt és a Dashinget.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Ez az első tartalom, amit a Dockerfile fájlba írok:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Ezután létrehozom a Docker-képet ezzel a paranccsal:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Nekem így néz ki:
{{< gallery match="images/1/*.png" >}}

## 2. lépés: Műszerfal létrehozása
Most már létrehozhatok egy új műszerfalat a következő paranccsal:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Ezután a Dashing projekt "dashboard" mappájának így kell kinéznie:
{{< gallery match="images/2/*.png" >}}
Nagyon jó! Most újra frissítenem kell a Dockerfile-t. Az új tartalom a következő:
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
Ezenkívül a "dashboard" mappában található Gemfile fájlt is módosítani kell:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Megismétlem a build parancsot:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Most tudom először elindítani az új műszerfalat, és a http://localhost:9292 címen hozzáférhetek hozzá.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
És így néz ki:
{{< gallery match="images/3/*.png" >}}
Ez az alapja egy jó információs rendszernek. Testreszabhatja az összes színt, szkriptet és widgetet.
