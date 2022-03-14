+++
date = "2021-03-21"
title = "使用阿特拉斯的酷事：在没有插件的情况下使用Bamboo和jMeter"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.zh.md"
+++
今天我在Bamboo中创建一个jMeter测试。当然，你也可以用Gitlab runners或Jenkins slaves实现这个测试设置。
## 第1步：创建jMeter测试
首先，当然，你必须创建一个jMeter测试。我从以下网址下载了jMeter：https://jmeter.apache.org/，并用这个命令启动它。
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
请看:我这个教程的演示测试是为了包含有问题的和工作的采样器。我故意把超时设置得很低。
{{< gallery match="images/2/*.png" >}}
我用JMX文件来保存我的Bamboo任务。
## 第2步：准备好竹剂
由于Java是奔步代理的先决条件，我只在事后安装Python。
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
我创建了一个新的工作和一个外壳任务。
{{< gallery match="images/3/*.png" >}}
并插入这个shell脚本。
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
工具目录在机器上是固定的，不是项目库的一部分。此外，我还使用这个Python脚本。
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
我还为结果日志创建了一个人工制品模式。
{{< gallery match="images/4/*.png" >}}

## 准备好了!
现在我可以做我的工作了。在我改变超时后，测试也是 "绿色 "的。
{{< gallery match="images/5/*.png" >}}