+++
date = "2021-04-04"
title = "Breve storia: Jenkins e openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-docker-jenkins/index.it.md"
+++
Questo tutorial si basa sulla conoscenza precedente di "[Grandi cose con i container: eseguire Jenkins su Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Grandi cose con i container: eseguire Jenkins su Synology DS")". Se hai già LDAP all'inizio, devi solo creare un gruppo di applicazioni adatto:
{{< gallery match="images/1/*.png" >}}
Dopo di che, è necessario inserire le impostazioni in Jenkins. Clicco su "Manage Jenkins" > "Configure Global Security".
{{< gallery match="images/2/*.png" >}}
Importante: per i certificati autofirmati, il truststore deve essere fornito dal Java-Opts del server Jenkins. Dato che il mio server Jenkins è stato creato tramite un file Docker Compose, appare qualcosa di simile a questo per me:
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