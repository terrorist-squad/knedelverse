+++
date = "2022-03-21"
title = "Страхотни неща с контейнери: табло за управление на ключови показатели (KPI)"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.bg.md"
+++
Особено в ерата на короната, когато работата е децентрализирана, актуалната информация е много необходима на всички места. Аз самият вече съм създал безброй информационни системи и бих искал да ви представя един чудесен софтуер, наречен Smashing.Говорител: https://smashing.github.io/Das Проектът Smashing първоначално е разработен под името Dashing от компанията Shopify за представяне на бизнес данни. Но, разбира се, не можете просто да показвате бизнес данни. Разработчици от цял свят са разработили плочки Smashing, т.нар. уиджети, за Gitlab, Jenkins, Bamboo, Jira и т.н., вижте:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch как се работи с тях?
## Стъпка 1: Създаване на базово изображение
Първо създавам прост образ на Docker, който вече включва Ruby и Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Това е първото съдържание, което записвам във файла Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
След това създавам образа на Docker с тази команда:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Ето как изглежда това за мен:
{{< gallery match="images/1/*.png" >}}

## Стъпка 2: Създаване на табло за управление
Сега мога да създам нов панел със следната команда:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
След това папката "dashboard" в проекта Dashing трябва да изглежда по следния начин:
{{< gallery match="images/2/*.png" >}}
Много добре! Сега трябва отново да актуализирам файла на Docker. Новото съдържание е следното:
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
Освен това трябва да се адаптира и файлът Gemfile в папката "dashboard":
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Повтарям командата за изграждане:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Сега мога да стартирам новото табло за управление за първи път и да имам достъп до него на адрес http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
И ето как изглежда:
{{< gallery match="images/3/*.png" >}}
