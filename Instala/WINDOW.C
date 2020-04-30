/* Includes a utilizar */

#include "inc_def.h"
#include "colores.h"


unsigned char _far *window = (unsigned char _far *)0xb8000000L;

/*
 *  Abre una Ventana de texto, con color y fondo de color
 *
 */
Open_window (int i_fila,int f_fila,int i_col,int f_col,int color, int caracter) {
    int x,y;

    if (i_fila<0) Mensaje_error();
    if (i_fila>80) Mensaje_error();
    if (i_col<0) Mensaje_error();
    if (i_col>25) Mensaje_error();

    /* Funci¢n de relleno de color */
    for (x=i_col;x<f_col;++x)
       for (y=i_fila;y<f_fila;++y) {
          *(window+(x*160)+(y*2)+0) = caracter;
          *(window+(x*160)+(y*2)+1) = color;
        }
}

/*
 *  Mensaje de error en la apertura de una ventana.
 *
 */
Mensaje_error() {
  clrscr();
  printf ("** Error en Open_Window **"); exit(1);
  }


/*
 * Rutina de Encuadre
 *
 */
 Encuadre (int i_fila,int f_fila,int i_col,int f_col,int color) {
     register int x;

     _settextcolor(color);
/*     _settextposition(i_col-1,i_fila-1); _outtext("É"); */
     _settextposition(i_col-1,i_fila); _outtext("É");
     for(x=i_fila;x<f_fila-1;++x) _outtext("Í");  _outtext("»");
     for(x=i_col;x<f_col;++x) {
        _settextposition(x,i_fila);
        _outtext("º");
        _settextposition(x,f_fila);
        _outtext("º");
       }
       _settextposition(x,i_fila); _outtext("È");
       for(x=i_fila;x<f_fila-1;++x) _outtext("Í"); _outtext("¼");
 }

