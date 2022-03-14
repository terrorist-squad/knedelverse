+++
date = "2021-04-04"
title = "Scurtă poveste: Jenkins și openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.ro.md"
+++
Acest tutorial se bazează pe cunoștințele anterioare despre "[Lucruri grozave cu containere: Rularea Jenkins pe Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Lucruri grozave cu containere: Rularea Jenkins pe Synology DS")". Dacă aveți deja LDAP la început, trebuie doar să creați un grup de aplicații adecvat:
{{< gallery match="images/1/*.png" >}}
După aceea, trebuie să introduceți setările în Jenkins. Fac clic pe "Manage Jenkins" > "Configure Global Security".
{{< gallery match="images/2/*.png" >}}
Important: Pentru certificatele autofirmate, depozitul de încredere trebuie să fie furnizat de Java-Opts al serverului Jenkins. Deoarece serverul meu Jenkins a fost creat prin intermediul unui fișier Docker Compose, acesta arată cam așa pentru mine:
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