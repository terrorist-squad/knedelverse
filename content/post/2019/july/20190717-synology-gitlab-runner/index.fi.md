+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - juoksija Docker Containerissa"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.fi.md"
+++
Miten asennan Gitlab-runnerin Docker-säiliönä Synology NAS -laitteeseeni?
## Vaihe 1: Etsi Docker-kuva
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin Gitlabia. Valitsen Docker-kuvan "gitlab/gitlab-runner" ja sitten tagin "bleeding".
{{< gallery match="images/1/*.png" >}}

## Vaihe 2: Ota kuva käyttöön:

##  Isäntien ongelma
Synology-gitlab-insterlaationi tunnistaa itsensä aina vain isäntänimellä. Koska otin alkuperäisen Synologyn Gitlab-paketin pakettikeskuksesta, tätä käyttäytymistä ei voi muuttaa jälkikäteen.  Voin kiertotienä sisällyttää oman hosts-tiedostoni. Tästä näet, että isäntänimi "peter" kuuluu Nas-IP-osoitteeseen 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Tämä tiedosto tallennetaan yksinkertaisesti Synology NAS:iin.
{{< gallery match="images/2/*.png" >}}

## Vaihe 3: GitLab Runnerin määrittäminen
Napsautan Runner-kuvaani:
{{< gallery match="images/3/*.png" >}}
Aktivoin asetuksen "Ota automaattinen uudelleenkäynnistys käyttöön":
{{< gallery match="images/4/*.png" >}}
Sitten napsautan "Lisäasetukset" ja valitsen "Äänenvoimakkuus"-välilehden:
{{< gallery match="images/5/*.png" >}}
Napsautan Add File (Lisää tiedosto) -painiketta ja lisään hosts-tiedostoni polun "/etc/hosts" kautta. Tämä vaihe on tarpeen vain, jos isäntänimiä ei voida määrittää.
{{< gallery match="images/6/*.png" >}}
Hyväksyn asetukset ja napsautan Seuraava.
{{< gallery match="images/7/*.png" >}}
Nyt löydän alustetun kuvan kohdasta Container:
{{< gallery match="images/8/*.png" >}}
Valitsen säiliön (gitlab-gitlab-runner2) ja napsautan "Tiedot". Sitten napsautan "Terminal"-välilehteä ja luon uuden bash-istunnon. Tässä kirjoitan komennon "gitlab-runner register". Rekisteröintiä varten tarvitsen tietoja, jotka löydän GitLab-asennuksestani osoitteesta http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Jos tarvitset lisää paketteja, voit asentaa ne komennolla "apt-get update" ja sitten "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Sen jälkeen voin sisällyttää juoksijan projekteihini ja käyttää sitä:
{{< gallery match="images/11/*.png" >}}
