+++
date = "2022-04-02"
title = "容器的伟大之处：安装Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.zh.md"
+++
通过Jitsi，你可以创建和部署一个安全的视频会议解决方案。今天我展示了如何在服务器上安装一个Jitsi服务，参考：https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ 。
## 第1步：创建 "jitsi "文件夹
我创建了一个名为 "jitsi "的新目录进行安装。
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## 第2步：配置
现在我复制了标准配置，并对其进行调整。
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
见。
{{< gallery match="images/1/*.png" >}}
为了在.env文件的安全选项中使用强密码，应该运行一次以下bash脚本。
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
现在我将为Jitsi再创建几个文件夹。
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
然后可以启动Jitsi服务器。
{{< terminal >}}
docker-compose up

{{</ terminal >}}
之后你就可以使用Jitsi服务器了。
{{< gallery match="images/2/*.png" >}}

