####  VTDL, a library for small systems

[Download](https://github.com/orac81/miniapples/raw/refs/heads/main/vtdl/vtdl-exe-latest.zip)

(Please note, this is "Work in progress", not yet complete!)

VTDL stands for "Very Tiny Development Layer", and is a simple portable 
C89/C99 library designed to be efficient with very small target systems.

For example the included demo game Skattabugs is about 3K, runs on an 
unexpanded 5K VIC20, and yet features Hires colour graphics, sound, 
smooth animation, and many features.

It will eventually target many systems, from Vic20s up to full PCs.

The source to VTDL is in the folder "tdl". 
Some compiler build scripts are also included.
The 6502 targets can be build with the OSCAR64 C compiler, which
is good for these small systems. 

For example to build for C64 and Vic20, install OSCAR64, then from the
base work dir type:

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

```
----------------------------------------------------------------------
/* CHRSET.C  -  Simple VTDL demo, show ASCII char set */

#define TDL_REQ_TEXT  1 	/* Text mode only program */
#define TDL_IO_DIRECT 1		/* Set TDL_IO_CON, TDL_IO_SYS or TDL_IO_DIRECT */

  /* The following code should be added to the start of all TDL programs. */
#ifdef TDL_PATH			/*	User sets TDL_PATH */
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
	TDL_PrintStr ("CHARACTER SET: ");
	pos = TDL_ScreenPos(0,3);
    for (x=32; x<96; x++) {
      TDL_ScreenSet (pos, TDL_ASC2CHR(x), TDL_COL_WHITE);
      pos ++;
    }
    while (TDL_GetKey () == 0);
    TDL_Finish ();
    return 0;
}
----------------------------------------------------------------------
```


### API Library & Macros.


This is the API Library as it currently is. 
Note that some functions maybe implemented as Macros with direct 
inline code on some platforms.
All Functions/Macros start with the letters TDL_...

(NOTE - CURRENTLY THIS API IS LIABLE TO CHANGE, STILL UNDER CONSTRUCTION!)


   SCREEN DRAWING
   --------------

UINT TDL_ScreenPos (BYTE x, BYTE y) 
  Calc Screen char position from X,Y (0 to max-1) 
  Return screen pos, for use with Screen functions.
  The range of X is 0 to (TDL_VDUX-1) and Y:0..(TDL_VDUY-1)

void TDL_ScreenSet (UINT pos, BYTE char, BYTE col) 
  Poke screen char pos with char & colour

void TDL_ScreenSet2 (UINT pos, BYTE char1, BYTE char2, BYTE col) 
  Poke screen char pos with 2 chars.

void TDL_ScreenSetXY (BYTE x, BYTE y, BYTE char, BYTE col) 
  Poke screen XY char pos with char & colour 
  The range of X is 0 to (TDL_VDUX-1) and Y:0..(TDL_VDUY-1)

void TDL_ScreenSetXY2 (BYTE x, BYTE y, BYTE char1, BYTE char2, BYTE col) 
  Poke screen XY char pos with 2 charaters. 

void TDL_ScreenSetNC (UINT pos, BYTE char) 
  Poke screen pos with char (No colour)

BYTE TDL_ScreenGet (UINT pos) 
  Peek screen pos, ret char.

BYTE TDL_ScreenGetXY (BYTE x, BYTE y) 
  Peek screen XY pos, ret char code.

void TDL_ScreenClr ()
  Clear the screen.

void TDL_DrawPoint (UINT xpos, UINT ypos, UINT color)
  If Hi-res is available, draw a pixel (0..TDL_VDUHX-1)
  
   PRINTING
   --------

void TDL_PrintChar (BYTE ch)
  Print an ASCII charracter.

void TDL_Ink (BYTE ink)
  Set print ink.

void TDL_GotoXY (BYTE x, BYTE y)
   Set cursor pos (1,1..X,Y)
   
void TDL_PrintStr (char *pStr)	
  Print a null-term string.

void TDL_PrintInt (UINT x)		
  Print an unsigned 16-bit integer. Avoids division/multiplication.
  
void TDL_PrintSignedInt (int x)		
  Print a signed 16-bit integer.

void TDL_PrintSI (char *istr, UINT iint)
  Print a string, then an unsigned integer.


   KEYBOARD INPUT
   --------------
   
BYTE TDL_GetKeyDown () 
  Get key held down 

BYTE TDL_GetKey_Shift () 
  Return shift status (0 = none)

BYTE TDL_GetKey () 
  Return a keystroke from input buffer.
  
   TIMER FUNCTIONS
   ---------------

UINT TDL_Clock ()
  Get approx 16-bit clock. Counts (TDL_CLOCKS_PER_SEC) every second.
  
void TDL_Sleep (int tim)  
  Sleep time milliseconds 
  
void TDL_FrameSync ()
  Wait for screen flyback (1/50 second for PAL, 1/60 NTSC).
  
  
   SOUND FUNCTIONS
   ---------------

void TDL_Sound (UINT val, BYTE voice)
  Simple sound tone generator.

TDL_SOUND_FREQ2TONE(FHz)
  Macro converts frequency (in hertz) to tone val to use with TDL_Sound.

void TDL_SoundOff (BYTE voice)
  Turn off voice.

void TDL_SoundInit ()
  Initialise sound system.
  
   OTHER FUNCTIONS
   ---------------

UINT TDL_Rand ()
  Simple random function, returns a 16-bit unsigned integer.

void TDL_UDG_Init (BYTE *pPix, UINT chstart, UINT psize)
    pPix    - a pointer to a BYTE array of 8x8 graphics.
    chstart - what poke-code the char maps to. (often TDL_UDG_START)
    psize   - the size of the array.
    
  Set up the UDG chr set. What happens to the data depends on the platform,
  so a Commodore 64/+4/v20 would copy the ROM char set to RAM, then 
  overlay the UDGs at TDL_UDG_START. A ZX_Spectrum or DOS PC may just
  store the pointer for later use when drawing to the hires screen.
  This process is "transparent" to the users code.


void TDL_ScreenBackground (BYTE screen, BYTE border)
  Set screen and border background colours.

BYTE TDL_ScreenMode (UINT sx, UINT sy, BYTE coldepth, BYTE flags)
  Request a screen resolution, sets nearest available. 
  Actual resolution in TDL_VDU_HIX, TDL_VDU_HIY, TDL_VDU_HICOL 
  are the size in pixels of Screen, and colour depth (bits).
  They can be statically defined, or refer to variables/function calls.
  
UINT TDL_Initialise (UINT mode, BYTE *pData)
  Initialise the library. Call this first.
  mode & pData are for future expansion, set these to NULL.

void TDL_Finish ()
  Tell TDL to prepare to end, tidy up variables, unhook IRQs.

------------------------------------------------------------------------------
  
   MACRO DEFINES
   -------------

These Defines set before inlining the VTDL library. This can be done 
within the Users program, or as a command line define, ie: -D[MACRO]

TDL_PATH
  This can be set with a -D TDL_PATH="PATH" command for the compiler.
  The default location is "../tdl/tdl.c"
  The following code should be added to the start of all TDL programs:

  #ifdef TDL_PATH			/*	User sets TDL_PATH */
    #include TDL_PATH
  #else
    #include "../tdl/tdl.c"
  #endif

TDL_CBM - Set this for CBM computers, then set:
          TDL_C64, TDL_VIC20, TDL_C16, TDL_PET, TDL_PET80
TDL_ZX  - Set for ZX-Spectrum
TDL_DOS - Set for a MSDOS .exe build, using VGA Mode 0x13 graphics (320x200x256)
TDL_DOS_BIOS  - Build a DOS .exe that uses BIOS calls to work. 
TDL_SDL2 - Build an SDL2 binary (unfinished). 

TDL_PRINT_ORG  - Sets print origin for TDL_GotoXY, default 1.
TDL_REQ_HIRES  - Request for Hires mode to be made available.
TDL_REQ_TEXT   - Request Text mode only (no UDG). For CBM platforms
                 this will allow PETSCII versions to be built.

------------------------------------------------------------------------------

The following defines are set by the library, the user can use them for 
portable code.

TDL_UDG_START  
  Indicates the start poke-code for UDGs, may vary.

TDL_COL_BLACK, TDL_COL_WHITE, TDL_COL_PURPLE, TDL_COL_BLUE,
TDL_COL_YELLOW, TDL_COL_RED, TDL_COL_CYAN, TDL_COL_GREEN
  These are the basic colours to use in Ink/Colour parameters.

TDL_UDG_MAX
  Indicates the no of UDG charaters available. 
  If zero, you can use ASCII or PETSCII alternatives. ie:
  #if (TDL_UDG_MAX > 0) /* Define UDGs, then #else ASCII.. */

TDL_UDG_START
  Character code of first UDG character.
  
TDL_HAS_PETSCII 
  Indicates a platform has PETSCII graphics available.

TDL_VDUX, TDL_VDUY  
  Indicates the size in characters of a Screen, if statically defined.

TDL_HAS_HIRES
  Indicates a platform has full Hi-res graphics available.

TDL_VDU_HIX, TDL_VDU_HIY, TDL_VDU_HICOL
  Indicates the size in pixels of a Screen, and colour depth (bits).
  Can be statically defined, or refer to variables/function calls.

TDL_VDU_STATIC
  Indicates Screen/VDU parameters are statically defined


NOTE - CURRENTLY THIS API IS LIABLE TO CHANGE, STILL UNDER CONSTRUCTION!


/*========================================================================
  COMPILING CODE, AND TOOLS:
==========================================================================*/

I used Z88DK to build the Spectrum version, see "z88init.bat" & "z88tdl.bat"

------------------------------------------------------------------------------
#This is the Build file for 6502/CBM targets with Oscar64. "tdlmakosc.sh"

#!/bin/sh
# tdlmakosc.sh  - Build TDL app with OSCAR64 in Linux
#  Syntax  ./tdlmakosc.sh progname [parms]   
#  ie: ./tdlmakosc.sh skattabugz/skattabugz -O2 -g
#  Note   -g add asm source
echo "Building C64.."
oscar64 -D TDL_CBM -D TDL_C64=1 -D IS_OSCAR=1 -tm=c64 $2 $3 $4 $5 $1.c -o=$1-c64.prg
echo "Building VIC20.."
oscar64 -D TDL_CBM -D TDL_VIC20=1 -D IS_OSCAR=1 -tm=vic20  $2 $3 $4 $5 $1.c -o=$1-v20.prg
echo "Building C16.."
oscar64 -D TDL_CBM -D TDL_C16=1 -D IS_OSCAR=1 -tm=plus4 $2 $3 $4 $5 $1.c -o=$1-c16.prg
echo "Building PET.."
oscar64 -D TDL_CBM -D TDL_PET=1 -D IS_OSCAR=1 -tm=pet  $2 $3 $4 $5 $1.c -o=$1-pet.prg
#echo "Building PET32k.."
#oscar64 -D TDL_CBM -D TDL_PET=1 -D IS_OSCAR=1 -tm=pet32  $2 $3 $4 $5 $1.c -o=$1-pet32k.prg
echo "Building PET80.."
oscar64 -D TDL_CBM -D TDL_PET80=1 -D IS_OSCAR=1 -tm=pet32  $2 $3 $4 $5 $1.c -o=$1-pet80.prg
------------------------------------------------------------------------------

rem This is the build file for MSDOS .EXE, using Microsofts MSVC1.52 (tdlmakdos.bat)

echo off
echo tdlmakdos msvc152-path dosprog [dosprog2.c ..] [flags..]
echo   ie: tdlmakdos d:\msvc15 demo\hello

echo .
echo Building DOS_VGA version: %2.exe
%1\bin\cl.exe /D "TDL_DOS" /D "TDL_DOS_VGA" /AM /nologo /Gs /G3 /FPi87 /FR /W3 /Oe /O1 /Ot /Ox /Fe%2.exe /I%1\include %2.c %3 %4 %5 %6 %7 %8 %9  -link /NOI /STACK:5120  %1\lib\oldnames.lib %1\lib\mlibc7.lib 
echo .
echo Building DOS_BIOS version: %2-bios.exe
%1\bin\cl.exe /D "TDL_DOS" /D "TDL_DOS_BIOS" /AM /nologo /Gs /G3 /FPi87 /FR /W3 /Oe /O1 /Ot /Ox /Fe%2-bios.exe /I%1\include %2.c %3 %4 %5 %6 %7 %8 %9  -link /NOI /STACK:5120  %1\lib\oldnames.lib %1\lib\mlibc7.lib 

------------------------------------------------------------------------------

The UDG mode for drawing graphics is based around 8x8 characters, 
supplied as 8 Bytes per character. I have supplied a tool "tdl/bmp2c.c" that 
can convert a mono bmp file to C source to put into your code.

Just design the set in your prefered gfx tool, and save as a mono bmp.
Use any width over 32 pixels, any height, the tool will extract 8x8 chars 
top-left to bottom right automatically.

To build this tool for Linux, type: cc bmp2c.c -o bmp2c -Os
------------------------------------------------------------------------------

FURTHER NOTES:

Note that some of these functions may still not yet be implemented for
some platforms. Also some might not yet have the fastest/intended code,
optimisation of some functions to Assembler is ongoing for some platforms.

The API provides functions for drawing characters with either coordinates,
(TDL_ScreenSetXY) or linear 16-bit position (TDL_ScreenSet). The latter
method is generally faster for most platforms, especially CBM.

Note that TDL_ScreenSetXY uses (0,0) as top left origin, whereas 
printing and TDL_GotoXY uses (1,1) as is traditional with print functions.
You can set print origin (0,0) with: #define TDL_PRINT_ORG 0

All Functions/Macros start with the letters "TDL_", also variables that 
start with "TDL__" are reserved for internal library use.

Please see the .c program sources in the folders "demo", "skattabugz" etc, 
for examples on using/calling VTDL.

I intend to expand the range of supported Platforms and C Compilers
in time, currently it is limited while I map out the API.


------------------------------------------------------------------------------
Copyright A.Millett 2011-2026. (github.com/orac81)     
The demos and games released as free/open software under GNU GPL3 license. 
  See: www.gnu.org/licenses/gpl-3.0.html
Library code itself licensed under Lesser GPL (LGPL), this permits
users to use the library within thier own code without restriction.
(The same licence GNU Compilers use for thier libraries.)

This program, and its source code, is provided for free "as-is",
no liability for its use or misuse is assumed by the author.
------------------------------------------------------------------------------
