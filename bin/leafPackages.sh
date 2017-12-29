#! /bin/bash

installedPackages="$HOME/installedPackages.txt"
leafPackages="$HOME/leafPackages.txt"

pacman -Qq > $installedPackages

> $leafPackages

for package in $(cat $installedPackages); do
  deps=$(($(pactree -r $package | wc -l) - 1))
  if [ $deps -eq 0 ]; then
    echo "$package" | tee -a $leafPackages
  fi
done

