#! /bin/sh

OPTIND=1 # Reset shell script invocation counter 

# Global
PARAM="ignbrk -brkint -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts"
ARDUINO_CONF="cs8 9600"
RENESAS_CONF="cs8 115200"

# Default
DEFAULT_CONF=$RENESAS_CONF
DEFAULT_COM="/dev/ttyACM0"

print_help() {
    echo "Usage : source $0 [ARG]"
    echo "Arguments :"
    echo "  -h  show help"
    echo "  -a  arduino"
    echo "  -r  renesas"
    echo "  -c  COM file"
}


conf=$DEFAULT_CONF
com=$DEFAULT_COM

while getopts "harc:" OPT; do
  case "$OPT" in
    a) conf=$ARDUINO_CONF;;
    r) conf=$RENESAS_CONF;;
    c) com="$OPTARG";;
    h) echo "Help :";
       print_help;
       exit 0;;
    *) # getopts produces error
       echo "Getopts error";
       print_help;
       exit 1;;
  esac
done

if [ ! -w "$com" ] || [ ! -r "$com" ]; then
  echo "Cannot read or write to file $com. Bad device file."
  exit 1
fi

echo "Setting COM $com"
stty -F $com $conf $PARAM

