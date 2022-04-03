+++
date = "2021-04-04"
title = "Kort fortalt: Jenkins og openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.da.md"
+++
Denne vejledning bygger på den tidligere viden om "[Store ting med containere: Kørsel af Jenkins på Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Store ting med containere: Kørsel af Jenkins på Synology DS")". Hvis du allerede har LDAP i starten, skal du kun oprette en passende programgruppe:
{{< gallery match="images/1/*.png" >}}
Herefter skal du indtaste indstillingerne i Jenkins. Jeg klikker på "Manage Jenkins" > "Configure Global Security" (Konfigurer global sikkerhed).
{{< gallery match="images/2/*.png" >}}
Vigtigt: For selv-signerede certifikater skal truststore leveres af Java-Opts på Jenkins-serveren. Da min Jenkins-server blev oprettet via en Docker Compose-fil, ser den nogenlunde sådan ud for mig:
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
