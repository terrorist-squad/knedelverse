+++
date = "2021-05-30"
title = "Créer son propre site Darknet"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.fr.md"
+++
Surfer sur le darknet en tant que visiteur est assez simple. Mais comment héberger une page Onion ? Je vous montre comment mettre en place votre propre site darknet.
## Étape 1 : Comment surfer sur le darknet ?
J'utilise un bureau Ubuntu pour mieux illustrer mon propos. J'y installe les paquets suivants :
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Ensuite, j'édite le fichier "/etc/privoxy/config" et j'y insère ce qui suit ($ sudo vim /etc/privoxy/config). L'IP de l'ordinateur s'obtient avec "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Voir
{{< gallery match="images/1/*.png" >}}
Pour que Tor et Privoxy soient également exécutés au démarrage du système, nous devons encore les ajouter à l'Autostart :
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Les services peuvent maintenant être démarrés :
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
J'entre l'adresse du proxy dans mon Firefox, je désactive "Javascript" et je visite la "page de test Tor". Si tout s'est bien passé, je peux maintenant visiter des sites TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Étape 2 : Comment héberger un site darknet ?
Tout d'abord, j'installe un serveur HTTP :
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Ensuite, je modifie la configuration de NGINX (vim /etc/nginx/nginx.conf) et désactive ces fonctionnalités :
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Voir
{{< gallery match="images/3/*.png" >}}
Le serveur NGINX doit maintenant être redémarré une nouvelle fois :
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Une modification doit également être apportée à la configuration de Tor. Je commente les lignes suivantes "HiddenServiceDir" et "HiddenServicePort" dans le fichier "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Ensuite, je redémarre également ce service :
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Prêt
Sous "/var/lib/tor/hidden_servic/hostname", je trouve mon adresse darknet/onion. Maintenant, tous les contenus sous /var/www/html sont disponibles dans le darkent.
{{< gallery match="images/5/*.png" >}}