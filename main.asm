; main.asm
; CSE3120 Contest 1
; Nicholas Bleeker

INCLUDE Irvine32.inc

BalloonInit PROTO

.data

.code

main PROC
	call BalloonInit
	exit

main ENDP
END main
