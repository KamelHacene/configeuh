#! /bin/sh

i3status | while :
do
  read line
  echo "Hello world | $line" || exit 1
done
