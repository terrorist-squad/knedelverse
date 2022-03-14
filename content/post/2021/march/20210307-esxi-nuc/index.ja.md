+++
date = "2021-03-07"
title = "NUCにESXiをインストールする。MacBookでUSBメモリを用意する。"
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.ja.md"
+++
ESXiを使えば、「intel NUC」を何台ものコンピューターに分割することができます。このチュートリアルでは、私のNUCにVMware ESXiをインストールした方法を紹介します。ちょっとした前置きですが、ESXiのインストールの前にBIOSのアップデートを行うことをお勧めします。また、32GBのUSBメモリも必要です。私はAmazonで1つ5ユーロ以下でまとめて買いました。
{{< gallery match="images/1/*.jpg" >}}
私のNUC-8I7BEHには、2x 16GB HyperX Impact Ram、1x 256GB Samsung 970 EVO M2モジュール、1TB 2.5-inch WD-REDハードドライブが搭載されています。
{{< gallery match="images/2/*.jpg" >}}

## Step 1: USBスティックの検索
次のコマンドは、すべてのドライブを表示します。
{{< terminal >}}
diskutil list

{{</ terminal >}}
ここでは、私のUSBメモリの識別子が「disk2」であることがわかります。
{{< gallery match="images/3/*.png" >}}

## ステップ2：ファイルシステムの準備
これで、次のコマンドを使って、ファイルシステムを準備することができました。
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
その後、Finderでも識別子が表示されるようになりました。
{{< gallery match="images/4/*.png" >}}

## ステップ3：USBメモリの取り出し
unmountDisk "コマンドを使ってボリュームを取り出します。
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
見てください。
{{< gallery match="images/5/*.png" >}}

## Step 4: スティックをブータブルにする
ここで、「sudo fdisk -e /dev/disk2」というコマンドを入力し、「f 1」、「write」、「quit」と入力すると、ご覧のようになります。
{{< gallery match="images/6/*.png" >}}

## Step 5: データのコピー
あとは、ESXi-ISO: https://www.vmware.com/de/try-vmware.html をダウンロードするだけです。その後、ESXi-ISOをマウントして、中身をUSBメモリにコピーします。
{{< gallery match="images/7/*.png" >}}
すべてがコピーされたら、「ISOLINUX.CFG」というファイルを探して、「SYSLINUX.CFG」にリネームします。また、「APPEND -c boot.cfg」の行に「-p 1」を追加しています。
{{< gallery match="images/8/*.png" >}}
お疲れ様でした。これで、スティックが使えるようになりました。楽しんでください。
{{< gallery match="images/9/*.png" >}}