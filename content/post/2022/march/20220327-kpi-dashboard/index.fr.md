+++
date = "2022-03-21"
title = "De grandes choses avec les conteneurs : tableau de bord KPI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.fr.md"
+++
A l'époque de Corona, avec le travail décentralisé, les informations actuelles sont très demandées à tous les endroits. J'ai moi-même déjà mis en place d'innombrables systèmes d'information et j'aimerais présenter ici un super logiciel appelé Smashing.intervenant : https://smashing.github.io/Das Le projet Smashing a été développé à l'origine sous le nom de Dashing par l'entreprise Shopify pour la présentation de chiffres commerciaux. Mais on ne peut évidemment pas se contenter de représenter des chiffres commerciaux. Des développeurs du monde entier ont développé des tuiles Smashing, appelées widgets, pour Gitlab, Jenkins, Bamboo, Jira, etc., voir:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch comment travailler avec ?
## Étape 1 : Créer une image de base
Tout d'abord, je crée une image Docker simple, qui inclut déjà Ruby et Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
C'est le premier contenu que j'écris dans le fichier Dockerfile :
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Ensuite, je crée l'image docker avec cette commande :
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Voilà à quoi ça ressemble pour moi :
{{< gallery match="images/1/*.png" >}}

## Étape 2 : Créer un tableau de bord
Je peux maintenant créer un nouveau tableau de bord avec la commande suivante :
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Après cela, le dossier "dashboard" dans le projet Dashing devrait ressembler à ceci :
{{< gallery match="images/2/*.png" >}}
Très bien ! Maintenant, je dois encore une fois mettre à jour le fichier docker. Le nouveau contenu est celui-ci :
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
En outre, le fichier Gemfile dans le dossier "dashboard" doit également être adapté :
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Je répète la commande Build :
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Je peux maintenant lancer mon nouveau tableau de bord pour la première fois et y accéder à l'adresse http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
Et voici à quoi cela ressemble :
{{< gallery match="images/3/*.png" >}}
