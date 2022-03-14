+++
date = "2021-06-25"
title = "Nadzor PI na daljavo s programom Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.sl.md"
+++
Po ustvarjanju gruče Kubernetes v učbeniku [Velike stvari z zabojniki: Kubenetesova gruča in shranjevanje NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Velike stvari z zabojniki: Kubenetesova gruča in shranjevanje NFS") bi zdaj rad te računalnike naslovil prek programa Ansible.
{{< gallery match="images/1/*.jpg" >}}
Za to je potreben nov ključ:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
V datoteko "/home/pi/.ssh/authorised_keys" vseh strežnikov (strežnik 1, strežnik 2 in strežnik 3) dodajte nov javni ključ.Ta paket mora biti nameščen tudi za Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Nato je treba v datoteko "/etc/ansible/hosts" vnesti Maline:
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Zdaj lahko konfiguracijo preverite na naslednji način:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Oglejte si:
{{< gallery match="images/2/*.png" >}}
Sedaj lahko izvajate knjige igranja ali ukaze, na primer ponovni zagon vseh strežnikov:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}
