+++
date = "2021-04-0q"
title = "Atlassian でできること: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-Bamboo-monitor/index.ja.md"
+++
Bamboo、Jenkins、Gitlab 用のビルドモニターを作成するにはどうしたらいいですか？今夜までに何とかします!すでに似たような[Gitlab-Issue-Boardsのためのチュートリアル]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Gitlab-Issue-Boardsのためのチュートリアル")を書きました。
{{< gallery match="images/1/*.jpg" >}}
このチュートリアルのベースとなるのは、ラズベリーイメージャーと「Raspberry Pi OS Lite」オペレーティングシステムです。OSのインストールが完了すると、SDカードをラズパイに挿入できるようになります。私の場合、これはRaspberry Pi Zeroです。
{{< gallery match="images/2/*.*" >}}

## ステップ1：Matchbox/Window Managerのインストール
キオスクモードでラズベリーを操作するには、ウィンドウマネージャとブラウザが必要です。これらは、以下のコマンドでインストールします。
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## ステップ2：ダッシュボードユーザーを作成する
以下のコマンドで、"dashboard "というユーザーを新規に作成します。
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## ステップ3：xServerとWindow Managerの設定
以下の手順は、すべて「dashboard」ユーザーセッションで行う必要があります。suでセッションに変更する。
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

## 3.1. ) ボタン／機能
Raspberryをキオスクモードで操作できるようにしたい。そのために、端末のCtrl Alt Xと端末を閉じるAlt Cという2つのキーコマンドを記憶させています。ターミナルでは、ifconfigで現在のIPを問い合わせたり、sudo shutdown -h nowでRaspberryをシャットダウンしたり......といったことができます。
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
この場合のキーレイアウトは以下の通りです。
```

## 窓の操作のショートカット
<Alt>c=close
<ctrl><alt>x=!xterm

```

## 3.2. ) X - セッション
また、「$ vim ~/.xsession」ファイルには、以下の行を入力する必要があります。このスクリプトは、ダッシュボードにアクセス可能かどうかをチェックします。到達できない場合は、10秒待つ。もちろん、アドレス/IPの調整も必要です。
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
スクリプトが実行可能であることが非常に重要です。
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

## 3.3. )インターフェース協調設定
以下の行は、ウェブインターフェースの設定です。ブラウザが最大化され、ステータスバーが非表示になります。
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
内容です。
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

## 3.4.)レディ
ダッシュボード」セッションを残すことができます。
{{< terminal >}}
exit

{{</ terminal >}}

## 3.5.) behaviour.jsとスクロールするテキスト
このJavascriptはボードの挙動を制御します。ビルドやテストに失敗した場合は、大きなテロップが表示されます。こうすることで、遠くからでもエラーを確認することができるのです。
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
内容です。
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
## 4. Xセッションへのオートロギング
次に、自動ログインの設定です。このファイルは、この目的に適合しています。
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
ここでログインユーザー "dashboard "を入力し、ディスプレイマネージャーを解除する。
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

## レディ
各ダスボードは、1日1回再起動する必要があります。そのためのcronを作りました。
