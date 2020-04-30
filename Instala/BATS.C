/*
 *  fichero bats.c
 *
 */

 #include "inc_def.h"
 #include "colores.h"



 /*
  * Genera Fichero AUTOEXEC.BAT
  *
  */
 OP1() {
    FILE *fp;
    fp=fopen("C:CONFIG.SYS","w");
       fprintf(fp,"device=c:himem.sys\n");
       fprintf(fp,"device=c:emm386.exe 1024 M9\n");
       fprintf(fp,"dos=high,umb\n");
       fprintf(fp,"devicehigh=c:ansi.sys\n");
       fprintf(fp,"buffers = 30\n");
       fprintf(fp,"files = 99\n");
    fclose(fp);
  }

/*
 *
 *
 *
 */
OP2() {
    FILE *fp;
    fp=fopen("C:DRV.BAT","w");
      fprintf(fp,"@echo off\n");
      fprintf(fp,"d40drv -h5 -j -e256 -i48\n");
    fclose(fp);
 }


/*
 *
 *
 *
 */
OP3() {
    FILE *fp;
    fp=fopen("C:DRV.BAT","w");
      fprintf(fp,"@echo off\n");
      fprintf(fp,"sbload\n");
      fprintf(fp,"d40drv -h5 -j -e256 -i48\n");
    fclose(fp);
 }



/*
 *
 *
 *
 */
 OP4() {
    FILE *fp;
    fp=fopen("C:DRV.BAT","w");
      fprintf(fp,"@echo off\n");
      fprintf(fp,"d40drv -h5 -j -e256 -i48\n");
      fprintf(fp,"d4xdnld vr40\n");
      fprintf(fp,"vrxdrv\n");
      fprintf(fp,"vrxdnld -h5\n");
    fclose(fp);
 }


/*
 *
 *
 *
 */
 OP5() {
    FILE *fp;
    fp=fopen("C:DRV.BAT","w");
      fprintf(fp,"@echo off\n");
      fprintf(fp,"sbload\n");
      fprintf(fp,"d40drv -h5 -j -e256 -i48\n");
      fprintf(fp,"d4xdnld vr40\n");
      fprintf(fp,"vrxdrv\n");
      fprintf(fp,"vrxdnld -h5\n");
    fclose(fp);
 }
