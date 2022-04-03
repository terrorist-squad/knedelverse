+++
date = "2021-03-07"
title = "在NUC上安装ESXi。通过MacBook准备好U盘。"
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.zh.md"
+++
通过ESXi，"intel NUC "可以被划分为任何数量的计算机。在本教程中，我展示了我是如何在我的NUC上安装VMware ESXi的。小前言：我建议在安装ESXi之前进行BIOS更新。你还将需要一个32GB的U盘。我从亚马逊买了一整捆，每捆不到5欧元。
{{< gallery match="images/1/*.jpg" >}}
我的NUC-8I7BEH有2个16GB HyperX Impact内存，1个256GB三星970 EVO M2模块和一个1TB 2.5英寸WD-RED硬盘。
{{< gallery match="images/2/*.jpg" >}}

## 第1步：找到USB棒
下面的命令显示了我所有的驱动器。
{{< terminal >}}
diskutil list

{{</ terminal >}}
这里你可以看到我的U盘的标识符是 "disk2"。
{{< gallery match="images/3/*.png" >}}

## 第2步：准备好文件系统
现在我可以使用以下命令来准备文件系统。
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
之后，我在Finder中也看到了标识符。
{{< gallery match="images/4/*.png" >}}

## 第3步：弹出U盘
我使用 "unmountDisk "命令弹出该卷。
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
见。
{{< gallery match="images/5/*.png" >}}

## 第4步：使记忆棒可启动
现在我们输入命令 "sudo fdisk -e /dev/disk2"，然后输入 "f 1"、"write "和 "quit"，见。
{{< gallery match="images/6/*.png" >}}

## 第5步：复制数据
现在我必须下载ESXi-ISO：https://www.vmware.com/de/try-vmware.html。之后，我可以挂载ESXi-ISO并将内容复制到我的U盘上。
{{< gallery match="images/7/*.png" >}}
当所有东西都被复制后，我寻找文件 "ISOLINUX.CFG "并将其重命名为 "SYSLINUX.CFG"。我还在 "APPEND -c boot.cfg "一行中加入"-p 1"。
{{< gallery match="images/8/*.png" >}}
勤奋!现在这根棍子可以使用了。玩得开心!
{{< gallery match="images/9/*.png" >}}
