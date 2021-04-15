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
      echo "and this : /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on"
      echo "http://krypted.com/mac-security/command-line-firewall-management-in-os-x-10-10/"
      echo sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -help
      echo sudo /usr/libexec/ApplicationFirewall/socketfilterfw --list
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
elif [[ $1 =~ "block" ]]; then
  echo "Setting BLock ALL ON"  
  /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on
  echo "Blocking Remote Management"
  sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off
  sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop
else
  usage
  exit
fi

echo "Action=[$ACTION], CMD_ARGS=[$CMD_ARGS]"
echo "sudo defaults $ACTION /Library/Preferences/com.apple.alf globalstate $CMD_ARGS"
echo "sudo defaults $ACTION /Library/Preferences/com.apple.alf $CMD_ARGS"
echo "1."
sudo defaults $ACTION /Library/Preferences/com.apple.alf globalstate $CMD_ARGS
echo "1.."
sudo defaults $ACTION /Library/Preferences/com.apple.alf $CMD_ARGS
echo "1..."

echo "Output of '/usr/libexec/ApplicationFirewall/socketfilterfw --getblockall'"
/usr/libexec/ApplicationFirewall/socketfilterfw --getblockall
echo "1...."
