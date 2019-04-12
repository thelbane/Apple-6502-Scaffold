                        processor 6502
                        incdir "include"

                        seg main
                        org $c00

main                    subroutine
                        jsr HOME

                        jsr print
                        byte "YOUR PROGRAM WORKED!",0

                        jsr print
                        byte '","CALL ",[main]d,'"," TO RUN AGAIN.",0

                        jmp DOSWRM

; ****************************************
; includes
; ****************************************

                        include "stdio"
                        include "print"
