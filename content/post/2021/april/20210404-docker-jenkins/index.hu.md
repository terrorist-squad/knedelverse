+++
date = "2021-04-04"
title = "Rövid történet: Jenkins és openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-docker-jenkins/index.hu.md"
+++
Ez a bemutató az "[Nagyszerű dolgok konténerekkel: Jenkins futtatása a Synology DS-en]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Nagyszerű dolgok konténerekkel: Jenkins futtatása a Synology DS-en")" korábbi ismereteire épül. Ha az LDAP már az induláskor rendelkezésre áll, akkor csak egy megfelelő alkalmazáscsoportot kell létrehoznia:
{{< gallery match="images/1/*.png" >}}
Ezt követően a beállításokat a Jenkinsben kell megadni. A "Jenkins kezelése" > "Globális biztonság konfigurálása" gombra kattintok.
{{< gallery match="images/2/*.png" >}}
Fontos: A saját aláírású tanúsítványok esetében a bizalmi tárolót a Jenkins-kiszolgáló Java-Opts-jának kell biztosítania. Mivel az én Jenkins szerveremet egy Docker Compose fájlon keresztül hoztam létre, nekem valahogy így néz ki:
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