.text
.align 2
.global main
main:

	bl GetGpioAddress

	@@ codigo que aumenta en 1 el valor del display de 7 segmentos que funciona a travez de integrdo 
	
	@@ GPIO para entrada
	@@ un boton

	@@ boton 1, aumentador de valor de display 1, el de decenas
	mov r0, #26
	mov r1,#0
	bl SetGpioFunction

	@@ boton 2, aumentador de valor de display 2, el de unidades
	mov r0, #19
	mov r1,#0
	bl SetGpioFunction

	@@boton 3, empezar el temporizador
	mov r0, #18
	mov r1,#0
	bl SetGpioFunction

	@@ GPIO para salida
	@@ input 1,2,3,4 de display 1 

	mov r0, #12
	mov r1,#1
	bl SetGpioFunction

	mov r0, #17
	mov r1,#1
	bl SetGpioFunction

	mov r0, #20
	mov r1,#1
	bl SetGpioFunction

	mov r0, #21
	mov r1,#1
	bl SetGpioFunction

	@@ input 1,2,3,4 de display 2

	mov r0, #5
	mov r1,#1
	bl SetGpioFunction

	mov r0, #6
	mov r1,#1
	bl SetGpioFunction

	mov r0, #13
	mov r1,#1
	bl SetGpioFunction

	mov r0, #27
	mov r1,#1
	bl SetGpioFunction

	@@ led que se prende cuando el temporizador llega a 0

	mov r0, #23
	mov r1,#1
	bl SetGpioFunction

	@@@@@

	begin:

	mov r9,	 #0 @@ que valor posee en el decenas, para luego convertirlo
	mov r10, #0 @@ que valor posee en las unidades para luego convertirlo a unidades

	initialSet:

	@@reset del primer delay 
 	@apagar GPIO 12
	mov r0, #12
	mov r1, #0
	bl SetGpio

	@apagar GPIO 17
	mov r0, #17
	mov r1, #0
	bl SetGpio


	@apagar GPIO 20
	mov r0, #20
	mov r1,#0
	bl SetGpio

	@ apagar GPIO 21
	mov r0, #21
	mov r1, #0
	bl SetGpio

	@@ reset del segundo delay 
    @GPIO 5
	mov r0, #5
	mov r1, #0
	bl SetGpio

	@GPIO 6
	mov r0, #6
	mov r1, #0
	bl SetGpio


	@GPIO 13
	mov r0, #13
	mov r1, #0
	bl SetGpio

	@GPIO 27
	mov r0, #27
	mov r1, #0
	bl SetGpio

	@@ apagar el led

	@GPIO 23
	mov r0, #23 
	mov r1, #0
	bl SetGpio

	@@ ask a question
	
	menu:

		ldr r0,=mensaje_ingreso
		bl puts

		ldr r0,=entrada
		ldr r1,=a
		bl scanf

		ldr r0,=a
		ldr r0,[r0]

		cmp r0, #1
		beq loop2

		cmp r0, #2
		beq loop3

		cmp r0, #3
		beq endAll

		b menu


	


	loop2: 

		
		
		mov r1, #26 @@ revisa el boton de aumentar el primer coso
		bl readGpio @@SI ESTA PONIENDO EL VALOR RECIBIDO EN R0
		cmp r0, #0
		beq continue

		b aumentar

		continue:
		mov r1, #19 @@ revisa el boton de aumentar el segundo coso
		bl readGpio @@ SI ESTA PONIENDO EL VALOR RECIBIDO EN R0
		cmp r0, #0
		beq continue2

		b aumentar2

		continue2:


		mov r1, #18 @@ revisa el boton en el que temporizador
		bl readGpio
		@mov r1, r0
		@ldr r0,=formato
		@bl printf
		cmp r0, #0
		beq loop2

		b temporizador

		aumentar: @@ el valor se va a ir guardando en r9 y se despliega en los puertos
			
			add r9, r9, #1
			cmp r9, #10
			moveq r9, #0
			ldr r0,=formato
			mov r1, r9
			bl printf

			mov r0, r9			
			@@ aqui hacer una funcion que deje en r0, r1, r2, r3 los valores de bit segun lo que hay en r9
			bl convertidor_binario

			mov r4, r0
			mov r5, r1
			mov r7, r2
			mov r8, r3

			ldr r0,=formato
			mov r1, r4
			bl printf

			ldr r0,=formato
			mov r1, r5
			bl printf

			ldr r0,=formato
			mov r1, r7
			bl printf

			ldr r0,=formato
			mov r1, r8
			bl printf

		 	@GPIO 12

			mov r0, #12
			mov r1, r4
			bl SetGpio

			@GPIO 17

			mov r0, #17
			mov r1, r5
			bl SetGpio


			@GPIO 20

			mov r0, #20
			mov r1, r7
			bl SetGpio

			@GPIO 21

			mov r0, #21
			mov r1, r8
			bl SetGpio

			bl wait



			b loop2


		aumentar2: @@ el valor se va a ir guardando en r10 y se despliega en los puertos
			ldr r0,=prueba
			bl puts

			add r10, r10, #1
			cmp r10, #10
			moveq r10, #0

			@@ aqui hacer una funcion que deje en r0, r1, r2, r3 los valores de bit segun lo que hay en r10
			ldr r0,=formato
			mov r1, r10	
			bl printf

			mov r0, r10		
			bl convertidor_binario

			mov r4, r0
			mov r5, r1
			mov r7, r2
			mov r8, r3

			ldr r0,=formato
			mov r1, r4
			bl printf

			ldr r0,=formato
			mov r1, r5
			bl printf

			ldr r0,=formato
			mov r1, r7
			bl printf

			ldr r0,=formato
			mov r1, r8
			bl printf

		 	@GPIO 5

			mov r0, #5
			mov r1, r4
			bl SetGpio

			@GPIO 17

			mov r0, #6
			mov r1, r5
			bl SetGpio


			@GPIO 20

			mov r0, #13
			mov r1, r7
			bl SetGpio

			@GPIO 27

			mov r0, #27
			mov r1, r8
			bl SetGpio

			bl wait
			b loop2

		loop3:
			ldr r0,=mensaje_ingreso_numero
			bl puts

			ldr r0,=entrada
			ldr r1,=a
			bl scanf

			ldr r0,=a
			ldr r0,[r0]

			cmp r0, #100
			bge loop3
			mov r9, r0 @@ decenas en r9
			mov r10,r0 @@ unidades en r10

			mov r4, #0
			cycleDecenas:
				add r4, r4, #1
				subs r9, r9, #10
				cmp r9, #0
				bge cycleDecenas

			mov r9, r4
			sub r9, r9, #1


			modulo10:
				cmp r10, #10
				blt temporizador
				subge r10, r10, #10
				bge modulo10

		temporizador:
			ldr r0,=formator9
			mov r1,r9
			bl printf
			ldr r0,=formator10
			mov r1, r10
			bl printf


			cmp r9, #0 @@ revisa si el display de decenas tiene 0, si si...
			beq check10
			@ldr r0,=prueba
			@bl puts

			b continueTemp

			check10: @@ revisa si el display de unidades tiene 0, si si, ir a terminar el programa
				ldr r0,=prueba
				bl puts

				cmp r10, #0
				beq endTemporizador

			@@ primero tiene que esperar un segundo para cambiar al siguiente numero
			continueTemp: @@ en el caso pues que aun hayan números...

				@@ delay de 1 segundo
				mov r0, #1
				bl sleep

				@@ cuando el r10 llegue a 0 entonces debe de convertirse en 9 
				@@ y cuando este se convierta en 0 entonces debe de convertirse el otro en una unidad menos

				cmp r10, #0 @@ en el caso que las unidades esten en 0 entonces se activa un switch en el r11 que  se pondra en 1 y 0 que servira para ver si se cambia o no las decenas
				moveq r11, #1 @@ switch change if r10 <- #0

				disminuirUnidades:

				@@ modulo 10 invertido
				subs r10, r10, #1
				cmp r10, #-1
				moveq r10, #9

				@@ subrutina utilizada arriba
				mov r0, r10	
				bl convertidor_binario
				
				mov r4, r0
				mov r5, r1
				mov r7, r2
				mov r8, r3

			 	@GPIO 5

				mov r0, #5
				mov r1, r4
				bl SetGpio

				@GPIO 17

				mov r0, #6
				mov r1, r5
				bl SetGpio


				@GPIO 20

				mov r0, #13
				mov r1, r7
				bl SetGpio

				@GPIO 27

				mov r0, #27
				mov r1, r8
				bl SetGpio

				cmp r11, #1
				beq disminuirDecenas
				b temporizador

				disminuirDecenas:

					@@ change switch
					mov r11, #0

					subs r9, r9, #1

					@@ aqui hacer una funcion que deje en r0, r1, r2, r3 
					@@los valores de bit segun lo que hay en r9 input en r0
					mov r0, r9			
					bl convertidor_binario

					mov r4, r0
					mov r5, r1
					mov r7, r2
					mov r8, r3

				 	@GPIO 12

					mov r0, #12
					mov r1, r4
					bl SetGpio

					@GPIO 17

					mov r0, #17
					mov r1, r5
					bl SetGpio


					@GPIO 20

					mov r0, #20
					mov r1, r7
					bl SetGpio

					@GPIO 21

					mov r0, #21
					mov r1, r8
					bl SetGpio

					b temporizador

				endTemporizador:

					mov r3, #0
					cmp r3, #5

					beq cicloLed

					b begin

					cicloLed:
						add r3, r3, #1

						@GPIO 23
						mov r0, #23 
						mov r1, #1
						bl SetGpio

						mov r0, #1
						bl sleep

						mov r0, #23 
						mov r1, #1
						bl SetGpio

						b endTemporizador


			endAll:

				mov	r3, #0
				mov	r0, r3

				@ colocar registro de enlace para desactivar la pila y retorna al SO
				ldmfd	sp!, {lr}
				bx	lr

			




				@@ cuando lo hace, modificar el valor del display que representa las unidades
				@@ r9 estan los valores de las decenas
				@@ r10 estan los valores de las unidades








wait:
 mov r0, #0x9000000 @ big number
sleepLoop:
 subs r0,#1
 bne sleepLoop @ loop delay
 mov pc,lr



	

convertidor_binario: @@ subrutina que toma un valor de r0 y lo convierte en binario almacenandolo en r0, r1, r2 y r3
 
 	mov r1, r0
 	mov r2, r0
 	mov r3, r0

 	@@ ultimo bit 2^0
 	and r0, r0, #1

 	@@ segundo bit 2^1
 	and r1, r1, #2

 	@@ tercer bit 2^2
 	and r2, r2, #4

 	@@ cuarto bit 2^3
 	and r3, r3, #8

 	mov pc, lr


.data
.align 2

.global myloc
myloc: .word 0

formato:
	.asciz "hola %d\n"

prueba:
	.asciz "hola"

formator9:
	.asciz "valor en r9 %d\n"

formator10:
	.asciz "valor en r10 %d\n"

mensaje_ingreso:
	.asciz "Bienvenido al controlador del timer \n
			1. manejar por botones \n
			2. manejar por teclado \
			3. Salir"
entrada:
	.asciz " %d"

mensaje_ingreso_numero:
	.asciz "Ingrese el número que desea colocar en el temporizador"

a:
	.word 0
.end
