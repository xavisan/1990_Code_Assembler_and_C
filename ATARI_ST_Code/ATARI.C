#include <graphics.h>
#include <fcntl.h>
#include <io.h>
#include <stdlib.h>
#include <dos.h>

char buffer[34000];
int word;
int a,b,fd,i;

main()
{
	int a,b;
	register int sc,k;
	a=VGA;
	b=VGALO;
	initgraph(&a,&b,"\\");
	fd=_open("orion1.PI1",O_RDONLY);
	_read(fd,buffer,34);
	sc=0;
	for (i=0;i<200;i++)
	{
		for (k=0;k<20;k++)
		{
			/* PLANO 1 */
			cambia_plano(1,sc);
			/* PLANO 2 */
			cambia_plano(2,sc);
			/* PLANO 3 */
			cambia_plano(4,sc);
			/* PLANO 1 */
			cambia_plano(8,sc);
			sc=sc+2;
		}
		sc=sc+40;
	}
	_close(fd);

}

cambia_plano(int plane,register int sc2)
{
	outportb(0x3c4,2);
	outportb(0x3c5,plane);
	_read(fd,&word,2);
	poke(0xa000,sc2,word);
}
init_ega()
{
	union REGS r;
	r.h.al=13;
	r.h.ah=0;
	int86(0x10,&r,&r);
}
