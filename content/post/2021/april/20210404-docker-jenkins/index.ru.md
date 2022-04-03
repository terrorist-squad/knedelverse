+++
date = "2021-04-04"
title = "Краткая история: Jenkins и openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.ru.md"
+++
Этот учебник опирается на предыдущие знания о "[Большие вещи с контейнерами: Запуск Jenkins на Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Большие вещи с контейнерами: Запуск Jenkins на Synology DS")". Если у вас уже есть LDAP на начальном этапе, вам нужно только создать подходящую группу приложений:
{{< gallery match="images/1/*.png" >}}
После этого необходимо ввести настройки в Jenkins. Я нажимаю "Manage Jenkins" > "Configure Global Security".
{{< gallery match="images/2/*.png" >}}
Важно: Для самоподписанных сертификатов хранилище доверия должно быть предоставлено Java-Opts сервера Jenkins. Поскольку мой сервер Jenkins был создан с помощью файла Docker Compose, для меня он выглядит примерно так:
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
