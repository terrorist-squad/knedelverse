+++
date = "2021-06-25"
title = "PI's op afstand beheren met Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210725-ansible/index.nl.md"
+++
Na het aanmaken van een Kubernetes cluster in de [Geweldige dingen met containers: Kubenetes cluster en NFS opslag]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Geweldige dingen met containers: Kubenetes cluster en NFS opslag") tutorial, zou ik nu graag in staat zijn om deze computers aan te spreken via Ansible.
{{< gallery match="images/1/*.jpg" >}}
Hiervoor is een nieuwe sleutel nodig:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
De nieuwe publieke sleutel toegevoegd aan het "/home/pi/.ssh/authorised_keys" bestand van alle servers (Server 1, Server 2 en Server 3). Dit pakket moet ook geïnstalleerd zijn voor Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Daarna moeten de Raspberrys ingevoerd worden in het "/etc/ansible/hosts" bestand:
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Nu kan de configuratie als volgt worden gecontroleerd:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Zie:
{{< gallery match="images/2/*.png" >}}
Nu kunt u playbooks of commando's uitvoeren, bijvoorbeeld alle servers rebooten:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}
