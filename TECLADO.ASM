.8086
.MODEL small
.STACK 100h
.DATA

;
; desarrollado en Turbo Assembler por Javier Sanchez
; para PC Compatibles
;

;
; definicion de datos iniciales
; del teclado, junto descripciones
;
        derecha DB      80      ; letra P derecha
        arriba  DB      81      ; letra Q arriba
        abajo   DB      65      ; letra A abajo
        izqu    DB      79      ; letra O izquierda

        ;
        ; definicion de descripciones con retorno de carro
        ;

        desc    DB      'F - Salir al DOS',0dh,0ah,'$'
        desc0   DB      'R - Reconfigura teclado',0dh,0ah,'$'

        desc1   DB      ' - Derecha   ','$'     ; mensaje derecha
        desc2   DB      ' - Izquierda ','$'     ; mensaje izquierda
        desc3   DB      ' - Arriba    ','$'     ; mensaje arriba
        desc4   DB      ' - Abajo     ','$'     ; mensaje abajo
        
        desc5   DB      'Configuracion Tecla ','$'  ; mensaje configura
        return  DB      '',0dh,0ah,'$'              ; retorno de carro

        ;
        ; Definicion de Macros
        ;

        Gotoxy  macro   fila,columna  ; coloca cursor en coordenadas x,y
                mov ah,0fh            ; AH = 0fh, numero de funcion
                int 10h               ; Deja BH, pagina de video activa
                mov dh, fila
                mov dl, columna
                mov bh, 0             ; 0 = modo grafico / 1 = modo texto
                mov ah, 2             ; funcion de la BIOS
                int 10h               ; interrupcion de la BIOS
                endm

        Print   macro  texto                 ; imprime una cadena de texto
                mov ax,@data                 ; sin retorno de carro
                mov ds,ax
                mov ah,9
                mov dx,OFFSET texto
                int 21h
                endm

        Letra   macro  caracter
                mov dl,caracter             ; lee caracter y lo imprime
                mov ah,2
                int 21h
                endm


.CODE


        call Cga                ; llama a la rutina inicializacion
                                ; de la CGA
        call imprime_tecla      ; Imprime definicion de teclado en pantalla
        jmp lee_caracter        ; realiza un salto a la lectura de teclado


;
; Rutina de lectura del teclado
; Bloque principal
;
lee_caracter  : mov ah,7
                int 21h                 ; int 21 de la BIOS
                cmp al,82               ; si se pulsa la tecla R, redefinir
                jz redefine             ; salta a rutina redefinir teclado
                cmp al,114              ; si se pulsa la tecla r, redefinir
                jz redefine             ; salta a rutina redefinir teclado
                cmp al,70               ; si se pulsa F
                jz final                ; termina programa

            ;   mov dl,al               ; almacena caracter en dl
            ;   mov ah,2
            ;   int 21h                 ; visualiza caracter
                jmp lee_caracter        ; buelve al inicio


;
; final del programa
;

final         : mov ah,4ch              ; Final
                int 21h                 ; Termina el programa
                ret



;
; Rutina de redinicion del teclado de PC e impresion de la configuracion
; actual de este
;
redefine      : call reconfigura        ; Salta a la subrutina de reconfi-
                                        ; guracion del teclado
                jmp lee_caracter        ; devuelve el control al programa
                                        ; principal


reconfigura   : Print desc5             ; imprime descripcion 5
                Print desc2             ; imprime descripcion 2
                mov ah,7
                int 21h                 ; espera pulsacion sin eco
                mov izqu,al             ; almacena al en izquierda
                mov dl,al               ; almacena al en dl
                mov ah,2
                int 21h                 ; imprime nueva tecla
                Print return
                ;
                ; definicion del teclado
                ; derecho
                ;
                Print desc5             ; imprime descripcion 5
                Print desc1             ; imprime descripcion 1
                mov ah,7
                int 21h                 ; espera pulsacion sin eco
                mov derecha,al          ; almacena al en derecha
                mov dl,al               ; almacena al en dl
                mov ah,2
                int 21h                 ; imprime nueva tecla
                Print return
                ;
                ; definicion del teclado
                ; arriba
                ;
                Print desc5             ; imprime descripcion 5
                Print desc3             ; imprime descripcion 3
                mov ah,7
                int 21h                 ; espera pulsacion sin eco
                mov arriba,al           ; almacena al en derecha
                mov dl,al               ; almacena al en dl
                mov ah,2
                int 21h                 ; imprime nueva tecla
                Print return
                ;
                ; definicion del teclado
                ; abajo
                ;
                Print desc5             ; imprime descripcion 5
                Print desc4             ; imprime descripcion 4
                mov ah,7
                int 21h                 ; espera pulsacion sin eco
                mov abajo,al            ; almacena al en derecha
                mov dl,al               ; almacena al en dl
                mov ah,2
                int 21h                 ; imprime nueva tecla
                Print return

                call Cga                ; Inicializa modo grafico
                call imprime_tecla      ; Imprime configuracion de teclado
                ret                     ; retorna el control a redefine

;
; imprime configuracion del teclado del PC en pantalla
;

imprime_tecla :
                Gotoxy 1,1              ; colocacion de las coordenadas en 1,1
                Print desc
                Print return            ; imprime retorno de carro
                Print return
                Print desc0             ; imprime descripcion 0
                Print return
                Letra derecha           ; imprime letra1
                Print desc1             ; imprime descripcion 1
                Print return
                Letra izqu              ; imprime letra2
                Print desc2             ; imprime descripcion 2
                Print return
                Letra arriba            ; imprime letra3
                Print desc3             ; imprime descripcion 3
                Print return
                Letra abajo             ; imprime letra4
                Print desc4             ; imprime descripcion 4
                Print return
                Print return
                ret

;
; Configuracion de la pantalla grafica a 320x200 4 colore
;

Cga           : mov ah,0                ; BIOS modo de funcion
                mov al,4                ; modo de pantalla 320x200 4 colores
                int 10h                 ; ejecuta rutina de la BIOS
                ret


               END                     ; final del programa

