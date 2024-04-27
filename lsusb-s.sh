#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# list select usb
#
# 2023-09-22 tweaked display
# 2023-10-17 tweaked display, getfacl for that mysterious permission '+'
#
#-------------------------------------------------------------------------------
function fx_getfacl ()
{
   getfacl "/${lin#*/}" 2> /dev/null |
   while read str
   do
      str=${str/\# }
      str=${str/file: /file: /}
      echo "$str"
   done | column
   echo
}
#-------------------------------------------------------------------------------
# clear
# source ~/data/global.dat
#-------------------------------------------------------------------------------
bse="/dev/bus/usb"

title-80.sh -t line "Select USB Devices & Permissions"
#-------------------------------------------------------------------------------
while read tgt
do
   lsusb | grep "$tgt"
done << EOF |
Future Technology
iRiver
Tripp-Lite
EOF

while read -a ary
do
   bus=${ary[1]}     # bus
   dev=${ary[3]}
   dev=${dev/:/}     # device
   ven=${ary[5]}
   pro=${ven#*:}     # product
   ven=${ven%:*}     # vendor
   dir="$bse/$bus"
   printf "%s\n" "${ary[*]}"
   # printf "%s %s %s %s\n" "$bus" "$dev" "$ven" "$pro"
   find "$dir" -type c -name "$dev" | #-printf "%M %p\n"
   while read lin
   do
      ls -l "$lin"
      fx_getfacl
   done
done
#-------------------------------------------------------------------------------
title-80.sh -t line "ttyUSB*"

ls -l /dev/ttyUSB* | sort |
while read lin
do
   echo "$lin"
   fx_getfacl
done
#-------------------------------------------------------------------------------
