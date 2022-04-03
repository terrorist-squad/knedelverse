+++
date = "2021-07-25"
title = "容器的伟大之处：带有用户界面的Docker注册处"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.zh.md"
+++
了解如何通过你自己的注册表使你的Docker镜像在整个网络中可用。
## 安装
我在服务器上创建了一个名为 "docker-registry "的新目录。
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
然后我进入docker-registry目录（"cd docker-registry"），创建一个名为 "registry.yml "的新文件，内容如下。
```
version: '3'

services:
  registry:
    restart: always
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./data:/data
    networks:
      - registry-ui-net

  ui:
    restart: always
    image: joxit/docker-registry-ui:static
    ports:
      - 8080:80
    environment:
      - REGISTRY_TITLE=My Private Docker Registry
      - REGISTRY_URL=http://registry:5000
    depends_on:
      - registry
    networks:
      - registry-ui-net

networks:
  registry-ui-net:

```
更多有用的家庭使用的Docker镜像可以在[洛克王国（Dockerverse）]({{< ref "dockerverse" >}} "洛克王国（Dockerverse）")中找到。
## 启动命令
这个文件是通过Docker Compose启动的。之后，在预定的域/端口下可以访问该安装。
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
之后，自己的注册表可以与UI容器的目标IP和端口一起使用。
{{< gallery match="images/1/*.png" >}}
现在我可以从我的注册表中建立、推送和填充图像。
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}

