; BalloonOBJ.asm
; CSE3120 Contest 1
; Ioannis Limniatis

; Usage of STRUCT was utilized from https://learn.microsoft.com/en-us/cpp/assembler/masm/struct-masm?view=msvc-170

INCLUDE Irvine32.inc

maxBalloonCount = 100
balloonRed = 1
balloonYellow = 2
balloonBlue = 3
balloonGreen = 4

Balloon STRUCT
	active BYTE ?
	balloonType BYTE ?
	hp BYTE ?
	moveTick BYTE ?
	balloonPathing DWORD ?

Balloon ENDS

.data

balloonSpeed BYTE 4, 3, 2, 1 ;Tickspeed setup, subject to change through testing goes in the order red yellow blue green
balloonHealth BYTE 1, 2, 3, 4 ; Health setup, subject to change through testing follows the order of red yellow blue greeen
.code

BalloonInit PROC
	ret

BalloonInit ENDP

END