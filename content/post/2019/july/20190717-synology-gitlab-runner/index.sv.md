+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner i Docker Container"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.sv.md"
+++
Hur installerar jag en Gitlab runner som en Docker-container på min Synology NAS?
## Steg 1: Sök efter Docker-avbildningen
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter Gitlab. Jag väljer Docker-avbildningen "gitlab/gitlab-runner" och väljer sedan taggen "bleeding".
{{< gallery match="images/1/*.png" >}}

## Steg 2: Använd bilden:

##  Problem med värdar
Min synologi-gitlab-insterlation identifierar sig alltid endast med värdnamn. Eftersom jag tog det ursprungliga Synology Gitlab-paketet från paketcentret kan detta beteende inte ändras i efterhand.  Som en lösning kan jag inkludera min egen hosts-fil. Här kan du se att värdnamnet "peter" hör till Nas IP-adress 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Filen lagras helt enkelt på Synology NAS-enheten.
{{< gallery match="images/2/*.png" >}}

## Steg 3: Konfigurera GitLab Runner
Jag klickar på min löparbild:
{{< gallery match="images/3/*.png" >}}
Jag aktiverar inställningen "Aktivera automatisk omstart":
{{< gallery match="images/4/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och väljer fliken "Volym":
{{< gallery match="images/5/*.png" >}}
Jag klickar på Lägg till fil och inkluderar min hosts-fil via sökvägen "/etc/hosts". Det här steget är bara nödvändigt om värdnamnen inte kan lösas upp.
{{< gallery match="images/6/*.png" >}}
Jag godkänner inställningarna och klickar på nästa.
{{< gallery match="images/7/*.png" >}}
Nu hittar jag den initialiserade bilden under Container:
{{< gallery match="images/8/*.png" >}}
Jag väljer behållaren (gitlab-gitlab-runner2 för mig) och klickar på "Details". Sedan klickar jag på fliken "Terminal" och skapar en ny bash-session. Här anger jag kommandot "gitlab-runner register". För registreringen behöver jag information som jag kan hitta i min GitLab-installation under http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Om du behöver fler paket kan du installera dem via "apt-get update" och sedan "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Därefter kan jag ta med löparen i mina projekt och använda den:
{{< gallery match="images/11/*.png" >}}