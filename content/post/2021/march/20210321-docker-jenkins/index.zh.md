+++
date = "2021-03-21"
title = "容器的伟大之处：在Synology DS上运行Jenkins"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-docker-jenkins/index.zh.md"
+++

## 第1步：准备好Synology
首先，必须在 DiskStation 上激活 SSH 登录。要做到这一点，请进入 "控制面板">"终端"。
{{< gallery match="images/1/*.png" >}}
然后你可以通过 "SSH"、指定的端口和管理员密码来登录（Windows用户使用Putty或WinSCP）。
{{< gallery match="images/2/*.png" >}}
我通过终端、winSCP或Putty登录，并将这个控制台打开以备不时之需。
## 第2步：准备好Docker文件夹
我在Docker目录下创建一个名为 "jenkins "的新目录。
{{< gallery match="images/3/*.png" >}}
然后我换到新的目录，创建一个新的文件夹 "data"。
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
我还创建了一个名为 "jenkins.yml "的文件，内容如下。端口 "8081: "的前面部分可以调整。
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
    container_name: jenkins
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker

```

## 第3步：开始
在这一步，我也可以很好地利用控制台。我通过Docker Compose启动Jenkins服务器。
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
之后，我可以用磁盘站的IP和 "步骤2 "中分配的端口调用我的Jenkins服务器。
{{< gallery match="images/4/*.png" >}}

## 第4步：设置

{{< gallery match="images/5/*.png" >}}
同样，我用控制台读出了初始密码。
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
见。
{{< gallery match="images/6/*.png" >}}
我选择了 "推荐安装"。
{{< gallery match="images/7/*.png" >}}

## 第5步：我的第一份工作
我登录并创建我的Docker作业。
{{< gallery match="images/8/*.png" >}}
正如你所看到的，一切都运作得很好!
{{< gallery match="images/9/*.png" >}}