+++
date = "2022-03-21"
title = "Great things with containers: KPI Dashboard"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.en.md"
+++
Especially in the Corona era, with decentralized work, current information is in hot demand in all places. I myself have already set up countless information systems and would like to introduce a great software called Smashing.Speaker: https://smashing.github.io/Das Smashing project was originally developed under the name Dashing by the company Shopify for the presentation of business figures. But of course you can display not only business figures. Developers from all over the world have developed Smashing - tiles so called widgets for Gitlab, Jenkins, Bamboo, Jira etc., see:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch how to work with it now?
## Step 1: Create base image
First, I create a simple Docker image that already comes with Ruby and Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
This is the first content I write to the Dockerfile file:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
After that, I create the Docker image with this command:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
This is what it looks like for me:
{{< gallery match="images/1/*.png" >}}

## Step 2: Create Dashboard
Now I can create a new dashboard with the following command:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
After that, the "dashboard" folder in the Dashing project should look like this:
{{< gallery match="images/2/*.png" >}}
Very good! Now I have to update the Dockerfile again. The new content is this:
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
In addition, the Gemfile file in the "dashboard" folder must also be adjusted:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
I repeat the build command:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Now I can launch my new dashboard for the first time and access it at http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
And this is how it looks:
{{< gallery match="images/3/*.png" >}}
This is the basis for a good information system. You can customize all color, scripts and widgets.
