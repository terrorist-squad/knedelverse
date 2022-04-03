+++
date = "2021-04-04"
title = "Кратка история: Jenkins и openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.bg.md"
+++
Този урок се основава на предишните знания за "[Страхотни неща с контейнери: стартиране на Jenkins на Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Страхотни неща с контейнери: стартиране на Jenkins на Synology DS")". Ако вече имате LDAP в началото, трябва само да създадете подходяща група за приложения:
{{< gallery match="images/1/*.png" >}}
След това трябва да въведете настройките в Jenkins. Кликвам върху "Manage Jenkins" > "Configure Global Security".
{{< gallery match="images/2/*.png" >}}
Важно: За самоподписани сертификати хранилището на доверие трябва да бъде предоставено от Java-Opts на сървъра Jenkins. Тъй като моят сървър Jenkins е създаден чрез файл Docker Compose, той изглежда по следния начин:
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
