.8086
.MODEL small
.STACK 100h
.DATA

mensaje  DB 'Hola, esto es un ejemplo en ASSEMBLER',13,10,12
longitud EQU $ - mensaje

.CODE

mov ax,@data
mov ds,ax
mov ah,40h              ; Salida por dispositivo PRN
mov bx,4
mov cx,longitud
mov dx,OFFSET mensaje
int 21h                 ; Interrupcion, imprime mensaje
mov ah,4ch              ; Final
int 21h                 ; Termina el programa

END

