#! /bin/sh
OPTIND=1 # Reset shell script invocation counter 

#SCRIPT_PATH=`realpath $0`
LOCAL_DIR=`pwd -P`

print_help() {
    echo "Usage : $0 [ARG]"
    echo "Possible Arguments :"
    echo "  -h  print_help"
    echo "  -n  : Remove spaces"
    echo "  -c  : Convert webm"
    echo "  -t  : Update tags"
    echo "  -a  : Do everything"
}

remove_space=0
convert_webm=0
update_tags=0

while getopts "nctahd:" OPT; do
  case "$OPT" in
    n) remove_space=1;;
    c) convert_webm=1;;
    t) update_tags=1;;
    a) remove_space=1;  
       convert_webm=1;  
       update_tags=1;;
    d) directory=$OPTARG;;   
    h) print_help;
       exit;;
    *) # getopts produces error
       echo "Getopts error";
       print_help;
       exit;;
  esac
done

if [ -z $directory ] ; then
    directory=$LOCAL_DIR
else
    directory=`realpath $directory` 
fi

echo "Directory aimed : $directory"

cd $directory

# Clean music names with spaces

if (($remove_space)); then
    echo "======= CLEAN MUSIC NAMES ======"
    for dir in `find -path ./.git -prune -o -type d -print`; do
        cd $dir
        for f in * ; do
            mv "$f" `echo $f | tr ' ' '_'` 2</dev/null
        done
        cd $directory
        echo $dir
    done
fi

if (($convert_webm)); then
    echo "======= CONVERT WEBM EXTS ======"
    webm_musics=`find -name "*.webm"`
    progress=`echo $webm_musics | wc -w`
    i=0

    for webm_music in $webm_musics ; do
        echo "$i/$progress"
        i=$(($i+1))
        ogg_music=${webm_music%.*}.ogg
        # Execude encoding command
        ffmpeg -loglevel quiet -y -i $webm_music $ogg_music
        rm $webm_music
    done
fi

if (($update_tags)); then
    echo "======= UPDATE MUSIC TAGS ======"
    all_musics=`find -iname "readme.txt" -o -iname "refresh.sh" -prune -o -type f -print`
    progress=`echo $all_musics | wc -w`
    i=0

    for music in $all_musics ; do
        echo "$i/$progress"
        music=`realpath $music`
        i=$(($i+1))
        full_dir=`dirname $music`
        artist=${full_dir##*/}              # Artist = Last directory
        album=$artist                       # Album = Artist (FIXME)
        genre=`echo $music | cut -d/ -f 1`  # Genre = First directory
        title=`basename $music`             # Title = music name
        # Execute tag editor command
        tageditor set "album=$album" "artist=$artist" "genre=$genre" "title=$title" --files $music < /dev/null
    done
fi

rm -f `find -name "*.bak"`

