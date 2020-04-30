.8086
.MODEL small
.STACK 100h
.DATA

;
;
;
;
;
; rutinas para lectura de teclado y joystick.
;
;
;
;
; PC COMPATIBLE
;
; 
;
;
;
; lectura de teclas definidas por el jugador.
;
; datos de entrada:
; (stick)=0 no lee el joystick.  (stick)=1 lee el joystick.
; tabtec: inicio de los datos de las teclas a leer, en el siguiente orden.
;         (dos bytes por dato).
;
;	-dato 1: fuego.
;	-dato 2: arriba.
;	-dato 3: abajo.
;	-dato 4: izquierda.
;	-dato 5: derecha.
;	-dato 6: opcional (no es necesario ponerlo).
;	-dato 7: opcional (no es necesario ponerlo).
;
; tecab: inicio de los datos de lectura de la tecla de pausa.
;
; datos de salida:
; b: joystick o teclas pulsadas (en formato kempston).
;
; -bit 0 a 1: pulsado derecha.
; -bit 1 a 1: pulsado izquierda.
; -bit 2 a 1: pulsado abajo.
; -bit 3 a 1: pulsado arriba.
; -bit 4 a 1: pulsado fuego.
; -bit 5    : uso opcional.
; -bit 6    : uso opcional.
; -bit 7 a 1: pulsado abort.
;
;
;
;
;
;
;

numtec      equ       5

;
;

.CODE

teclas:     call      leetec
            mov       si,offset matec
            mov       bl,offset numtec
            mov       bh,0
            mov       ah,byte ptr cs:stick
            and       ah,ah
            mov       cx,offset tabjoys
            je        salta1
            jmp       tecla2
salta1:     mov       cx,offset tabtec
tecla2:     xchg      di,cx
            mov       ah,cs:[di]
            xchg      di,cx
            mov       byte ptr cs:tecpok+2,ah
tecpok:     mov       ah,cs:[si+0]
            inc       cx
            xchg      di,cx
            and       ah,cs:[di]
            xchg      di,cx
            je        salta2
            jmp       tecla1
salta2:     or        bh,128
tecla1:     rol       bh,1
            inc       cx
            dec       bl
            je        salta3
            jmp       tecla2
salta3:     
leepau:     mov       ah,byte ptr cs:tecab+1
            mov       bl,ah
            mov       ah,byte ptr cs:tecab
            mov       byte ptr cs:tecpok1+2,ah
tecpok1:    mov       ah,cs:[si+0]
            and       ah,bl
            je        paso1
            ret
paso1:      or        bh,128
            ret
;

tabjoys:    db          9,16,9,1,9,2,9,4,9,8    ; tabla para lectura del joystick.

;
;
;
; tabla para la lectura de la teclas durante el juego (modificable).
;
;

tabtec:     db          5,128,8,8,8,32,4,4,3,8  ; tabla (sp,q,a,o,p).
tecab:      db        	5,16,0,0		; abort (h).
stick:      db          0                       ; joystick s/n.

;
;
;
; ***************************************************************************
; ***************************************************************************
;
;
;
; lectura de teclado usada para redefinir, inputs, menu de opciones, etc,...
;
;
; datos de entrada: ninguno. 
; datos de salida:
; d: primer dato de lectura de la tecla (semi-fila).
; e: segundo dato de lectura de la tecla).
; (los dos datos anteriores son los que deben colocarse en la tabla tabtec).
; h: codigo standard de la tecla pulsada (0- no hay ninguna tecla pulsada).
;
; (la rutina no espera a que haya una tecla pulsada).
;
;
;
;
;
;
;
redef:      call      leetec
            mov       si,offset matec
            mov       dh,0
            mov       ch,1
            mov       bl,10
redef0:     mov       dl,1
            mov       bh,8
redef1:     mov       ah,cs:[si+0]
            and       ah,dl
            jne       salta4
            jmp       redef3
salta4:     shl       dl,1
            inc       ch
            dec       bh
            cmp       bh,0
            jne       redef1
            inc       dh
            inc       si
            dec       bl
            je        salta5
            jmp       redef0
salta5:     mov       ch,0
            ret
redef3:     mov       bl,ch
            mov       bh,0
            mov       cx,offset contec-1
            add       cx,bx
            xchg      di,cx
            mov       ah,cs:[di]
            xchg      di,cx
            mov       ch,ah
            ret
;
;
; tabla para conversion de la tabla de teclas de amstrad a formato standard.
; (80 bytes).
;
contec:     db        	63,66,64,62,59,56,48,67,65,47
            db        	60,61,58,54,55,53,51,72,40,69
            db        	57,45,75,46,50,49,52,16,68,73
            db        	74,71,27,36,15,9,12,11,13,70
            db        	35,34,21,25,8,10,14,37,33,32
            db        	18,20,7,6,2,22,31,30,5,23
            db        	19,4,3,24,28,29,41,17,42,1
            db        	43,26,0,0,0,0,0,0,0,44
;
;
;
;
;
;
; tabla de codigos amstrad:
;
; a-70   k-38   u-43   4-57     may-22   f0-16   cup-1    eny-30	
; b-55   l-37   v-56   5-50     ctr-24   f1-14   cdo-3    ?  -31
; c-63   m-39   w-60   6-49     cop-10   f2-15   cle-9    \  -23
; d-62   n-47   x-64   7-42     spc-48   f3-6    cri-2
; e-59   o-35   y-44   8-41     int-7    f4-21   .  -8
; f-54   p-28   z-72   9-34     =  -26   f5-13   ;  -29
; g-53   q-68   0-33   esc-67   pt -25   f6-5    +  -20
; h-45   r-51   1-65   tab-69   clr-17   f7-11   <  -40
; i-36   s-61   2-66   fim-71   ret-19   f8-12   >  -32
; j-46   t-52   3-58   bor-80   @  -27   f9-4    *  -18
;
; ***************************************************************************
; ***************************************************************************
;
;
;
;
; rutina general de lectura de teclado y joystick (usada por las anteriores).
;
;
leetec:     mov       cx,offset matec
            mov       bx,f40e
            mov       bh,f6
            and       ah,30
            mov       bl,ah
            or        ah,c0
            inc       bh
            mov       ah,92
            push      bx
            or        bl,64
leetec0:    mov       bh,f6
            mov       bh,f4
            xchg      di,cx
            mov       cs:[di],ah
            xchg      di,cx
            inc       cx
            inc       bl
            mov       ah,bl
            and       ah,f
            cmp       ah,ah
            je        salta6
            jmp       leetec0
salta6:     pop       bx
            mov       ah,82
            dec       bh
            ret

matec:      db       10,0 dup (0)

;
; ***************************************************************************
; ***************************************************************************
;
;
;
            mov       ax,4c00h
            int       21h

programa    endp

codigo      ends

datos       segment para 'data'
datos       ends

pila        segment para stack 'stack'
            dw     64 dup (?)
pila        ends
            end     programa
