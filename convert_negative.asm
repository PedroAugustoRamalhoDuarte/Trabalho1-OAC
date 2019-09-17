.text	
		# Local que está sendo carregada a imagem
		la 	a0, image_name
		lw 	a1, address
		la 	a2, buffer
		lw 	a3, size
		jal 	load_image
		lw 	a1, address
	
	#-------------------------------------------------------------------------
	# Funcao convert_negative: Subtrair da máscara 0x00FFFFFF cada pixel
	#
	# A função foi implementada da seguinte maneira:
	# 1 - Coloca o ponteiro no endereço do inicio da imagem
	# 2 - Pega o valor da word atual
	# 3 - Subtrai da máscara 0x00FFFFFF o valor da word
	# 4 - Devolve o novo valor/cor para a imagem/endereço
	# 5 - Avança o ponteiro do endereço para a próxima word
	# 6 - Repete do passo 2 ao 4 de acordo com o size (tamanho da imagem)
	#-------------------------------------------------------------------------
	
	convert_negative:
		# define parâmetros e segue para a função para carregar a imagem		
		li 	s7, 0x00FFFFFF			# máscara que representa a constante 255 em cada byte com informação de cor
		li 	s8, 4096 			# Tamanho da imagem (words) - Quantidade de loops
		b	convert_negative_loop		# após inicialização, avança para a subrotina do loop		
		
	convert_negative_loop:
		
		lw 	s0,0(a1)			# pega o valor de uma word da imagem
		sub	s0,s7,s0			# subtrair byte a byte do valor 255 (255 - Informação de cor)
		sw 	s0,0(a1)			# devolve 255 subtraido do valor para a imagem/endereço		
		addi 	a1,a1,4				# pega a próxima word da imagem				
		blez 	s8, cabouImagem			# verifica se o contador é 0 para saber se chegamos no fim da imagem
		addi 	s8, s8, -1			# decrementa o contador 
		b 	convert_negative_loop 		# repete o procedimento se não tiver chegado ao fim	
		
	cabouImagem:
		ebreak
		#ret					# retorna pra rotina principal
		
	.include "/home/waliffcordeiro/UnB/OAC/Trabalho1-OAC/load_image.asm"
