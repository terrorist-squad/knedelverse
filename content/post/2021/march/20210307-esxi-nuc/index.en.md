+++
date = "2021-03-07"
title = "Install ESXi on a NUC. Prepare USB stick via MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.en.md"
+++
With ESXi the "intel NUC" can be divided into any number of computers. In this tutorial I show how I installed VMware ESXi on my NUC.Small preface: I recommend a BIOS update before the ESXi installation. Also, a 32GB USB flash drive is required. I bought a whole bundle for less than 5 euros each from Amazon.
{{< gallery match="images/1/*.jpg" >}}
My NUC-8I7BEH has 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 module and a 1TB 2.5-inch WD-RED hard drive installed.
{{< gallery match="images/2/*.jpg" >}}

## Step 1: Find USB - Stick
The following command shows me all drives:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Here you can see that my USB stick has the identifier "disk2":
{{< gallery match="images/3/*.png" >}}

## Step 2: Prepare file system
Now I can use the following command to prepare the file system:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
After that I also see the identifier in the Finder:
{{< gallery match="images/4/*.png" >}}

## Step 3: Eject USB stick
I use the "unmountDisk" command to eject the volume:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
See:
{{< gallery match="images/5/*.png" >}}

## Step 4: Make stick bootable
Now we enter the command "sudo fdisk -e /dev/disk2" and then enter "f 1", "write" and "quit", see:
{{< gallery match="images/6/*.png" >}}

## Step 5: Copy data
Now I need to download the ESXi-ISO: https://www.vmware.com/de/try-vmware.html. After that I can mount the ESXi-ISO and copy the content to my USB stick.
{{< gallery match="images/7/*.png" >}}
When everything is copied, I search the file "ISOLINUX.CFG" and rename it to "SYSLINUX.CFG". I also add "-p 1" to the line "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Now the stick is usable. Have fun!
{{< gallery match="images/9/*.png" >}}
