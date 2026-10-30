; BalloonOBJ.asm
; CSE3120 Contest 1
; Ioannis Limniatis

; Usage of STRUCT was utilized from https://learn.microsoft.com/en-us/cpp/assembler/masm/struct-masm?view=msvc-170
; Usage of call was utilized from https://www.coddykit.com/courses/assembly/defining-and-calling-procedures-2278939
; Usage of .IF and .ELSE utilized from https://learn.microsoft.com/en-us/cpp/assembler/masm/if-masm?view=msvc-170

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
tempPath Byte 200 * 2 DUP(0) ;Temporary until map is done
tempPathLen DWORD 200 ;Temporary until map is done
tempMoney DWORD 200; Temporary until maps and towers are closer to completion

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

;Places balloon at the start of the path

SpawnBalloon PROC

	push ebx
	push ecx
	push edx
	push esi

	movzx edx, al
	mov esi, OFFSET BalloonsArr
	mov ebx, 0
	mov ecx, maxBalloonCount

spawnLoopSearch:

	cmp		(Balloon PTR [esi]).active,0
	je		spawnLoopFound
	add		esi, SIZEOF Balloon
	inc		ebx
	loop	spawnLoopSearch
	;If every slot is full
	mov		eax, -1
	jmp		spawnloopEnd

spawnLoopFound:

	mov (Balloon PTR [esi]).active,1
	mov (Balloon PTR [esi]).hp,dl
	mov (Balloon PTR [esi]).moveTick,0
	mov (Balloon PTR [esi]).balloonPathing,0
	mov eax, ebx

spawnloopEND:

	pop esi
	pop edx
	pop ecx
	pop ebx
	ret

SpawnBalloon ENDP

;Runs when a balloon is popped so it can be removed from the map

popBalloon PROC

push esi
call balloonPointer

mov (Balloon PTR [esi]).active,0
pop esi
ret

popBalloon ENDP

;Finds the current map tile a balloon could be on for computation

findBalloon PROC

	push ebx
	push esi
	call balloonPointer
	mov ebx,(Balloon PTR [esi]).balloonPathing
	mov dl,tempPath ;tempPath is temporary, when map is done this will be done
	mov dh,tempPath ;tempPath is temporary, when map is done this will be done
	pop esi
	pop ebx
	ret

findBalloon ENDP

;Moves the balloon each tick according to the balloons speed.

moveBalloon PROC

	push eax
	push ebx
	push ecx
	push edx
	push esi

	mov esi, OFFSET BalloonsArr
	mov ebx, 0
	mov ecx, maxBalloonCount

	moveLoop:

	cmp (Balloon PTR [esi]).active,0
	je moveNextBalloon

	inc (Balloon PTR [esi]).moveTick

	movzx eax,(Balloon PTR [esi]).hp
	mov dl,balloonSpeed[eax]
	cmp (Balloon PTR [esi]).moveTick,dl
	jb	moveNextBalloon

	mov (Balloon PTR [esi]).moveTick,0
	inc (Balloon PTR [esi]).balloonPathing
	mov eax, (Balloon PTR [esi]).balloonPathing 
	cmp eax, tempPathLen ;Will be updated once maps are complete

	jb moveNextBalloon
	
	mov eax,ebx
	
	call popBalloon

	moveNextBalloon:

	add esi, SIZEOF Balloon
	inc ebx
	loop moveLoop

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

moveBalloon ENDP

;Computates the damage given to the balloon, decreaasing layers until there are non left and the balloon has to pop

damageBalloon PROC

	push eax
	push ebx
	push esi

	call balloonPointer

	mov dl, (Balloon PTR [esi]).hp

	.IF dl <= bl

		movzx ebx, dl
		add tempMoney, ebx
		call popBalloon

	.ELSE

		sub (Balloon PTR [esi]).hp,bl
		movzx ebx, bl
		add tempMoney, ebx

	.ENDIF

	pop esi
	pop ebx
	pop eax
	ret

damageBalloon ENDP

END