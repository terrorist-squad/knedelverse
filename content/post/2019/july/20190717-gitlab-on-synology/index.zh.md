+++
date = "2019-07-17"
title = "Synology Nas: 安装 Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.zh.md"
+++
这里我展示了我如何在我的Synology NAS上安装Gitlab和Gitlab runner。首先，GitLab应用程序必须以Synology软件包的形式安装。在 "软件包中心 "搜索 "Gitlab "并点击 "安装"。   
{{< gallery match="images/1/*.*" >}}
该服务为我监听端口 "30000"。当一切都成功后，我用 http://SynologyHostName:30000 调用我的 Gitlab，看到这个图片。
{{< gallery match="images/2/*.*" >}}
当我第一次登录时，我被要求提供未来的 "管理员 "密码。就是这样!现在我可以组织项目了。现在可以安装一个Gitlab运行器了。  
{{< gallery match="images/3/*.*" >}}
