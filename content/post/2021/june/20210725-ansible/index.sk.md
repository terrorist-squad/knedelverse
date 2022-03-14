+++
date = "2021-06-25"
title = "Ovládanie PI na diaľku pomocou Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210725-ansible/index.sk.md"
+++
Po vytvorení klastra Kubernetes v návode [Veľké veci s kontajnermi: Kubenetes cluster a ukladanie NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Veľké veci s kontajnermi: Kubenetes cluster a ukladanie NFS") by som teraz chcel mať možnosť adresovať tieto počítače prostredníctvom Ansible.
{{< gallery match="images/1/*.jpg" >}}
Na to je potrebný nový kľúč:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Pridanie nového verejného kľúča do súboru "/home/pi/.ssh/authorised_keys" všetkých serverov (Server 1, Server 2 a Server 3).Tento balík musí byť nainštalovaný aj pre Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Potom je potrebné zadať Maliny do súboru "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Teraz môžete konfiguráciu skontrolovať takto:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Pozri:
{{< gallery match="images/2/*.png" >}}
Teraz môžete spúšťať knihy skladieb alebo príkazy, napríklad reštartovať všetky servery:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}
