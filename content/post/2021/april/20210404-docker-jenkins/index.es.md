+++
date = "2021-04-04"
title = "Historia corta: Jenkins y openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.es.md"
+++
Este tutorial se basa en los conocimientos previos de "[Grandes cosas con contenedores: ejecutar Jenkins en el Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Grandes cosas con contenedores: ejecutar Jenkins en el Synology DS")". Si ya dispone de LDAP al principio, sólo tiene que crear un grupo de aplicación adecuado:
{{< gallery match="images/1/*.png" >}}
Después de eso, es necesario introducir la configuración en Jenkins. Hago clic en "Manage Jenkins" > "Configure Global Security".
{{< gallery match="images/2/*.png" >}}
Importante: Para los certificados autofirmados, el almacén de confianza debe ser proporcionado por los Java-Opts del servidor Jenkins. Como mi servidor Jenkins fue creado a través de un archivo Docker Compose, se ve algo así para mí:
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
