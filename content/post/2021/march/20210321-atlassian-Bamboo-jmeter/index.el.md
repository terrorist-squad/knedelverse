+++
date = "2021-03-21"
title = "Δροσερά πράγματα με την Atlassian: χρήση του Bamboo και του jMeter χωρίς plugins"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.el.md"
+++
Σήμερα δημιουργώ μια δοκιμή jMeter στο Bamboo. Φυσικά, μπορείτε επίσης να υλοποιήσετε αυτή τη ρύθμιση δοκιμών με Gitlab runners ή Jenkins slaves.
## Βήμα 1: Δημιουργία δοκιμής jMeter
Πρώτα, φυσικά, πρέπει να δημιουργήσετε μια δοκιμή jMeter. Κατέβασα το jMeter από το ακόλουθο url https://jmeter.apache.org/ και το ξεκίνησα με την ακόλουθη εντολή:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Βλέπε:Η δοκιμή επίδειξης για αυτό το σεμινάριο προορίζεται να περιέχει ελαττωματικούς και λειτουργικούς δειγματολήπτες. Έχω ρυθμίσει τα χρονικά όρια πολύ χαμηλά επίτηδες.
{{< gallery match="images/2/*.png" >}}
Αποθηκεύω με το αρχείο JMX για την εργασία μου στο Bamboo.
## Βήμα 2: Προετοιμάστε τον παράγοντα μπαμπού
Δεδομένου ότι η Java είναι προαπαιτούμενο για τους πράκτορες του Bamboo, εγκαθιστώ την Python μόνο στη συνέχεια.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Δημιουργώ μια νέα εργασία και μια εργασία κελύφους.
{{< gallery match="images/3/*.png" >}}
Και εισάγετε αυτό το σενάριο κελύφους:
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
Ο κατάλογος εργαλείων είναι σταθερός στο μηχάνημα και δεν αποτελεί μέρος του αποθετηρίου έργου. Επιπλέον, χρησιμοποιώ αυτό το σενάριο Python:
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
Δημιουργώ επίσης ένα μοτίβο αντικειμένων για τα αρχεία καταγραφής αποτελεσμάτων.
{{< gallery match="images/4/*.png" >}}

## Έτοιμοι!
Τώρα μπορώ να κάνω τη δουλειά μου. Αφού άλλαξα τα χρονικά όρια, η δοκιμή είναι επίσης "πράσινη".
{{< gallery match="images/5/*.png" >}}