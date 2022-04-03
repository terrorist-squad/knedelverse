+++
date = "2022-03-21"
title = "Stora saker med behållare: KPI Dashboard"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.sv.md"
+++
Särskilt i Corona-eran, med decentraliserat arbete, är det viktigt att ha aktuell information på alla platser. Jag har själv redan inrättat otaliga informationssystem och skulle vilja presentera en fantastisk programvara som heter Smashing.Speaker: https://smashing.github.io/Das Smashing-projektet utvecklades ursprungligen under namnet Dashing av företaget Shopify för att presentera affärssiffror. Men du kan naturligtvis inte bara visa affärssiffror. Utvecklare från hela världen har utvecklat så kallade widgets för Gitlab, Jenkins, Bamboo, Jira etc., se:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch Hur arbetar du med det?
## Steg 1: Skapa en basbild
Först skapar jag en enkel Docker-avbildning som redan innehåller Ruby och Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Detta är det första innehållet jag skriver i Dockerfile-filen:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Sedan skapar jag Docker-avbildningen med det här kommandot:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Så här ser det ut för mig:
{{< gallery match="images/1/*.png" >}}

## Steg 2: Skapa en instrumentpanel
Nu kan jag skapa en ny instrumentpanel med följande kommando:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Därefter bör mappen "dashboard" i Dashing-projektet se ut så här:
{{< gallery match="images/2/*.png" >}}
Mycket bra! Nu måste jag uppdatera Dockerfilen igen. Det nya innehållet är följande:
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
Dessutom måste Gemfile-filen i mappen "dashboard" anpassas:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Jag upprepar byggkommandot:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Nu kan jag starta min nya instrumentpanel för första gången och komma åt den på http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
Och så här ser det ut:
{{< gallery match="images/3/*.png" >}}
Detta är grunden för ett bra informationssystem. Du kan anpassa alla färger, skript och widgets.
