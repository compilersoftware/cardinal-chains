' numeritos
' 2020 COMPILER SOFTWARE

' ###########################################################
' VARIABLES

' puntero apunta al nivel en juego y puntBuffer al buffer de pantalla.
DIM puntero, puntBuffer as uInteger

' LECTOR DEL CONTENIDO DE LA DIRECCIÓN DEL PUNTERO
DIM a as uByte

' CONTADOR PARA VER SI TERMINAMOS EL NIVEL
' AL MAPEAR SUMAMOS EL VALOR DE CADA TILE Y, SEGÚN JUGAMOS, LO VAMOS RESTANDO. AL LLEGAR A CERO, NIVEL TERMINADO

DIM contador as UInteger

' AQUÍ SE COLOCAN LAS COORDENADAS DE MOVIMIENTO ACTUALES DEPENDIENDO DEL PLAYER ELEGIDO
DIM xProta, yProta as uByte

' NUMERO DE PLAYERS
DIM nPlayers as uByte

' PLAYER SELECCIONADO
' DE 0 A 5, CORRESPONDE CON EL COLOR -1 (para manejo de arrays). SE EMPIEZA SIEMPRE CON EL BLUE SELECCIONADO
DIM player as Byte

' LAS MEDIDAS EN TILES DEL NIVEL
DIM xAncho, yAlto as uByte

' LAS COORDENADAS DE IMPRESIÓN ESQUINA SUP/IZQ DEL NIVEL
DIM xBoard, yBoard as uByte

' NIVEL EN JUEGO
DIM level as uByte = 107

' PARA LA CADENA DEL MARCADOR DE NIVEL
DIM m$ as string

CONST tile as uInteger = 36

' MATRIZ DE DATOS DE CADA PLAYER
' X,Y,ATTR NO SELEC, ATTR SELEC.

dim players (5,3) as uByte => {_
		{0,0,57,15},_
		{0,0,58,23},_
		{0,0,59,31},_
		{0,0,60,39},_
		{0,0,61,47},_
		{0,0,62,55}_
}

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

' END VARIABLES
' ###########################################################


' COMIENZO DE SETEO PROVISIONAL
SETEO:
border 0: paper 0: ink 7: cls
poke UINTEGER 23675, @UDG
player = 0

go sub INTERFACE
puntero = @LEVELPR
go sub MAPEA

fin: go sub BUCLE: go to fin 

stop

'puntBuffer=(((yProta/2)*16)+(xProta/2))+@BUFFER
'putTile(xProta,yProta,grafProta1)

' ###########################################################
' BUCLE PRINCIPAL DEL JUEGO
BUCLE:

if code inkey$= keySelectRight and nPlayers > 0 then
	paintPlayer(2)
	let player = player + 1
	if player = nPlayers then player = 0: end if
	paintPlayer(3)
	go sub PLINTERFACE
	pausa(10)
	beep 0.01,-12
end if

if code inkey$= keySelectLeft and nPlayers > 0 then
	paintPlayer(2)
	let player = player - 1
	if player < 0 then player = 5: end if
	paintPlayer(3)
	go sub PLINTERFACE
	pausa(10)
	beep 0.01,-12
end if

return
' ###########################################################

' ###########################################################
' hace una pausa de n milisegundos
FUNCTION pausa(time as uByte) as uByte

	for d = 0 to time
	asm
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

	poke (@CURSOR + 32),players(player,type): poke (@CURSOR + 33),players(player,type): poke (@CURSOR + 34),players(player,type): poke (@CURSOR + 35),players(player,type):
	putTile(players(player,0),players(player,1),@CURSOR)

end function
' ###########################################################


' ###########################################################
INTERFACE:

'IMPRIME MARCADOR DEL NIVEL
m$=str$(level)
DIM prov as uByte = (24-(len(m$)*2))/2
for d=0 to len (m$)-1
	a=val(m$(d))
	putTile(0,prov,(@NUMBERS) + (a*tile))
	prov=prov+2
next

' IMPRIME PLAYER SELECCIONADO
' DE INCIO ES PLAYER 1 (0)


PLINTERFACE:
poke (@CURSOR + 32),players(player,3): poke (@CURSOR + 33),players(player,3): poke (@CURSOR + 34),players(player,3): poke (@CURSOR + 35),players(player,3)
putTile(0,prov+2,@CURSOR)

return

'END INTERFACE
' ###########################################################


' ###########################################################
' MAPEA

MAPEA:
			' ENTRADA en puntero el nivel a volcar

			' SETEO DE VARIABLES
			puntBuffer = @BUFFER
			player = 0
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
					if a=41 then
						a = 10:
						poke (@CURSOR + 32),players(0,3):
						poke (@CURSOR + 33),players(0,3):
						poke (@CURSOR + 34),players(0,3):
						poke (@CURSOR + 35),players(0,3): 
						nPlayers=1:
						players(0,0)=f:
						players(0,1)=d:
						xProta=f:
						yProta=d:
						puntPlayers(0) = puntBuffer
					end if

					if a=42 then
					a = 10:
					poke (@CURSOR + 32),players(1,2):
					poke (@CURSOR + 33),players(1,2):
					poke (@CURSOR + 34),players(1,2):
					poke (@CURSOR + 35),players(1,2):
					nPlayers=2:
					players(1,0)=f:
					players(1,1)=d:
					puntPlayers(1) = puntBuffer
					end if

					if a=43 then
					a = 10:
					poke (@CURSOR + 32),players(2,2):
					poke (@CURSOR + 33),players(2,2):
					poke (@CURSOR + 34),players(2,2):
					poke (@CURSOR + 35),players(2,2): 
					nPlayers=3:
					players(2,0)=f:
					players(2,1)=d:
					puntPlayers(2) = puntBuffer
					end if

					if a=44 then
					a = 10:
					poke (@CURSOR + 32),players(3,2):
					poke (@CURSOR + 33),players(3,2):
					poke (@CURSOR + 34),players(3,2):
					poke (@CURSOR + 35),players(3,2): 
					nPlayers=4:
					players(3,0)=f:
					players(3,1)=d:
					puntPlayers(3) = puntBuffer
					end if

					if a=45 then
					a = 10:
					poke (@CURSOR + 32),players(4,2):
					poke (@CURSOR + 33),players(4,2):
					poke (@CURSOR + 34),players(4,2):
					poke (@CURSOR + 35),players(4,2): 
					nPlayers=5:
					players(4,0)=f:
					players(4,1)=d:
					puntPlayers(4) = puntBuffer
					end if

					if a=46 then
					a = 10:
					poke (@CURSOR + 32),players(5,2):
					poke (@CURSOR + 33),players(5,2):
					poke (@CURSOR + 34),players(5,2):
					poke (@CURSOR + 35),players(5,2): 
					nPlayers=6:
					players(5,0)=f:
					players(5,1)=d:
					puntPlayers(5) = puntBuffer
					end if

MAPEA01:			putTile(f,d,(@TILES-36) + (a*tile))
					if a=10 then  a = 0
MAPEA00:			poke (puntBuffer),a:  puntero = puntero + 1:  puntBuffer = puntBuffer + 1:  contador = contador + a
				next f

			next d

return

' END MAPEA
' ###########################################################



#include "putTile.bas"
#include "graphs.asm"
#include "levels.asm"

UDG:
ASM
DEFB	  0, 16, 16, 16, 84, 56, 16,  0	; FLECHA ABAJO (144)
DEFB	  0, 16, 32,126, 32, 16,  0,  0 ; FLECHA IZQUIERDA (145)
DEFB	  0,  8,  4,126,  4,  8,  0,  0 ; FLECHA DERECHA (146)
END ASM


' BUFFER DE PANTALLA
BUFFER:
ASM
DEFS 180,0
END ASM

