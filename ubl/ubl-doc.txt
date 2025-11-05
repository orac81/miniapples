   Universal Basic Library
   -----------------------
 
(C) A.Millett 2011-2025. Released as free software under GPL3.

UBL is a simple Universal portable Basic library for a range of machines.

It currently has support (to varying degrees) for 
Commodore 8bits (C64, C16, VIC20, PET), DOS QBasic/BasicA, Apple2, 
Dragon32, BBC, ZX-Spectrum, Amstrad CPC, MSX,  TRS80, 
Exidy Sorcerer and Ohio Superboard.

See the file UBL25.TXT for the actual source code for each target.

You can perform a range of simple tasks, poke/peek the vdu, set colour, etc,
by using gosub calls in your code. By merging the UBL library for your
target system, the same program should run on many machines.
I have tended to concentrate on the Basics that are either Microsoft Basic
derived, or later ones that have a fair degree of compatiblity.
But expect for there to be bugs and omissions, I have not cross tested every 
combination at this stage.

The Library is written mostly in Basic, and is in Lines 1-49, and 9500-9999
Why those lines? Some time critical functions, ie; peek/poke screen, are 
fastest when located at the program start. But other lengthier routines
can be placed high, too much code low-down will slow up the main program.

I have tried to make UBL "Compiler friendly", so that code should compile
fairly well, given the limits of the Basic language. 

You code should be at lines 100-9499, and one of the first calls should be 
gosub 9500, which initialises UBL code.
UBL uses variables starting with the letter U, care should be taken not 
to reuse them in your code.

UBL is mostly based around standard Upper case ASCII, so that the calls
to poke/peek use ASCII codes. There is a provision for "extra characters",
so far a few PETSCII chars, the cards (Heart/Diamond/etc) 
Ball (81), Grey (102), and some form-line chars. On non-cbm these map to 
nearest ASCII equivalents.

While I have made a few disk images, I have supplied the code as simple
text files to cut/paste into a users preferred emulator.
In the main UBLXX.TXT file you will find a number of different libraries
for each platform. Just copy and paste the one for your desired system.

There are so many different systems, and different methods for 
transfering and implementing programs on real hardware, I feel this 
method is the best. Propogating small code changes across many
different formats is difficult, particularly at this early stage.

I have supplied a Commodore D64 image file "ubl-cbm.d64", with sample
programs to load and run. The Commodore lib will autodetect the machine
and set up variables accordingly. Note that you should use LOAD "PROG",8  and
not: LOAD "PROG",8,1   since I have saved the programs at $0401 so that 
PET computers can load them.


  API Command Summary
 ---------------------
 
(Use "gosub linenumber" to call. Note that the var U is a common parameter.)

(To calculate a VDU pos for these functions, use "u=x+y*ux")
       
 3     Poke VDU pos U with char U1, Colour U2
       ie: u=4*ux:u1=65:u2=2:gosub 3:rem put 'A' at VDU(0,5),color 2.
 4     Poke VDU pos U with char U1, (no colour set)
       ie: for u=0 to ux-1:u1=u+32:gosub 4:next:rem show chrset 
 6     Doke VDU pos U with char U1,U2.
 8     U1 = VDUPEEK (U) 
 9500  Initialise UBL. Return VDU size UX,UY, use these in your code.   
 9560  Return getkey() in U  (ret zero if none)
 9570  Return getkey() in U  (wait for key)
 9580  Return special (PETSCII) code, poke-char(u),printable(u1) 
       (otherwise typical asc "%*OHDSC#_^)(+-!") 
 9590  Convert Asc U to peek/poke code 
 9600  u=random number  0..1
 9610  Output a string (u$) to vdu pos (ui,uj)
 9630  Convert cga-type rgbi (0-15 bits:irgb) in U to local color poke val U.
 9650  Set print cursor pos(ui,uj) (1..n)
 9670  Clear the VDU.
 9680  Set screen colour (u)
 9690  Fast fill (u3..u4 step u5) with u1, (colour u2 if set)
 9700  u2=colorPeek(u)
 9710  Return time in secs (uf=float var)


In the "example" folder is a collection of simple samples, demos and games. 
Paste that program into your emulator, then copy/paste the section of the 
library for the machine you want to target from the source library, 
ie: UBL25L.TXT 

These examples should be viewed as part of the documentation.
Most have elementry instructions on the title screen, but for the odd
one that doesnt (maze, ugomoku) use keys about letter "S" to move, enter to make
move, "k" to exit. I left out the title screen to save memory on these ones.

The examples are also in the "qbasic" folder, ready to run under QBASIC.
But note, some of the programs will run too fast, some allow a "speed" setting
on their title screen. Capslock might be needed for some examples.

I have tended to write the code in lower case, since the emulator I use
the most (Commodore WinVice) accepts paste in lower case. If you need upper
case, use a utility that converts a text file to upper case.

Finally I will say again, this library is very simple, and at an early 
stage, with bugs and ommissions. Please treat it as such!

