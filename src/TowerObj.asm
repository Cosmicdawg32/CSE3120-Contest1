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

placeDone:

	pop edx
	pop ebx
	pop eax
	ret

placeTower ENDP

END