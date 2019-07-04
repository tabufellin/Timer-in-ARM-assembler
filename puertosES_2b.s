@ Basado en el curso de la U. de Cambridge de Alex Chadwick
@ puertosES_2.s prueba con puertos de entrada y salida
@ Funciona con cualquier puerto, utilizando biblioteca gpio0_2.s

 .text
 .align 2
 .global main
main:
	@utilizando la biblioteca GPIO (gpio0_2.s)
	bl GetGpioAddress @solo se llama una vez
	
	@GPIO para escritura (salida) puerto 15
	mov r0,#15
	mov r1,#1
	bl SetGpioFunction

	@GPIO para lectura (entrada) puerto 14 
	mov r0,#14
	mov r1,#
	bl SetGpioFunction
loop:
	@Apagar GPIO 15
	mov r0,#15
	mov r1,#0
	bl SetGpio

	@loop:
	@Revision del boton
	@Para revisar si el nivel de un GPIO esta en alto o bajo 
	@se lee en la direccion 0x3F200034 para los GPIO 0-31
	ldr r6, =myloc
 	ldr r0, [r6]		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34]	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#14
	and r5,r7 		@se revisa el bit 14 (puerto de entrada)

	@Si el boton esta en alto (1), fue presionado y enciende GPIO 15
	teq r5,#0 			@es lo mismo que un CMP
	movne r0,#15		@instrucciones para encender GPIO 15
	movne r1,#1
	blne SetGpio
	blne wait 
		
	b loop

@ brief pause routine
wait:
 mov r0, #0x4000000 @ big number
sleepLoop:
 subs r0,#1
 bne sleepLoop @ loop delay
 mov pc,lr

 .data
 .align 2
 
.global myloc
myloc: .word 0

 .end

