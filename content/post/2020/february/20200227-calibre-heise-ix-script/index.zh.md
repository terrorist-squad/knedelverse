+++
date = "2020-02-27"
title = "容器的伟大之处：用Calibre和Docker自动标记PDF文件"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.zh.md"
+++
在PDF中添加正确的元信息往往是很乏味的。我自己将下载的PDF文件从我的Heise IX订阅账户中分类到我的私人Calibre图书馆。
{{< gallery match="images/1/*.png" >}}
因为这个过程每个月都在重复，所以我想出了以下设置。我只把我的新PDF拖入我的资料库。
{{< gallery match="images/2/*.png" >}}
我已经创建了一个容器，将我的Calibre库作为一个卷（-v ...:/books）获得。在这个容器中，我安装了以下软件包。
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
现在我的脚本搜索符合 "IX*.pdf "模式的新PDF。从每个PDF中，前5页被导出为文本。然后，所有出现在这个单词列表中的单词都被删除：https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
```
#!/bin/bash
export LANG=C.UTF-8
mkdir /tmp/worker1/

find /books/ -type f -iname '*.pdf' -newermt 20201201 -print0 | 
while IFS= read -r -d '' line; do 
        calibreID=$(echo  "$line" | sed -r 's/.*\(([0-9]+)\).*/\1/g')
        
        echo "bearbeite $clearName"
        echo "id $calibreID";

        cp "$line" /tmp/worker1/test.pdf

        echo "ocr "
        pdftotext -f 0 -l 5 /tmp/worker1/test.pdf /tmp/worker1/tmp.txt

        echo "text aufbereitung"
        cat /tmp/worker1/tmp.txt  | grep  -i -F -w -v -f  /books/blacklist.txt | sed -r s/[^a-zA-ZäöüÄÖÜ]+//g | grep -iE '[A-Za-z]{2,212}' |  sed ':begin;$!N;s/\n/,/;tbegin' > /tmp/worker1/final.txt

        calibredb set_metadata  --with-library /books/ --field cover:"cover.jpg" --field tags:"$(cat /tmp/worker1/final.txt) " --field series:"Heise IX" --field languages:"Deutsch" --field authors:"Heise Verkag" $calibreID
        
        rm /tmp/worker1/*
done


```
通过 "calibredb set_metadata "命令，我把其他一切都设置为标签。结果看起来是这样的。
{{< gallery match="images/3/*.png" >}}
