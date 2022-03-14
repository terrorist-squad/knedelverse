+++
date = "2021-06-25"
title = "PI:iden hallinta etänä Ansiblen avulla"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.fi.md"
+++
Kun olen luonut Kubernetes-klusterin [Hienoja asioita konttien kanssa: Kubenetes-klusteri ja NFS-tallennustila]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Hienoja asioita konttien kanssa: Kubenetes-klusteri ja NFS-tallennustila")-oppaassa, haluaisin nyt pystyä käsittelemään näitä tietokoneita Ansiblen kautta.
{{< gallery match="images/1/*.jpg" >}}
Tätä varten tarvitaan uusi avain:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Lisäsit uuden julkisen avaimen kaikkien palvelimien (Palvelin 1, Palvelin 2 ja Palvelin 3) tiedostoon "/home/pi/.ssh/authorised_keys".Tämä paketti on asennettava myös Ansiblea varten:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Tämän jälkeen Raspberrys on lisättävä tiedostoon "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Nyt kokoonpano voidaan tarkistaa seuraavasti:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Katso:
{{< gallery match="images/2/*.png" >}}
Nyt voit suorittaa pelikirjoja tai komentoja, esimerkiksi käynnistää kaikki palvelimet uudelleen:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}
