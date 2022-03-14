+++
date = "2021-03-21"
title = "Cool things with Atlassian: using Bamboo and jMeter without plugins"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.en.md"
+++
Today I'm creating a jMeter test in Bamboo. Of course, you can also implement this test setup with Gitlab runners or Jenkins slaves.
## Step 1: Create jMeter test
The first thing to do, of course, is to create a jMeter test. I downloaded jMeter from the following url https://jmeter.apache.org/ and started it with this command:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
See:My demo test for this tutorial is meant to contain buggy and working samplers. I set the timeouts very low on purpose.
{{< gallery match="images/2/*.png" >}}
I save with the JMX file for my Bamboo task.
## Step 2: Prepare Bamboo Agent
Since Java is the prerequisite for Bamboo agents, I'm just post-installing Python.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
I create a new job and shell task.
{{< gallery match="images/3/*.png" >}}
And insert this shell script:
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
The tools directory is fixed on the machine and not part of the project repository. Additionally I use this Python script:
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
I also create an artifact pattern for the result logs.
{{< gallery match="images/4/*.png" >}}

## Ready!
Now I can run my job. After I changed the timeouts, the test is also "green".
{{< gallery match="images/5/*.png" >}}