+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner in Docker Container"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-synology-gitlab-runner/index.it.md"
+++
Come posso installare un runner Gitlab come contenitore Docker sul mio Synology NAS?
## Passo 1: cercare l'immagine Docker
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco Gitlab. Seleziono l'immagine Docker "gitlab/gitlab-runner" e poi seleziono il tag "bleeding".
{{< gallery match="images/1/*.png" >}}

## Passo 2: Mettere l'immagine in funzione:

##  Problema degli host
La mia synology-gitlab-insterlation si identifica sempre e solo con l'hostname. Dato che ho preso il pacchetto originale Synology Gitlab dal centro pacchetti, questo comportamento non può essere cambiato in seguito.  Come workaround, posso includere il mio file hosts. Qui si può vedere che il nome host "peter" appartiene all'indirizzo IP 192.168.12.42 del Nas.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Questo file è semplicemente memorizzato sul Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Passo 3: impostare GitLab Runner
Clicco sull'immagine del mio corridore:
{{< gallery match="images/3/*.png" >}}
Attivo l'impostazione "Abilita il riavvio automatico":
{{< gallery match="images/4/*.png" >}}
Poi clicco su "Impostazioni avanzate" e seleziono la scheda "Volume":
{{< gallery match="images/5/*.png" >}}
Clicco su Add file e includo il mio file hosts attraverso il percorso "/etc/hosts". Questo passo è necessario solo se gli hostname non possono essere risolti.
{{< gallery match="images/6/*.png" >}}
Accetto le impostazioni e clicco su next.
{{< gallery match="images/7/*.png" >}}
Ora trovo l'immagine inizializzata sotto Container:
{{< gallery match="images/8/*.png" >}}
Seleziono il contenitore (gitlab-gitlab-runner2 per me) e clicco su "Dettagli". Poi clicco sulla scheda "Terminale" e creo una nuova sessione bash. Qui inserisco il comando "gitlab-runner register". Per la registrazione, ho bisogno di informazioni che posso trovare nella mia installazione di GitLab sotto http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Se avete bisogno di altri pacchetti, potete installarli tramite "apt-get update" e poi "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Dopo di che posso includere la guida nei miei progetti e usarla:
{{< gallery match="images/11/*.png" >}}