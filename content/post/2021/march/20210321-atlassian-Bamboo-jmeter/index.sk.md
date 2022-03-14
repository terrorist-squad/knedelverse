+++
date = "2021-03-21"
title = "Parádne veci s Atlassianom: používanie Bamboo a jMeter bez zásuvných modulov"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.sk.md"
+++
Dnes vytváram test jMeter v aplikácii Bamboo. Samozrejme, toto testovacie nastavenie môžete implementovať aj pomocou Gitlab runnerov alebo Jenkins slave.
## Krok 1: Vytvorenie testu jMeter
Najprv musíte samozrejme vytvoriť test jMeter. Stiahol som si jMeter z nasledujúcej url adresy https://jmeter.apache.org/ a spustil ho týmto príkazom:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Pozri:Môj demonštračný test pre tento návod má obsahovať chybné a funkčné vzorkovače. Časové limity som nastavil zámerne veľmi nízko.
{{< gallery match="images/2/*.png" >}}
Uložím súbor JMX pre svoju úlohu Bamboo.
## Krok 2: Príprava bambusového prostriedku
Keďže Java je nevyhnutnou podmienkou pre agentov Bamboo, Python inštalujem až potom.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Vytvorím novú úlohu a úlohu shell.
{{< gallery match="images/3/*.png" >}}
A vložte tento shell skript:
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
Adresár nástroja je pevne umiestnený v počítači a nie je súčasťou úložiska projektu. Okrem toho používam tento skript Python:
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
Vytvorím tiež vzor artefaktu pre protokoly výsledkov.
{{< gallery match="images/4/*.png" >}}

## Pripravený!
Teraz môžem robiť svoju prácu. Po zmene časových limitov je test tiež "zelený".
{{< gallery match="images/5/*.png" >}}