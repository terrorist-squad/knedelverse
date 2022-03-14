+++
date = "2021-04-04"
title = "História curta: Jenkins e openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-docker-jenkins/index.pt.md"
+++
Este tutorial se baseia no conhecimento anterior do "[Grandes coisas com recipientes: Executando Jenkins sobre a Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Grandes coisas com recipientes: Executando Jenkins sobre a Synology DS")". Se você já tem LDAP no início, você só precisa criar um grupo de aplicação adequado:
{{< gallery match="images/1/*.png" >}}
Depois disso, você precisa entrar com as configurações em Jenkins. Clico em "Gerir Jenkins" > "Configurar a Segurança Global".
{{< gallery match="images/2/*.png" >}}
Importante: Para certificados autoassinados, o truststore deve ser fornecido pelo Java-Opts do servidor Jenkins. Desde que o meu servidor Jenkins foi criado através de um ficheiro Docker Compose, parece-me algo assim:
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