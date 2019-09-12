.data
		li 	s8, 4096			# Tamanho da imagem - Quantidade de words que serão acessadas
		li 	s7, 0x00FF0000			# Máscara que mantém apenas a informação do vermelho (RGB)
.text	
		# Local que está sendo carregada a imagem
		la 	a0, image_name
		lw 	a1, address
		la 	a2, buffer
		lw 	a3, size			
		jal 	load_image
		lw 	a1, address
		
	#-------------------------------------------------------------------------
	# Funcao convert_redtones: Aplica uma máscara que zera todos os bits que não possuem a informação do vermelho
	#
	# A função foi implementada da seguinte maneira:
	# 1 - Coloca o ponteiro no endereço do inicio da imagem
	# 2 - Pega o valor da word atual
	# 3 - Aplica a máscara 0x00FF0000 na word
	# 4 - Devolve o novo valor/cor para o endereço/imagem
	# 5 - Repete do passo 2 ao 4 de acordo com o size (tamanho da imagem)
	#-------------------------------------------------------------------------
		
	convert_redtones:
			
		lw 	s0,0(a1)			# pega o valor da imagem em 1 word
		and	s0,s7,s0			# aplica a máscara
		sw 	s0,0(a1)			# devolve o valor/cor da word para o endereço/imagem
		addi	a1,a1,4				# aponta para a próxima word da imagem		
		blez 	s8, cabouImagem			# verifica se o contador s8 chegou em 0 para encerrar o programa
		addi 	s8, s8, -1			# decrementa o contador 
		b 	convert_redtones		# continua enquanto não acabar a imagem
	
	cabouImagem:
		ret					# retorna pra rotina principal
				
	.include "/home/waliffcordeiro/UnB/OAC/Trabalho1-OAC/load_image.asm"
