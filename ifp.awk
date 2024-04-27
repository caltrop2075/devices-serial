#!/usr/bin/awk -f
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# iRiver MP3 lister
#
# builtin 'numfmt' SUCKS! wrote my own a while back and tweaked
#
# 2023-09-19 fix numfmt() ZERO
#
#===============================================================================
BEGIN {

   blk="\033[0;2;30m"            # dim
   red="\033[0;2;31m"
   grn="\033[0;2;32m"
   yel="\033[0;2;33m"
   blu="\033[0;2;34m"
   mag="\033[0;2;35m"
   cyn="\033[0;2;36m"
   wht="\033[0;2;37m"

   Blk="\033[0;30m"              # normal
   Red="\033[0;31m"
   Grn="\033[0;32m"
   Yel="\033[0;33m"
   Blu="\033[0;34m"
   Mag="\033[0;35m"
   Cyn="\033[0;36m"
   Wht="\033[0;37m"

   BLK="\033[0;1;30m"            # bold         some terminals
   RED="\033[0;1;31m"
   GRN="\033[0;1;32m"
   YEL="\033[0;1;33m"
   BLU="\033[0;1;34m"
   MAG="\033[0;1;35m"
   CYN="\033[0;1;36m"
   WHT="\033[0;1;37m"

   nrm="\033[0m"                 # 0 add these after colors

   FS="|"
   c=0
   i=0
   n=0
}
#===============================================================================
{
   sub(/\t\(size /,"|")
   sub(/\)$/,"")
   switch($2)
   {
      case "d" :
         printf("%"$1*3"s%s\n","",$3)
         break
      case "f" :
         n=$4
         numfmt()
         printf("%"$1*3"s%-48s %5."p"f%s\n","",$3,n,s)
         c+=$4
         i++
         break
   }
}
#===============================================================================
END {
   if(c!=0)
   {
      n=c
      numfmt()
   }
   printf("\n%s:%s\n","fil",i)
   printf("%s:%4."p"f%s\n","tot",n,s)
}
#===============================================================================
# functions
#-------------------------------------------------------------------------------
function numfmt()
{
   l=log(n)/log(10)+0.000000001  # base 10 log w/rounding error fix
   e=int(int(l/3)*3)
   if(l<0)                       # adjust for +/-
      e=e-3
   n=n/10^e                      # convert number
   p=p=int(4-(l-e))              # palces "%5."p"f"
   switch(e)                     # suffix
   {
      case -24: s="y"; break     # yocto
      case -21: s="z"; break     # zepto
      case -18: s="a"; break     # atto
      case -15: s="f"; break     # femto
      case -12: s="p"; break     # pico
      case  -9: s="n"; break     # nano
      case  -6: s="µ"; break     # micro
      case  -3: s="m"; break     # mili
      case   0: s="";  break     # none
      case   3: s="K"; break     # kilo
      case   6: s="M"; break     # mega
      case   9: s="G"; break     # giga
      case  12: s="T"; break     # tera
      case  15: s="P"; break     # peta
      case  18: s="E"; break     # exa
      case  21: s="Z"; break     # zetta
      case  24: s="Y"; break     # yotta
      default: s="*10^"e         # out of range, 10 power
   }
}
#===============================================================================
