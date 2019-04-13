; ****************************************
; main.asm
; Copyright (C) 20XX [your_name_here]
; ****************************************

                        processor 6502
                        incdir "include"

                        echo "main length:",[main_end-main]d,"bytes"
; ****************************************
; main
; ****************************************

                        seg
                        org $c00

main                    subroutine

                        jsr HOME                ; Clear the screen

                        jsr print
                        byte "YOUR PROGRAM WORKED!",0

                        jsr print
                        byte '","CALL ",[main]d,'"," TO RUN AGAIN.",0

                        jmp DOSWRM              ; Return to Applesoft

; ****************************************
; includes
; ****************************************

                        include "stdio"
                        include "print"

main_end