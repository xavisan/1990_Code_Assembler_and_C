.8086
.MODEL small
.STACK 100h
.DATA


mensaje         DB '(C) 1990 Javier Sanchez',13,10,0
longitud        DB 80


; bloque principal del programa

.CODE

call Imprime_mensaje


mov ah,4ch              ; Final
int 21h                 ; Termina el programa




Imprime_mensaje :       mov ax,@data
                        mov ds,ax
                        mov ah,40h              ; Salida por dispositivo Pant.
                        mov bx,1
                        mov cx,longitud
                        mov dx,OFFSET mensaje
                        int 21h                 ; Interrupcion, imprime mensaje
                        ret

END




