+++
date = "2021-04-04"
title = "Kratka zgodba: Jenkins in openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.sl.md"
+++
Ta vaja temelji na prejšnjem znanju o "[Velike stvari s kontejnerji: Zagon programa Jenkins na strežniku Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Velike stvari s kontejnerji: Zagon programa Jenkins na strežniku Synology DS")". Če že imate LDAP na začetku, morate ustvariti le ustrezno skupino aplikacij:
{{< gallery match="images/1/*.png" >}}
Nato morate vnesti nastavitve v program Jenkins. Kliknem na "Upravljanje Jenkins" > "Konfiguriranje globalne varnosti".
{{< gallery match="images/2/*.png" >}}
Pomembno: Za samopodpisana potrdila mora skladišče zaupanja zagotoviti Java-Opts strežnika Jenkins. Ker je bil moj strežnik Jenkins ustvarjen z datoteko Docker Compose, je videti približno takole:
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
