+++
date = "2021-03-06"
title = "Πίνακας ελέγχου ζητημάτων με RaspberryPiZeroW, Javascript και GitLab"
difficulty = "level-3"
tags = ["git", "gitlab", "issueboard", "issues", "javascript", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210306-gitlab-dashboard/index.el.md"
+++
Η εγκατάσταση με το Raspberry Noobs είναι παιχνιδάκι! Το μόνο που χρειάζεστε είναι ένα RaspberryZeroW και μια κενή κάρτα SD.
## Βήμα 1: Εγκατάσταση Noobs
Κατεβάστε τον εγκαταστάτη Noobs από το https://www.raspberrypi.org/downloads/noobs/.
## Βήμα 2: Κάρτα SD
Αποσυσκευάστε αυτό το αρχείο zip στην άδεια κάρτα SD.
{{< gallery match="images/1/*.png" >}}
Έγινε! Τώρα μπορείτε να συνδέσετε το RaspberryPiZero στην τηλεόραση. Στη συνέχεια θα εμφανιστεί το μενού εγκατάστασης.
{{< gallery match="images/2/*.jpg" >}}
Εάν έχετε το NoobsLite στην κάρτα, πρέπει πρώτα να δημιουργήσετε μια σύνδεση WLAN. Στη συνέχεια επιλέξτε το "Rasbian Lite" και κάντε κλικ στο "Install". Το Rasbian Lite είναι η έκδοση διακομιστή χωρίς επιφάνεια εργασίας. Μετά την εκκίνηση, η διαχείριση πακέτων πρέπει να ενημερωθεί.
{{< terminal >}}
sudo apt-get update

{{</ terminal >}}
Στη συνέχεια, πρέπει να εγκατασταθούν τα ακόλουθα πακέτα:
{{< terminal >}}
sudo apt-get install -y nodm matchbox-window-manager uzbl xinit vim

{{</ terminal >}}
Πρέπει επίσης να δημιουργηθεί ένας χρήστης για την εμφάνιση του πίνακα οργάνων.
{{< terminal >}}
sudo adduser dashboard

{{</ terminal >}}
Συνδεθείτε ως χρήστης "Dashboard":
{{< terminal >}}
sudo su dashboard

{{</ terminal >}}
Δημιουργήστε μια X-Session -Script. Μπορώ να μεταβώ σε αυτή τη γραμμή με τα πλήκτρα δρομέα και να μεταβώ σε λειτουργία εισαγωγής με το πλήκτρο "i".
{{< terminal >}}
sudo vim ~/.xsession

{{</ terminal >}}
Περιεχόμενο
```
#!/bin/bash 
xset s off 
xset s noblank 
xset -dpms 
while true; do 
  uzbl -u http://git-lab-ip/host/ -c /home/dashboard/uzbl.conf & exec matchbox-window-manager -use_titlebar no
done

```
Στη συνέχεια, πατήστε το πλήκτρο "Esc" για να αλλάξετε τη λειτουργία εντολών και στη συνέχεια ":wq" για "write" και "quit". Επιπλέον, αυτό το σενάριο απαιτεί τα ακόλουθα δικαιώματα:
{{< terminal >}}
chmod 755 ~/.xsession

{{</ terminal >}}
Σε αυτό το σενάριο βλέπετε μια ρύθμιση παραμέτρων του προγράμματος περιήγησης (/home/dashboard/uzbl.conf). Αυτή η διαμόρφωση έχει ως εξής:
```
set config_home = /home/dashboard 
set socket_dir=/tmp 
set geometry=maximized 
set show_status=0 
set on_event = request ON_EVENT 
@on_event LOAD_FINISH script @config_home/gitlab.js

```
Ημίχρονο! Σχεδόν τελειώσατε. Τώρα χρειάζεστε μια Javascript με την οποία μπορείτε να προσομοιώσετε τη συμπεριφορά του χρήστη. Είναι σημαντικό να δημιουργήσετε έναν ξεχωριστό χρήστη του Gitlab. Αυτός ο χρήστης μπορεί να διαχειριστεί ως "δημοσιογράφος" σε έργα.
```
var gitlabUrl = 'http://git-lab-url:port';
var gitlabUser = 'userName';
var gitlabPassword = 'userPasswort';

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

/* login verhalten */
var timer = new Timer(1000);
timer.append(
  function()
  {
    if (jQuery('#user_login').length > 0)
    {
      jQuery('#user_login').val(gitlabUser);
      jQuery('#user_password').val(gitlabPassword);
      jQuery('.btn-save').click();
    }
  }
);

/* wallboard aufrufen */
timer.append(
  function()
  {
    if (jQuery('.js-projects-list-holder').length > 0)
    {
      window.location.href = window.gitlabUrl + '/dashboard/issues?state=opened&utf8=✓&assignee_id=0';
    }
  }
);
/* reload verhalten */
timer.append(
  function()
  {
    if (jQuery('.issues-filters').length > 0)
    {
      window.location.href = window.gitlabUrl + '/dashboard/issues?state=opened&utf8=✓&assignee_id=0';
    }
  }
);


```
Τώρα μπορείτε να αποσυνδεθείτε. Αλλάξτε τη ρύθμιση DisplayManager στο αρχείο "/etc/default/nodm". Εδώ πρέπει να αλλάξετε το "NODM_USER" σε "dashboard" και το "NODM_ENABLED" σε "true".
```
# nodm configuration

# Set NODM_ENABLED to something different than 'false' to enable nodm
NODM_ENABLED=true

# User to autologin for
NODM_USER=dashboard

# First vt to try when looking for free VTs
NODM_FIRST_VT=7

# X session
NODM_XSESSION=/etc/X11/Xsession

# Options for nodm itself
NODM_OPTIONS=

# Options for the X server.
#
# Format: [/usr/bin/<Xserver>] [:<disp>] <Xserver-options>
#
# The Xserver executable and the display name can be omitted, but should
# be placed in front, if nodm's defaults shall be overridden.
NODM_X_OPTIONS='-nolisten tcp'

# If an X session will run for less than this time in seconds, nodm will wait an
# increasing bit of time before restarting the session
NODM_MIN_SESSION_TIME=60

# Timeout (in seconds) to wait for X to be ready to accept connections. If X is
# not ready before this timeout, it is killed and restarted.
NODM_X_TIMEOUT=300

```
Αν τώρα κάνετε επανεκκίνηση με την εντολή "sudo reboot", θα εμφανιστεί το ακόλουθο ταμπλό:
{{< gallery match="images/3/*.jpg" >}}
