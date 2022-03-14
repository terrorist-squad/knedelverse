+++
date = "2021-06-25"
title = "用Ansible远程控制PIs"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210725-ansible/index.zh.md"
+++
Error:LibreSSL SSL_read: SSL_ERROR_SYSCALL, errno 50Error:Could not resolve host: api.deepl.com在[]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "")教程中创建了一个Kubernetes集群后，我现在希望能够通过Ansible解决这些计算机。
{{< gallery match="images/1/*.jpg" >}}
Error:Could not resolve host: api.deepl.com
{{< terminal >}}
ssh-keygen -b 4096
Error:Could not resolve host: api.deepl.com
{{</ terminal >}}
Error:Could not resolve host: api.deepl.com
{{< terminal >}}
sudo apt-get install -y ansible
Error:Could not resolve host: api.deepl.com
{{</ terminal >}}
Error:Could not resolve host: api.deepl.com
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 
Error:Could not resolve host: api.deepl.com
```
Error:Could not resolve host: api.deepl.com
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'
Error:Could not resolve host: api.deepl.com
{{</ terminal >}}
Error:Could not resolve host: api.deepl.com
{{< gallery match="images/2/*.png" >}}
Error:Could not resolve host: api.deepl.com
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'
Error:Could not resolve host: api.deepl.com
{{</ terminal >}}
