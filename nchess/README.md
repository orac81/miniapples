### NCHESS


Released as free software under GNU GPL3 license.

NCHESS is a simple/small open source Chess Program written in C. (C89/99)
It can operate as an engine, or as a C console program.
It can build on systems smaller than 64K, such as  the 
Commodore 64/128, VIC20, etc.
It can play with variable board size. (4x4 up to 12x10).

There are compiled versions for CBM (.prg) Linux (.elf) and Windows (.exe)
in this zip.

At time of writing it isn't strong compared to most modern programs, but I 
hope to improve playing strength with time. Having said that, the versions 
for Linux/Windows will play "OK" chess. 
It is a "work in progress" beta version, expect bugs!
There will be a VTDL front end in due course.


## COMMANDS

```
  A#A#    Make move (ie E2E4)
  n[#,#]  New game (Optional setting x,y brd size) 
  d       Draw board
  g       Computer go  (or just hit ENTER)
  a       Auto play
  sFile   Save pos to file
  lFile   Load pos from file
  =FEN    Set a FEN
  #..     Assort Benchmark/tests..
  /[A-Z]# Set/view params A..Z (/D#:set depth,/T#:sec/move,/R#:rand..)
  x       Exit
```

## EXAMPLES

You can set parameters with the "/" command, so
 /T2     sets 2 seconds per move
 
 /T0 <ENTER> /I2 <ENTER>   Sets fixed depth of 2 ply.
 
 n6,6    sets a 6x6 board
 
 n10,10  sets a 10x10 board
 
 n8,6    set an 8x6 board
 
 You can play a demo game just by hitting ENTER, ENTER, etc.
 

The source code is included in the zip (nchess.c, nchess.h).
The file "maknosc.sh" will build the CBM .prg files with Oscar64
(VBCC or CC65 can also be used)
The file "makncc.sh" will build for Linux.

