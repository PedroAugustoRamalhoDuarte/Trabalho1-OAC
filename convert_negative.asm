.text	
		# Local que está sendo carregada a imagem
		la 	a0, image_name
		lw 	a1, address
		la 	a2, buffer
		lw 	a3, size
		jal 	load_image
		lw 	a1, address
	
	#-------------------------------------------------------------------------
	# Funcao convert_negative: Recebe de parametro o endereço de inicio de uma imagem
	# pega 
	#
	# A função foi implementada da seguinte maneira:
	# 1 - Coloca o ponteiro no inicio da imagem
	# 2 - Pega o valor da word
	# 3 - Subtrai a máscara 0x00FFFFFF da word
	# 4 - Devolve o novo valor/cor para a imagem/endereço
	# 5 - Avança o ponteiro do endereço
	# 6 - Repete do passo 2 ao 4 de acordo com o size (tamanho da imagem)
	#-------------------------------------------------------------------------
	
	convert_negative:
		# define parâmetros e segue para a função para carregar a imagem
		
		li 	s7, 0x00FFFFFF			# máscara que representa a constante(255) subtraida de cada informação de cor
		li 	s8, 4096 			# Tamanho da imagem (words) - Quantidade de loops
		b	convert_negative_loop		# após inicialização, avança para a subrotina do loop		
		
	convert_negative_loop:
		
		lw 	s0,0(a1)			# pega o valor da imagem em 1 words
		sub	s0,s7,s0			# subtrair byte a byte o valor de 255
		sw 	s0,0(a1)			# devolve 255 subtraido do valor para a imagem/endereço		
		addi 	a1,a1,4				# pega a próxima word da imagem				
		blez 	s8, cabouImagem			# verifica se o contador é 0 para saber se chegamos no fim da imagem
		addi 	s8, s8, -1			# decrementa o contador 
		b 	convert_negative_loop 		# repete o procedimento se não tiver chegado ao fim	
		
	cabouImagem:
		ret
		
	.include "/home/waliffcordeiro/UnB/OAC/Trabalho1-OAC/load_image.asm"
