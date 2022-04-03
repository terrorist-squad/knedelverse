+++
date = "2021-04-04"
title = "小故事：Jenkins和openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.zh.md"
+++
本教程是建立在以前的 "[容器的伟大之处：在Synology DS上运行Jenkins]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "容器的伟大之处：在Synology DS上运行Jenkins") "知识基础上的。如果你一开始就已经有了LDAP，你只需要创建一个合适的应用组。
{{< gallery match="images/1/*.png" >}}
之后，你需要在Jenkins中输入设置。我点击 "管理Jenkins">"配置全球安全"。
{{< gallery match="images/2/*.png" >}}
重要提示：对于自签名的证书，信任库必须由Jenkins服务器的Java-Opts提供。由于我的Jenkins服务器是通过Docker Compose文件创建的，对我来说，它看起来像这样。
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - port:8443
      - port:50001
    container_name: jenkins
    environment:
      JENKINS_SLAVE_AGENT_PORT: 50001
      TZ: 'Europe/Berlin'
      JAVA_OPTS: '-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=pass'
      JENKINS_OPTS: "--httpsKeyStore='/store/keystore.jks' --httpsKeyStorePassword='pass' --httpPort=-1 --httpsPort=8443"
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker
      - ./keystore.jks:/store/keystore.jks
      - ./certs:/certs
    logging:
   ..... usw

   ```
