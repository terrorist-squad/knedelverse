+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner in Docker container"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.en.md"
+++
How do I install a Gitlab runner as a Docker container on my Synology NAS?
## Step 1: Find Docker image
I click on the "Registration" tab in the Synology Docker window and search for Gitlab. I select the Docker image "gitlab/gitlab-runner" and then select the tag "bleeding".
{{< gallery match="images/1/*.png" >}}

## Step 2: Put image/image into operation:

##  Hosts problem
My synology-gitlab-insterlation always identifies itself by hostname only. Since I took the original synology-gitlab-package from the package-center, this behavior cannot be changed afterwards.  As a workaround I can include a custom hosts file. Here you can see that the hostname "peter" belongs to the Nas IP address 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
This file is simply placed on the Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Step 3: Set up GitLab Runner
I click on my Runner image:
{{< gallery match="images/3/*.png" >}}
I enable the "Enable automatic restart" setting:
{{< gallery match="images/4/*.png" >}}
After that I click on "Advanced Settings" and select the "Volume" tab:
{{< gallery match="images/5/*.png" >}}
I click Add File and include my hosts file via the path "/etc/hosts". This step is only necessary if the hostnames cannot be resolved.
{{< gallery match="images/6/*.png" >}}
I accept the settings and click next
{{< gallery match="images/7/*.png" >}}
Now I find the initialized image under Container:
{{< gallery match="images/8/*.png" >}}
I select the container (gitlab-gitlab-runner2 for me) and click on "Details". Then I click on the "Terminal" tab and create a new bash session. Here I enter the command "gitlab-runner register". For registering I need information that I find in my GitLab installation at http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
If you still need more packages, then you can install them via "apt-get update" followed by "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
After that I can include the runner in my projects and use it:
{{< gallery match="images/11/*.png" >}}
