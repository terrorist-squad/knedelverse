+++
date = "2022-03-21"
title = "Grandi cose con i container: KPI Dashboard"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.it.md"
+++
Soprattutto nell'era Corona, con il lavoro decentralizzato, le informazioni aggiornate sono molto richieste in tutte le sedi. Io stesso ho già impostato innumerevoli sistemi informativi e vorrei presentare un ottimo software chiamato Smashing.Speaker: https://smashing.github.io/Das Il progetto Smashing è stato originariamente sviluppato con il nome di Dashing dalla società Shopify per la presentazione di cifre aziendali. Ma ovviamente non si possono mostrare solo le cifre degli affari. Sviluppatori di tutto il mondo hanno sviluppato Smashing tiles, i cosiddetti widget, per Gitlab, Jenkins, Bamboo, Jira, ecc., vedi:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch come ci si lavora?
## Passo 1: creare l'immagine di base
Per prima cosa, creo una semplice immagine Docker che include già Ruby e Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Questo è il primo contenuto che scrivo nel file Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Poi creo l'immagine Docker con questo comando:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Questo è quello che sembra per me:
{{< gallery match="images/1/*.png" >}}

## Passo 2: Creare il cruscotto
Ora posso creare una nuova dashboard con il seguente comando:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Dopo di che, la cartella "dashboard" nel progetto Dashing dovrebbe apparire come questa:
{{< gallery match="images/2/*.png" >}}
Molto bene! Ora devo aggiornare nuovamente il Dockerfile. Il nuovo contenuto è questo:
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
Inoltre, anche il file Gemfile nella cartella "dashboard" deve essere adattato:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Ripeto il comando di costruzione:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Ora posso avviare la mia nuova dashboard per la prima volta e accedervi su http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
E questo è il suo aspetto:
{{< gallery match="images/3/*.png" >}}
Questa è la base di un buon sistema informativo. È possibile personalizzare tutto il colore, gli script e i widget.
