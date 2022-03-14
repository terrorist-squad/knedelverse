+++
date = "2021-04-04"
title = "Brève histoire : Jenkins et openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-docker-jenkins/index.fr.md"
+++
Ce tutoriel se base sur les connaissances préalables de "[De grandes choses avec les conteneurs : faire fonctionner Jenkins sur le DS de Synology]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "De grandes choses avec les conteneurs : faire fonctionner Jenkins sur le DS de Synology")". Si l'on dispose déjà de LDAP au départ, il suffit de créer un groupe d'applications approprié :
{{< gallery match="images/1/*.png" >}}
Ensuite, vous devez entrer les paramètres dans Jenkins. Je clique sur "Gérer Jenkins" > "Configurer la sécurité globale".
{{< gallery match="images/2/*.png" >}}
Important : pour les certificats auto-signés, le truststore doit être fourni par les Java-Opts du serveur Jenkins. Comme mon serveur Jenkins a été créé via un fichier composite Docker, cela ressemble à peu près à cela chez moi :
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