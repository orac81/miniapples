  VTDL, a library for small systems
 -----------------------------------


(Please note, this is "Work in progress", not yet complete!)

VTDL stands for "Very Tiny Development Layer", and is a simple portable 
library designed to be efficient with very small target systems.

For example the included demo game Skattabugs runs on an unexpanded 5K VIC20,
and yet features Hires colour graphics, sound, smooth animation, and
many features.

It will eventually target many systems, from Vic20s up to full PCs.

The source to VTDL is in the folder "tdl". 
Some compiler build scripts are also included.
The 6502 targets can be build with the OSCAR64 C compiler, which
is good for these small systems. 

For example to build for C64 and Vic20, install OSCAR64, 
then from the base work dir type:

 tdl/tdlmakosc.sh skattabugz/skattabugz -Os 

There are some simple demos in the folder "demo".

This library tries to give the Compiler the best chance possible to
optimise the code. To do this, it is included as source within the program,
rather than as a traditional "lib" file. Furthermore decisions are taken
to maximise optimisation for 8 bit systems, ie use of BYTE, using macros
to pre-compute paramaters before use. For example the Colour defines:
TDL_COL_WHITE etc are the actual targets specific codes, so when used
no extra lookups are needed.
This version is based around 8x8 UDG characters, which is the most
efficient for 8 bit platforms. Later versions will extend from that.

Set the target (TDL_C64, TDL_VIC20, TDL_ZX..) from the compile line 
ie -D TDL_C64

By default TDL assumes it is included with this command:
  #include "../tdl/tdl.c"
so, you run the compiler from a work folder (called "vtdl")
with the other folders (tdl, demo, skattabugz, etc) within that.

Your code should have this near the start:

#ifdef TDL_PATH		/* User sets TDL_PATH */
 #include TDL_PATH
#else
 #include "../tdl/tdl.c"
#endif

You can set the macro define TDL_PATH with a new path for the library.

Here is a simple example program to display the ASCII char set:

----------------------------------------------------------------------
/* HELLO.C  -  Simplest VTDL demo */

#define TDL_IO_DIRECT 1		/* Set TDL_IO_CON, TDL_IO_SYS or TDL_IO_DIRECT */

#ifdef TDL_PATH			/* User sets TDL_PATH */
 #include TDL_PATH
#else
 #include "../tdl/tdl.c"
#endif

int main ()
{
    UINT x;
    UINT pos = 0;
    TDL_Initialise (0,NULL);
    TDL_Ink (TDL_COL_PURPLE);
	TDL_PrintStr ((char *) "CHARACTER SET: ");
	pos = TDL_ScreenPos(0,3);
    for (x=32; x<96; x++) {
      TDL_ScreenSet (pos, TDL_ASC2CHR(x), TDL_COL_WHITE);
      pos ++;
    }
    while (TDL_GetKey () == 0);
    return 0;
}

----------------------------------------------------------------------

This is the API Library as it is. (currently liable to change):

UINT TDL_ScreenPos (BYTE x, BYTE y) 
  Calc Screen char position from X,Y (0 to max-1) 
  Return screen pos, for use with Screen functions.

void TDL_ScreenSet (UINT pos, BYTE char, BYTE col) 
  Poke screen pos with char & colour

void TDL_ScreenSetNC (UINT pos, BYTE char) 
  Poke screen pos with char (No colour)

BYTE TDL_ScreenGet (UINT pos) 
  Peek screen pos, ret char

BYTE TDL_GetKeyDown () 
  Get key held down 

BYTE TDL_GetKey_Shift () 
  Return shift status (0 = none)

void TDL_ScreenClr ()
  Clear the screen
  
UINT TDL_Clock ()
  Get 16bit clock
  
void TDL_Sleep (int tim)  
  Sleep (tim) milliseconds 
  
void TDL_FrameSync ()
  Wait for screen flyback (1/50 sec PAL 1/60 NTSC).  

void TDL_Sound (UINT val, BYTE voice)
  Simple sound tone generator.

void TDL_SoundOff (BYTE voice)
  Turn off voice.

void TDL_SoundInit ()
  Initialise sound system.
  
void TDL_UDG_Init (BYTE *pPix, UINT chstart, UINT psize)
  Set up the UDG chr set.
  pPix    - a pointer to a BYTE array of 8x8 graphics.
  chstart - what code the char maps to.
  psize   - the size of the array.

void TDL_ScreenBackground (BYTE screen, BYTE border)
  Set screen and border background colours.
  
UINT TDL_Initialise (UINT mode, BYTE *pData)
  Initialise the library. Call this first.
  
  
************* MORE TO COME.......

-----------------------------------------------------------------------------
Copyright A.Millett 2011-2026. (github.com/orac81)     
Released as free/open software under GNU GPL3 license. 
  See: www.gnu.org/licenses/gpl-3.0.html
Library code itself licensed under Lesser GPL (LGPL)

This program, and its source code, is provided for free "as-is". 
The author take no responsibility or liability its subsequent use or mis-use.
The user uses it entirely at his or her own risk. 
-----------------------------------------------------------------------------
