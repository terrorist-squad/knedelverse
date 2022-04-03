+++
date = "2021-04-04"
title = "Lyhyt tarina: Jenkins ja openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.fi.md"
+++
Tämä opetusohjelma perustuu aiempaan tietämykseen "[Suuria asioita konttien avulla: Jenkinsin käyttäminen Synology DS:llä]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Suuria asioita konttien avulla: Jenkinsin käyttäminen Synology DS:llä"):sta". Jos LDAP on jo käytössäsi, sinun tarvitsee vain luoda sopiva sovellusryhmä:
{{< gallery match="images/1/*.png" >}}
Tämän jälkeen sinun on syötettävä asetukset Jenkinsiin. Napsautan "Manage Jenkins" > "Configure Global Security".
{{< gallery match="images/2/*.png" >}}
Tärkeää: Itse allekirjoitettujen varmenteiden osalta Jenkins-palvelimen Java-Optsin on tarjottava luotettavuusvarasto. Koska Jenkins-palvelimeni luotiin Docker Compose -tiedostolla, se näyttää minulle suunnilleen tältä:
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
