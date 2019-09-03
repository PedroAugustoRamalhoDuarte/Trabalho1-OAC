#-------------------------------------------------------------------------
#		Organização e Arquitetura de Computadores - Turma C 
#			Trabalho 1 - Assembly RISC-V
#
# Nome: 				Matrícula: 
# Nome: 				Matrícula: 
# Nome: 				Matrícula: 

.data
	image_name:   	.asciz "lenaeye.raw"	# nome da imagem a ser carregada
	address: 	.word   0x10040000			# endereco do bitmap display na memoria	
	buffer:		.word   0					# configuracao default do RARS
	size:		.word	4096				# numero de pixels da imagem

.text

	# define parâmetros e chama a função para carregar a imagem
	la a0, image_name
	lw a1, address
	la a2, buffer
	lw a3, size
	jal load_image
  	
	#definição da chamada de sistema para encerrar programa	
	#parâmetros da chamada de sistema: a7=10
	li a7, 10		
	ecall

	#-------------------------------------------------------------------------
	# Funcao load_image: carrega uma imagem em formato RAW RGB para memoria
	# Formato RAW: sequencia de pixels no formato RGB, 8 bits por componente
	# de cor, R o byte mais significativo
	#
	# Parametros:
	#  a0: endereco do string ".asciz" com o nome do arquivo com a imagem
	#  a1: endereco de memoria para onde a imagem sera carregada
	#  a2: endereco de uma palavra na memoria para utilizar como buffer
	#  a3: tamanho da imagem em pixels
	#
	# A função foi implementada ... (explicação da função)
  
	load_image:
		# salva os parâmetros da funçao nos temporários
		mv t0, a0		# nome do arquivo
		mv t1, a1		# endereco de carga
		mv t2, a2		# buffer para leitura de um pixel do arquivo
	
		# chamada de sistema para abertura de arquivo
		#parâmetros da chamada de sistema: a7=1024, a0=string com o diretório da imagem, a1 = definição de leitura/escrita
		li a7, 1024		# chamada de sistema para abertura de arquivo
		li a1, 0		# Abre arquivo para leitura (pode ser 0: leitura, 1: escrita)
		ecall			# Abre um arquivo (descritor do arquivo é retornado em a0)
		mv s6, a0		# salva o descritor do arquivo em s6
	
		mv a0, s6		# descritor do arquivo 
		mv a1, t2		# endereço do buffer 
		li a2, 3		# largura do buffer
	
	#loop utilizado para ler pixel a pixel da imagem
	loop:  
		
		beq a3, zero, close		#verifica se o contador de pixels da imagem chegou a 0
		
		#chamada de sistema para leitura de arquivo
		#parâmetros da chamada de sistema: a7=63, a0=descritor do arquivo, a1 = endereço do buffer, a2 = máximo tamanho pra ler
		li a7, 63				# definição da chamada de sistema para leitura de arquivo 
		ecall            		# lê o arquivo
		lw   t4, 0(a1)   		# lê pixel do buffer	
		sw   t4, 0(t1)   		# escreve pixel no display
		addi t1, t1, 4  		# próximo pixel
		addi a3, a3, -1  		# decrementa countador de pixels da imagem
		
		j loop
		
		# fecha o arquivo 
	close:
		# chamada de sistema para fechamento do arquivo
		#parâmetros da chamada de sistema: a7=57, a0=descritor do arquivo
		li a7, 57		# chamada de sistema para fechamento do arquivo
		mv a0, s6		# descritor do arquivo a ser fechado
		ecall           # fecha arquivo
			
		jr ra
	
  
  
