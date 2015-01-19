#!/bin/sh

if [ "$#" == 0 ]
then
  echo "Usage: $0 file1 [... fileN]" >&2
  echo "Generated playlist is printed to stdout"
fi

cat=cat
which pv > /dev/null 2>&1 && cat=pv

while [ "$#" -gt 0 ]
do
  if [ "$cat" == "pv" ]
  then
    echo -n "# $(pv -N "$1" "$1" | md5sum | cut -d \  -f 1)"
  else
    echo -n "# $(cat "$1" | md5sum | cut -d \  -f 1)"
  fi
  echo " $(stat -c%s "$1") $(cat "$1" | file - | cut -d \  -f 2-)"
  echo "$1"
  shift
done
