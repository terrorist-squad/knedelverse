+++
date = "2021-04-04"
title = "Kort verhaal: Jenkins en openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.nl.md"
+++
Deze tutorial bouwt voort op de eerdere kennis van "[Geweldige dingen met containers: Jenkins draaien op de Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Geweldige dingen met containers: Jenkins draaien op de Synology DS")". Als u LDAP al hebt, hoeft u alleen maar een geschikte toepassingsgroep te maken:
{{< gallery match="images/1/*.png" >}}
Daarna moet je de instellingen in Jenkins invoeren. Ik klik op "Manage Jenkins" > "Configureer Globale Beveiliging".
{{< gallery match="images/2/*.png" >}}
Belangrijk: Voor zelf-ondertekende certificaten moet de vertrouwensopslag voorzien worden door de Java-Opts van de Jenkins server. Aangezien mijn Jenkins server is gemaakt via een Docker Compose bestand, ziet het er voor mij ongeveer zo uit:
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