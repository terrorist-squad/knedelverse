+++
date = "2022-03-21"
title = "Великие дела с контейнерами: приборная панель KPI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.ru.md"
+++
Особенно в эпоху Corona, когда децентрализованная работа требует актуальной информации на всех участках. Я сам уже установил бесчисленное количество информационных систем и хотел бы представить вам замечательное программное обеспечение под названием Smashing.Speaker: https://smashing.github.io/Das Проект Smashing изначально был разработан под названием Dashing компанией Shopify для представления бизнес-показателей. Но, конечно, вы не можете просто отображать бизнес показатели. Разработчики со всего мира создали плитки Smashing, так называемые виджеты, для Gitlab, Jenkins, Bamboo, Jira и т.д., см.:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch как с этим работать?
## Шаг 1: Создание базового изображения
Сначала я создаю простой образ Docker, который уже включает Ruby и Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Это первое содержимое, которое я пишу в файле Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Затем я создаю образ Docker с помощью этой команды:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Вот как это выглядит для меня:
{{< gallery match="images/1/*.png" >}}

## Шаг 2: Создание приборной панели
Теперь я могу создать новую приборную панель с помощью следующей команды:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
После этого папка "dashboard" в проекте Dashing должна выглядеть следующим образом:
{{< gallery match="images/2/*.png" >}}
Очень хорошо! Теперь мне нужно снова обновить Dockerfile. Новое содержание заключается в следующем:
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
Кроме того, файл Gemfile в папке "dashboard" также должен быть адаптирован:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Я повторяю команду сборки:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Теперь я могу впервые запустить новую приборную панель и получить к ней доступ по адресу http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
И вот как это выглядит:
{{< gallery match="images/3/*.png" >}}
