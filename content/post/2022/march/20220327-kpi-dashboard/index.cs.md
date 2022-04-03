+++
date = "2022-03-21"
title = "Velké věci s kontejnery: KPI Dashboard"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.cs.md"
+++
Zejména v éře Corona, kdy je práce decentralizovaná, jsou aktuální informace na všech místech velmi žádané. Sám jsem již nastavil nespočet informačních systémů a rád bych vám představil skvělý software s názvem Smashing.Mluvčí: https://smashing.github.io/Das Projekt Smashing byl původně vyvinut pod názvem Dashing společností Shopify pro prezentaci obchodních údajů. Samozřejmě však nelze zobrazovat pouze obchodní údaje. Vývojáři z celého světa vytvořili dlaždice Smashing, tzv. widgety, pro Gitlab, Jenkins, Bamboo, Jira atd., viz:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch jak se s nimi pracuje?
## Krok 1: Vytvoření základního obrazu
Nejprve vytvořím jednoduchý obraz Dockeru, který již obsahuje Ruby a Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Toto je první obsah, který zapíšu do souboru Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Poté vytvořím obraz Dockeru pomocí tohoto příkazu:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Takhle to vypadá u mě:
{{< gallery match="images/1/*.png" >}}

## Krok 2: Vytvoření řídicího panelu
Nyní mohu vytvořit nový řídicí panel pomocí následujícího příkazu:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Poté by měla složka "dashboard" v projektu Dashing vypadat takto:
{{< gallery match="images/2/*.png" >}}
Velmi dobře! Nyní musím znovu aktualizovat soubor Docker. Nový obsah je následující:
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
Kromě toho je třeba upravit také soubor Gemfile ve složce "dashboard":
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Zopakuji příkaz build:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Nyní mohu poprvé spustit nový řídicí panel a přistupovat k němu na adrese http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
A takhle to vypadá:
{{< gallery match="images/3/*.png" >}}
To je základ dobrého informačního systému. Můžete si přizpůsobit všechny barvy, skripty a widgety.
