.data
	aq:		.asciz	"Aqui\n"
	ac:		.asciz	"acabou"

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
		jal 	load_image
		lw 	a1, address
		jal	convert_negative
	
	convert_negative:
		# define parâmetros e chama a função para carregar a imagem
		
		li 	s4, 4				# Setando mod 4 para ignorar o bit sem informação de cor
		li 	s5, 0				# Contador
		li 	s9, 0				# guardar o resultado
		li 	s7, 255				# constante zero
		li 	s8, 16384 			# 256*256/4 = 16384 - Verificar essa conta porque com metade do valor da o mesmo resultado	
  	
		
	convert_negative_loop:
		print_string(aq)
		addi 	s5, s5,1  			# contador inicado em -1
		rem 	s9,s5,s4   			# mod 4 com o contador
		#blez	s9,ignore_mod_4 		# se for o 4º elemnto, não faz nada
		
		lb 	s0,0(a1)			# pega o valor da imagem em 1 byte
		sub	s0,s7,s0			# subtrair 255
		sb 	s0,0(a1)			# devolve o valor subtraido de 255 para a imagem		
		addi 	a1,a1,2				# pega o próximo byte da imagem
		
		#beq 	s7,s8, cabouImagem		# verifica se o contador é <= 0 para saber se chegamos no fim da imagem
		blez 	s8, cabouImagem
		addi 	s8, s8, -1			# decrementa o contador 
		jal 	convert_negative_loop 		# repete o procedimento se não tiver chegado ao fim	
	
	ignore_mod_4:
		addi 	s8, s8, -1		
		addi 	a1,a1,2
		jal 	convert_negative_loop
		
	cabouImagem:
		print_string(ac)
		li	a7,10
		ecall
		#ret
		
		
		
		print_string(aq)



	#definição da chamada de sistema para encerrar programa	
	#parâmetros da chamada de sistema: a7=10

	.include "/home/waliffcordeiro/UnB/OAC/Trabalho1-OAC/load_image.asm"
