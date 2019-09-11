#!/bin/bash

OFF=0
ON_SPECIFIC=1
ON_ESSENTIAL=2
VERBOSE=false
MSG=""

function usage {
  echo "usage : $(basename $0)  [ read  help  off  on  essential] "
  if [[ ${VERBOSE} ]]; then
      echo "Use this to READ or WRITE 'defaults' .."
      echo -n

      echo "Try this:\n defaults read /Library/Preferences/"
  fi

  exit
}

shopt -s nocasematch
CMD_ARGS=""
ACTION="read"

if [[ $1 =~ "off" ]]; then
  CMD_ARGS="-int $OFF"
  ACTION="write"
elif [[ $1 =~ "on" ]]; then
  CMD_ARGS="-int $ON_SPECIFIC"
  ACTION="write"
elif [[ $1 =~ "essential" ]]; then
  CMD_ARGS="-int $ON_ESSENTIAL"
  ACTION="write"
elif [[ $1 =~ "read" ]]; then
  VERBOSE=true
  MSG="Read mode selected"
else
  usage
  exit
fi

echo "Action=[$ACTION], CMD_ARGS=[$CMD_ARGS]"
echo "sudo defaults $ACTION /Library/Preferences/com.apple.alf globalstate $CMD_ARGS"
echo "sudo defaults $ACTION /Library/Preferences/com.apple.alf $CMD_ARGS"
sudo defaults $ACTION /Library/Preferences/com.apple.alf globalstate $CMD_ARGS
sudo defaults $ACTION /Library/Preferences/com.apple.alf $CMD_ARGS

