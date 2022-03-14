+++
date = "2020-02-14"
title = "Generate PDF page overview"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.en.md"
+++
If you want to create a page overview image from a PDF file, then you've come to the right place!
{{< gallery match="images/1/*.jpg" >}}

## Step 1: Create working folder
Use this command to create a temporary working folder:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Step 2: Separate page
The following command creates an image of each PDF page:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Step 3: Mounting the pictures
Now the collage just needs to be put together:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
