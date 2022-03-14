+++
date = "2021-04-04"
title = "Kurzgeschichte: Jenkins und openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.de.md"
+++

Dieses Tutorial baut auf dem Vorwissen von "[Großartiges mit Containern: Jenkins auf der Synology-DS betreiben]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Großartiges mit Containern: Jenkins auf der Synology-DS betreiben")" auf. Wenn man bereits LDAP am Start hat, muss nur eine passende Applikations-Gruppe angelegt werden:
{{< gallery match="images/1/*.png" >}}


Danach müssen Sie die Einstellungen in Jenkins eingetragen. Ich klicke auf „Jenkins verwalten“ > „Globale Sicherheit konfigurieren“. 
{{< gallery match="images/2/*.png" >}}

Wichtig: Bei selbstsignierten Zertifikaten muss der truststore durch die Java-Opts vom Jenkins-Server mitgegeben werden. Da mein Jenkins-Server über eine Docker-Compose-Datei erzeugt wurde, sieht das bei mir ungefähr so aus:
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