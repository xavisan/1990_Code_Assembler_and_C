
/* Defnicion de Includes */

#include <stdio.h>
#include <string.h>
#include <io.h>
#include <graph.h>
#include <dos.h>
#include <conio.h>
#include <bios.h>
#include <process.h>


#define clrscr()   _clearscreen(_GCLEARSCREEN)

/*
 *
 * Si se ha pulsado la tecla F1 aparece otro men£ de opciones
 *
 */
int pulsa_tecla() {
    /* Inicia un proceso sin FIN */
    int n;
    for(;;) {
        Hora(1,2);
        if(kbhit()) {
            n=getch();
            return(n);
               }
          }
 }
