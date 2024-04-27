#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# find files in ifp.dat
# WARNING!
#     some songs are named the same but different genres
#     some songs get skipped, regex issue, overall does well
#
#-------------------------------------------------------------------- initialize
clear
source ~/data/global.dat

fil="$HOME/data/ifp.dat"
out="$HOME/data/ifp-fnd.dat"
rex="[0-9][0-9]-"
#-------------------------------------------------------------------------------
title-80.sh -t line "Finding Files In ifp.dat"

tail -n +8 "$fil" | head -n -7 |
while read lin
do
   if [[ "$lin" =~ $rex ]]
   then
      fil=${lin#*-}
      fil="${fil%.mp3*}.mp3"
      fil=${fil//(/\\(}
      fil=${fil//)/\\)}
      echo "> > > $fil"
      find ~/Music -type f -regextype egrep -iregex ".*/[0-9]+-$fil" | sort
   fi
done | tee "$out"
#-------------------------------------------------------------------------------
