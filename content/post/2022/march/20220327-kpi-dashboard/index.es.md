+++
date = "2022-03-21"
title = "Grandes cosas con contenedores: Cuadro de mando de KPI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.es.md"
+++
Especialmente en la era Corona, con el trabajo descentralizado, la información actualizada es muy solicitada en todos los lugares. Yo mismo he creado ya innumerables sistemas de información y me gustaría presentar un gran software llamado Smashing.Speaker: https://smashing.github.io/Das El proyecto Smashing fue desarrollado originalmente bajo el nombre de Dashing por la empresa Shopify para la presentación de cifras comerciales. Pero, por supuesto, no puede limitarse a mostrar las cifras del negocio. Desarrolladores de todo el mundo han desarrollado las baldosas de Smashing, los llamados widgets, para Gitlab, Jenkins, Bamboo, Jira, etc., ver:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch ¿cómo se trabaja con él?
## Paso 1: Crear la imagen base
Primero, creo una imagen Docker simple que ya incluye Ruby y Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Este es el primer contenido que escribo en el archivo Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Luego creo la imagen Docker con este comando:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Esto es lo que parece para mí:
{{< gallery match="images/1/*.png" >}}

## Paso 2: Crear un panel de control
Ahora puedo crear un nuevo panel de control con el siguiente comando:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Después de eso, la carpeta "dashboard" en el proyecto Dashing debería tener este aspecto:
{{< gallery match="images/2/*.png" >}}
¡Muy bien! Ahora tengo que actualizar el Dockerfile de nuevo. El nuevo contenido es este:
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
Además, también hay que adaptar el archivo Gemfile de la carpeta "dashboard":
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Repito el comando de construcción:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Ahora puedo iniciar mi nuevo tablero por primera vez y acceder a él en http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
Y así es como se ve:
{{< gallery match="images/3/*.png" >}}
Esta es la base de un buen sistema de información. Puedes personalizar todo el color, los scripts y los widgets.
