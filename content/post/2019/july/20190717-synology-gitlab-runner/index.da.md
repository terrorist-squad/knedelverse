+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner i Docker Container"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.da.md"
+++
Hvordan installerer jeg en Gitlab runner som en Docker-container på min Synology NAS?
## Trin 1: Søg efter Docker-aftryk
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter Gitlab. Jeg vælger Docker-image "gitlab/gitlab-runner" og vælger derefter tagget "bleeding".
{{< gallery match="images/1/*.png" >}}

## Trin 2: Sæt billedet i drift:

##  Problemer med værter
Min synology-gitlab-insterlation identificerer sig altid kun ved hjælp af værtsnavnet. Da jeg tog den originale Synology Gitlab-pakke fra pakkecenteret, kan denne adfærd ikke ændres efterfølgende.  Som en løsning kan jeg inkludere min egen hosts-fil. Her kan du se, at værtsnavnet "peter" tilhører Nas IP-adresse 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Denne fil gemmes simpelthen på Synology NAS'en.
{{< gallery match="images/2/*.png" >}}

## Trin 3: Opsætning af GitLab Runner
Jeg klikker på mit Runner-billede:
{{< gallery match="images/3/*.png" >}}
Jeg aktiverer indstillingen "Aktiver automatisk genstart":
{{< gallery match="images/4/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og vælger fanen "Volumen":
{{< gallery match="images/5/*.png" >}}
Jeg klikker på Tilføj fil og inkluderer min hosts-fil via stien "/etc/hosts". Dette trin er kun nødvendigt, hvis værtsnavnene ikke kan opløses.
{{< gallery match="images/6/*.png" >}}
Jeg accepterer indstillingerne og klikker på næste.
{{< gallery match="images/7/*.png" >}}
Nu finder jeg det initialiserede billede under Container:
{{< gallery match="images/8/*.png" >}}
Jeg vælger containeren (gitlab-gitlab-runner2 for mig) og klikker på "Details". Derefter klikker jeg på fanen "Terminal" og opretter en ny bash-session. Her indtaster jeg kommandoen "gitlab-runner register". Til registreringen har jeg brug for oplysninger, som jeg kan finde i min GitLab-installation under http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Hvis du har brug for flere pakker, kan du installere dem via "apt-get update" og derefter "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Derefter kan jeg bruge løberen i mine projekter og bruge den:
{{< gallery match="images/11/*.png" >}}