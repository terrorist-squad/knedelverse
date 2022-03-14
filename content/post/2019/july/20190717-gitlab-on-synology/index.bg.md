+++
date = "2019-07-17"
title = "Synology Nas: Инсталирайте Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.bg.md"
+++
Тук показвам как инсталирах Gitlab и Gitlab runner на моето Synology NAS. Първо, приложението GitLab трябва да бъде инсталирано като пакет на Synology. Потърсете "Gitlab" в "Центъра за пакети" и кликнете върху "Инсталиране".   
{{< gallery match="images/1/*.*" >}}
Услугата слуша порт "30000" за мен. Когато всичко е готово, извиквам моя Gitlab с http://SynologyHostName:30000 и виждам тази картина:
{{< gallery match="images/2/*.*" >}}
Когато вляза за първи път, от мен се иска бъдещата парола "admin". Това беше всичко! Вече мога да организирам проекти. Сега може да се инсталира Gitlab runner.  
{{< gallery match="images/3/*.*" >}}
