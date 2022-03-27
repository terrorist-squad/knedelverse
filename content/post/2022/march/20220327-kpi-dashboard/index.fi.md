+++
date = "2022-03-21"
title = "Suuria asioita konttien avulla: KPI-mittaristo"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.fi.md"
+++
Varsinkin Corona-aikakaudella, jolloin työ on hajautettua, ajantasaista tietoa tarvitaan kipeästi kaikissa toimipisteissä. Olen itse perustanut jo lukemattomia tietojärjestelmiä ja haluaisin esitellä loistavan ohjelmiston nimeltä Smashing.Speaker: https://smashing.github.io/Das Shopify-yhtiö Shopify kehitti alun perin Smashing-hankkeen nimellä Dashing liiketoimintalukujen esittämistä varten. Mutta et tietenkään voi vain näyttää liiketaloudellisia lukuja. Kehittäjät ympäri maailmaa ovat kehittäneet Smashing-laattoja, niin sanottuja widgettejä, Gitlabiin, Jenkinsiin, Bamboon, Jiraan jne., katso:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch miten sen kanssa työskennellään?
## Vaihe 1: Luo pohjakuva
Ensin luon yksinkertaisen Docker-imagen, joka sisältää jo Rubyn ja Dashingin.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Tämä on ensimmäinen sisältö, jonka kirjoitan Dockerfile-tiedostoon:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Sitten luon Docker-kuvan tällä komennolla:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Minulle se näyttää tältä:
{{< gallery match="images/1/*.png" >}}

## Vaihe 2: Luo kojelauta
Nyt voin luoda uuden kojelaudan seuraavalla komennolla:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Tämän jälkeen Dashing-projektin "dashboard"-kansio näyttää tältä:
{{< gallery match="images/2/*.png" >}}
Oikein hyvä! Nyt minun on päivitettävä Dockerfile uudelleen. Uusi sisältö on tämä:
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
Lisäksi "dashboard"-kansiossa olevaa Gemfile-tiedostoa on myös mukautettava:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Toistan rakennuskomennon:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Nyt voin käynnistää uuden kojelautani ensimmäistä kertaa ja käyttää sitä osoitteessa http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
Ja tältä se näyttää:
{{< gallery match="images/3/*.png" >}}
