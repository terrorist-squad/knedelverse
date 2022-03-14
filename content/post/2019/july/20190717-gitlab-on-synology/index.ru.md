+++
date = "2019-07-17"
title = "Synology Nas: установить Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.ru.md"
+++
Здесь я показываю, как я установил Gitlab и Gitlab runner на NAS Synology. Во-первых, приложение GitLab должно быть установлено как пакет Synology. Найдите "Gitlab" в "Центре пакетов" и нажмите "Установить".   
{{< gallery match="images/1/*.*" >}}
Для меня служба слушает порт "30000". Когда все заработало, я вызываю свой Gitlab с помощью http://SynologyHostName:30000 и вижу такую картину:
{{< gallery match="images/2/*.*" >}}
Когда я вхожу в систему в первый раз, меня просят ввести будущий пароль "admin". Это было все! Теперь я могу организовывать проекты. Теперь можно установить бегунок Gitlab.  
{{< gallery match="images/3/*.*" >}}
