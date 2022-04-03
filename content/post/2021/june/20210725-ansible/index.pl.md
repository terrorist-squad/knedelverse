+++
date = "2021-06-25"
title = "Zdalne kontrolowanie PI za pomocą Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.pl.md"
+++
Po utworzeniu klastra Kubernetes w samouczku [Wspaniałe rzeczy z kontenerami: klaster Kubenetes i pamięć masowa NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Wspaniałe rzeczy z kontenerami: klaster Kubenetes i pamięć masowa NFS") chciałbym teraz mieć możliwość adresowania tych komputerów za pomocą Ansible.
{{< gallery match="images/1/*.jpg" >}}
W tym celu potrzebny jest nowy klucz:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Dodaje nowy klucz publiczny do pliku "/home/pi/.ssh/authorised_keys" wszystkich serwerów (Server 1, Server 2 i Server 3). Ten pakiet musi być również zainstalowany dla Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Następnie w pliku "/etc/ansible/hosts" należy wpisać adresy Malin:
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Teraz można sprawdzić konfigurację w następujący sposób:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Zobacz:
{{< gallery match="images/2/*.png" >}}
Teraz można wykonywać playbooki lub polecenia, np. restartować wszystkie serwery:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}

