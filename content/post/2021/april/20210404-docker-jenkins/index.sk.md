+++
date = "2021-04-04"
title = "Krátky príbeh: Jenkins a openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.sk.md"
+++
Tento návod vychádza z predchádzajúcich poznatkov o "[Veľké veci s kontajnermi: Spustenie aplikácie Jenkins na zariadení Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Veľké veci s kontajnermi: Spustenie aplikácie Jenkins na zariadení Synology DS")". Ak už máte LDAP na začiatku, stačí vytvoriť vhodnú skupinu aplikácií:
{{< gallery match="images/1/*.png" >}}
Potom je potrebné zadať nastavenia v programe Jenkins. Kliknem na "Spravovať Jenkins" > "Konfigurácia globálneho zabezpečenia".
{{< gallery match="images/2/*.png" >}}
Dôležité: V prípade certifikátov podpísaných vlastným podpisom musí byť úložisko dôveryhodnosti poskytnuté Java-Opts servera Jenkins. Keďže môj server Jenkins bol vytvorený prostredníctvom súboru Docker Compose, vyzerá to asi takto:
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
