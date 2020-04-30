         mov  bx,Fileno                ;assignar handle del fitxer
         mov  ah,3Fh                   ;funci¢ del DOS per llegir d'un fitxer
         int  21h                      ;interrupci¢ per llegir
