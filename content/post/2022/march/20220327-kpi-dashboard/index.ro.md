+++
date = "2022-03-21"
title = "Lucruri grozave cu containere: Tablou de bord KPI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.ro.md"
+++
Mai ales în era Corona, cu munca descentralizată, informațiile actualizate sunt foarte solicitate în toate locațiile. Eu însumi am creat deja nenumărate sisteme de informații și aș dori să vă prezint un software grozav numit Smashing.Speaker: https://smashing.github.io/Das Proiectul Smashing a fost dezvoltat inițial sub numele Dashing de către compania Shopify pentru prezentarea cifrelor de afaceri. Dar, desigur, nu puteți afișa doar cifrele de afaceri. Dezvoltatorii din întreaga lume au dezvoltat plăci Smashing, așa-numitele widget-uri, pentru Gitlab, Jenkins, Bamboo, Jira etc., vezi:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch cum se lucrează cu ele?
## Pasul 1: Creați imaginea de bază
Mai întâi, creez o imagine Docker simplă care include deja Ruby și Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Acesta este primul conținut pe care îl scriu în fișierul Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Apoi creez imaginea Docker cu această comandă:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Iată cum arată pentru mine:
{{< gallery match="images/1/*.png" >}}

## Pasul 2: Crearea tabloului de bord
Acum pot crea un nou tablou de bord cu următoarea comandă:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
După aceea, dosarul "dashboard" din proiectul Dashing ar trebui să arate astfel:
{{< gallery match="images/2/*.png" >}}
Foarte bine! Acum trebuie să actualizez din nou fișierul Dockerfile. Noul conținut este următorul:
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
În plus, fișierul Gemfile din dosarul "dashboard" trebuie, de asemenea, să fie adaptat:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Repet comanda de construire:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Acum pot să pornesc pentru prima dată noul meu tablou de bord și să îl accesez la http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
Și iată cum arată:
{{< gallery match="images/3/*.png" >}}
