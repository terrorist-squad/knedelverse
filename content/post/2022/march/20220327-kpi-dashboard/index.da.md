+++
date = "2022-03-21"
title = "Store ting med containere: KPI Dashboard"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.da.md"
+++
Især i Corona-æraen med decentraliseret arbejde er der stor efterspørgsel efter opdaterede oplysninger alle steder. Jeg har selv allerede oprettet utallige informationssystemer og vil gerne præsentere en fantastisk software kaldet Smashing.Speaker: https://smashing.github.io/Das Smashing-projektet blev oprindeligt udviklet under navnet Dashing af virksomheden Shopify til præsentation af forretningstal. Men du kan naturligvis ikke bare vise forretningstal. Udviklere fra hele verden har udviklet Smashing-tiles, såkaldte widgets, til Gitlab, Jenkins, Bamboo, Jira osv., se:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch Hvordan arbejder du med det?
## Trin 1: Opret basisbillede
Først opretter jeg et simpelt Docker-aftryk, der allerede indeholder Ruby og Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Dette er det første indhold, jeg skriver i Dockerfile-filen:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Derefter opretter jeg Docker-aftrykket med denne kommando:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Sådan ser det ud for mig:
{{< gallery match="images/1/*.png" >}}

## Trin 2: Opret dashboard
Nu kan jeg oprette et nyt dashboard med følgende kommando:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Herefter skal mappen "dashboard" i Dashing-projektet se sådan ud:
{{< gallery match="images/2/*.png" >}}
Meget godt! Nu er jeg nødt til at opdatere Dockerfilen igen. Det nye indhold er følgende:
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
Desuden skal Gemfile-filen i mappen "dashboard" også tilpasses:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Jeg gentager byggekommandoen:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Nu kan jeg starte mit nye instrumentbræt for første gang og få adgang til det på http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
Og sådan ser det ud:
{{< gallery match="images/3/*.png" >}}
