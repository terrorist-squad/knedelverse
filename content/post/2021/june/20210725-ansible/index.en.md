+++
date = "2021-06-25"
title = "Controlling PIs remotely with Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.en.md"
+++
After creating a Kubernetes cluster in the [Great things with containers: Kubenetes cluster and NFS storage]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Great things with containers: Kubenetes cluster and NFS storage") tutorial, I would now like to be able to address these machines via Ansible.
{{< gallery match="images/1/*.jpg" >}}
A new key is required for this:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
The new public key added to the "/home/pi/.ssh/authorized_keys" file of all servers (Server 1, Server 2 and Server 3).Also, this package must be installed for Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
After that the Raspberrys have to be entered into the "/etc/ansible/hosts" file:
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Now the configuration can be checked as follows:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
See:
{{< gallery match="images/2/*.png" >}}
Now you can run playbooks or commands, for example, reboot all servers:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}

