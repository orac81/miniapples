rem UGOMOKUxx.TXT - (c) a.millett, from 1981 PET "GO-MOKU AM"
rem ->ugomoku01.txt (4.8.14)     (Use with UBL20L.TXT)     
rem  adapt to ubl..
rem ->ugomoku02.txt (4.8.14)   
rem  cont adaption..
rem  imp crsr about s. go cmd. color.
rem ->ugomoku04.txt (5.8.14)   
rem  conv lg%(x,y) to lo/hi%(y) for simpler legal move array
rem  conv center bias ce() to simpler formulea.
rem ->ugomoku05.txt (5.8.14)   
rem  imp cmds:k=alter,m=auto,k=quit
rem ->ugomoku06.txt (7.8.14)   
rem  fix flashing at end of pieces.
rem ->ugomoku07.txt (7.8.14)   
rem  fix @555 for apple (no bitwise and) 
rem ->ugomoku08.txt (7.8.14)   
rem ->ugomoku09.txt (7.8.14)
rem  imp cursor, title screen.   
rem ->ugomoku10.txt (8.11.25)   
rem ->
rem -----1---------2---------3---------4---------5---------6---------7---------8

100 rem * go-moku (c)a.millett apr1981-2014
112 rem@i=xx,yy,e,n,i,j,be,a,x,y,cl
120 mx=19:dim b%(20,20),ev%(3,5,1),lo%(20),hi%(20),ch(2),co(2)
140 gosub 9500
150 np=1:rem no players
160 gosub 11000
170 gosub 9000
200 gosub 8000
210 if cc then 270
250 if au=0 then gosub 7000
260 if wn then 15000
265 if np=2 then 250
270 gosub 6000
280 if wn then 15000
490 goto 250

499 rem * eval pos (i,j)
500 e=int((2*(mx*2-abs(mx-j-j)-abs(mx-i-i)))/mx)
rem 500 e=ce(j)+ce(i)
520 for xx=-1 to 1:for yy=-1 to 1
530 if xx=0 then if yy=0 then 640
540 x=i+xx:y=j+yy:k=1:n=-k:a=b%(x,y):if a=ks then 640
550 f=b%(x+xx,y+yy)
rem 555 if ((a or f) and 1)=0 then 640
555 if (a=0 or a=ks) and (f=0 or f=ks) then 640
560 cc=a:if a=0 then cc=b%(x+xx,y+yy):goto 700
570 n=n+1:x=x+xx:y=y+yy:if b%(x,y)=cc then 570
580 cl=abs(b%(x,y)<>0):g=0:if cl=0 then if b%(x+xx,y+yy)=cc then 700
590 x=i-xx:y=j-yy:if b%(x,y)<>cc then 620
610 n=n+1:x=x-xx:y=y-yy:if b%(x,y)=cc then 610
615 k=2-g
620 cl=abs(b%(x,y)<>0)+cl
625 if n>3 then n=3
630 tt=cl+3*abs(c<>cc):e=e+ev%(n,tt,g)/k
640 next yy
650 next xx:return

700 x=x+xx:y=y+yy:g=1
720 n=n+1:x=x+xx:y=y+yy:if b%(x,y)=cc then 720
730 cl=abs(b%(x,y)<>0):goto 590

6000 rem * comp move
6010 t=0:uf=0:gosub 9710
6017 u$="hmm..":gosub 7800
6020 c=-c:wn=0
6050 be=-9000:bx=int(mx/2):by=bx
6100 for j=1 to mx
6105  if lo%(j)>hi%(j) then 6155
6110  for i=lo%(j) to hi%(j)
6120   if b%(i,j) then 6150
6130   gosub 500:gosub 6900
6140   if e>be then be=e:bx=i:by=j
6150  next
6155 next
6160 u$="i go":gosub 7800
6165 t=uf:gosub 9710:t=int(uf-t)
6170 i=bx:j=by:e=be:gosub 6900
6200 x=bx:y=by:px=x:py=y
6210 for b=0 to 5:b%(x,y)=0:gosub 8900:for a=0 to 100:next
6220 b%(x,y)=c:gosub 8900:for a=0 to 100
6230 next:next

6250 if be>799 then wn=-1
6490 goto 7400

     rem show pos (i,j)
6900 u$=chr$(64+i)+right$(str$(j),2):if e then u$=u$+"="+str$(e)+" "
6910 if t then u$=u$+","+str$(t)+"s   "
6920 ui=5:uj=0:goto 9610

7000 rem * human move c
7010 c=-c:h=1
7020 x=px:y=py:if y=0 then return
7030 b=0:i=x:j=y:e=0:t=0:gosub 6900
7040 gosub 9560:if u>96 then u=u-32
     rem cursor d/u/l/r
7042 dx=0:dy=0:if u=4 or u=76 then dy=-1
7044 if u=5 or u=79 then dy=1
7046 if u=6 or u=74 then dx=-1
7048 if u=7 or u=75 then dx=1
7050 if u=13 then if b%(x,y)=0 then 7150
7057 if u=71 then c=-c:goto 8900
7058 if u=69 then gosub 7600:goto 7040
7060 if u=88 then wn=-1:return
7062 if u=65 then c=-c:au=1:goto 8900
7065 gosub 8900:b=1-b:if b then u1=kc:u2=cu:gosub 3
7070 if dx=0 and dy=0 then for z=1 to 50:next:goto 7040
7080 j=y+dy:i=x+dx:if h then h=0:gosub 7800
7090 if i<1 or i>mx or j<1 or j>mx then 7040
7100 gosub 8900:u$="pos":gosub 7820:y=j:x=i:goto 7030
7150 i=x:j=y:gosub 500
7170 x=i:y=j:bx=x:by=y:if e>799 then wn=1
7190 b%(x,y)=c:gosub 8900:u$="":gosub 7800
     rem update leg mv arrays lo%() hi%() for move (x,y)
7400 for j=y-1 to y+1
7420  if x-1<lo%(j) then lo%(j)=x-1
7440  if x+1>hi%(j) then hi%(j)=x+1
7460 next:return

     rem alter sqr (x,y) cmd j
7600 a=b%(x,y):a=a+1:if a>1 then a=-1
7610 b%(x,y)=a:gosub 8900:goto 7400

     rem clr statline
7800 u3=0:u4=ux-1:u5=1:u1=ks:u2=cu:gosub 9690
7820 if u$<>"" then ui=0:uj=0:gosub 9610
7840 ui=1:uj=1:goto 9650

8000 rem * new game
8050 z=1:gosub 8500
8100 for x=0 to mx+1
8110  b%(x,0)=ks:b%(x,mx+1)=ks:b%(0,x)=ks:b%(mx+1,x)=ks
8120 next
8200 cc=0
8300 for y=1 to mx
8320  lo%(y)=mx:hi%(y)=1
8340  for x=1 to mx
8360   b%(x,y)=0
8380 next:next
8400 au=0:px=int(mx/2):py=px:c=-1:wn=0:bx=0
8490 return

     rem draw board (z set for clr brd)
8500 u=0:gosub 9680:u=15:gosub 9640:gosub 9670:u5=1
8520 for y=1 to mx:w=(mx+2-y)*ux
8530  if z then u3=w+1:u4=w+mx:u1=ch(1):u2=co(1):gosub 9690:goto 8580
8540  for x=1 to mx
8560   u=w+x:u2=b%(x,y)+1:u1=ch(u2):u2=co(u2):gosub 3
8570  next
8580 next
     rem draw borders
8700 for x=0 to mx+1
8710  u=ux+x:u1=ke:u2=ce:gosub 3:u=ux*(mx+2)+x:gosub 3
8720 next
8760 for y=1 to mx
8770  u=ux*(y+1):gosub 3:u=u+mx+1:gosub 3
8780 next
8790 return

     rem * plot b%(x,y)
8900 u=(mx+2-y)*ux+x:u2=b%(x,y)+1:u1=ch(u2):u2=co(u2):goto 3

9000 rem * init
9100 y=0:n=0:z=0:a=0:b=0:xx=0:yy=0:k=0:cc=0
9110 u=32:gosub 9590:ks=u
9120 u=64:gosub 9590:ka=u
     rem black,empty,white pieces
9150 u=3:gosub 9580:ch(0)=u:u=10:gosub 9630:co(0)=u
9160 ch(1)=ks+14:u=1:gosub 9630:co(1)=u
9170 u=2:gosub 9580:ch(2)=u:u=15:gosub 9630:co(2)=u:cu=u
9180 u=8:gosub 9580:kc=u
9190 u=1:gosub 9580:ke=u:u=5:gosub 9630:ce=u
     rem ch(0)=209:ch(1)=219:ch(2)=215
9400 restore
9420 for g=0 to 1:for cl=0 to 5:for n=0 to 3
9430   read ev%(n,cl,g)
9440 next:next:next
9490 return

10120 data 3,8,100,800, 1,2,7,800, 0,0,0,800
10160 data 3,6,40,300, 1,2,5,300, 0,0,0,300
10200 data 3,7,8,9, 0,2,7,8, 0,0,0,0
10230 data 3,6,7,8, 0,2,6,7, 0,0,0,0
10240 data 0

      rem title screen, set scr colr, ink, cls
11000 u=0:gosub 9680:u=15:gosub 9640:gosub 9670
11060 print"  go-moku":print" ---------"
11080 u=5:gosub 9640
11200 print:print"(c) a.millett 1981-25"
11210 print "freeware/gpl3"
11220 u=14:gosub 9640
11240 print:print"get 5 in a line to win"
11250 print"to move, use cursor"
11255 print"(or jkol) then enter"
11260 print"g : computer move":print"a : auto play"
11280 print"e : edit square":print"x : exit"
11340 u=15:gosub 9640
11360 print:print "hit space";
      rem wait for space
11400 gosub 9570:if u>96 then u=u-32
11405 if u=88 then end
11420 if u<>32 then 11400
11490 return

15000 u$="you":if wn<0 then u$="i"
15020 u$=u$+" win. again (y/n)?"
15100 gosub 7800

15160 gosub 15500:xx=i:yy=j:if w=0 then 15300
15170 for c2=0 to 1:cc=c2*c:x=bx:y=by:gosub 8900:z=u
15180 for x=0 to 4:u=z+x*xx-x*yy*ux:u1=ch(cc+1):gosub 4:next
15190 for y=1 to 100:next:next
15300 gosub 9560:if u>96 then u=u-32
15310 if u=89 then run
15320 if u<>78 then 15160
15400 gosub 9670
15490 end
     
15500 w=0:i=0:j=0:if bx<1 then return 
15505 for xx=-1 to 1:for yy=-1 to 1
15510 if xx=0 then if yy=0 then 15600
15520 n=0:x=bx:y=by
15530 n=n+1:x=x+xx:y=y+yy:if b%(x,y)=c then 15530
15540 x=bx-xx:y=by-yy:if b%(x,y)<>c then 15580
15560 x=x-xx:y=y-yy:n=n+1:if b%(x,y)=c then 15560
15570 if n>4 then by=y+yy:bx=x+xx
15580 if n>4 then w=1:i=xx:j=yy:xx=2:yy=2
15600 next:next
15620 return

