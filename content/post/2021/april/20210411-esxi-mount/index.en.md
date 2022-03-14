+++
date = "2021-04-11"
title = "Short Story: Connecting Synology Volumes to ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.en.md"
+++

## Step 1: Enable "NFS" service
The first thing to do is to enable the "NFS" service on the Diskstation. To do this, I go to the "Control Panel" > "File Services" setting and click on "Enable NFS".
{{< gallery match="images/1/*.png" >}}
I then click on "Shared folder" and select a directory.
{{< gallery match="images/2/*.png" >}}

## Step 2: Mount directories in ESXi
In ESXi, I click on "Storage" > "New Datastore" and enter my data there.
{{< gallery match="images/3/*.png" >}}

## Ready
Now the memory can be used.
{{< gallery match="images/4/*.png" >}}
For testing, I installed a DOS installation and an old accounting software using this mount point.
{{< gallery match="images/5/*.png" >}}
