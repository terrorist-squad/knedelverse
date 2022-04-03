+++
date = "2021-06-19"
title = "容器的伟大之处: Remark42是我的评论解决方案"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210619-docker-remark42/index.zh.md"
+++
如果你把你的博客作为一个静态网站运行，你可能想要一个提供动态评论功能的微服务/垂直。例如，这个博客是在HUGO中实现的，这是一个用GO编写的用于Markdown内容的 "网站生成器"。在我的案例中，我为自己改编了这个Docker Compose文件，并用 "docker-compose -f compose.yml up -d "启动它。我已经存储了API密钥，用于与谷歌和Facebook的认证。我还输入了邮件服务器设置，以便与读者互动。
```
version: '2'

services:
    remark:

        image: umputun/remark42:latest
        container_name: "remark42"
        restart: always

        logging:
          driver: json-file
          options:
              max-size: "10m"
              max-file: "5"

        ports:
          - "8050:8080"   

        environment:
            - REMARK_URL=https://www.christian-knedel.de/comments/ 
            - "SECRET=secret"          
            - SITE=www.adresse.de 
            - STORE_BOLT_PATH=/srv/var/db
            - BACKUP_PATH=/srv/var/backup

        volumes:
            - ./data:/srv/var

```
配置完成后，该服务就可以使用了，并可以整合到网站中。
```
<script>
  var remark_config = {
    host: "https://www.christian-knedel.de/comments", 
    site_id: 'www.christian-knedel.de',
    components: ['embed'], 
    max_shown_comments: 10,
    theme: 'dark',
    locale: 'de',
    show_email_subscription: false
  };
</script>
<script>
  (function(c) {
    for(var i = 0; i < c.length; i++){
      var d = document, s = d.createElement('script');
      s.src = remark_config.host + '/web/' +c[i] +'.js';
      s.defer = true;
      (d.head || d.body).appendChild(s);
    }
  })(remark_config.components || ['embed']);
</script>

<br>
<hr>
<br>
<div id="remark42"></div>

```
而这就是Remark42的样子。
{{< gallery match="images/1/*.png" >}}

