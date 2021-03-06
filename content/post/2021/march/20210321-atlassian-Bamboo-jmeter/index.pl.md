+++
date = "2021-03-21"
title = "Fajne rzeczy z Atlassian: używanie Bamboo i jMeter bez wtyczek"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.pl.md"
+++
Dzisiaj tworzę test jMeter w programie Bamboo. Oczywiście można również zastosować tę konfigurację testów za pomocą programów uruchamiających Gitlab lub podrzędnych Jenkinsa.
## Krok 1: Utwórz test jMeter
Najpierw należy oczywiście utworzyć test jMeter. Pobrałem program jMeter z następującego adresu url https://jmeter.apache.org/ i uruchomiłem go za pomocą tego polecenia:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Zobacz:Mój test demonstracyjny na potrzeby tego poradnika ma zawierać wadliwe i działające samplery. Celowo ustawiłem bardzo niskie limity czasu.
{{< gallery match="images/2/*.png" >}}
Zapisuję plik JMX dla mojego zadania w programie Bamboo.
## Krok 2: Przygotowanie środka do bambusa
Ponieważ Java jest warunkiem wstępnym dla agentów Bamboo, dopiero potem instaluję Pythona.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Tworzę nowe zadanie i zadanie powłoki.
{{< gallery match="images/3/*.png" >}}
I wstaw ten skrypt powłoki:
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
Katalog narzędzi jest na stałe zapisany na komputerze i nie jest częścią repozytorium projektu. Dodatkowo używam tego skryptu Pythona:
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
Tworzę również schemat artefaktów dla dzienników wynikowych.
{{< gallery match="images/4/*.png" >}}

## Gotowe!
Teraz mogę wykonywać swoją pracę. Po zmianie limitów czasu test jest również "zielony".
{{< gallery match="images/5/*.png" >}}
