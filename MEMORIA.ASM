.8086
.MODEL small
.STACK 100h
.DATA

mensaje DB      'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿  ',13,10
        DB      '³ (C) 1990 Javier Sanchez Alcazar ³  ',13,10
        DB      'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  ',13,10,0

mensaje2 DB     ' Kbytes de RAM',13,10,0

datos           EQU 0
longitud        EQU $ - mensaje
longitud2       EQU $ - mensaje2

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

memoria :               mov ah,12h              ; llamada funcion 12h
                        int 12h                 ; memoria RAM

                        mov ax,dx
                        mov ah,40h
                        mov bx,1
                        int 21h

Imprime :               mov ax,@data
                        mov ds,ax
                        mov ah,40h              ; Salida por dispositivo Pant.
                        mov bx,1
                        mov cx,longitud2
                        mov dx,OFFSET mensaje2
                        int 21h                 ; Interrupcion, imprime mensaje
                        ret

END



