+++
date = "2021-06-25"
title = "Удаленное управление PI с помощью Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.ru.md"
+++
После создания кластера Kubernetes в учебнике [Большие вещи с контейнерами: кластер Kubenetes и хранилище NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Большие вещи с контейнерами: кластер Kubenetes и хранилище NFS") я хотел бы иметь возможность обращаться к этим компьютерам через Ansible.
{{< gallery match="images/1/*.jpg" >}}
Для этого необходим новый ключ:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Добавьте новый открытый ключ в файл "/home/pi/.ssh/authorised_keys" всех серверов (сервер 1, сервер 2 и сервер 3). Также этот пакет должен быть установлен для Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
После этого необходимо внести Raspberrys в файл "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Теперь конфигурацию можно проверить следующим образом:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
См:
{{< gallery match="images/2/*.png" >}}
Теперь вы можете выполнять игровые книги или команды, например, перезагрузить все серверы:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}

