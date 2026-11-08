; TowerObj.asm
; CSE 3120 Contest 1
; Ioannis Limniatis, Nick Bleeker

Include masmTD.inc

findTarget PROTO ;Not written yet, will be added to BalloonObj will find the closest balloon in range
damageBalloon PROTO
EXTERNDEF tempMoney:DWORD

maxTowers = 10 ;current max towers, can be changed
towerCost = 50 ;cost needed to place a tower, can be changed
towerRange = 4 ;How far the tower sees, can be changed
towerFireRate = 1 ; How fast the tower fires, can be changed
towerDamage = 1 ; How much damage the tower does, can be changed

towerVisual = ((magenta SHL 4) OR white) OR ('/' SHL 8) OR ('\' SHL 16)

.data

towerX BYTE maxTowers DUP(0)
towerY BYTE maxTowers DUP(0)
towerTicksPerFrame BYTE maxTowers DUP(0)
towerCount DWORD 0

.code

;Places a tower under the cursor if it is a valid spot to place a tower, checks if there is money to place

placeTower PROC

	push eax
	push ebx
	push edx

	mov eax, towerCount
	cmp eax, maxTowers

	jae placeDone

	mov eax, tempMoney
	cmp eax, towerCost

	jb placeDone

	mov ebx, cursorY
	imul ebx, MAP_W
	add ebx, cursorX

	cmp mapGrid[ebx], T_GRASS
	jne placeDone

	mov mapGrid[ebx], T_TOWER
	mov baseLook[ebx*4], towerVisual
	sub tempMoney, towerCost

	mov edx, towerCount
	mov eax, cursorX
	mov towerX[edx], al
	mov eax, cursorY
	mov towerY[edx], al
	mov towerTicksPerFrame[edx], 0
	inc towerCount

placeDone:

	pop edx
	pop ebx
	pop eax
	ret

placeTower ENDP

towerTick PROC

	push eax
	push ebx
	push ecx
	push edx
	push esi

	mov ecx, towerCount
	cmp ecx, 0
	je towerTickDone

	mov esi, 0

towerLoop:

	cmp towerTicksPerFrame[esi], 0
	je towerReadyShoot

	dec towerTicksPerFrame[esi]
	jmp towerNext

towerReadyShoot:

	mov dl, towerX[esi]
	mov dh, towerY[esi]
	mov bl, towerRange
	call findTarget
	cmp eax, -1

	je towerNext

	mov bl, towerDamage
	call damageBalloon
	mov towerTicksPerFrame[esi], towerFireRate

towerNext:

	inc esi
	loop towerLoop

towerTickDone:

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

towerTick ENDP

END