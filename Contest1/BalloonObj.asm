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

BalloonsArr Balloon maxBalloonCount DUP (<>)

.code

;Retrieve the index of the balloon and turn it into an address for the struct

balloonPointer PROC

	push eax
	mov esi, OFFSET BalloonsArr
	imul eax, SIZEOF Balloon

	add esi, eax
	pop eax
	ret

balloonPointer ENDP

; Clear the balloon slot on startup and restart, so games can start with no balloons on the map

BalloonInit PROC
	
	push ecx
	push esi
	mov esi, OFFSET BalloonsArr
	mov ecx, maxBalloonCount * SIZEOF Balloon

ClearLoop:

	mov BYTE PTR [esi], 0
	inc esi
	loop ClearLoop
	pop esi
	pop ecx
	ret

BalloonInit ENDP

END