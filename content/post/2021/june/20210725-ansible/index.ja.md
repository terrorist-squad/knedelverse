+++
date = "2021-06-25"
title = "AnsibleによるPIのリモート制御"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.ja.md"
+++
[コンテナの優れた点：KubenetesクラスタとNFSストレージ]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "コンテナの優れた点：KubenetesクラスタとNFSストレージ")チュートリアルでKubernetesクラスタを作成した後、今度はAnsibleでこれらのコンピュータに対応できるようにしたいと思います。
{{< gallery match="images/1/*.jpg" >}}
これには新しいキーが必要です。
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
すべてのサーバー（Server 1、Server 2、Server 3）の「/home/pi/.ssh/authorised_keys」ファイルに新しい公開鍵を追加しました。また、Ansibleのためにこのパッケージをインストールする必要があります。
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
その後、「/etc/ansible/hosts」ファイルにRaspberryを入力する必要があります。
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
これで、以下のように設定を確認することができます。
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
見てください。
{{< gallery match="images/2/*.png" >}}
これで、プレイブックやコマンドを実行することができます。例えば、すべてのサーバーをリブートすることができます。
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}
