/*
 *
 * Revision :
 * Release  : 1.05
 *
 * Programa para instalaciones de programas de ICR. / Javier Sanchez
 * Fichero de configuraci¢n INSTALA.OPT
 * Primera linea indica numero de opciones
 * Linea segunda en adelante : Formato :
 * Fichero.BAT Descripcion (No superior a 36 Caracteres)
 *    ³
 *    ÀÄ> Longitud de 12 caracteres Maximo incluido "."
 *
 *    Open_Window(10,60,3,15,0,1,0xDB);
 *
 *
 */


/* Definicion de Includes */

#include "inc_def.h"


extern int pulsa_tecla(void);
extern void Open_Window(int f,int f1,int c, int c1, int col,int car);
extern void Encuadre(int f,int f1,int c,int c1,int col);

extern void OP1(void);
extern void OP2(void);
extern void OP3(void);
extern void OP4(void);
extern void OP5(void);

int    c_numero;         /* Numero de Opciones */
int    opcion=0;         /* Seleccion de la Opcion */
char   descrip[60];      /* Descripcion de la opcion Longitud Maxima 60 */
char   *file_o[10][13];  /* Nombre del fichero BAT a ejecutar */
int    n=0;
int numero=0;            /* Control para menu de generacion de BATS, si
                            numero=0, no sale menu con F1
                            numero=1, sale menu con F1
                            fichero INSTALA.DAT */


/* Linkar con graphics.lib */
/* Inicio del programa */

void main(void)
{
    FILE *fp;
    if ((fp=fopen("INSTALA.DAT","r"))==NULL) { clrscr();
        printf("** EROR DE CONFIGURACION **\n");
        printf("Fichero INSTALA.DAT no encontrado.");
        exit(1);
       }
       fscanf(fp,"%d",&numero);
       fclose(fp);

    clrscr();
    opciones();
    for(;;) {
    pulsa_opcion(numero);
    }
  }


/*
 * Lectura de las opciones e impresion para su posterior ejecucion
 *
 */
 opciones() {
    int x=0,xx=0,k=0;
    FILE *fichero;

    clrscr();
    Imprime_F_H();
    pinta_pantalla();
    if((fichero=fopen("INSTALA.OPT","r"))==NULL) {
        printf("\n\n** ERROR DE CONFIGURACION **");
        printf("\nFichero INSTALA.OPT de Instalaci¢n no encontrado");
        exit(1);
      }
      fscanf(fichero,"%d",&c_numero);  /* Lectura del numero de opciones */

      /* Control del numero maximo de opciones */
      if ((c_numero>9) || (c_numero<1)){
        printf("\n\n** ERROR DE CONFIGURACION ***\nError en [Opciones=%d]",c_numero);
        printf("\nRevise el fichero INSTALA.OPT\n");
        fclose(fichero);
        exit(1);
        }

     /* Imprime el encuadre de opciones en pantalla */
     _settextposition(6,11); printf("É");
     for(x=1;x<43;++x) printf("Í");  printf("»");
     for(x=1;x<c_numero+1;++x) {
        _settextposition(x+6,11);
        printf("º                                          º");
       }
       _settextposition(x+6,11); printf("È");
       for(x=1;x<43;++x) printf("Í"); printf("¼");


     /* Lee el fichero de opciones e imprime estas en pantalla */
     for(x=1;x<c_numero+1;++x) {
        fscanf(fichero,"%12s",file_o[x]);
        fgets(descrip,61,fichero);
        _settextposition(x+6,12);
        printf(" %01d - %-s",x,descrip);
           }

 fclose(fichero);
}


/*
 *
 *  Pulsa la opcion determinada X para seleccionar
 *  proceso de instalacion
 *
 */
pulsa_opcion(int dato) {
    int n=0;
    n=pulsa_tecla();

            if ( (n>48)&&(n<58) ) {  /* Numeros del 1-9 */
               system(file_o[n-48]);
               _setbkcolor(0);
               _setcolor(0);
               _settextcolor(7);
               opciones();  }

             if (n==ESC) {
               CURON();
               _setbkcolor(0);
               _setcolor(0);
               _settextcolor(7);
               clrscr();
               printf("Instalador de Aplicaciones - Revisi¢n 1.05 \n.");
               exit(1); }


            if ((n==F1) && (dato==109)) {
                _setbkcolor(3);
                Encuadre(17,60,11,16,0);
                Open_Window(17,59,10,15,0x13,0xDB);
                  _settextposition(11,19); _outtext (" 1. Generar fichero CONFIG.SYS");
                  _settextposition(12,19); _outtext (" 2. Generar fichero BAT D41B");
                  _settextposition(13,19); _outtext (" 3. Generar fichero BAT D41D");
                  _settextposition(14,19); _outtext (" 4. Generar fichero BAT D41B+VR");
                  _settextposition(15,19); _outtext (" 5. Generar fichero BAT D41D+VR");
                  n=pulsa_tecla();
                  printf("%d",n);
                     if (n-48==1) OP1();  /* Numero 1 */
                     if (n-48==2) OP2();  /* Numero 2 */
                     if (n-48==3) OP3();  /* Numero 3 */
                     if (n-48==4) OP4();  /* Numero 4 */
                     if (n-48==5) OP5();  /* Numero 5 */
               _setbkcolor(0);
               _setcolor(0);
               _settextcolor(7);
                opciones();
              }


}


/*
 *
 * Dibuja la trama de fondo de la pantalla de trabajo.
 *
 */
 pinta_pantalla() {
    register int x=0,y=0;
    char *buffer;

    Open_Window(0,80,1,24,0x13,0xB1);

        _setbkcolor(11);
        _settextcolor(14);
        _settextposition(24,1);
        if(numero==109) {
        _outtext("                [F1-Menu de Generaci¢n de BATS] - [ESC- Salir]     ");
        _outtext("             ");
          } else {
        _outtext (" [ESC] - Salir "); }
}


/*
 * Impresion Fecha en linea en color + (Copyright) ICR.
 *
 */
 Imprime_F_H() {
    char buffer[32];
    int n=0;
    _setbkcolor(4);
    _setcolor(4);
    _settextcolor(15);
    for (n=0;n<80;++n) _outtext(" ");
    _settextcolor(15);
    Fecha(1,60);
    _settextposition(1,20);
    _settextcolor(11);
    sprintf(buffer,"Instalaci¢n (C)1992 I.C.R, S.A.");
    _outtext(buffer);
    _settextcursor(0x2000);

    _setbkcolor(0);
    _setcolor(0);
    _settextcolor(0);
 }




/*
 * Imprime un texto ASCII
 *
 */
Imprime_P(char nombre[12]) {
     FILE *fp;
     char p;

     if((fp=fopen(nombre,"r"))==NULL) {
        printf("Fichero %s no encontrado.\n",nombre);
        exit(1);
        }

      while (!feof(fp)) {
             p=fgetc(fp);
             printf("%c",p);
            }
      fclose(fp);
    }


/*
 * Escribe la hora actual del sistema en pantalla coordenadas 1,1
 *
 */
Hora(int x,int y) {
    char buffer[3];
    struct dostime_t Var;
    _dos_gettime( &Var );
    _settextposition(x,y);
    _setbkcolor(4);
    _setcolor(4);
    _settextcolor(30);
    sprintf(buffer,"%02d:",Var.hour);   _outtext(buffer);
    sprintf(buffer,"%02d:",Var.minute); _outtext(buffer);
    sprintf(buffer,"%02d",Var.second);  _outtext(buffer);
 }
 /*
  * Impresion de la Fecha del sistema
  *
  */
Fecha(int x, int y) {
    char buffer[3],buffer2[5];
    struct dosdate_t Var;
    _dos_getdate(&Var);
    _settextposition(x,y);
    _settextcolor(15);
    sprintf(buffer,"%02d",Var.day);
           _outtext(buffer);
           if (Var.month==1)  _outtext("/Enero/");
           if (Var.month==2)  _outtext("/Febrero/");
           if (Var.month==3)  _outtext("/Marzo/");
           if (Var.month==4)  _outtext("/Abril/");
           if (Var.month==5)  _outtext("/Mayo/");
           if (Var.month==6)  _outtext("/Junio/");
           if (Var.month==7)  _outtext("/Julio/");
           if (Var.month==8)  _outtext("/Agosto/");
           if (Var.month==9)  _outtext("/Septiembre/");
           if (Var.month==10) _outtext("/Octubre/");
           if (Var.month==11) _outtext("/Noviembre/");
           if (Var.month==12) _outtext("/Diciembre/");
    sprintf(buffer2,"%04d",Var.year);
    _outtext(buffer2);
}

