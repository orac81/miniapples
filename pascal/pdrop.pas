(* PDROP.PAS : 4-in-a-row game in Standard Pascal. (C) A.Millett 1980-2016. Freeware! 
  Released as free software under GNU GPL-3 license.
  
  Convert DROPX36.C (26.1.14) to simple pascal..
  Simple version working (1 ply, small board)
->PDROP100  (26.7.2016)
  Imp full search
  (same as DROPX36 - 12805 nodes)
->PDROP101  (26.7.2016)
  Small mods
->PDROP102  (28.7.2016)

*)

program Pdrop;

{$A-}	        (* Enable recursion on TP3-CP/M *) 

(*---------------------------------------------------------------------------
  Search Engine code.
---------------------------------------------------------------------------*)


const PROG_NAME = 'PDROP v1.02. Make 4 in a line game. (C)A.Millett 1980-2016. Freeware.';
      MAX_BOARD = 400;	    (* Max board size *)
      WIN_EVAL = 5000;     (* Indicates win/loss *)
      White = 1;		    (* Board vals *)
      Black = 2;
      Edge = -4;
      szCh : array [1..4] of char = '.*O ';
      wineval : array [0..23] of integer =	(* Eval scores nclosed 0,1,2 *)
	( 0, 1,10,30,200, 2000, 0, 0,
	  0, 0, 5,10, 70, 2000, 0, 0,
	  0, 0, 0, 0,  0, 2000, 0, 0 ); 

var boardx,boardy :integer;     (* Board size *)
    losemode :integer;	     
    twoplaymode : integer;
    iqlevel :integer;	        (* Level of play *)
    debugflag :integer;
    inaline : integer;
    gameover :integer;	        (* No more moves *)
    bmult : integer;		(* Multiplier *)
    pxpos,pypos : integer; 	(* Player posn *)
    cxpos,cypos : integer;	(* Computer posn *)
    xpos,ypos : integer;	(* General pos *)
    xdir,ydir : integer;
    yoff : integer;
    ccolor : integer;		(* White := 1, Black := 2 *)
    cpiece : integer;
    bxpos,bypos : integer;	(* Best xy pos *)
    beval : integer;		(* Best score *)
    nodecount  : integer;
    xeval : integer;		(* Comp term eval score *)
    ceval : integer;		(* Temp eval score *)
    nline : integer;		(* No in line *)
    mline : integer;
    nclosed : integer;		(* No of open ends *)
    ngaps : integer;		(* No of gaps in line *)
    offseteval  : integer;
    board : array [0..MAX_BOARD] of integer;	(* Game board *)
    winside,winpos,windir : integer;
    startdepth : integer;


    (* Display analysis *)
procedure sch_callback (sxpos, sypos, seval : integer);
begin
  write (' ',sxpos,'=',seval);
end;



  (* Set a board pos *)
procedure Setboard (xpos,ypos,cpiece : integer);
begin
      board [xpos + ypos * bmult] := cpiece;
end;

  (* Get a board pos *)
function Getboard (xpos,ypos : integer) : integer;
begin
     Getboard := board [xpos + ypos * bmult];
end;

procedure newgame ;
begin
	ccolor := White;
	bmult := boardx + 2;
	for xpos := 1 to boardx do  begin
	  Setboard ( xpos, 0, Edge);
	  Setboard ( xpos, boardy + 1, Edge);
	  for ypos := 1 to boardy do begin
	    Setboard ( xpos, ypos, 0);
	  end;
	end;
	for ypos := 0 to boardy+1 do begin
	  Setboard ( 0, ypos, Edge);
	  Setboard ( boardx + 1, ypos, Edge);
	end;
end;

  (* See if win-line in this cdir? *)

function isWin (tpos, cdir : integer) : boolean;
var cpos : integer;
begin
	while ( board [tpos] = ccolor) do begin		(* Back track *)
	  tpos := tpos - cdir;
	end;
	tpos := tpos + cdir;
	winpos := tpos;			(* Save win-line pos/dir.. *)
	windir := cdir;
	winside := ccolor;
	nline := 0;
	cpos := tpos;
	while ( board [cpos] = ccolor) do begin	(* Count line *)
	  cpos := cpos + cdir;
	  nline := nline + 1;
	end;
	isWin := TRUE;
	if (nline < inaline) then isWin := FALSE;		(* Nope *)
end;

  (* Ret TRUE if game over *)
function isGameOver (wxpos, wypos: integer) : boolean;
var tpos : integer;
begin
	tpos := wxpos + wypos * bmult;
	isGameOver := TRUE;
	if (isWin (tpos,1) = FALSE) then begin
	  if (isWin (tpos,bmult - 1) = FALSE) then begin
	    if (isWin (tpos,bmult) = FALSE) then begin
	      if (isWin (tpos,bmult + 1) = FALSE) then begin
		winside := 0;
		isGameOver := FALSE;
	      end;
	    end;
	  end;
	end;
end;

	(* Computer Move evaluation functions *)

  (* Scan line at (tpos,ccdir) & count how many in-a-row (nline,nclosed) for side (ccolor) *)

procedure scanline (tpos, icolor, ccdir : integer) ;
  var tpiece : integer;
begin
	nline := 1;
	nclosed := 0;

	(* Count (nline,nclosed) in dir (ccdir) : Scandir (+ccdir) *)
	tpiece := board [tpos + ccdir ];
	if (tpiece = icolor) then begin
	  nline := nline + 1;
	  tpiece := board [tpos + ccdir + ccdir ];
	  if ( tpiece = icolor) then begin
	    nline := nline + 1;
	    tpiece := board [tpos + ccdir + ccdir + ccdir ];
	    if (tpiece = icolor) then begin
	      nline := nline + 1;
	      tpiece := board [tpos + ccdir + ccdir + ccdir + ccdir ];
	      if ( tpiece = icolor) then begin
	        nline := nline + 1;
	      end else if (tpiece <>0) then begin
	        nclosed := nclosed + 1;
	      end;
	    end else if (tpiece <>0) then begin
	      nclosed := nclosed + 1;
	    end;
	  end else if (tpiece <>0) then begin
	    nclosed := nclosed + 1;
	  end;
	end else if (tpiece <>0) then begin
	  nclosed := nclosed + 1;
	end;

	(* Count (nline,nclosed) in dir (-ccdir) : Scandir (-ccdir) *)
	tpiece := board [tpos - ccdir ];
	if ( tpiece = icolor) then begin
	  nline := nline + 1;
	  tpiece := board [tpos - ccdir - ccdir ];
	  if ( tpiece = icolor) then begin
	    nline := nline + 1;
	    tpiece := board [tpos - ccdir - ccdir - ccdir ];
	    if ( tpiece = icolor) then begin
	      nline := nline + 1;
	      tpiece := board [tpos - ccdir - ccdir - ccdir - ccdir ];
	      if ( tpiece = icolor) then begin
	        nline := nline + 1;
	      end else if (tpiece <>0) then begin
	        nclosed := nclosed + 1;
	      end;
	    end else if (tpiece <>0) then begin
	      nclosed := nclosed + 1;
	    end;
	  end else if (tpiece <>0) then begin
	    nclosed := nclosed + 1;
	  end;
	end else if (tpiece <>0) then begin
	  nclosed := nclosed + 1;
	end;

	(* (nclosed > 2) prints ("Nclosed > 2"); *)
	if (nline >= inaline) then begin
	  mline := inaline; 
	  nline := inaline;
	end;
	ceval := ceval + wineval [nline + (nclosed * 8) + offseteval];
end;

  (* Term-node eval (cxpos,cypos,ccolor), ceval *)

function evalpos (ixpos, iypos, icolor: integer) : integer;
  var tpos : integer;
begin
	tpos := ixpos + iypos * bmult;
	ceval := 0;
	mline := 0;
	scanline (tpos, icolor, 1);
	scanline (tpos, icolor, bmult - 1);
	scanline (tpos, icolor, bmult);
	scanline (tpos, icolor, bmult + 1);
	if (losemode > 0) then ceval := -ceval;
	evalpos := ceval;
end;

  (* Find next vacant row on col. *)

function findypos (fxpos : integer) : integer;
  label exitfindypos;
  var fypos: integer;
begin
	yoff := fxpos + boardy * bmult;
	fypos := boardy;
	while (fypos > 0) do begin
	  if ( board [yoff] = 0) then begin
	    findypos := fypos;
	    goto exitfindypos;
	  end;
	  yoff := yoff - bmult;
	  fypos := fypos - 1;
	end;
	findypos := -1;
exitfindypos:
end;

  (* Eval for (ccolor), ret best move (bxpos,bypos,beval) 
       Simple original 1 ply static search *)

(* SIMPLE ENGINE

procedure compmove ;
begin
	bxpos := 0; bypos := 0;
        if ( ccolor = White) then begin
	  beval := -32000;
	end else begin
	  beval := -32000;
	end;

	for cxpos := 1 to boardx do begin
	    cypos := findypos (cxpos);
            if ( cypos > 0) then begin
	      xeval := evalpos (cxpos, cypos, ccolor);
	      xeval := xeval - abs (cxpos - ((boardx div 2) + 1));
	      xeval := xeval + (evalpos (cxpos, cypos, 3 - ccolor) div 2);
	      if (iqlevel > 1) then begin
                if (Getboard (cxpos,cypos - 1) = 0) then begin
		  ceval := evalpos (cxpos, cypos-1, ccolor);
		  xeval := xeval - (ceval div 8);
		  ceval := evalpos (cxpos, cypos-1, 3 - ccolor);
		  xeval := xeval - (ceval div 4);
		end;
	      end;
	      if (xeval > beval) then begin
		bxpos := cxpos;
		bypos := cypos;
                beval := xeval;
		write (' ',bxpos, '=',beval);
	      end;
	    end;
	end;
end;
 *)

function AlphaBeta(depth, alpha, beta, upeval : integer) : integer;
label exitAlphaBeta;
var seval : integer;
    sxpos,sypos: integer;
    neweval: integer;
    nmoves: integer;
begin

    nmoves := 0;
    for sxpos := 1 to boardx do begin
      sypos := findypos (sxpos);
      if ( sypos > 0) then begin
        nmoves := nmoves + 1;
        neweval := upeval + evalpos (sxpos, sypos, ccolor);
	neweval := neweval - (abs (sxpos - ((boardx div 2) + 1)) * 4);	(* Center tropism *)
	if (mline >= inaline) then begin
	  if (depth = startdepth) then begin
	    bxpos := sxpos; bypos := sypos;
	  end;
	  nodecount := nodecount + 1;
          AlphaBeta := WIN_EVAL + depth; goto exitAlphaBeta;
	end;
  	neweval := neweval + (evalpos (sxpos, sypos, 3-ccolor) div 4);
		(* Do move *)
	Setboard (sxpos,sypos,ccolor);
	ccolor := 3 - ccolor;
		(* Search deeper? *)
	if (depth > 0) then begin
	  seval := -AlphaBeta (depth-1, -beta, -alpha, -neweval);
	end else begin	
	  seval := neweval;	(* Use accumulated seval as score *)
	  nodecount := nodecount + 1;
	end;
		(* Undo move *)
	Setboard (sxpos,sypos,0);
	ccolor := 3 - ccolor;
	if (debugflag>0) then begin
	  write ('.',depth,':',sxpos,'=',seval);
	  if (seval > alpha) then write ('*');
	  if (depth = startdepth) then writeln ('');
	end;
		(* First ply.. *)
	if (depth = startdepth) then begin
	  if (seval > alpha) then begin
	    bxpos := sxpos; bypos := sypos;
	  end;
	  sch_callback (sxpos, sypos, seval);
	end;
	if (seval > alpha) then begin
	  alpha := seval;
	end;
	if (seval >= beta) then begin
          AlphaBeta := beta; goto exitAlphaBeta;
	end;
      end;
    end;
    if (nmoves = 0) then begin		(* No moves, drawn. *)
      nodecount := nodecount + 1;
      AlphaBeta := 0; goto exitAlphaBeta;
    end;
    AlphaBeta := alpha;
exitAlphaBeta:
end;

procedure compmove;
begin
    startdepth := iqlevel; 
    nodecount := 0;
    bxpos := -1;
    beval := AlphaBeta (iqlevel, -12000, 12000, 0);
end;

(* 
int AlphaBeta(int depth, int alpha, int beta)
begin
    if (depth = 0)
        return Evaluate();
    GenerateLegalMoves();
    while (MovesLeft()) begin
        MakeNextMove();
        val := -AlphaBeta(depth - 1, -beta, -alpha);
        UnmakeMove();
        if (val >= beta)
            return beta;
        if (val > alpha)
            alpha := val;
    end;
    return alpha;
end;
*)

(*-------------------------------------------------
   Front end code starts here, simple console i.o
---------------------------------------------------*)

procedure drawboard;
  var ch,xpos,ypos,lin : integer; 
begin
    writeln ('');
    for ypos := 1 to boardy do  begin
      for xpos := 1 to boardx do  begin
        ch := Getboard(xpos,ypos);
        write (' ', szCh[ch+1]);
      end;
      writeln ('');
    end;
    for xpos := 1 to boardx do  begin
      write(' ',xpos);
    end;
    writeln ('');
end;

procedure testend (xpos,ypos: integer);
begin
	if (isGameOver (xpos, ypos)) then begin
	  if (ccolor = White + losemode) then begin
	    writeln ('White (*) wins!');
	  end else begin
	    writeln ('Black (O) wins!\n');
	  end;
	end;
end;

  (* Call engine to search for best move *)

procedure execcomp (hintmode : integer) ;
  label exitexeccomp;

begin
	compmove ;		(* Find best comp bxpos,bypos *)
	if (bxpos > 0) and (bypos > 0) then begin
	  cxpos := bxpos; cypos := bypos;
	  ceval := evalpos (bxpos, bypos, ccolor);			(* 5 line ? *)
	  if (hintmode>0) then begin
	    pxpos := cxpos; pypos := cypos;
	    writeln (' Try ',cxpos);
	    goto exitexeccomp;
	  end;
	  Setboard ( bxpos, bypos, ccolor);
	  pxpos := bxpos; pypos := bypos;
          writeln (' I Move ',pxpos,'=',beval,', Nodes:',nodecount);
	  if (mline >= inaline) then begin		(* Win.. *)
	    testend (bxpos, bypos);
	    goto exitexeccomp;
	  end;
	end else begin
	  writeln (' Drawn !');
	end;
exitexeccomp:
end;

    (* Main game play loop *)

procedure game;
 var strIn : string[64];	        (* User input *) 
     cret : integer;
     cmd : char;
     parm,parm2 : integer;
begin
    writeln (PROG_NAME);

    boardx := 7; boardy := 6;
    iqlevel := 5;
    losemode := 0;
    twoplaymode := 0;
    debugflag := 0;
    inaline := 4;
    offseteval  := 1;
    newgame ;
    while (strIn[1] <> 'x') do begin
      drawboard;
      if (ccolor = White) then begin
        write ('White (*)');
      end else begin
        write ('Black (O)');
      end;
      write (' to move. Cmd (1-9,gixn[##]) :');
      strIn[1] := 'g';
      readln (strIn);
      cmd := strIn [1];
      parm := (ord(strIn [2]) - ord('0'));
      parm2 := (ord(strIn [3]) - ord('0'));

		(* Move column 1-? *)
      pxpos := (ord(strIn [1]) - ord('0'));
      if (pxpos > 0) and (pxpos <= boardx) then begin
	pypos := findypos (pxpos);
	if ( pypos < 1) then exit;
        ceval := evalpos (pxpos, pypos, ccolor);	(* win - line ? *)
	Setboard ( pxpos, pypos, ccolor);
	if (mline >= inaline) then begin		(* Win.. *)
	  testend (pxpos, pypos);
	  drawboard ;
	  newgame ;
	end else begin			(* Comp reply *)
	  ccolor := 3 - ccolor;
	  if (twoplaymode = 0) then begin
	    execcomp (0);
	    ccolor := 3 - ccolor;
	    if (mline >= inaline) then begin
              drawboard ;
	      newgame ;
	    end;
	  end;
	end;
      end;

      if (cmd = 'i') then begin		(* i: Level of play *)
	iqlevel := parm;
	writeln ('iq:',iqlevel);
      end;

      if (cmd = 'g') then begin		(* g: Computer go .. *)
	execcomp (0);
	ccolor := 3 - ccolor;
	if (mline >= inaline) then begin
          drawboard ;
	  newgame ;
	end;
      end;

      if (cmd = '?') then begin		(* HINT .. *)
	execcomp (1);
      end;

      if (cmd = '$') then begin		(* Toggle Debug mode *)
	debugflag := 1 - debugflag;
      end;

      if (cmd = 'n') then begin		(* n: New game.. (resize: n55..n99) *)
	if (parm > 4) and (parm < 12) and (parm2 > 4) then begin
	  boardx := parm;
	  boardy := parm2;
	end;
	newgame ;
      end;
      if (cmd = 't') then begin
	twoplaymode := 1 - twoplaymode;
      end;
    end;		(* Main command loop *)
end;



    (* Main program *)
begin
  game;
end.
