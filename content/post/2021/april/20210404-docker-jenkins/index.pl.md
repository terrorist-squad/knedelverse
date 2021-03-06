+++
date = "2021-04-04"
title = "Krótka historia: Jenkins i openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.pl.md"
+++
W tym podręczniku wykorzystano wcześniejszą wiedzę o "[Wspaniałe rzeczy z kontenerami: Uruchamianie Jenkinsa na Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Wspaniałe rzeczy z kontenerami: Uruchamianie Jenkinsa na Synology DS")". Jeśli na początku działa już protokół LDAP, wystarczy utworzyć odpowiednią grupę aplikacji:
{{< gallery match="images/1/*.png" >}}
Następnie należy wprowadzić ustawienia w programie Jenkins. Klikam na "Zarządzaj Jenkinsem" > "Konfiguruj zabezpieczenia globalne".
{{< gallery match="images/2/*.png" >}}
Ważne: W przypadku certyfikatów samopodpisanych magazyn zaufania musi być udostępniony przez Java-Opts serwera Jenkinsa. Ponieważ mój serwer Jenkinsa został utworzony za pomocą pliku Docker Compose, wygląda on dla mnie mniej więcej tak:
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
