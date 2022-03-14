+++
date = "2021-05-30"
title = "Set up your own Darknet page"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-darknet-tor-site/index.en.md"
+++
Surfing the darknet as a visitor is pretty simple. But how can I host an Onion page? I show how you can set up your own darknet page.
## Step 1: How can I surf the Darknet?
I am using an Ubuntu desktop for better illustration. There I install the following packages:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Then I edit the "/etc/privoxy/config" file and enter the following ($ sudo vim /etc/privoxy/config). You can get the IP of the computer with "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
See:
{{< gallery match="images/1/*.png" >}}
In order for Tor and Privoxy to run at startup, we need to add them to the autostart:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Now the services can be started:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
I enter the proxy address into my Firefox, disable "Javascript" and visit the "Tor test page". If everything worked, I can now visit TOR/.Onion sites.
{{< gallery match="images/2/*.png" >}}

## Step 2: How can I host darknet site?
First, I install an HTTP server:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Then I change the NGINX configuration (vim /etc/nginx/nginx.conf) and turn off these features:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
See:
{{< gallery match="images/3/*.png" >}}
The NGINX server must now be restarted again:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
I also need to make a change in the Tor configuration. I comment the following lines "HiddenServiceDir" and "HiddenServicePort" in the "/etc/tor/torrc" file.
{{< gallery match="images/4/*.png" >}}
After that I also restart this DIenst:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Ready
Under "/var/lib/tor/hidden_servic/hostname" I find my Darknet/Onion address. Now all content under /var/www/html is available in the darkent.
{{< gallery match="images/5/*.png" >}}