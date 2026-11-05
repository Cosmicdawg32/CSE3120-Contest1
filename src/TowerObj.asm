; TowerObj.asm
; CSE 3120 Contest 1
; Ioannis Limniatis, Nick Bleeker

Include masmTD.inc

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

END