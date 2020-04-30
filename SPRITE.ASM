.8086
.MODEL small
.STACK 100h
.DATA

;
; desarrollado en Turbo Assembler por Javier Sanchez
; para PC Compatibles
;


.CODE

org 100h

inicio : jmp instalar
         call final

;
; final del programa
;

final         : mov ah,4ch              ; Final
                int 21h                 ; Termina el programa
                ret

                
;
; instalacion de nuevo font de Caracteres
;

tabla label byte

        db 0FCh,0FCh,0CCh,0CCh,0CCh,0FCh,0FCh,000h  ; ASCII 128
        db 0E0h,0E0h,0E0h,0FCh,01Ch,01Ch,01Ch,000h  ; ASCII 129


instalar proc
                mov ax,0
                mov es,ax                       ; cambio vector de interrupcion
                mov es:[1Fh*4],OFFSET tabla     ; desplazamiento
                mov es:[1Fh*4+2],cs             ; segmento

                ;
                ; dejar residente la tabla y volver al DOS
                ;
                mov dx,OFFSET instalar          ; dx = ultima direc + 1
                int 27h                         ; terminar. dejando residente

                ;
                instalar endp


                END                     ; final del programa

