+++
date = "2021-05-30"
title = "建立你自己的黑暗网络页面"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-darknet-tor-site/index.zh.md"
+++
作为访问者在黑暗网络上冲浪是非常简单的。但是，我怎么能主持一个洋葱头页面呢？我将告诉你如何建立你自己的暗网网页。
## 第1步：我怎样才能在暗网冲浪？
为了更好地说明问题，我使用Ubuntu桌面。我在那里安装了以下软件包。
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
然后我编辑"/etc/privoxy/config "文件并输入以下内容（$ sudo vim /etc/privoxy/config）。你可以用 "ifconfig "查出电脑的IP。
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
见。
{{< gallery match="images/1/*.png" >}}
为了确保Tor和Privoxy在系统启动时也被执行，我们仍然要在自动启动中输入它们。
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
现在可以启动服务了。
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
我在我的Firefox中输入代理地址，停用 "Javascript "并访问 "Tor测试页面"。如果一切都成功了，我现在可以访问TOR/.Onion网站。
{{< gallery match="images/2/*.png" >}}

## 第二步：如何托管暗网网站？
首先，我安装一个HTTP服务器。
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
然后我改变了NGINX的配置（vim /etc/nginx/nginx.conf），关闭了这些功能。
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
见。
{{< gallery match="images/3/*.png" >}}
现在必须再次重启NGINX服务器。
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
在Tor的配置中也必须做出改变。我在"/etc/tor/torrc "文件中注释了以下几行 "HiddenServiceDir "和 "HiddenServicePort"。
{{< gallery match="images/4/*.png" >}}
之后，我也重新启动这个服务。
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## 准备就绪
在"/var/lib/tor/hidden_servic/hostname "下，我找到了我的Darknet/Onion地址。现在，/var/www/html下的所有内容都可以在Darkent中使用。
{{< gallery match="images/5/*.png" >}}