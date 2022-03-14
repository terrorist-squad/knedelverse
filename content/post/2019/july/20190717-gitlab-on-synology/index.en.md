+++
date = "2019-07-17"
title = "Synology Nas: Install Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-gitlab-on-synology/index.en.md"
+++
Here I show how I installed Gitlab and a Gitlab runner on my Synology nas. First, you need to install the GitLab application as a Synology package. Search for "Gitlab" in the "Package Center" and click "Install".   
{{< gallery match="images/1/*.*" >}}
The service listens on port "30000" for me. If everything worked, I call my gitlab with http://SynologyHostName:30000 and see this picture:
{{< gallery match="images/2/*.*" >}}
When I log in for the first time, I am asked for the future "admin" password. That was it already! Now I can organize projects. Now a Gitlab-Runner can be installed.  
{{< gallery match="images/3/*.*" >}}
