+++
date = "2020-02-07"
title = "用Gitlab协调uiPath Windows机器人"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-gitlab-uipath/index.zh.md"
+++
UiPath是机器人流程自动化的一个既定标准。利用uiPath，你可以开发一个基于软件的机器人/机械人，为你处理复杂的数据处理或点击任务。但这样的机器人也能用Gitlab来控制吗？简短的回答是 "可以"。而具体如何，你可以在这里看到。对于以下步骤，你需要有管理权限和一些uipath、Windows和Gitlab的经验。
## 第一步：首先要做的是安装一个Gitlab运行器。
1.1.)为你的目标操作系统创建一个新的 Gitlab 用户。请点击 "设置">"家庭和其他用户"，然后点击 "在这台电脑上添加另一个人"。
{{< gallery match="images/1/*.png" >}}
1.2.)请点击 "我不知道这个人的凭证"，然后点击 "添加没有微软账户的用户 "来创建一个本地用户。
{{< gallery match="images/2/*.png" >}}
1.3.)在下面的对话中，你可以自由选择用户名和密码。
{{< gallery match="images/3/*.png" >}}

## 第2步：激活服务登录
如果你想为你的 Windows Gitlab Runner 使用一个单独的本地用户，那么你必须 "以服务方式激活登录"。要做到这一点，请进入Windows菜单>"本地安全策略"。在那里，选择 "本地政策">"分配用户权限"，在左侧选择 "作为服务登录"。
{{< gallery match="images/4/*.png" >}}
然后添加新的用户。
{{< gallery match="images/5/*.png" >}}

## 第3步：注册Gitlab Runner
Gitlab Runner 的 Windows 安装程序可以在以下页面找到：https://docs.gitlab.com/runner/install/windows.html 。我在 "C "驱动器中创建了一个新文件夹，并将安装程序放在那里。
{{< gallery match="images/6/*.png" >}}
3.1.)我以 "管理员 "身份使用 "CMD "命令，打开一个新的控制台，并改变到一个目录 "cd C:\gitlab-runner"。
{{< gallery match="images/7/*.png" >}}
我在那里调用以下命令。如你所见，我还在这里输入了Gitlab用户的用户名和密码。
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.)现在可以注册Gitlab的运行器了。如果你的Gitlab安装使用的是自签名证书，你必须提供带有"-tls-ca-file="属性的证书。然后输入Gitlab的网址和注册表记号。
{{< gallery match="images/8/*.png" >}}
3.2.)注册成功后，可以用 "gitlab-runner-windows-386.exe start "命令启动运行器。
{{< gallery match="images/9/*.png" >}}
很好!你的Gitlab Runner已经开始运行，并且可以使用。
{{< gallery match="images/10/*.png" >}}

## 第四步：安装Git
由于Gitlab运行程序与Git版本管理一起工作，所以还必须安装Git for Windows。
{{< gallery match="images/11/*.png" >}}

## 第5步：安装UiPath
UiPath的安装是本教程中最简单的部分。以Gitlab用户身份登录并安装社区版。当然，你可以马上安装你的机器人需要的所有软件，例如：Office 365。
{{< gallery match="images/12/*.png" >}}

## 第6步：创建Gitlab项目和管道
现在是本教程的压轴大戏。我创建了一个新的Gitlab项目，并在我的uiPath项目文件中检查。
{{< gallery match="images/13/*.png" >}}
6.1.)此外，我创建了一个新文件".gitlab-ci.yml"，内容如下。
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
我的Windows软件机器人是在提交到主分支后直接执行的。
{{< gallery match="images/14/*.png" >}}
