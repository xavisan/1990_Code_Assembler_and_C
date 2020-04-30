.8086
.MODE small
.STACK 100h
.DATA

MAXIMA_LONGITUD_STRING  EQU     1000
String_everse           DB      MAXIMA_LONGITUD_STRING DUP(?)
Reverse_string          DB      MAXIMA_LONGITUD_STRING DUP(?)


.CODE

        mov     ax,@data
        mov     ds,ax
        mov     ah,3fh
        mov     bx,MAXIMA_LONGITUD_STRING
        mov     dx,OFFSET String_everse
        int     21h

        and     ax,ax
        jz      Final
        mov     cx,ax

        push    cx
        mov     bx,OFFSET

