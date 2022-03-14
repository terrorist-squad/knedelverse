+++
date = "2021-03-21"
title = "Kul stvari z Atlassianom: uporaba Bamboo in jMeter brez vtičnikov"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.sl.md"
+++
Danes ustvarjam test jMeter v programu Bamboo. Seveda lahko to testno nastavitev izvedete tudi z Gitlab runnerji ali Jenkins slaves.
## Korak 1: Ustvarite test jMeter
Najprej morate seveda ustvariti test jMeter. JMeter sem prenesel z naslednjega url naslova https://jmeter.apache.org/ in ga zagnal s tem ukazom:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Oglejte si:Moj demo test za to vadnico naj bi vseboval okvarjene in delujoče vzorčevalnike. Namenoma sem nastavil zelo nizke časovne omejitve.
{{< gallery match="images/2/*.png" >}}
Shranjujem z datoteko JMX za svoje opravilo Bamboo.
## Korak 2: Pripravite bambusovo sredstvo
Ker je Java predpogoj za agente Bamboo, Python namestim šele pozneje.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Ustvarim novo opravilo in nalogo lupine.
{{< gallery match="images/3/*.png" >}}
In vstavite to lupinsko skripto:
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
Imenik z orodji je fiksno nameščen v računalniku in ni del skladišča projekta. Poleg tega uporabljam tudi to skripto Python:
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
Prav tako ustvarim vzorec artefaktov za dnevnike rezultatov.
{{< gallery match="images/4/*.png" >}}

## Pripravljen!
Zdaj lahko opravljam svoje delo. Ko sem spremenil časovne omejitve, je test tudi "zelen".
{{< gallery match="images/5/*.png" >}}