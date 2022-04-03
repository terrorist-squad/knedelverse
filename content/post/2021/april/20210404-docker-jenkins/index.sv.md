+++
date = "2021-04-04"
title = "Kort berättelse: Jenkins och openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.sv.md"
+++
Denna handledning bygger på tidigare kunskaper om "[Stora saker med behållare: Kör Jenkins på Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Stora saker med behållare: Kör Jenkins på Synology DS")". Om du redan har LDAP från början behöver du bara skapa en lämplig programgrupp:
{{< gallery match="images/1/*.png" >}}
Därefter måste du ange inställningarna i Jenkins. Jag klickar på "Manage Jenkins" > "Configure Global Security".
{{< gallery match="images/2/*.png" >}}
Viktigt: För självsignerade certifikat måste truststore tillhandahållas av Java-Opts på Jenkins-servern. Eftersom min Jenkins-server skapades via en Docker Compose-fil ser den ut ungefär så här för mig:
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
