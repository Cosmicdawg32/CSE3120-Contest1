; main.asm
; CSE3120 Contest 1
; Nicholas Bleeker

INCLUDE masmTD.inc

.code
main PROC
    call SayHello
    call WaitMsg
    exit
main ENDP
END main
