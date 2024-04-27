# devices-serial
serial com port stuff &amp; iRiver MP3 Player

ifp-ana.sh
--------------------------------------------------------------------------------
ifp-bkp.dat analysis

2023-09-22 tweaked display & numeric format
           negative & zero will not process thru numfmt.awk
2023-10-16 tweaked comment detect


ifp-bkp.sh
--------------------------------------------------------------------------------
iRiver restore from backup list
a LOT less tedious than using WinXP

WARNING!
a full load (265 MP3) takes time...

ifp format
WARNING! kinda FUCKS things
erases ALL directories & you can't recreate them
think it erases the firmware update as well

2023-09-20 added comment capability
2023-10-16 added iriver detection


ifp-fnd.sh
--------------------------------------------------------------------------------
find files in ifp.dat
WARNING!
    some songs are named the same but different genres
    some songs get skipped, regex issue, overall does well


ifp.awk
--------------------------------------------------------------------------------
iRiver MP3 lister

builtin 'numfmt' SUCKS! wrote my own a while back and tweaked

2023-09-19 fix numfmt() ZERO


ifp.sh
--------------------------------------------------------------------------------
iRiver MP3 utility

nothing like the iRiver except one on scAmazon
everything else looks like a smart phone with built-in batteries
MP3 players have really declined with the advent of smart phones

sometimes after ifp operations communication locks up
especially if aborted ^C
the iRiver needs to be reconnected

2023-09-18 added total, power suffix, auto indent, & data file
2023-09-19 added command line options
2023-09-20 added ifp-bkp.dat analysis
2023-09-23 added connection detect
2023-10-16 added non-ifp iriver detection


lsusb-s.sh
--------------------------------------------------------------------------------
list select usb

2023-09-22 tweaked display
2023-10-17 tweaked display, getfacl for that mysterious permission '+'

