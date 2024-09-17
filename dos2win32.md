Well, thats really good, thanks everyone for all the ideas!

I think I may have a go at this sometime. 

I will call the project DOS2WIN32.

It would target win32 api to start, since i have written a fair bit for it, and it can run under wine for all other PC systems. But it should be possible to extend the same API to compile for MacOS, Linux, etc.

It would be a library with routines starting dos_.. or macros DOS_..
It would be possible to set TARGET_SYSTEM to WIN32 or DOS, conditionally compiling as appropriate. 

Macros such as USE_VGA_PLANAR, USE_VGA_MODE13, USE_CGA, USE_MOUSE etc could be set to selectively enable and compile the parts of the library needed for your code, trapping int86 calls and video memory writes. 
To start I will implement the bits I need for my stuff, but in a way that is extendable.

dos_init() can malloc 256k for the emulated vga output. It can setup a server thread (running at user set refresh rate) that starts up a window (ie 640x480), and tracks/updates/refreshes vdu redrawing.

A wrapper DOS_VPTR(ptr) will add an offset to ptr to point to the ram to be used, and could trap writes for updating the right area of the screen.

DOS_INP(), DOS_OUTP(), dos_int86() etc, can mirror those functions accordingly.

Now if the compiler can trap the original DOS code syntax, or privide runtime support (mmap etc) it would do so and pass the calls to the above routines. Otherwise the user has to search/replace and modify the source (in the long term, the best thing to do).

But importantly the code will still compile the same way for DOS, under whatever original DOS C compiler (Turbo C, MSVC 1.52, Watcom etc) simply by setting the target macro to DOS. 

Does this all sound like a good idea?


And to start it all off, a link:

https://github.com/orac81/miniapples/raw/main/dos2win32.md

