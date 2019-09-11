.data
	aq:		.asciz	"Aqui\n"
	ac:		.asciz	"acabou\n"
.text
	
	.macro print_string($arg)
		#chamada de sistema para imprimir strings na tela -> definida por a7=4 
		#parâmetros: a0 -> endereço da string que se quer imprimir
		#retorno: imprime uma string no console
		li	a7, 4		#a7=4 -> definição da chamada de sistema para imprimir strings na tela
		la	a0, $arg	#a0=endereço da string "str0"
		ecall			#realiza a chamada de sistema
	.end_macro
	
		la 	a0, image_name
		lw 	a1, address
		la 	a2, buffer
		lw 	a3, size
		li 	s8, 4096				# Quantidade de repetições
		jal 	load_image
		lw 	a1, address
		jal	convert_redtones
	
	convert_redtones:
	
		print_string(ac)
		li 	s7, 0x00FF0000			# Máscara
		
		lw 	s0,0(a1)			# pega o valor da imagem em 1 word
		and	s0,s7,s0			# aplica a máscara
		sw 	s0,0(a1)			# devolve o valor do word para o destino no endereço
		addi	a1,a1,4
		
		blez 	s8, cabouImagem			# se a quantidade de repetições = 0
		addi 	s8, s8, -1			# decrementa o contador 
		jal 	convert_redtones
	
	cabouImagem:
		print_string(ac)
		li	a7,10
		ecall
		#ret
	
	
	
	
	
	
	.include "/home/waliffcordeiro/UnB/OAC/Trabalho1-OAC/load_image.asm"
