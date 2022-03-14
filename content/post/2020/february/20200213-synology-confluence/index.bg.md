+++
date = "2020-02-13"
title = "Synology-Nas: Confluence като уики система"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-confluence/index.bg.md"
+++
Ако искате да инсталирате Atlassian Confluence на Synology NAS, значи сте попаднали на правилното място.
## Стъпка 1
Първо отварям приложението Docker в интерфейса на Synology и след това отивам на подпозицията "Регистрация". Там търся "Confluence" и щраквам върху първото изображение "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Стъпка 2
След изтеглянето на изображението то е достъпно като изображение. Docker прави разлика между 2 състояния - контейнер "динамично състояние" и образ/имдж (фиксирано състояние). Преди да можем да създадем контейнер от изображението, трябва да се направят няколко настройки.
## Автоматично рестартиране
Кликвам два пъти върху моето изображение на Confluence.
{{< gallery match="images/2/*.png" >}}
След това щракнах върху "Разширени настройки" и активирах "Автоматично рестартиране".
{{< gallery match="images/3/*.png" >}}

## Портове
Присвоявам фиксирани портове за контейнера Confluence. Без фиксирани портове Confluence може да се стартира на друг порт след рестартиране.
{{< gallery match="images/4/*.png" >}}

## Памет
Създавам физическа папка и я монтирам в контейнера (/var/atlassian/application-data/confluence/). Тази настройка улеснява архивирането и възстановяването на данни.
{{< gallery match="images/5/*.png" >}}
След тези настройки Confluence може да бъде стартирана!
{{< gallery match="images/6/*.png" >}}