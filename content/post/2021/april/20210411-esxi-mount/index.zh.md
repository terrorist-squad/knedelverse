+++
date = "2021-04-11"
title = "简要说明：将Synology的卷轴连接到ESXi。"
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.zh.md"
+++

## 步骤1：激活 "NFS "服务
首先，必须在Diskstation上激活 "NFS "服务。要做到这一点，我进入 "控制面板">"文件服务 "设置，点击 "启用NFS"。
{{< gallery match="images/1/*.png" >}}
然后我点击 "共享文件夹"，选择一个目录。
{{< gallery match="images/2/*.png" >}}

## 第2步：在ESXi中装载目录
在ESXi中，我点击 "存储">"新数据存储"，在那里输入我的数据。
{{< gallery match="images/3/*.png" >}}

## 准备就绪
现在可以使用内存了。
{{< gallery match="images/4/*.png" >}}
为了测试，我通过这个挂载点安装了一个DOS安装和一个旧的会计软件。
{{< gallery match="images/5/*.png" >}}

