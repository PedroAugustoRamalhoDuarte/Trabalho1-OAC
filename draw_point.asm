.data
	str0:	.asciz	"Digite um número: "
	menu:	.asciz	"• Defina o número opção desejada: \n 1 •"
	init:	.word	0x10043F00	# 0x10040000 + 64x63 
.text

	.macro print_string($arg)
		#chamada de sistema para imprimir strings na tela -> definida por a7=4 
		#parâmetros: a0 -> endereço da string que se quer imprimir
		#retorno: imprime uma string no console
		li	a7, 4		#a7=4 -> definição da chamada de sistema para imprimir strings na tela
		la	a0, $arg	#a0=endereço da string "str0"
		ecall			#realiza a chamada de sistema
	.end_macro
	
	 print_string(str0)
	
	.macro input_int() 
		li a7, 5		#a7 = 5 -> definição da chamada de sistema para ler número inteiro
		ecall			#realiza a chamada de sistema
		mv t0, a0 		#
	.end_macro
	
	draw_point:
		
		input_int()
		mv s1, t0
		input_int()
		mv s2, t0
		lw t0, init
		li t1, 0x00FF0000
		sw t1, 0(t0) 
		
		