+++
date = "2021-03-21"
title = "Great things with containers: Running Jenkins on the Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.en.md"
+++

## Step 1: Prepare Synology
First of all, you need to enable SSH login on Diskstation. To do this, go to the "Control Panel" > "Terminal
{{< gallery match="images/1/*.png" >}}
After that you can log in via "SSH", the given port and the administrator password (Windows users take Putty or WinSCP).
{{< gallery match="images/2/*.png" >}}
I log in via Terminal, winSCP or Putty and leave this console open for later.
## Step 2: Prepare Docker folder
I create a new directory called "jenkins" in the Docker directory.
{{< gallery match="images/3/*.png" >}}
Then I change to the new directory and create a new folder "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
I also create a file called "jenkins.yml" with the following content. For the port, the front part "8081:" can be adjusted.
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
    container_name: jenkins
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker

```

## Step 3: Start
I can also make good use of the console in this step. I start the Jenkins server via Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
After that I can call my Jenkins server with the IP of the diskstation and the assigned port from "step 2".
{{< gallery match="images/4/*.png" >}}

## Step 4: Setup

{{< gallery match="images/5/*.png" >}}
Again, I use the console to read the initial password:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
See:
{{< gallery match="images/6/*.png" >}}
I have selected the "Recommended Installation".
{{< gallery match="images/7/*.png" >}}

## Step 5: My first job
I log in and create my Docker job.
{{< gallery match="images/8/*.png" >}}
As you can see, everything works great!
{{< gallery match="images/9/*.png" >}}