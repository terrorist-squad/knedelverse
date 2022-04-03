+++
date = "2021-04-04"
title = "ショートストーリー：JenkinsとopenLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.ja.md"
+++
このチュートリアルは、"[コンテナですごいこと：Synology DSでJenkinsを動かす]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "コンテナですごいこと：Synology DSでJenkinsを動かす") "に関するこれまでの知識をもとに構成されています。すでにLDAPを最初から持っている場合は、適切なアプリケーション・グループを作成するだけでよい。
{{< gallery match="images/1/*.png" >}}
その後、Jenkinsに設定を入力する必要があります。Jenkinsの管理」→「グローバルセキュリティの設定」をクリックしました。
{{< gallery match="images/2/*.png" >}}
重要：自己署名証明書の場合、トラストストアはJenkinsサーバーのJava-Optsで提供される必要があります。私のJenkinsサーバーはDocker Composeファイル経由で作成されているので、私の場合は以下のような感じになっています。
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
