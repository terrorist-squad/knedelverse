+++
date = "2021-06-25"
title = "Controlul IP-urilor de la distanță cu Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210725-ansible/index.ro.md"
+++
După ce am creat un cluster Kubernetes în tutorialul [Lucruri grozave cu containere: cluster Kubenetes și stocare NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Lucruri grozave cu containere: cluster Kubenetes și stocare NFS"), aș dori acum să pot adresa aceste computere prin Ansible.
{{< gallery match="images/1/*.jpg" >}}
Pentru aceasta este necesară o nouă cheie:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
A adăugat noua cheie publică în fișierul "/home/pi/.ssh/authorised_keys" al tuturor serverelor (Server 1, Server 2 și Server 3).De asemenea, acest pachet trebuie instalat pentru Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
După aceea, Raspberrys trebuie să fie introduse în fișierul "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Acum, configurația poate fi verificată după cum urmează:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
A se vedea:
{{< gallery match="images/2/*.png" >}}
Acum puteți executa playbook-uri sau comenzi, de exemplu, reporniți toate serverele:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}
