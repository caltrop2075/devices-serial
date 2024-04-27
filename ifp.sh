#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# iRiver MP3 utility
#
# nothing like the iRiver except one on scAmazon
# everything else looks like a smart phone with built-in batteries
# MP3 players have really declined with the advent of smart phones
#
# sometimes after ifp operations communication locks up
# especially if aborted ^C
# the iRiver needs to be reconnected
#
# 2023-09-18 added total, power suffix, auto indent, & data file
# 2023-09-19 added command line options
# 2023-09-20 added ifp-bkp.dat analysis
# 2023-09-23 added connection detect
# 2023-10-16 added non-ifp iriver detection
#
#-------------------------------------------------------------------- initialize
unset LC_ALL
fil="$HOME/data/ifp.dat"
#------------------------------------------------------ recursive read directory
function fx_ifp ()
{
   ifp ls "$1" 2> /dev/null |
   while read a b
   do
      if [[ ${a:0:1} == d ]]
      then
         printf "%d|%s|%s\n" "$l" "$a" "$b"
         ((l++))                                # directory indent
         fx_ifp "$1/$b"                         # recurse
         ((l--))                                # directory dedent
      else
         if [[ ${a:0:1} == "f" ]]               # file detect
         then
            printf "%d|%s|%s\n" "$l" "$a" "$b"  # file data
         fi
      fi
   done
}
#------------------------------------------------------------------ main program
if (($#>0))
then
   case $1 in
      -a ) ifp-ana.sh ;;
      -f ) ifp-fnd.sh ;;
      -l ) clear; cat "$fil" ;;
      -r ) ifp-bkp.sh ;;
      -h )
         f="%10s   %-36s%-19s%-14s%s\n"
         echo
         printf "iRiver Command Line Utility\n"
         printf "ifp.sh [-a -f -l -r]\n"
         printf "$f" "OPTION" "DESCRIPTION" "SCRIPT" "DATA IN" "DATA  OUT"
         printf "$f" "default" "read device" "ifp.sh & ifp.awk" "-" "ifp.dat"
         printf "$f" "-a" "analyze backup data" "ifp-ana.sh" "ifp-bkp.dat"
         printf "$f" "-f" "find files (some false positives)" "ifp-fnd.sh" "ifp.dat" "ifp-fnd.dat"
         printf "$f" "-l" "list data file" "ifp.sh" "ifp.dat" "-"
         printf "$f" "-r" "restore from backup list" "ifp-bkp.sh" "ifp-bkp.dat" "-"
         printf "$f" "" "WARNING! takes a long time" ""
         ;;
      * )
         echo "unknown command line, try -h"
   esac
else
   if [[ $(lsusb | grep "iRiver, Ltd. iFP-700") ]] # detect iRiver
   then                                            # iRiver connected
      clear
      title-80.sh -t line "iRiver MP3 Listing -> $fil" | tee "$fil"

      ifp df 2> /dev/null |                        # disk free
      while read lin
      do
         lft=${lin%%:*}
         rht=${lin#*:}
         if ((i>0))                                # data line detect
         then                                      # not first line
            read a b <<< $rht                      # trim leading spaces -> vars
            if ((i==1))                            # capacity
            then
               echo $a > ~/temp/temp.dat           # save capacity
            fi
            printf "%8s %s\n" "$lft" "$(echo $a | numfmt.awk)"
         else                                      # first line
            printf "%8s %s\n" "$lft" "$rht"
         fi
         ((i++))
      done | tee -a "$fil"
      sleep 3
      echo  | tee -a "$fil"
      read q < ~/temp/temp.dat                     # read saved capacity
      l=0                                          # initial indent
      fx_ifp "MP3" | ifp.awk -v q=$q | tee -a "$fil" # start recursive directory
   else                                            # iRiver NOT connected
      echo
      echo "iRiver NOT connected"
   fi
fi
#-------------------------------------------------------------------------------
