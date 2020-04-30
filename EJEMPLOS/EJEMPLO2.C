#include <graphics.h>
#include <fcntl.h>
#include <io.h>
#include <stdlib.h>
#include <dos.h>

char buffer[34000];
int word;
int a,b,fd,i,v;

main()
{
	int a,b;
	register int sc,k;
	a=VGA;
	b=VGALO;
	initgraph(&a,&b,"\\");
	fd=_open("64x64.mbk",O_RDONLY);
	_read(fd,buffer,796);
	sc=0;
	for (i=0;i<200;i++) /* numero de sprites */
	{

		for (k=0;k<64;k++) /* altura */
		{

	       /* hace linea de 64, con 4 de 64
		  con 3 de 48 con 2 de 32 si 1 de
		  16, cada vez se suman 16 */

		       for(v=0;v<4;v++)
			{
			cambia_plano(1,sc);
			cambia_plano(2,sc);
			cambia_plano(4,sc);
			cambia_plano(8,sc);
			sc=sc+2;
			}

	      /* longitud de pantalla menos ancho de sprite en bytes */
		 sc=sc+72;
		}

		/* saltarse 512 bytes de mierda */
	  _read(fd,buffer,512);
	  sc=0;

	}
	_close(fd);
}



/*
 ***************************************************
 ***************************************************
 */
cambia_plano(int plane,register int sc2)
{
	outportb(0x3c4,2);
	outportb(0x3c5,plane);
	_read(fd,&word,2);
	poke(0xa000,sc2,word);
}

/*
 ***************************************************
 ***************************************************
 */

init_ega()
{
	union REGS r;
	r.h.al=13;
	r.h.ah=0;
	int86(0x10,&r,&r);
}
