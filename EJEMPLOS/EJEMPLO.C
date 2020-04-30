#include<stdio.h>
#include<graphics.h>
#include<dos.h>
#include<string.h>
#include<mem.h>

char buffer[32000];
int p1=1,p2=2;

main()
{
IniEGA();
fondo();
getch();
demo();
}


/*
 *********************************** dibuja circulo *******
 */
demo()
{
 int y;
 for(y=100;y>0;y--)
 {
  /* copia de buffer a pantalla */
  movedata(_DS,(unsigned)&buffer,0xA000,0,32000);

  setcolor(y%12);
  circle(320,100,20+y);
  floodfill(320,100,y%12);
/*  cambia_pagina(); */

  }
}
/*
 *********************************** cambia pagina **********
 */

cambia_pagina()
{
 int p=0;

 p=p1; p1=p2; p2=p;
 setvisualpage(p1);
 setactivepage(p2);
}

/*
 *********************************** dibuja fondo ************
 */
fondo()
{
setfillstyle(HATCH_FILL,4);
floodfill(0,0,5);
setfillstyle(255,3);
/* copiamos pantalla a buffer */
movedata(0xA000,0,_DS,(unsigned)&buffer,32000);

}



/*
 *********************************** IniEga() *************
 */
IniEGA()  /** Inicializa modo grafico **/
   {
   int modo = EGA ;
   int res  = EGALO ;
   initgraph (&modo, &res,"\\");
 }

