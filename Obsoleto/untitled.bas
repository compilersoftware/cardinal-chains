' untitled

DIM puntero, puntBuffer, puntATTR, puntSelector as uInteger
DIM xProta, yProta, seMueve, direccion, futPosicion as uByte
DIM cantSuelo, cantObstaculo, cantBomba, objSeleccionado as uByte
DIM tintaSuelo, tintaObstaculo, tintaBomba as uByte
DIM dureza as uByte
DIM xCursor, yCursor as uInteger
DIM grafProta1, grafProta2 as uInteger

CONST tile as uInteger = 36
CONST vacioMax as uByte = 8
CONST sueloMin as uByte = 13
CONST sueloMax as uByte = 25 ' escalera se excluye para no poder poner obstáculo encima
CONST obstaculoMin as uByte = 28
CONST obstaculoMax as uByte = 32



'OBJETO SELECCIONADO
' 0 = nada; 1 = suelo; 2 = obstáculo; 3 = bomba

'DIRECCION DEL MONO
'direccion = 1 arriba 2 derecha 3 abajo 4 izquierda


' COMIENZO DE SETEO PROVISIONAL
SETEO:
border 0: paper 1: bright 1: cls

'seteo de variables provisional para lanzar el juego
objSeleccionado = 0
xCursor=10
yCursor=18
xProta=2
yProta=10
seMueve=1
direccion=2
cantSuelo=10
cantObstaculo=9
cantBomba=5

'colocamos la dirección de los gráficos adecuada
if direccion = 1 then grafProta1=@EspiaArriba1: grafProta2=@EspiaArriba2
if direccion = 2 then grafProta1=@EspiaDerecha1: grafProta2=@EspiaDerecha2
if direccion = 3 then grafProta1=@EspiaAbajo1: grafProta2=@EspiaAbajo2
if direccion = 4 then grafProta1=@EspiaIzquierda1: grafProta2=@EspiaIzquierda2


if cantSuelo > 0 then
tintaSuelo = 6
else
tintaSuelo = 1
end if

if cantObstaculo > 0 then
tintaObstaculo = 6
else
tintaObstaculo = 1
end if

if cantBomba > 0 then
tintaBomba = 6
else
tintaBomba = 1
end if

go sub MAPEA
go sub INTERFACE


puntBuffer=(((yProta/2)*16)+(xProta/2))+@BUFFER
puntSelector=(((yCursor/2)*16)+(xCursor/2))+@BUFFER
putTile(xProta,yProta,grafProta1)
go sub GUARDASELECTOR
go sub DIBUJASELECTOR


' BUCLE DE JUEGO

BUCLEJUEGO:

do

'MOVIMIENTO A LA DERECHA
if direccion=2 then
	let futPosicion=peek(puntBuffer+1)
	if futPosicion=0 then
	let seMueve=0
	goto MUERTE
	End If

GOSUB CURSOR

IF INKEY$="r" THEN GO TO SETEO

for f=1 to 3000: next

End If


loop while seMueve

STOP

MUERTE:

	border 0: paper 0: ink 7: stop


GUARDASELECTOR:

		' GUARDAMOS LOS ATTR BAJO EL SELECTOR PARA REPONER.
		poke @ATTRBUFFER,peek (22528+((yCursor*32)+xCursor))
		poke @ATTRBUFFER+1,peek (22528+((yCursor*32)+xCursor+1))
		poke @ATTRBUFFER+2,peek (22528+(((yCursor+1)*32)+xCursor))
		poke @ATTRBUFFER+3,peek (22528+(((yCursor+1)*32)+xCursor+1))
		return

RESTAURASELECTOR:

		' RESTAURA LOS ATTR BAJO EL SELECTOR.
		poke 22528+((yCursor*32)+xCursor), peek (@ATTRBUFFER)
		poke 22528+((yCursor*32)+xCursor+1), peek (@ATTRBUFFER+1)
		poke 22528+(((yCursor+1)*32)+xCursor), peek (@ATTRBUFFER+2)
		poke 22528+(((yCursor+1)*32)+xCursor+1), peek (@ATTRBUFFER+3)
		return

DIBUJASELECTOR:
		' PONE EL CURSOR EN PANTALLA
		poke 22528+((yCursor*32)+xCursor), 41
		poke 22528+((yCursor*32)+xCursor+1), 41
		poke 22528+(((yCursor+1)*32)+xCursor), 41
		poke 22528+(((yCursor+1)*32)+xCursor+1), 41
		return

CURSOR:

		' LEE EL TECLADO Y MANEJA EL CURSOR
		
		' PULSAMOS ACCIÓN
		if inkey$ =" " then

			' SI ESTAMOS EN ZONA DE INTERFACE
			if yCursor=22 then
			
				' SI PULSAMOS EN SUELO
				if xCursor=14 and cantSuelo>0 then
					objSeleccionado = 1
					go sub IMPMARCADORES
					print at 22,16; paper 6;ink 2; bold 1; bright 1; cantSuelo
					return
				end if

				' SI PULSAMOS EN OBSTÁCULO
				if xCursor=18 and cantObstaculo>0 then
					objSeleccionado = 2
					go sub IMPMARCADORES
					print at 22,20; paper 6;ink 2; bold 1; bright 1; cantObstaculo
					return
				end if

				' SI PULSAMOS EN BOMBA
				if xCursor=22 and cantBomba>0 then
					objSeleccionado = 3
					go sub IMPMARCADORES
					print at 22,24; paper 6;ink 2; bold 1; bright 1; cantBomba
					return
				end if

				return
			end if
			' FIN ZONA DE INTERFACE
		

			' SI ESTAMOS EN ZONA DE JUEGO

			' COMPROBAMOS QUE NO TENGAMOS AL PERSONAJE DEBAJO
			if (xCursor <> xProta or yCursor <> yProta) then

				puntSelector=(((yCursor/2)*16)+(xCursor/2))+@BUFFER

				dureza=0 'vamos a ver si tenemos algún suelo alrededor para pintar el nuestro y evitas que se ponga en zonas vacías.

				' COMPROBAMOS SI TENEMOS EL SUELO SELECCIONADO. SÓLO SE PUEDE AÑADIR SOBRE ZONA VACÍA
				if objSeleccionado = 1 and peek(puntSelector)<=vacioMax then

					' COMPROBAMOS SI TOCAMOS SUELO EN UNO DE LOS CUATRO PUNTOS DE CONTACTO DE LA PIEZA A COLOCAR
					'ARRIBA
					if peek (puntSelector-16) >=sueloMin and peek (puntSelector-16) <=sueloMax  and yCursor>0 then
					dureza = dureza +1
					end if
					'ABAJO
					if peek (puntSelector+16) >=sueloMin and peek (puntSelector-16) <=sueloMax and yCursor<20 then
					dureza = dureza +1
					end if
					'izquierda
					if peek (puntSelector-1) >=sueloMin and peek (puntSelector-16) <=sueloMax and xCursor>0 then
					dureza = dureza +1
					end if
					'DERECHA
					if peek (puntSelector+1) >=sueloMin and peek (puntSelector-16) <=sueloMax and xCursor<30 then
					dureza = dureza +1
					end if
					' no deja poner la pieza si no hay contacto con suelo
					if dureza = 0 then return


								let cantSuelo=cantSuelo-1
								if cantSuelo>0 then 
								print at 22,16; paper 6;ink 2; bold 1; bright 1; "  "; at 22,16; cantSuelo
								else
								objSeleccionado=0
								tintaSuelo=1
								go sub INTER01
								end if
								poke (puntSelector),25
								putTile(xCursor,yCursor,@SUELO13)
								if (peek (puntSelector+16) <= vacioMax) and (yCursor <= 18) then
								putTile(xCursor,yCursor+2,@VACIO08)
								poke (puntSelector+16),8
								end if

								go sub GUARDASELECTOR
								go sub DIBUJASELECTOR
				return
				' END DEL if objSeleccionado = 1
				end if

				' COMPROBAMOS SI TENEMOS EL OBSTÁCULO SELECCIONADO. SÓLO SE PUEDE AÑADIR SOBRE ZONA SUELO
				if objSeleccionado = 2 and (peek (puntSelector)>=sueloMin and peek (puntSelector)<=sueloMax) then
					let cantObstaculo=cantObstaculo-1
					if cantObstaculo>0 then 
					print at 22,20; paper 6;ink 2; bold 1; bright 1; cantObstaculo
					else
					objSeleccionado=0
					tintaObstaculo=1
					go sub INTER01
					end if
					poke (puntSelector),28
					putTile(xCursor,yCursor,@OBSTACULO01)
					go sub GUARDASELECTOR
					go sub DIBUJASELECTOR
				return
				end if

			end if

		return
		end if
		' FIN PULSAR ACCIÓN'


		' MUEVE EL CURSOR IZQUIERDA
		if inkey$="o" and xCursor>0 then
			gosub RESTAURASELECTOR

				' SI ESTAMOS EN LA ZONA DE INTERFACE
				if yCursor=22 then
					xCursor=xCursor-4
					if xCursor < 6 then
						xCursor=22
					end if
					goto CURIZQ01
				end if

			let xCursor=xCursor-2

CURIZQ01:	gosub GUARDASELECTOR
			GOSUB DIBUJASELECTOR
			return
		end if

		' MUEVE EL CURSOR DERECHA	
		if inkey$="p" and xCursor<30 then
			gosub RESTAURASELECTOR

				' SI ESTAMOS EN LA ZONA DE INTERFACE
				if yCursor=22 then
					xCursor=xCursor+4
					if xCursor >22 then
						xCursor= 6
					end if
					goto CURDER01
				end if

			let xCursor=xCursor+2
CURDER01:	gosub GUARDASELECTOR
			GOSUB DIBUJASELECTOR
			return
		end if

		' MUEVE EL CURSOR ARRIBA
		if inkey$="q" and yCursor>0 then
			gosub RESTAURASELECTOR
			let yCursor=yCursor-2
			gosub GUARDASELECTOR
			GOSUB DIBUJASELECTOR
			return
		end if		

		' MUEVE EL CURSOR ABAJO
		if inkey$="a" and yCursor<21 then
			gosub RESTAURASELECTOR
	
			let yCursor=yCursor+2

				' SI ESTAMOS EN LA ZONA DE INTERFACE
				if yCursor=22 then
						if xCursor=8 or xCursor= 12 or xCursor = 16 or xCursor = 20 or xCursor = 24 then
							xCursor=xCursor-2
					end if

					if xCursor<6 then
						let xCursor=6
					end if

					if xCursor>24 then
						let xCursor=22
					end if
				end if

			gosub GUARDASELECTOR
			GOSUB DIBUJASELECTOR
			return
		end if	

		RETURN


INTERFACE:

		for f=0 to 31
		print at 22,f; paper 0; ink 0 ;" "; at 23,f; " "
		next

		putTile(6,22,@PARAR)

		putTile(10,22,@PAUSA)

INTER01:

		if cantSuelo > 0 then
		putTile(14,22,@SUELO13)
		else
		putTile(14,22,@SUELONO)
		end if

		if cantObstaculo > 0
		putTile(18,22,@OBSTACULO01)
		else
		putTile(18,22,@OBSTACULONO)
		end if

		if cantBomba > 0
		putTile(22,22,@BOMBASI)
		else
		putTile(22,22,@BOMBANO)
		end if

IMPMARCADORES:

		print at 22,16; paper 0;ink tintaSuelo; bold 1;"  "; at 22,16; cantSuelo
		print at 22,20; paper 0;ink tintaObstaculo; bold 1;"  "; at 22,20; cantObstaculo
		print at 22,24; paper 0;ink tintaBomba; bold 1;"  "; at 22,24; cantBomba
	
		return




MAPEA:
			puntero = @LEVEL01
			puntBuffer = @BUFFER 

		for d=0 to 21 step 2

			for f=0 to 30 step 2
			if peek (puntero)=0 goto MAPEA01
			putTile(f,d,(@TILES-36) + (peek (puntero)*tile))
MAPEA01:	poke (puntBuffer),peek (puntero)
MAPEA02:	puntBuffer = puntBuffer +1
			puntero = puntero+1
			next

		next

return



#include "putTile.bas"
#include "graphs.asm"
#include "levels.asm"

' BUFFER DE PANTALLA
BUFFER:
ASM
DEFS 176,0
END ASM

' BUFFER DE ATRIBUTOS BAJO EL CURSOR
ATTRBUFFER:
ASM
DEFS 4,0
END ASM