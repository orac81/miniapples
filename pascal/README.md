###PDROP

 
PDROP is the classic 4-in-a-line game implemented in standard Pascal.
It is released as free software under GNU GPL-3 license.
The files are:
  pdrop.pas    - Pascal version.
  
  pdrop.c      - C version for comparison.
  
  pdrop.com    - DOS version, compiled with Turbo-C 3.
  
  pdropcpm.com - CPM version, compiled with Turbo-C 3 for CPM.


  Playing the game 
 ------------------
Each player takes turns to drop pieces into the columns.
The first player to get 4 pieces in a row wins the game.

Commands:
  1-9     Drop your piece in that column.
  
  n       New game (nXY to set board size, ie n99 for a 9x9 board)
  
  i#      Set search depth (iq level) from 1-9  (can be >9, ie: i: for 10, iA for 16!)
  
  g       Make computer take current turn. (swaps sides) 
  
  t       Toggle Two player mode, no computer reply.
  
  ?       Get computer hint.
  
  x       Quit.

Hitting "RETURN" on its own executes the "g" compute command, keep hitting
RETURN for auto-play.
  
Thw default IQ level setting is 5 ply. If you run the program and then hit
"g", the computer should search 12805 nodes, and play column 4,eval=-14.
The C version with do the same, and you can use this to test/compare 
Pascal/C compilers across platforms.
I would recommend a lower IQ of 4 for slow 8bit platforms.

The computer AlphaBeta search is written for simplicity, is as basic as it 
can be, just searching left-right without move ordering. 
Doing simple static eval and sorting by score would drmatically 
improve search depth.

Enjoy!
