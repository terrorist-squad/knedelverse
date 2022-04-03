+++
date = "2022-03-21"
title = "Grote dingen met containers: KPI Dashboard"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.nl.md"
+++
Vooral in het Coronatijdperk, met gedecentraliseerd werk, is actuele informatie op alle locaties een must. Ik heb zelf al talloze informatiesystemen opgezet en wil u graag kennis laten maken met een geweldige software genaamd Smashing.Speaker: https://smashing.github.io/Das Smashing project is oorspronkelijk onder de naam Dashing ontwikkeld door het bedrijf Shopify voor de presentatie van bedrijfscijfers. Maar je kunt natuurlijk niet alleen bedrijfscijfers laten zien. Ontwikkelaars van over de hele wereld hebben Smashing-tegels, zogenaamde widgets, ontwikkeld voor Gitlab, Jenkins, Bamboo, Jira, enz., zie:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch hoe werk je ermee?
## Stap 1: Maak basisafbeelding
Eerst maak ik een eenvoudig Docker image dat al Ruby en Dashing bevat.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Dit is de eerste inhoud die ik schrijf in het Dockerfile bestand:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Dan maak ik de Docker image met dit commando:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Dit is hoe het er voor mij uitziet:
{{< gallery match="images/1/*.png" >}}

## Stap 2: Dashboard aanmaken
Nu kan ik een nieuw dashboard maken met het volgende commando:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Daarna zou de "dashboard" map in het Dashing project er als volgt uit moeten zien:
{{< gallery match="images/2/*.png" >}}
Heel goed. Nu moet ik het Dockerfile weer bijwerken. De nieuwe inhoud is dit:
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
Daarnaast moet ook het Gemfile bestand in de "dashboard" map aangepast worden:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Ik herhaal het bouwcommando:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Nu kan ik mijn nieuwe dashboard voor de eerste keer starten en er toegang toe krijgen op http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
En dit is hoe het eruit ziet:
{{< gallery match="images/3/*.png" >}}
Dit is de basis voor een goed informatiesysteem. U kunt alle kleuren, scripts en widgets aanpassen.
