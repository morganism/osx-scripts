#!/bin/bash

DMG_FILE=$1
ISO_FILE=$2

hdiutil convert $1 -format UDTO -o $2
