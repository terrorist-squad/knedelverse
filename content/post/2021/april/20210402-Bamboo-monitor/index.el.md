+++
date = "2021-04-04"
title = "Δροσερά πράγματα με την Atlassian: Pimp my Bamboo Monitor"
difficulty = "level-5"
tags = ["bamboo", "build", "build-monitor", "cd", "ci", "devops", "linux", "raspberry", "raspberry-pi", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-Bamboo-monitor/index.el.md"
+++
Πώς μπορώ να δημιουργήσω μια οθόνη δημιουργίας για το Bamboo, το Jenkins ή το Gitlab; Θα το καταλάβω μέχρι το βράδυ! Έχω ήδη γράψει ένα παρόμοιο [Σεμινάριο για το Gitlab-Issue-Boards]({{< ref "post/2021/march/20210306-gitlab-dashboard" >}} "Σεμινάριο για το Gitlab-Issue-Boards").
{{< gallery match="images/1/*.jpg" >}}
Η βάση για αυτό το σεμινάριο είναι το Raspberry Imager και το λειτουργικό σύστημα "Raspberry Pi OS Lite". Μετά την εγκατάσταση του λειτουργικού συστήματος, η κάρτα SD μπορεί να εισαχθεί στο Raspberry. Στην περίπτωσή μου, πρόκειται για ένα Raspberry Pi Zero.
{{< gallery match="images/2/*.*" >}}

## Βήμα 1: Εγκαταστήστε το Matchbox/Window Manager
Για να λειτουργήσει ένα Raspberry σε λειτουργία περιπτέρου, απαιτείται ένας διαχειριστής παραθύρων και ένα πρόγραμμα περιήγησης. Αυτά εγκαθίστανται με την ακόλουθη εντολή:
{{< terminal >}}
sudo apt-get install xorg nodm matchbox-window-manager uzbl xinit unclutter vim

{{</ terminal >}}

## Βήμα 2: Δημιουργώ έναν χρήστη του ταμπλό
Με την ακόλουθη εντολή δημιουργώ έναν νέο χρήστη με όνομα "dashboard":
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}

## Βήμα 3: Διαμόρφωση του xServer και του Window Manager
Όλα τα παρακάτω βήματα πρέπει να εκτελούνται στη συνεδρία χρήστη "ταμπλό". Αλλάζω στη σύνοδο με το "su":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}

##  3.1. ) Κουμπιά/λειτουργία
Θέλω το Βατόμουρο μου να είναι λειτουργικό σε λειτουργία περιπτέρου. Για να το κάνω αυτό, αποθηκεύω δύο εντολές πλήκτρων, Ctrl Alt X για το τερματικό και Alt C για το κλείσιμο του τερματικού. Στο τερματικό μπορείτε να ζητήσετε την τρέχουσα IP με το ifconfig, να κλείσετε το βατόμουρο με το sudo shutdown -h now etc.....
{{< terminal >}}
cd ~
mkdir .matchbox
vim .matchbox/kbdconfig

{{</ terminal >}}
Η διάταξη των κλειδιών σε αυτή την περίπτωση έχει ως εξής:
```

##  Σύντομες συντομεύσεις λειτουργίας παραθύρου
<Alt>c=close
<ctrl><alt>x=!xterm

```

##  3.2. ) X - Σύνοδος
Οι ακόλουθες γραμμές πρέπει επίσης να εισαχθούν σε ένα αρχείο "$ vim ~/.xsession". Αυτή η δέσμη ενεργειών ελέγχει αν το ταμπλό είναι προσβάσιμο. Εάν δεν είναι προσβάσιμο, περιμένει 10 δευτερόλεπτα. Φυσικά, η διεύθυνση/IP πρέπει να προσαρμοστεί.
```
xset -dpms
xset s off

while ! curl -s -o /dev/null https://192.168.178.61:8085/ sleep 10
done
exec matchbox-window-manager -use_titlebar no & while true; do
   
    uzbl -u https://192.168.178.61:8085/telemetry.action -c /home/pi/uzbl.conf
done

```
Είναι πολύ σημαντικό το σενάριο να είναι εκτελέσιμο:
{{< terminal >}}
sudo chmod 755 ~/.xsession

{{</ terminal >}}

##  3.3. ) Συνδιαμόρφωση διασύνδεσης
Οι ακόλουθες γραμμές ρυθμίζουν τις παραμέτρους της διεπαφής web. Το πρόγραμμα περιήγησης είναι μεγιστοποιημένο και η γραμμή κατάστασης είναι κρυμμένη.
{{< terminal >}}
vim ~/uzbl.conf

{{</ terminal >}}
Περιεχόμενο:
```
set socket_dir=/tmp
set geometry=maximized
set show_status=0
set on_event = request ON_EVENT
set show_status=0

@on_event LOAD_FINISH script ~/dashboard/verhalten.js

```

##  3.4.) Έτοιμο
Η συνεδρία "ταμπλό" μπορεί να παραμείνει:
{{< terminal >}}
exit

{{</ terminal >}}

##  3.5.) behavior.js και κύλιση κειμένου
Αυτή η Javascript ελέγχει τη συμπεριφορά του πίνακα. Εάν η κατασκευή ή η δοκιμή αποτύχει, εμφανίζεται ένα μεγάλο χρονικό σήμα. Με αυτόν τον τρόπο μπορώ να βλέπω τα σφάλματα ακόμη και από απόσταση.
{{< gallery match="images/3/*.png" >}}

{{< terminal >}}
vim ~/verhalten.conf

{{</ terminal >}}
Περιεχόμενο:
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
Φυσικά, μπορείτε να ενσωματώσετε οποιαδήποτε συμπεριφορά θέλετε, όπως η επανεκκίνηση αποτυχημένων δοκιμών.
## 4. αυτόματη εγγραφή στην συνεδρία Χ
Το επόμενο βήμα είναι να ρυθμίσετε την αυτόματη σύνδεση. Αυτό το αρχείο είναι προσαρμοσμένο για το σκοπό αυτό:
{{< terminal >}}
sudo vim /etc/default/nodm

{{</ terminal >}}
Εδώ εισάγεται ο χρήστης σύνδεσης "ταμπλό" και απενεργοποιείται ο διαχειριστής οθόνης:
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
Το σύστημα μπορεί στη συνέχεια να επανεκκινήσει.
{{< terminal >}}
sudo reboot

{{</ terminal >}}

## Έτοιμο
