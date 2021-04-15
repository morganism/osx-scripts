#!/bin/bash

DMG_FILE=$1
ISO_FILE=$2
function usage() {
  echo "Usage: $0 INPUT_FILE.dmg [ OUTPUT_FILE.iso ]"
  echo "  INPUT_FILE.dmg Apple
}
if [[ -z $DMG_FILE ]]; then
  || ! -f $DMG_FILE ]]; then

/usr/bin/hdiutil convert /path/imagefile.dmg -format UDTO -o /path/convertedimage.iso
