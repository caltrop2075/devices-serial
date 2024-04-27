#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# iRiver restore from backup list
# a LOT less tedious than using WinXP
#
# WARNING!
# a full load (265 MP3) takes time...
#
# ifp format
# WARNING! kinda FUCKS things
# erases ALL directories & you can't recreate them
# think it erases the firmware update as well
#
# 2023-09-20 added comment capability
# 2023-10-16 added iriver detection
#
#-------------------------------------------------------------------- initialize
if [[ $(lsusb | grep "iRiver, Ltd. iFP-700") ]] # detect iRiver
then
   clear
   source ~/data/global.dat
   dat="$HOME/data/ifp-bkp.dat"
   echo "iRiver detected"
   sleep 1
#------------------------------------------------------------------------- reset
   title-80.sh -t line "initializing iRiver"
   printf "$Wht%s\n" "removing all directories & files"
   ifp rm -r MP3 > /dev/null 2>&1               # delete directory & all files

   printf "%s$nrm\n%s\n"  "creating base directory:" "MP3"
   ifp mkdir MP3 > /dev/null 2>&1               # create base directory

   printf "$Wht%s$nrm\n"  "creating sub-directories:"
   while read src                               # scan data & create dirctory list
   do
      if [[ ! $src =~ \#--- ]]                     # ignore cmments
      then
         dir=${src%/*}
         if [[ $dir =~ Zeppelin ]] || [[ $dir =~ Beatles ]]
         then
            dir=${dir%/*}
            dir=${dir#/}
            dir=${dir/, The/}
         else
            dir=${dir##*/}
         fi
         dir="MP3/$dir"
         echo "$dir"
      fi
   done < "$dat" | sort | uniq |
   while read dir
   do
      printf "%s\n" "$dir"
      ifp mkdir "$dir" > /dev/null 2>&1         # create base directory
   done
#-------------------------------------------------------------------------- copy
   title-80.sh -t line "copy to iRiver"
   while read lin                                  # read backup list
   do
      if [[ ! $lin =~ \#--- ]]                     # ignore cmments
      then
         dir=${lin%/*}                             # directory
         fil=${lin##*/}                            # filename
         fil=${fil/ (*)/}                          # remove stuff
         fil=${fil/(*) /}
         if [[ $dir =~ Zeppelin ]] || [[ $dir =~ Beatles ]]
         then                                      # fix select directories
            dir=${dir%/*}
            dir=${dir#/}
            dir=${dir/, The/}
         else                                      # default directories
            dir=${dir##*/}
         fi
         src="$HOME/Music/$lin"
         des="MP3/$dir/$fil"                       # destination
         printf "$Wht%-20s %s$nrm\n" "$dir" "${src##*/}"
         ifp upload "$src" "$des" 2> /dev/null  # copy MP3
      fi
   done < "$dat"
#-------------------------------------------------------------------------------
   echo
   ifp df 2> /dev/null
else
   echo
   echo "no iRiver connected"
fi
