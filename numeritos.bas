' numeritos
' 2020 COMPILER SOFTWARE
' Versión Spectum: Miguel A. G. Prada.
' Juego original: Cardinal Chains de Daniel Nora.

' ###########################################################
' VARIABLES

' puntero apunta al nivel en juego y puntBuffer al buffer de pantalla.
DIM puntero, puntBuffer as uInteger

' LECTOR DEL CONTENIDO DE LA DIRECCIÓN DEL PUNTERO
DIM a as uByte
DIM a2 as uByte

' CONTADOR PARA VER SI TERMINAMOS EL NIVEL
' AL MAPEAR SUMAMOS EL VALOR DE CADA TILE Y, SEGÚN JUGAMOS, LO VAMOS RESTANDO. AL LLEGAR A CERO, NIVEL TERMINADO

DIM contador as UInteger

DIM dPause as uInteger

' NUMERO DE PLAYERS
DIM nPlayers as uByte

' PLAYER SELECCIONADO
' DE 0 A 5, CORRESPONDE CON EL COLOR -1 (para manejo de arrays). SE EMPIEZA SIEMPRE CON EL BLUE SELECCIONADO
DIM player as Byte

' LAS MEDIDAS EN TILES DEL NIVEL
DIM xAncho, yAlto as uByte

' LAS COORDENADAS DE IMPRESIÓN ESQUINA SUP/IZQ DEL NIVEL
DIM xBoard, yBoard as uByte

' NIVEL EN JUEGO Y MÁXIMO NÚMERO DE NIVELES
DIM level as Integer = 0
dim levelmax as Integer = 31

' PARA LA CADENA DEL MARCADOR DE NIVEL
DIM m$ as string

CONST tile as uInteger = 36

' MATRIZ DE DATOS DE CADA PLAYER
' X,Y,ATTR NO SELEC, ATTR SELEC, BUFF del valor del tile que  había antes de pisar con el player,
' MOVIMIENTOS, si el player se ha movido o está en el inicio (para el cambio de attr pos. inicial)

' dim players (5,5) as uByte => {_
'		{0,0,57,15,0,0},_
'		{0,0,58,23,0,0},_
'		{0,0,59,31,0,0},_
'		{0,0,60,39,0,0},_
'		{0,0,61,47,0,0},_
'		{0,0,62,55,0,0}_
'}

 dim players (5,5) as uByte => {_
		{0,0,65,72,0,0},_
		{0,0,66,80,0,0},_
		{0,0,67,88,0,0},_
		{0,0,68,96,0,0},_
		{0,0,69,104,0,0},_
		{0,0,70,112,0,0}_
 }

' MATRIZ DE PUNTEROS AL BUFFER POR CADA PLAYER
dim puntPlayers (5) as uInteger

' CONTROLES
DIM keyUp, keyDown, keyRight, keyLeft, keySelectLeft, keySelectRight, keyReset, keyMenu as uByte

keyUp = code "q"
keyDown = code "a"
keyRight = code "p"
keyLeft = code "o"
keySelectLeft = code "n"
keySelectRight = code "m"
keyReset = code "r"
keyMenu = code "t"

#include "tables.asm"

dim compiler, cardinal as string
compiler = "COMPILER SOFTWARE 2020"
cardinal = "CARDINAL CHAINS SPECTRUM"

' END VARIABLES
' ###########################################################

' ###########################################################
' MENU

menu:

border 0: paper 0: ink 0: bright 0: cls

print at 3, 4; bold 1; ink 1; cardinal
print at 23, 0; bold 1; ink 1; compiler; at 23, 28; "bout"; at 23,27; paper 1; ink 0; "A"
print at 10, 6; ink 1; "LEVEL SELECTED"; at 8, 24; "P"; at 12,23;"OWN"; ink 0; paper 1; at 8, 23; "U"; at 12, 22; "D"
print at 15, 6; ink 1; "PRESS SPACE TO START"

MENULOOP:
	print at 10, 22; bold 1; ink 1; "   "; at 10,22; level + 1

DO

	if inkey$ = "u"	then
	level = level + 1: pausa(5)
		if level > levelmax then
			level = 0
		end if
		go to MENULOOP
	end if

	if inkey$ = "d"	then
	level = level - 1: pausa(5)
		if level < 0
			level = levelmax
		end if
		go to MENULOOP
	end if

	if inkey$ = " " then pausa(10): go to BUCLE

	if inkey$ = "a" then about()

LOOP

' ###########################################################

' ###########################################################
' ABOUT

sub about()
	ink 3: bright 1:
	cls
	print at 3, 4; bold 1; cardinal
	print at 6, 0; "ORIGINAL PC GAME BY  DANIEL NORA"
	print AT 7, 4; "https://danijmn.itch.io"
	print at 10, 0; "SPECTRUM VERSION BY MIGUEL PRADA"
	print at 13, 11; "THANKS TO"
	print at 15, 9; "JAVIER  VISPE"
	print at 16, 9; "FEDE  ALVAREZ"
	print at 21, 2; "https://compiler.speccy.org"
	print at 23, 0; bold 1; compiler; at 23, 29; "ENU"; at 23,28; paper 3; ink 0; "M"
	
do
	if inkey$ ="m" then go to menu
loop

end sub
' ###########################################################

' ###########################################################
' BUCLE PRINCIPAL DEL JUEGO

BUCLE:

SETEO:
border 7: paper 7: ink 0: bright 0: cls
player = 0
players(0,4)=0
players(1,4)=0
players(2,4)=0
players(3,4)=0
players(4,4)=0
players(5,4)=0
players(0,5)=0
players(1,5)=0
players(2,5)=0
players(3,5)=0
players(4,5)=0
players(5,5)=0

INTERFACE()

puntero = tablelevels(level)

MAPEA()

while (contador > 0)

	if code inkey$ = keyReset then
	border 1
	pausa(30)		
	go to SETEO
	end if

	if code inkey$ = keyMenu then
	border 1
	pausa(30)		
	go to menu
	end if


	if code inkey$ = keySelectRight and nPlayers > 1 then
		
		if players(player, 5) = 0
		pintaTile(2)
		else
		pintaTile(3)
		end if
		
		player = player + 1
		if player = nPlayers then player = 0: end if
		
		if players(player ,5) = 0
		pintaTile(3)
		else
		pintaTile(2)
		end if
		
		coloreaNivel()
		pausa(10)
		beep 0.01,-12
	end if

	if code inkey$ = keySelectLeft and nPlayers > 1 then
		
		if players(player, 5) = 0
		pintaTile(2)
		else
		pintaTile(3)
		end if
		
		player = player - 1
		if player < 0 then player = nPlayers - 1: end if
		
		if players(player, 5) = 0
		pintaTile(3)
		else
		pintaTile(2)
		end if

		coloreaNivel()
		pausa(10)
		beep 0.01,-12
	end if

	if code inkey$ = keyRight and players(player,0) < (xBoard + (xAncho*2)-2) then
		a =  players(player,4)
		a2 = peek (puntPlayers(player)+1)
		if a <= a2 and a2 > 0 then
			players(player,4) = a2
			contador = contador - a2
			puntPlayers(player) = puntPlayers(player) + 1
			poke puntPlayers(player), 0
			pintaTile(3)
			players(player,0) = players(player,0) + 2
			pintaTile(3)
			pausa(8)
			players(player, 5) = 1
			beep 0.01,3
		end if
	end if

	if code inkey$ = keyLeft and players(player,0) > xBoard then
		a = players(player,4)
		a2 = peek (puntPlayers(player)-1)
		if a <= a2 and a2 > 0 then
			players(player,4) = a2
			contador = contador - a2
			puntPlayers(player) = puntPlayers(player) - 1
			poke puntPlayers(player), 0
			pintaTile(3)
			players(player,0) = players(player,0) - 2
			pintaTile(3)
			pausa(8)
			players(player, 5) = 1
			beep 0.01,3
		end if
	end if

	if code inkey$ = keyDown and players(player,1) < (yBoard + (yAlto * 2)-2) then
		a =  players(player,4)
		a2 = peek (puntPlayers(player) + xAncho)
		if a <= a2 and a2 > 0 then
			players(player,4) = a2
			contador = contador - a2
			puntPlayers(player) = puntPlayers(player) + xAncho
			poke puntPlayers(player), 0
			pintaTile(3)
			players(player,1) = players(player,1) + 2
			pintaTile(3)
			pausa(8)
			players(player, 5) = 1
			beep 0.01,3
		end if
	end if

	if code inkey$ = keyUp and players(player,1) > yBoard then
		a =  players(player,4)
		a2 = peek (puntPlayers(player) - xAncho)
		if a <= a2 and a2 > 0 then
			players(player,4) = a2
			contador = contador - a2
			puntPlayers(player) = puntPlayers(player) - xAncho
			poke puntPlayers(player), 0
			pintaTile(3)
			players(player,1) = players(player,1) - 2
			pintaTile(3)
			pausa(8)
			players(player, 5) = 1
			beep 0.01,3
		end if
	end if

end while
	
	' CAMBIO DE NIVEL
	level = level + 1
	
	if level > levelmax then level = 0: end if

	for d = 0 to 23
	print at d, 0; over 1; ink 2; "                                "
	pausa(1)
	next d

	go to BUCLE

' ###########################################################

' ###########################################################
' CUANDO AVANZAMOS POR EL TABLERO PINTA EL TILE QUE DEJA EL PLAYER DEL MISMO COLOR

FUNCTION pintaTile(type2 as uByte) as Integer

	dim puntATTR as uInteger
	puntATTR = cast(uInteger, players(player,1))*32 + cast(uInteger, players(player,0)) + 22528
	poke puntATTR, players(player, type2)
	poke puntATTR+1, players(player, type2)
	poke puntATTR+32, players(player, type2)
	poke puntATTR+33, players(player, type2)

END FUNCTION
' ###########################################################

' ###########################################################
' hace una pausa de n milisegundos

FUNCTION pausa(time as uByte) as uByte

	for dPause = 0 to time
	asm
	ei
	halt
	end asm
	next

END FUNCTION
' ###########################################################

' ###########################################################
' cambia el estado del player seleccionado.
' se le pasa un entero con:	2 para deseleccionar
'							3 para seleccionar

FUNCTION paintPlayer(type as uByte) as uByte

	poke (@CURSOR + 32),players(player,type):
	poke (@CURSOR + 33),players(player,type):
	poke (@CURSOR + 34),players(player,type):
	poke (@CURSOR + 35),players(player,type):
	putTile(players(player,0),players(player,1),@CURSOR)


end function
' ###########################################################

' ###########################################################

sub INTERFACE()

'IMPRIME MARCADOR DEL NIVEL
m$ = str$(level+1)
DIM prov as uByte = (24-(len(m$)*2))/2
for d = 0 to len (m$) - 1
	a = val(m$(d))
	putTile(0,prov,(@NUMBERS) + (a*tile))
	prov = prov+2
next

' PONE EL COLOR AL NIVEL CORRESPONDIENTE AL PLAYER SELECCIONADO

coloreaNivel()

end sub

'END INTERFACE
' ###########################################################

' ###########################################################
' MAPEA

sub MAPEA()
			' ENTRADA en puntero el nivel a volcar

			' SETEO DE VARIABLES
			puntBuffer = @BUFFER
			contador = 0
			 xAncho = peek (puntero)
			 yAlto = peek (puntero+1)
			puntero = puntero +2
			' CALCULA LAS COORDENADAS DE IMPRESIÓN DEL NIVEL
			' SIEMPRE LO CENTRA EN PANTALLA
			' IGNORA LAS DOS COLUMNAS DEL INTERFACE
			 xBoard = ((30-(xAncho*2))/2)+2
			 yBoard = (24-(yAlto*2))/2

			for d = yBoard to yBoard + (yAlto*2)-2 step 2

				for f = xBoard to xBoard + (xAncho*2)-2 step 2
					 a = peek (puntero)
					if a=0 then go to MAPEA00
					if a<10 then go to MAPEA01

					if a = 41 then
						a = 0:
						player = 0:
						nPlayers = 1:
						players(0,0) = f:
						players(0,1) = d:
						paintPlayer(3):
						puntPlayers(0) = puntBuffer
					end if

					if a = 42 then
						a = 0:
						player = 1:
						nPlayers = 2:
						players(1,0) = f:
						players(1,1) = d:
						paintPlayer(2):
						puntPlayers(1) = puntBuffer
					end if

					if a = 43 then
						a = 0:
						player = 2:
						nPlayers = 3:
						players(2,0) = f:
						players(2,1) = d:
						paintPlayer(2): 
						puntPlayers(2) = puntBuffer
					end if

					if a = 44 then
						a = 0:
						player = 3:
						nPlayers = 4:
						players(3,0) = f:
						players(3,1) = d:
						paintPlayer(2):
						puntPlayers(3) = puntBuffer
					end if

					if a = 45 then
						a = 0:
						player = 4:
						nPlayers = 5:
						players(4,0) = f:
						players(4,1) = d:
						paintPlayer(2):
						puntPlayers(4) = puntBuffer
					end if

					if a=46 then
						a = 0:
						player = 5:
						nPlayers = 6:
						players(5,0) = f:
						players(5,1) = d:
						paintPlayer(2):
						puntPlayers(5) = puntBuffer
					end if

					go to MAPEA00

MAPEA01:			putTile(f,d,(@TILES-36) + (a*tile))
MAPEA00:			poke (puntBuffer),a:  puntero = puntero + 1:  puntBuffer = puntBuffer + 1:  contador = contador + a
				next f

			next d
			player = 0

END SUB

' END MAPEA
' ###########################################################

' ###########################################################
' CAMBIA EL COLOR DEL INDICADOR DE NIVEL DE ACUERDO CON EL PLAYER SELECCIONADO

SUB coloreaNivel()

	for d = 9 to 14
		print at d,0; over 1; ink player + 1; "  "
	next

END SUB
' ###########################################################

#include "putTile.bas"
#include "graphs.asm"
#include "levels.asm"

' BUFFER DE PANTALLA
BUFFER:
ASM
DEFS 180,0
END ASM

