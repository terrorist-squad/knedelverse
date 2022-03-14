+++
date = "2021-05-30"
title = "Crea la tua pagina Darknet"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.it.md"
+++
Navigare in Darknet come visitatore è abbastanza semplice. Ma come posso ospitare una pagina di Onion? Vi mostrerò come impostare la vostra pagina Darknet.
## Passo 1: Come posso navigare in Darknet?
Uso un desktop Ubuntu per illustrare meglio. Lì installo i seguenti pacchetti:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Poi modifico il file "/etc/privoxy/config" e inserisco quanto segue ($ sudo vim /etc/privoxy/config). Puoi scoprire l'IP del computer con "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Vedere:
{{< gallery match="images/1/*.png" >}}
Per assicurarsi che Tor e Privoxy siano eseguiti anche all'avvio del sistema, dobbiamo ancora inserirli nell'autostart:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Ora i servizi possono essere avviati:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Inserisco l'indirizzo del proxy nel mio Firefox, disattivo "Javascript" e visito la "Tor test page". Se tutto ha funzionato, ora posso visitare i siti TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Passo 2: Come posso ospitare un sito Darknet?
Per prima cosa, installo un server HTTP:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Poi cambio la configurazione di NGINX (vim /etc/nginx/nginx.conf) e spengo queste funzioni:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Vedere:
{{< gallery match="images/3/*.png" >}}
Il server NGINX deve ora essere riavviato di nuovo:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Un cambiamento deve essere fatto anche nella configurazione di Tor. Commento le seguenti linee "HiddenServiceDir" e "HiddenServicePort" nel file "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Dopo di che, riavvio anche questo servizio:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Pronto
Sotto "/var/lib/tor/hidden_servic/hostname" trovo il mio indirizzo Darknet/Onion. Ora tutti i contenuti sotto /var/www/html sono disponibili nel Darkent.
{{< gallery match="images/5/*.png" >}}