; masmTD.inc
; CSE3120 Contest 1
; Nicholas Bleeker

INCUDE Irvine32.inc

; Map size
mapW = 60   ; map width in tiles (each tile = 2 chars)
mapH = 30   ; map height in tiles
mapTiles = mapW * mapH
screenW = 121   ; 120 + 1 so rows dont wrap
screenH = 37
hudRow = mapH   ; HUD row to start under the map

; Max values
maxBalloons = 100
maxTowers = 40
maxPath = 256
TickMS = 40     ; game tick rate (25 ticks/sec)

; Game rules
numRounds = 10
startMoney = 650
startHeath = 50     
sellValue = 70      ; refund percentage when selling tower (70% original value)
roundBonus = 100    ; end of round money bonus