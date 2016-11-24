#! /bin/bash

OPTIND=1 # Reset shell script invocation counter 


print_help() {
    echo "Usage : source $0 [ARG]"
    echo "Arguments :"
    echo "  -h  print_help"
    echo "  -a  address : use custom address:port"
}

addr_set=0
address=

while getopts "hEIa:" OPT; do
  case "$OPT" in
    a) addr_set=1; address="$OPTARG";;
    h) echo "Help :";
       print_help;
       return 0;;
    *) # getopts produces error
       echo "Getopts error";
       print_help;
       return 0;;
  esac
done
if ((!$addr_set)); then
  echo Give me an address and a port ! >>/dev/stderr
  print_help;
  return 0
fi

echo "Proxy set to $address"
export "http_proxy=$address"
export "https_proxy=$address"
export "ftp_proxy=$address"

