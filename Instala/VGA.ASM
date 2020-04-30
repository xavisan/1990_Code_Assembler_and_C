                          name     vga
                          page     55,80
                          title    'vga.obj --- funcions per EGA/VGA'

.MODEL HUGE
Fileno   equ  [bp + 6]
EquiFis  equ  487h

.DATA
Memo     db   38400 dup(0)

.CODE
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³   SaveGrScr                                                                ³
;³                                                                            ³
;³   Salva els 4 plans d'una pantalla gr…fica en un fitxer. El fitxer habr    ³
;³   sigut obert prŠviament. Adem‚s, habrem posicionat el punter all… a on    ³
;³   voldrem que comen‡i a gravar.                                            ³
;³   Considerarem que ens trobem en una pantalla VGA 640x480 16 colors.       ³
;³                                                                            ³
;³   int SaveGrScr(Fileno)                                                    ³
;³   int Fileno; /* Descriptor de fitxer, prŠviament obert. */                ³
;³                                                                            ³
;³   Oscar Ortega                                                             ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         public _SaveGrScr
_SaveGrScr    proc
         ;*** Salvar registres
         push bp
         mov  bp,sp
         push bx
         push cx
         push dx
         push di
         push si
         push ds
         push es
         ;*** Preparar les dades neces…ries
         mov  bx,3                     ;BX=comptador de plans
         mov  dx,3CEh                  ;seleccionar el READ MAP SELECT
         mov  al,4                     ;del GRAPHICS CONTROLLER
         out  dx,al
         mov  ax,0A000h                ;carregar segment de pantalla gr…fica
         mov  ds,ax                    ;al registre DS
DumpPlaneLoop: ;*** Bucle per gravar els 4 plans
         mov  al,bl                    ;seleccionar el segent pla per llegir
         mov  dx,3CFh
         out  dx,al
         xor  dx,dx                    ;offset de pantalla (DX=0)
         mov  cx,38400                 ;salvar 38400 bytes (38400x8=307200bits)
         push bx                       ;salvar a la pila el comptador de plans
         mov  bx,Fileno                ;assignar handle del fitxer
         mov  ah,40h                   ;funci¢ del DOS per gravar en fitxer
         int  21h                      ;interrupci¢ per gravar
         pop  bx                       ;restaurar el comptador de plans
         jc   NoGrava                  ;saltar si error al gravar
         cmp  ax,38400
         jne  NoGrava                  ;o si no ho ha gravat tot
         dec  bx                       ;hem fet tots els plans?
         jge  DumpPlaneLoop            ;si ‚s que no, repetir operaci¢
         ;*** Avisar de que hem acabat correctament, i acabar.
         mov  ax,1
         push ax
         jmp  Restaura
NoGrava: ;*** Avisar de que ha hagut un error, i acabar.
         mov  ax,0
         push ax
Restaura: ;*** Restaurar READ MAP SELECT REGISTER
         mov  dx,3CEh
         mov  al,3
         out  dx,al
         inc  dx
         mov  al,0                     ;restaurar
         out  dx,al                    ;ficant com a pl… de lectura el pl… 0
         ;*** Recuperar valor de retorn inicialitzat abans
         pop  ax
         ;*** Recuperar registres i acabar
         pop  es
         pop  ds
         pop  si
         pop  di
         pop  dx
         pop  cx
         pop  bx
         mov  sp,bp
         pop  bp
         ret
_SaveGrScr    endp
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³   LoadGrScr                                                                ³
;³                                                                            ³
;³   Carrega els 4 plans d'una pantalla gr…fica en un fitxer. El fitxer habr  ³
;³   sigut obert prŠviament. Adem‚s, habrem posicionat el punter all… a on    ³
;³   voldrem que comen‡i a gravar.                                            ³
;³   Considerarem que ens trobem en una pantalla VGA 640x480 16 colors.       ³
;³                                                                            ³
;³   int LoadGrScr(Fileno)                                                    ³
;³   int Fileno; /* Descriptor de fitxer, prŠviament obert. */                ³
;³                                                                            ³
;³   Oscar Ortega                                                             ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         public _LoadGrScr
_LoadGrScr    proc
         ;*** Salvar registres
         push bp
         mov  bp,sp
         push bx
         push cx
         push dx
         push di
         push si
         push ds
         push es

         assume ds:_DATA
         mov  ax,_DATA
         mov  ds,ax

         ;*** Preparar les dades neces…ries
         mov  bx,8                     ;BX=comptador de plans
         mov  dx,3C4h                  ;seleccionar el PLANE ENABLE REGISTER
         mov  al,2                     ;del SEQUENCER
         out  dx,al

         mov  ax,0A000h                ;carregar segment de pantalla gr…fica
         mov  es,ax                    ;al registre ES

LoadPlaneLoop: ;*** Bucle per carregar els 4 plans
         mov  al,bl                    ;seleccionar el segent pl… per gravar
         mov  dx,3C5h
         out  dx,al

         push bx                       ;salvar a la pila el comptador de plans
         lea  dx,Memo
         mov  cx,38400                 ;llegir 38400 bytes (38400x8=307200bits)
         mov  bx,Fileno                ;assignar handle del fitxer
         mov  ah,3Fh                   ;funci¢ del DOS per llegir d'un fitxer
         int  21h                      ;interrupci¢ per llegir
         push ax
         mov  cx,38400
         lea  bx,Memo
         xor  di,di
copia:   mov  al,byte ptr [bx]
         mov  byte ptr es:[di],al
         inc  di
         inc  bx
         loop copia
         pop  ax
         pop  bx                       ;restaurar el comptador de plans

         jc   NoLlegeix                ;saltar si error al llegir
         cmp  ax,38400
         jne  NoLlegeix                ;o si no ho ha llegit tot
         shr  bx,1                     ;hem fet tots els plans?
         jnz  LoadPlaneLoop            ;si ‚s que no, repetir operaci¢

         ;*** Avisar de que hem acabat correctament, i acabar.
         mov  ax,1
         push ax
         jmp  Restaura2

NoLlegeix: ;*** Avisar de que ha hagut un error, i acabar.
         mov  ax,0
         push ax

Restaura2: ;*** Restaurar PLANE ENABLE REGISTER
         mov  dx,3C4h
         mov  al,2
         out  dx,al
         inc  dx
         mov  al,0Fh                   ;restaurar
         out  dx,al                    ;ficant tots 4 plans per escriure

         ;*** Recuperar valor de retorn inicialitzat abans
         pop  ax

         ;*** Recuperar registres i acabar
         pop  es
         pop  ds
         pop  si
         pop  di
         pop  dx
         pop  cx
         pop  bx
         mov  sp,bp
         pop  bp
         ret
_LoadGrScr    endp
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³   VideoOn                                                                  ³
;³                                                                            ³
;³   Activa la pantalla. Aquesta funci¢ ‚s util nom‚s per VGA.                ³
;³                                                                            ³
;³   void VideoOn()                                                           ³
;³                                                                            ³
;³   Oscar Ortega                                                             ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         public _VideoOn
_VideoOn      proc
         ;*** Salvar registres
         push ax
         push bx
         ;*** Activar la pantalla
         mov  ah,12h
         mov  bl,36h
         mov  al,0h
         int  10h
         ;*** Recuperar registres i acabar
         pop  bx
         pop  ax
         ret
_VideoOn      endp
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³   VideoOff                                                                 ³
;³                                                                            ³
;³   Desactiva la pantalla. Aquesta funci¢ ‚s util nom‚s per VGA.             ³
;³                                                                            ³
;³   void VideoOff()                                                          ³
;³                                                                            ³
;³   Oscar Ortega                                                             ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         public _VideoOff
_VideoOff     proc
         ;*** Salvar registres
         push ax
         push bx
         ;*** Desactivar la pantalla
         mov  ah,12h
         mov  bl,36h
         mov  al,1h
         int  10h
         ;*** Recuperar registres i acabar
         pop  bx
         pop  ax
         ret
_VideoOff     endp
         end

