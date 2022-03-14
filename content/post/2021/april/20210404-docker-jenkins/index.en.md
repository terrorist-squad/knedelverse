+++
date = "2021-04-04"
title = "Short story: Jenkins and openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-docker-jenkins/index.en.md"
+++
This tutorial builds on the previous knowledge of "[Great things with containers: Running Jenkins on the Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Great things with containers: Running Jenkins on the Synology DS")". If you already have LDAP at the start, you only need to create a suitable application group:
{{< gallery match="images/1/*.png" >}}
After that, you need to enter the settings in Jenkins. I click on "Manage Jenkins" > "Configure Global Security".
{{< gallery match="images/2/*.png" >}}
Important: For self-signed certificates, the truststore must be provided by the Java-Opts of the Jenkins server. Since my Jenkins server was created via a Docker compose file, it looks something like this for me:
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