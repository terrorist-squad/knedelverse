+++
date = "2022-03-21"
title = "コンテナですごいこと：KPIダッシュボード"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.ja.md"
+++
特にコロナ時代には、仕事が分散しているため、どの拠点でも最新の情報が求められています。私自身、すでに数え切れないほどの情報システムを構築してきましたが、今回はSmashing.Speakerという素晴らしいソフトウェアを紹介したいと思います。https://smashing.github.io/Das Smashingプロジェクトは、もともとShopifyという会社がビジネスの数字を提示するためにDashingという名前で開発したものです。しかし、もちろんビジネスの数字を表示するだけではダメです。世界中の開発者が、Gitlab、Jenkins、Bamboo、JiraなどのためにSmashingタイル、いわゆるウィジェットを開発しています。参照:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch どうやって作業するのでしょうか？
## ステップ1：ベース画像の作成
まず、RubyとDashingをすでに含む簡単なDockerイメージを作成します。
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
これは、Dockerfileファイルに最初に書く内容です。
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
そして、このコマンドでDockerイメージを作成します。
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
私の場合は、こんな感じです。
{{< gallery match="images/1/*.png" >}}

## ステップ2：ダッシュボードの作成
これで、次のコマンドで新しいダッシュボードを作成することができました。
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
その後、Dashingプロジェクト内の "dashboard "フォルダは以下のようになります。
{{< gallery match="images/2/*.png" >}}
非常に良いこれで、またDockerfileを更新しなければなりません。新コンテンツはこれ。
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
また、"dashboard "フォルダ内のGemfileファイルも適応させる必要があります。
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
ビルドコマンドを繰り返す。
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
これで初めて新しいダッシュボードを起動し、http://localhost:9292 にアクセスできるようになりました。
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
そして、このような姿になりました。
{{< gallery match="images/3/*.png" >}}
これが優れた情報システムの基本です。色、スクリプト、ウィジェットのすべてをカスタマイズすることができます。
