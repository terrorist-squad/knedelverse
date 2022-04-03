+++
date = "2021-03-07"
title = "NUCにESXiをインストールします。MacBook経由でUSBメモリを用意する。"
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.ja.md"
+++
ESXiを使えば、「intel NUC」を任意の台数のコンピュータに分割することができます。このチュートリアルでは、NUCにVMware ESXiをインストールする方法を紹介します。小さな前置き：ESXiをインストールする前にBIOSのアップデートをすることをお勧めします。また、32GBのUSBメモリが必要です。アマゾンで1つ5ユーロ以下でバンドルごと購入しました。
{{< gallery match="images/1/*.jpg" >}}
私のNUC-8I7BEHには、2x 16GB HyperX Impact Ram、1x 256GB Samsung 970 EVO M2モジュール、1TB 2.5-inch WD-RED hard driveが搭載されています。
{{< gallery match="images/2/*.jpg" >}}

## ステップ1: USB-Stickを探す
次のコマンドですべてのドライブを表示させることができます。
{{< terminal >}}
diskutil list

{{</ terminal >}}
ここで、私のUSBメモリには「disk2」という識別子がついていることがわかります。
{{< gallery match="images/3/*.png" >}}

## ステップ2：ファイルシステムの準備
これで、次のコマンドでファイルシステムを準備できるようになりました。
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
その後、Finderでも識別子が表示されるようになりました。
{{< gallery match="images/4/*.png" >}}

## ステップ3：USBメモリーを取り出す
unmountDisk」コマンドでボリュームをイジェクトしています。
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
ご覧ください。
{{< gallery match="images/5/*.png" >}}

## ステップ4：スティックをブータブルにする
ここで、「sudo fdisk -e /dev/disk2」というコマンドを入力し、「f 1」、「write」、「quit」を入力すると、ご覧のようになります。
{{< gallery match="images/6/*.png" >}}

## ステップ5：データをコピーする
あとは、ESXi-ISO: https://www.vmware.com/de/try-vmware.html をダウンロードする必要があります。その後、ESXi-ISOをマウントして、中身をUSBメモリにコピーすればいいんです。
{{< gallery match="images/7/*.png" >}}
すべてコピーできたら、「ISOLINUX.CFG」というファイルを探して、「SYSLINUX.CFG」にリネームしています。APPEND -c boot.cfg」の行に「-p 1」も追加しています。
{{< gallery match="images/8/*.png" >}}
失敬これでスティックが使えるようになりました。楽しんできてください。
{{< gallery match="images/9/*.png" >}}
