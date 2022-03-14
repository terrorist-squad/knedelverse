+++
date = "2021-06-25"
title = "Vzdálené ovládání PI pomocí Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210725-ansible/index.cs.md"
+++
Po vytvoření clusteru Kubernetes v tutoriálu [Skvělé věci s kontejnery: cluster Kubenetes a úložiště NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Skvělé věci s kontejnery: cluster Kubenetes a úložiště NFS") bych nyní chtěl mít možnost oslovit tyto počítače pomocí Ansible.
{{< gallery match="images/1/*.jpg" >}}
K tomu je zapotřebí nový klíč:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Přidání nového veřejného klíče do souboru "/home/pi/.ssh/authorised_keys" všech serverů (Server 1, Server 2 a Server 3).Tento balíček musí být nainstalován také pro Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Poté je třeba zadat maliny do souboru "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Nyní lze konfiguraci zkontrolovat následujícím způsobem:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Viz:
{{< gallery match="images/2/*.png" >}}
Nyní můžete spouštět knihy skladeb nebo příkazy, například restartovat všechny servery:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}