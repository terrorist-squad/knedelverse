+++
date = "2021-03-21"
title = "Готини неща с Atlassian: използване на Bamboo и jMeter без плъгини"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.bg.md"
+++
Днес създавам тест на jMeter в Bamboo. Разбира се, можете да приложите тази тестова настройка и с помощта на Gitlab runners или Jenkins slave.
## Стъпка 1: Създаване на jMeter тест
Първо, разбира се, трябва да създадете тест на jMeter. Изтеглих jMeter от следния адрес https://jmeter.apache.org/ и го стартирах с тази команда:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Вижте:Моят демонстрационен тест за този урок е предназначен да съдържа дефектни и работещи семплери. Нарочно зададох много ниско времетраене.
{{< gallery match="images/2/*.png" >}}
Запазвам с JMX файла за моята задача в Bamboo.
## Стъпка 2: Подготовка на бамбуковия агент
Тъй като Java е необходимо условие за агентите на Bamboo, инсталирам Python едва след това.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Създавам нова задача и задача на обвивката.
{{< gallery match="images/3/*.png" >}}
И въведете този скрипт:
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
Директорията с инструменти е фиксирана на машината и не е част от хранилището на проекта. Освен това използвам този скрипт на Python:
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
Също така създавам модел на артефакти за дневниците с резултати.
{{< gallery match="images/4/*.png" >}}

## Готови!
Сега мога да си върша работата. След като промених времетраенето, тестът също е "зелен".
{{< gallery match="images/5/*.png" >}}
