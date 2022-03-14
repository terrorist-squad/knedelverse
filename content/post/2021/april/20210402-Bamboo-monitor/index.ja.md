+++
date = "2021-04-04"
title = "アトラシアンのクールな機能：Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.ja.md"
+++
Bamboo、Jenkins、Gitlab用のビルドモニターを作るにはどうすればいいですか？今夜までに解決します！」と言っていました。すでに同じような[Gitlab-Issue-Boardsのチュートリアル]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Gitlab-Issue-Boardsのチュートリアル")を書いています。
{{< gallery match="images/1/*.jpg" >}}
このチュートリアルの基礎となるのは、Raspberry Imagerと「Raspberry Pi OS Lite」というOSです。OSのインストールが終わると、SDカードをラズベリーに挿入できるようになります。私の場合、これはRaspberry Pi Zeroです。
{{< gallery match="images/2/*.*" >}}

## ステップ1：Matchbox/Window Managerのインストール
キオスクモードでRaspberryを操作するには、ウィンドウマネージャとブラウザが必要です。これらは以下のコマンドでインストールされます。
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## ステップ2： ダッシュボードのユーザーを作成します
次のコマンドで、"dashboard "という新しいユーザーを作成します。
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## ステップ3：xServerとWindow Managerの設定
以下のすべての手順は、"dashboard "ユーザーセッションで実行する必要があります。私は "su "でセッションに変更します。
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

## 3.1. ) ボタン/機能
ラズベリーをキオスクモードで操作できるようにしたい。そのために、Ctrl Alt Xでターミナル、Alt Cでターミナルを閉じるという2つのキーコマンドを保存しています。ターミナルでは、ifconfigで現在のIPを確認し、sudo shutdown -h now etc..... でラズベリーをシャットダウンします。
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
この場合のキーレイアウトは以下の通りです。
```

## ウィンドウ操作のショートカット
<Alt>c=close
<ctrl><alt>x=!xterm

```

## 3.2. ) X - セッション
また、「$ vim ~/.xsession」というファイルに以下の行を入力する必要があります。このスクリプトは、ダッシュボードがアクセス可能かどうかをチェックします。到達できない場合は、10秒待ちます。もちろん、アドレス/IPの調整も必要です。
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
スクリプトが実行可能であることは非常に重要です。
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

## 3.3. )インターフェイスの共同設定
以下の行では、Webインターフェースの設定を行います。ブラウザは最大化され、ステータスバーは隠されています。
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
内容をご紹介します。
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

## 3.4.)準備完了
ダッシュボード」のセッションは残すことができます。
{{< terminal >}}
exit

{{</ terminal >}}

## 3.5.) behaviour.jsとテキストのスクロール
このJavascriptは、ボードの動作を制御します。ビルドやテストが失敗すると、大きなテロップが表示されます。そうすれば、遠くからでもエラーを確認することができます。
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
内容をご紹介します。
```
var bamboobUrl = 'https://ip:port';
var bambooUser = 'nutzer';
var bambooPassword = 'password';
var ticker = jQuery('<marquee direction="left" scrollamount="5" scrolldelay="2" style="display:none;background:#962526;position:fixed;bottom:0;left:0;width:100%;line-height:100px;font-size:80px;"></marquee>');

/*--------------------------Timer--------------------------*/

var Timer = function(intervallInMsec)
{
  this.caller = new Array();
  this.intervall = window.setInterval(
    this.call.bind(this),
    intervallInMsec
  );
};

Timer.prototype.append = function(callFunction)
{
  this.caller.push(callFunction);
};

Timer.prototype.remove = function(callFunction)
{
  var index = this.caller.indexOf(callFunction);
  if (index > -1) 
  {
    this.caller.splice(index, 1);
  }
};

Timer.prototype.call = function()
{
  for(
    var callerIndex = 0, callerLenght = this.caller.length;
    callerIndex < callerLenght;
    callerIndex++
  ) {
    this.caller[ callerIndex ].call();
  }
};

var timer = new Timer(10000);
jQuery('body').append(ticker);

/* login verhalten */
timer.append(
  function()
  {
    if (jQuery('#loginForm_os_username').length > 0)
    {
      jQuery('#loginForm_os_username').val(bambooUser);
      jQuery('#loginForm_os_password').val(bambooPassword);
      jQuery('#loginForm_save').click();
    }
    else if (jQuery('.aui-dropdown2-trigger-group').length > 0)
    {
      window.location.href = window.gitlabUrl + '/telemetry.action';
    }
  }
);

/* roter ticker */
timer.append(
  function()
  {
    if (jQuery('.Failed').length > 0)
    {
      var failedJobs = new Array();

      jQuery.each(
        jQuery('.Failed'),
        function() {
          failedJobs.push( jQuery(this).children('.plan-name').text() + ' (' + jQuery(this).find('time').text() + ')');
        }
      );
      var text = 'Fehlerhafte Jobs: ' + failedJobs.join(' | ');
      if( jQuery(ticker).text() !== text) 
      {
          jQuery(ticker).html('<span>' + text + '</span>');
          jQuery(ticker).show();
      }
      
    }
    else
    {
        jQuery(ticker).hide();
    }
  }
);


```
もちろん、失敗したテストを再開するなど、必要な動作を組み込むことができます。
## 4. X-sessionにオートローグする
次は、自動ログインの設定です。このファイルはそのために用意されたものです。
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
ここでログインユーザー「dashboard」を入力し、ディスプレイマネージャーを解除します。
```
# nodm configuration
# Set NODM_ENABLED to something different than 'false' to enable nodm
NODM_ENABLED=true # <-- hier muss true hin

# User to autologin for
NODM_USER=dashboard # <-- hier muss dashboard hin

# First vt to try when looking for free VTs
NODM_FIRST_VT=7
# X session
NODM_XSESSION=/etc/X11/Xsession
# Options for the X server
NODM_X_OPTIONS='-nolisten tcp'
... usw

```
その後、システムを再起動することができます。
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## 準備完了
