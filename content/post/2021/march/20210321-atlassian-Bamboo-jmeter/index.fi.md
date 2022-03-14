+++
date = "2021-03-21"
title = "Siistejä asioita Atlassianin kanssa: Bamboon ja jMeterin käyttö ilman lisäosia"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.fi.md"
+++
Tänään luon jMeter-testin Bamboon. Voit tietysti toteuttaa tämän testiasetelman myös Gitlab-juoksijoiden tai Jenkins-orjien avulla.
## Vaihe 1: Luo jMeter-testi
Ensin on tietenkin luotava jMeter-testi. Latasin jMeterin seuraavasta url-osoitteesta https://jmeter.apache.org/ ja käynnistin sen tällä komennolla:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Katso:Tämän ohjeen demotestini on tarkoitettu sisältämään viallisia ja toimivia näytteenottajia. Asetin aikakatkaisut tarkoituksella hyvin alhaisiksi.
{{< gallery match="images/2/*.png" >}}
Tallennan Bamboo-tehtäväni JMX-tiedoston kanssa.
## Vaihe 2: Valmistele bambuagentti
Koska Java on Bamboo-agenttien edellytys, asennan Pythonin vasta sen jälkeen.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Luon uuden työn ja komentotehtävän.
{{< gallery match="images/3/*.png" >}}
Ja lisää tämä komentosarjan komentosarja:
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
Työkaluhakemisto on kiinteä koneella, eikä se ole osa projektin arkistoa. Lisäksi käytän tätä Python-skriptiä:
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
Luon myös artefaktimallin tuloslokeja varten.
{{< gallery match="images/4/*.png" >}}

## Valmiina!
Nyt voin tehdä työni. Kun muutin aikakatkaisuja, testi on myös "vihreä".
{{< gallery match="images/5/*.png" >}}