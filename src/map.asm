; map.asm
; CSE3120 Contest 1
; Nicholas Bleeker
; Temporary code to debug map building
INCLUDE masmTD.inc

.data
helloMsg BYTE "map.asm is functioning", 0

.code
SayHello PROC USES edx
    mov edx, OFFSET helloMsg
    call WriteString
    call Crlf
    ret
SayHello ENDP
END

