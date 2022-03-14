+++
date = "2021-03-21"
title = "Крутые штуки с Atlassian: использование Bamboo и jMeter без плагинов"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.ru.md"
+++
Сегодня я создаю тест jMeter в Bamboo. Конечно, вы также можете реализовать эту тестовую установку с помощью бегунов Gitlab или ведомых Jenkins.
## Шаг 1: Создайте тест jMeter
Сначала, конечно, нужно создать тест jMeter. Я загрузил jMeter со следующего url https://jmeter.apache.org/ и запустил его с помощью этой команды:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Смотрите:Мой демонстрационный тест для этого руководства содержит неисправные и работающие семплеры. Я специально установил очень низкие тайм-ауты.
{{< gallery match="images/2/*.png" >}}
Я сохраняю с помощью JMX-файла для своей задачи Bamboo.
## Шаг 2: Подготовьте бамбуковое средство
Поскольку Java является обязательным условием для агентов Bamboo, я устанавливаю Python только после этого.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Я создаю новое задание и задание оболочки.
{{< gallery match="images/3/*.png" >}}
И вставьте этот сценарий оболочки:
```
#!/bin/bash
java -jar /tools/apache-jmeter-5.4.1/bin/ApacheJMeter.jar -n -t test.jmx -l requests.log > result.log

echo "Ergebnis:"
cat result.log

if cat result.log | python /tools/check.py > /dev/null; 
then
    echo "Proceed... Alles Prima!"
    exit 0
else
    echo "Returned an error.... Oje!"
    exit 1
fi

```
Каталог инструментов фиксирован на машине и не является частью репозитория проекта. Кроме того, я использую этот сценарий Python:
```
#!/usr/bin/python
import re
import sys
 
for line in sys.stdin:
    print line,
    match = re.search('summary =[\s].*Err:[ ]{0,10}([1-9]\d{0,10})[ ].*',line)
    print 'Check in line if Err: > 0 -> if so Error occured -> Test fails: '
    print match
    if match :
        print "exit 1"
        sys.exit(1)
print "nothing found - exit 0"
sys.exit(0)

```
Я также создаю шаблон артефактов для журналов результатов.
{{< gallery match="images/4/*.png" >}}

## Готов!
Теперь я могу выполнять свою работу. После того, как я изменил тайм-ауты, тест также стал "зеленым".
{{< gallery match="images/5/*.png" >}}