#! /bin/sh
CACHE_FILE=$HOME/.music_replace_id

if [ $# -ne 1 ] ; then
    echo "No music name specified"
    exit 1
fi

EXPORT_REPLACE_ID=`cat $CACHE_FILE 2>/dev/null`

if [[ -z $EXPORT_REPLACE_ID ]]; then
    EXPORT_REPLACE_ID=0
fi

#echo Prev : $EXPORT_REPLACE_ID
EXPORT_REPLACE_ID=`notify-send.sh -r $EXPORT_REPLACE_ID -t 3000 -i audio-volume-high "$1" -p`
#echo Next : $EXPORT_REPLACE_ID

echo $EXPORT_REPLACE_ID > $CACHE_FILE

