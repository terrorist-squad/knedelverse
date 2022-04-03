+++
date = "2019-07-17"
title = "Synology Nas: ¿Instalar Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.es.md"
+++
Aquí muestro cómo he instalado Gitlab y un corredor de Gitlab en mi NAS de Synology. En primer lugar, la aplicación GitLab debe instalarse como un paquete de Synology. Busque "Gitlab" en el "Centro de paquetes" y haga clic en "Instalar".   
{{< gallery match="images/1/*.*" >}}
El servicio escucha el puerto "30000" para mí. Cuando todo ha funcionado, llamo a mi Gitlab con http://SynologyHostName:30000 y veo esta imagen:
{{< gallery match="images/2/*.*" >}}
Cuando me conecto por primera vez, se me pide la futura contraseña "admin". ¡Eso fue todo! Ahora puedo organizar proyectos. Ahora se puede instalar un corredor de Gitlab.  
{{< gallery match="images/3/*.*" >}}

