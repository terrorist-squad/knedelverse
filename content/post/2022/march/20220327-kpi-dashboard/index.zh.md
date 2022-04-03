+++
date = "2022-03-21"
title = "容器的伟大之处：KPI仪表板"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.zh.md"
+++
特别是在科罗纳时代，随着工作的分散，所有地点都对最新的信息有很高的要求。我自己已经建立了无数的信息系统，我想介绍一个伟大的软件，叫做Smashing.Speaker: https://smashing.github.io/Das Smashing项目最初是由Shopify公司以Dashing的名字开发的，用于展示商业数字。但当然，你不能只显示商业数字。来自世界各地的开发者已经为Gitlab、Jenkins、Bamboo、Jira等开发了Smashing瓦片，即所谓的widget，见：https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch 如何使用它？
## 第1步：创建基础图像
首先，我创建了一个简单的Docker镜像，其中已经包含了Ruby和Dashing。
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
这是我在Dockerfile文件中写的第一个内容。
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
然后我用这个命令创建Docker镜像。
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
对我来说，这就是它的模样。
{{< gallery match="images/1/*.png" >}}

## 第2步：创建仪表板
现在我可以用以下命令创建一个新的仪表板。
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
之后，Dashing项目中的 "仪表板 "文件夹应该是这样的。
{{< gallery match="images/2/*.png" >}}
非常好!现在我必须再次更新Docker文件。新的内容是这样的。
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
此外，"dashboard "文件夹中的Gemfile文件也必须被调整。
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
我重复构建命令。
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
现在我可以第一次启动我的新仪表板，并在http://localhost:9292。
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
而这就是它的样子。
{{< gallery match="images/3/*.png" >}}
这是一个好的信息系统的基础。你可以定制所有的颜色、脚本和小工具。
