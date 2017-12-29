#! /bin/sh
OPTIND=1 # Reset shell script invocation counter 

CACHE_FILE=$HOME/.music_replace_id
EXPORT_REPLACE_ID=$(cat $CACHE_FILE 2>/dev/null)
if [[ -z $EXPORT_REPLACE_ID ]]; then
    EXPORT_REPLACE_ID=0
fi
DEFAULT_DISPLAYED_TIME=2000

print_help() {
    echo "Usage : $0 [ARG]"
    echo "Possible Arguments :"
    echo "  -h  : print_help"
    echo "  -c  : Use cmus-remote to get music name"
    echo "  -t  : Displayed time in ms"
    echo "  -p [String] : Print the string"
}

use_cmus=false
display_string=""
display_time=$DEFAULT_DISPLAYED_TIME

while getopts "hcp:t:" OPT; do
  case "$OPT" in
    h) print_help;
       exit;;
    c) use_cmus=true;;
    p) display_string=$OPTARG;;
    t) display_time=$OPTARG;;
    *) # getopts produces error
       echo "Getopts error";
       print_help;
       exit;;
  esac
done

if $use_cmus; then
  display_string=$(cmus-remote -Q | sed -n -e 's/tag\s\(\w*\)/\1\t:\t/gp')
fi

if [ "$display_string" = "" ] ; then
    echo "No music name specified"
    exit 1
fi

EXPORT_REPLACE_ID=$(notify-send.sh -r $EXPORT_REPLACE_ID -t $display_time -i audio-volume-high "$display_string" -p)

echo $EXPORT_REPLACE_ID > $CACHE_FILE

