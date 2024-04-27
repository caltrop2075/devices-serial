#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# ifp-bkp.dat analysis
#
# 2023-09-22 tweaked display & numeric format
#            negative & zero will not process thru numfmt.awk
# 2023-10-16 tweaked comment detect
#
#-------------------------------------------------------------------------------
# clear
source ~/data/global.dat
# unset LC_ALL
bse="$HOME/Music"
dat="$HOME/data/ifp-bkp.dat"
q=72780           # per file factor
c=1048313856      # ifp-799 capacity
f=0               # free
t=0               # size total
n=0               # file count
d=0               # size difference, not actual free space
w=14              # decimal width
#----------------------------------------------------------------------- analyze
title-80.sh -t line "ifp-bkp.dat analysis\n free size is approximate -- ${WHT}OK${nrm}/${RED}OVER${nrm}"

while read fil                                     # scan files
do
   if [[ ! ${fil:0:1} == "#" ]]                    # ignore comments
   then
      if [ -f "$bse/$fil" ]
      then                                         # file exists
         printf "%-80s\r" "${fil##*/}"
         ((t+=$(stat -c "%s" "$bse/$fil")))
         ((n++))
      else                                         # file not found
         echo "ERROR! file not found -- $fil"
      fi
   fi
   sleep 0.01                                      # display pause
done < "$dat"
printf "%-80s\r" ""                                # erase display
d=$((c-t))                                         # actual difference
f=$((d-n*q))                                       # calc appx free on drive
#----------------------------------------------------------------------- display
for i in n c t d f                                 # scan variables
do
   case $i in
      n ) s="fil" ;;
      c ) s="cap" ;;
      t ) s="tot" ;;
      d ) s="dif" ;;
      f ) s="fre" ;;
   esac
   if [[ $i == "f" ]]                              # free color
   then
      printf "$WHT"
   fi
   if ((${!i}<0))                                  # error color & change sign
   then
      eval $i=$((-${!i}))
      printf "$RED"
   fi
   if ((${!i}==0))                                 # zero detect
   then                                            # zero
      printf "%s:%s\n" "$s" "${!i}"
   else                                            # non-zero
      printf "%s:%s\n" "$s" "$(echo ${!i} | numfmt.awk)"
   fi
   printf "$nrm"                                   # reset display color
done
#-------------------------------------------------------------------------------
