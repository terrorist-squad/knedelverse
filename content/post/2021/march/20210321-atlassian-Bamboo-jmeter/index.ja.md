+++
date = "2021-03-21"
title = "アトラシアンのすごいところ: BambooとjMeterをプラグインなしで使う"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.ja.md"
+++
今日はBambooでjMeterのテストを作ります。もちろん、GitlabのランナーやJenkinsのスレーブを使って、このテストセットアップを実装することもできます。
## ステップ1：jMeterテストの作成
まず、当然ながら、jMeterのテストを作成しなければなりません。以下のURL https://jmeter.apache.org/ からjMeterをダウンロードし、以下のコマンドで起動しました。
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
参照：「このチュートリアルのための私のデモテストには、不具合のあるサンプラーと動作するサンプラーが含まれています。わざとタイムアウトを低く設定しています。
{{< gallery match="images/2/*.png" >}}
私はBambooタスクのJMXファイルで保存しています。
## ステップ2：Bamboo Agentの準備
BambooのエージェントはJavaが前提条件なので、Pythonはその後にインストールするだけです。
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
新しいジョブとシェルタスクを作成します。
{{< gallery match="images/3/*.png" >}}
そして、このシェルスクリプトを挿入する。
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
ツールのディレクトリはマシン上に固定されており、プロジェクトのリポジトリには含まれていません。さらに、このPythonスクリプトを使っています。
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
また、結果ログのアーティファクトパターンを作成しています。
{{< gallery match="images/4/*.png" >}}

## Ready!
これで自分の仕事ができるようになりました。タイムアウトを変更したら、テストも「緑」になりました。
{{< gallery match="images/5/*.png" >}}