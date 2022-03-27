+++
date = "2022-03-21"
title = "Großartiges mit Containern: KPI Dashboard"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.de.md"
+++

Gerade in der Coronazeit, beim dezentralen Arbeiten sind aktuelle Informationen an allen Orten heiß gefragt. Ich selbst habe schon unzählige Informations-Systeme aufgestellt und möchte hier einmal eine tolle Software namens Smashing vorstellen.
Referent: https://smashing.github.io/

Das Smashing-Projekt wurde ursprünglich unter dem Namen Dashing von der Firma Shopify für die Darstellung von Geschäftszahlen entwickelt. Aber man kann natürlich nicht nur Geschäftszahlen darstellen. Entwickler aus der ganzen Welt haben Smashing - Kacheln sogenannte Widgets für Gitlab, Jenkins, Bamboo, Jira usw. entwickelt, siehe:
https://github.com/Smashing/smashing/wiki/Additional-Widgets

Doch wie arbeitet man nun damit?

## Schritt 1: Basis-Image erstellen
Als erstes erstelle ich mir ein einfaches Docker-Image, dass bereits Ruby und Dashing mitbringt.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile
{{</ terminal >}}
Das ist der erste Inhalt, den ich in die Dockerfile-Datei schreibe:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean
```
Danach erzeuge ich das Docker-Image mit diesem Befehl:
{{< terminal >}}
docker build -t my-dashboard:latest .
{{</ terminal >}}

So sieht das bei mir aus:
{{< gallery match="images/1/*.png" >}}

## Schritt 2: Dashboard erstellen
Nun kann ich mit dem folgenden Befehl ein neues Dashboard erstellen:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard
{{</ terminal >}}
Danach sollte der "dashboard-Ordner im Dashing-Project wie folgt aussehen:
{{< gallery match="images/2/*.png" >}}

Sehr gut! Nun muss ich noch einmal das Dockerfile updaten. Der neue Inhalt ist dieser:
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
Außerdem muss auch die Gemfile-Datei im "dashboard"-Ordner angepasst werden:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'
```
Ich wiederhole den Build-Befehl:
{{< terminal >}}
docker build -t my-dashboard:latest .
{{</ terminal >}}
Jetzt kann ich mein neues Dashboard zum ersten Mal starten und unter http://localhost:9292 aufrufen.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest
{{</ terminal >}}
Und so sieht es aus:
{{< gallery match="images/3/*.png" >}}
Das ist die Grundlage für ein gutes Informationssystem. Man kann alle Farbe, Skripte und Widgets anpassen.