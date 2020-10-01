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

' ATRIBUTO DEL PLAYER SELECCIONADO
DIM attrProta as uByte

' PLAYER BLUE
DIM xProta1, yProta1 as uByte

' PLAYER RED
DIM xProta2, yProta2 as uByte

' PLAYER MAGENTA
DIM xProta3, yProta3 as uByte

' PLAYER GREEN
DIM xProta4, yProta4 as uByte

' PLAYER CYAN
DIM xProta5, yProta5 as uByte

' PLAYER YELLOW
DIM xProta6, yProta6 as uByte

' NUMERO DE PLAYERS
DIM nPlayers as uByte

' PLAYER SELECCIONADO
' DE 1 A 6, CORRESPONDE CON EL COLOR. SE EMPIEZA SIEMPRE CON EL BLUE SELECCIONADO
DIM player as uByte

' LAS MEDIDAS EN TILES DEL NIVEL
DIM xAncho, yAlto as uByte

' LAS COORDENADAS DE IMPRESIÓN ESQUINA SUP/IZQ DEL NIVEL
DIM xBoard, yBoard as uByte

' NIVEL EN JUEGO
DIM level as uByte = 107

' PARA LA CADENA DEL MARCADOR DE NIVEL
DIM m$ as string

CONST tile as uInteger = 36

' ATRIBUTOS DEL CURSOR INACTIVO/SELECCIONADO

CONST attr1 as uByte = 57
CONST attr2 as uByte = 58
CONST attr3 as uByte = 59
CONST attr4 as uByte = 60
CONST attr5 as uByte = 61
CONST attr6 as uByte = 62
CONST attr1B as uByte = 15
CONST attr2B as uByte = 23
CONST attr3B as uByte = 31
CONST attr4B as uByte = 39
CONST attr5B as uByte = 47
CONST attr6B as uByte = 49

' PUNTEROS DE CADA CURSOR

DIM puntero1, puntero2, puntero3, puntero4, puntero5, puntero6 as uInteger

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

go sub INTERFACE
puntero = @LEVELPR
go sub MAPEA

fin: go to fin

stop

'puntBuffer=(((yProta/2)*16)+(xProta/2))+@BUFFER
'putTile(xProta,yProta,grafProta1)

' ###########################################################
' BUCLE PRINCIPAL DEL JUEGO
BUCLE:



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

'IMPRIME PLAYER SELECCIONADO
'DE INCIO ES 1

poke (@CURSOR + 32),attr1B: poke (@CURSOR + 33),attr1B: poke (@CURSOR + 34),attr1B: poke (@CURSOR + 35),attr1B
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
			player = 1
			contador = 0
			attrProta = attr1
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
					if a=41 then a = 10: poke (@CURSOR + 32),attr1B: poke (@CURSOR + 33),attr1B: poke (@CURSOR + 34),attr1B: poke (@CURSOR + 35),attr1B:  nPlayers=1: xProta1=f: yProta1=d: xProta=f: yProta=d: puntero1 = puntero
					if a=42 then a = 10: poke (@CURSOR + 32),attr2: poke (@CURSOR + 33),attr2: poke (@CURSOR + 34),attr2: poke (@CURSOR + 35),attr2:  nPlayers=2: xProta2=f: yProta2=d: puntero2 = puntBuffer
					if a=43 then a = 10: poke (@CURSOR + 32),attr3: poke (@CURSOR + 33),attr3: poke (@CURSOR + 34),attr3: poke (@CURSOR + 35),attr3:  nPlayers=3: xProta3=f: yProta3=d: puntero3 = puntBuffer
					if a=44 then a = 10: poke (@CURSOR + 32),attr4: poke (@CURSOR + 33),attr4: poke (@CURSOR + 34),attr4: poke (@CURSOR + 35),attr4:  nPlayers=4: xProta4=f: yProta4=d: puntero4 = puntBuffer
					if a=45 then a = 10: poke (@CURSOR + 32),attr5: poke (@CURSOR + 33),attr5: poke (@CURSOR + 34),attr5: poke (@CURSOR + 35),attr5:  nPlayers=5: xProta5=f: yProta5=d: puntero5 = puntBuffer
					if a=46 then a = 10: poke (@CURSOR + 32),attr6: poke (@CURSOR + 33),attr6: poke (@CURSOR + 34),attr6: poke (@CURSOR + 35),attr6:  nPlayers=6: xProta6=f: yProta6=d: puntero6 = puntBuffer

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

