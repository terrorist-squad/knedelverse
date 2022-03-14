+++
date = "2021-04-04"
title = "ショートストーリー：JenkinsとopenLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.ja.md"
+++
このチュートリアルでは、"[コンテナで実現すること：Synology DSでJenkinsを動かす]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "コンテナで実現すること：Synology DSでJenkinsを動かす") "の前の知識を基にしています。すでにLDAPを導入している場合は、適切なアプリケーショングループを作成するだけで済みます。
{{< gallery match="images/1/*.png" >}}
その後、Jenkinsに設定を入力する必要があります。ジェンキンスの管理」→「グローバルセキュリティの設定」をクリックします。
{{< gallery match="images/2/*.png" >}}
重要：自己署名証明書の場合、JenkinsサーバーのJava-Optsでトラストストアを提供する必要があります。私のJenkinsサーバーはDocker Composeファイルで作成されているので、私の場合は以下のようになっています。
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