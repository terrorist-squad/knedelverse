+++
date = "2021-04-04"
title = "Krátký příběh: Jenkins a openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-docker-jenkins/index.cs.md"
+++
Tento výukový program navazuje na předchozí znalosti o "[Skvělé věci s kontejnery: Spuštění nástroje Jenkins na zařízení Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Skvělé věci s kontejnery: Spuštění nástroje Jenkins na zařízení Synology DS")". Pokud již máte LDAP na začátku, stačí vytvořit vhodnou skupinu aplikací:
{{< gallery match="images/1/*.png" >}}
Poté je třeba zadat nastavení v aplikaci Jenkins. Kliknu na "Manage Jenkins" > "Configure Global Security".
{{< gallery match="images/2/*.png" >}}
Důležité: V případě certifikátů podepsaných vlastním podpisem musí být úložiště důvěryhodnosti poskytnuto serverem Java-Opts serveru Jenkins. Protože můj server Jenkins byl vytvořen pomocí souboru Docker Compose, vypadá to asi takto:
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