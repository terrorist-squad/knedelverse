+++
date = "2021-06-25"
title = "PI-k távoli vezérlése Ansible segítségével"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.hu.md"
+++
Miután létrehoztam egy Kubernetes fürtöt az [Nagyszerű dolgok konténerekkel: Kubenetes fürt és NFS tárolás]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Nagyszerű dolgok konténerekkel: Kubenetes fürt és NFS tárolás") bemutatóban, most szeretném, ha ezeket a számítógépeket az Ansible segítségével tudnám megszólítani.
{{< gallery match="images/1/*.jpg" >}}
Ehhez új kulcsra van szükség:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Hozzáadta az új nyilvános kulcsot az összes szerver (Server 1, Server 2 és Server 3) "/home/pi/.ssh/authorised_keys" fájljához.Ezt a csomagot is telepíteni kell az Ansible-hoz:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Ezután a málnákat be kell írni az "/etc/ansible/hosts" fájlba:
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Most a konfiguráció a következőképpen ellenőrizhető:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Lásd:
{{< gallery match="images/2/*.png" >}}
Most már végre lehet hajtani a playbookokat vagy parancsokat, például újraindítani az összes kiszolgálót:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}

