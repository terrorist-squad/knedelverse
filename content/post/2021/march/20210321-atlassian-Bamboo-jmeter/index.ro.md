+++
date = "2021-03-21"
title = "Lucruri interesante cu Atlassian: utilizarea Bamboo și jMeter fără plugin-uri"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.ro.md"
+++
Astăzi creez un test jMeter în Bamboo. Bineînțeles, puteți implementa această configurație de testare și cu Gitlab runners sau Jenkins slaves.
## Pasul 1: Creați testul jMeter
Mai întâi, desigur, trebuie să creați un test jMeter. Am descărcat jMeter de la următoarea adresă https://jmeter.apache.org/ și l-am pornit cu această comandă:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Vedeți:Testul meu demonstrativ pentru acest tutorial este menit să conțină eșantioane defecte și funcționale. Am setat intenționat timpii de așteptare foarte mici.
{{< gallery match="images/2/*.png" >}}
Salvez cu fișierul JMX pentru sarcina mea Bamboo.
## Pasul 2: Pregătiți agentul Bamboo
Deoarece Java este o condiție prealabilă pentru agenții Bamboo, eu instalez Python doar după aceea.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Creez un nou job și o sarcină de tip shell.
{{< gallery match="images/3/*.png" >}}
Și introduceți acest script shell:
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
Directorul de instrumente este fixat pe mașină și nu face parte din depozitul de proiecte. În plus, folosesc acest script Python:
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
De asemenea, creez un model de artefact pentru jurnalele de rezultate.
{{< gallery match="images/4/*.png" >}}

## Gata!
Acum îmi pot face treaba. După ce am schimbat timeout-urile, testul este, de asemenea, "verde".
{{< gallery match="images/5/*.png" >}}