#! /bin/sh

PROJECT="elsys/zodiac/noqt"
WORK_DIR="$HOME/work/$PROJECT"
REMOTE_DIR="/mnt/sdc1/backup/$PROJECT"

TOUCH="/usr/bin/touch"
RSYNC="/usr/bin/rsync -az "
SLEEP="/usr/bin/sleep"
SYNC="/usr/bin/sync"
FIND="/usr/bin/find"
NOTIFY="/home/chamow/mybin/notify-send.sh"
NOTIFY_FAIL="$NOTIFY -i software-update-available"
NOTIFY_SUCCESS="$NOTIFY -i software-update-available"

# Enable notification
eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -x -u $LOGNAME i3)/environ)"

# Backup directory mounted/exists ?
if [ ! -d $REMOTE_DIR ]; then
  $NOTIFY_FAIL -t 1000 "Backup" "Directory not mounted : $REMOTE_DIR"
  exit
fi

date_hour="$(date +"%H")"
date_complete="$(date +"%F")"
BACKUP_DIR="$REMOTE_DIR/$date_hour"

# Notify and save the id
id=$($NOTIFY_SUCCESS -p -t 120000 "Backup...")

# Rsync
$RSYNC $WORK_DIR $BACKUP_DIR

$SYNC

# Wait at least 1s
$SLEEP 1

# Update the date of the last backup
$FIND $REMOTE_DIR -maxdepth 1 -type f -delete
$TOUCH $REMOTE_DIR/$date_complete

# Clear the notification
$NOTIFY_SUCCESS --close=$id

