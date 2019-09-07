.data
	xInicial:	.asciz	"Digite um valor para o X inicial(0 a 63): "
	yInicial:	.asciz	"Digite um valor para o Y inicial(0 a 63):"
	xFinal:		.asciz	"Digite um valor para o X final(0 a 63):"
	yFinal:		.asciz	"Digite um valor para o Y final(0 a 63):"
	init:		.word	0x10043F00	# 0x10040000 + 64x63 
.text

	.macro print_string($arg)
		#chamada de sistema para imprimir strings na tela -> definida por a7=4 
		#parâmetros: a0 -> endereço da string que se quer imprimir
		#retorno: imprime uma string no console
		li	a7, 4		#a7=4 -> definição da chamada de sistema para imprimir strings na tela
		la	a0, $arg	#a0=endereço da string "str0"
		ecall			#realiza a chamada de sistema
	.end_macro
	
	
	.macro input_int() 
		li	a7, 5		#a7 = 5 -> definição da chamada de sistema para ler número inteiro
		ecall			#realiza a chamada de sistema
		mv	t0, a0 		#
	.end_macro
	
	#-------------------------------------------------------------------------
	# Funcao draw_full_rectangle: recebe de input do teclado 2 pontos e cores rgb 
	# e desenha um retângulo, tendo em vista que o X e o Y inciais são menor que os finais
	# Parametros:
	#	recebe do teclado
	# Registradores:
	#	s1 - Xi
	#	s2 - Yi
	#	s3 - Xf
	#	s4 - Yf
	#
	# A função foi implementada da seguinte maneira:
	# 1 - Coloca o ponteiro da imagem no ponto Xiniail, Yinicial
	# 2 - Para cada linha, acrescenta o ponteiro e pinta até chegar no Xfinal
	# 3 - Depois de preencher as colunas da linha, volta uma linha caso n tenha 
	#     chegado no Y final e repete o passo 2
	 
	draw_full_rectangle:
		# Coleta os pontos do retângulo
		print_string(xInicial)
		input_int()
		mv s1, t0	# S1 = XInicial
		
		print_string(yInicial)
		input_int()
		mv s2, t0	# S2 = YInicial
		
		print_string(xFinal)
		input_int()
		mv s3, t0	# S3 = XFinal
		
		print_string(yFinal)
		input_int()
		mv s4, t0	# S4 = YFinal
		
		# Auxiliares lógicos
		sub	t4, s3, s2	# Delta X
		
		# Auxiliares para contar linha
		addi	t2, s1, 0	# t2 contador para pontos na linha
		addi	t3, s2, 0	# t3 contador para pontos na coluna
		
		# Multiplica para somar certo os ponteiros
		slli	s2,s2,8		#s2 = s2 * 4 * 64
		slli	s1,s1,2		#s1 = s1 * 4

		# Coleta a cor RGB do teclado
		li t1, 0x00FF0000	
	
		# Cor está em t1, ponteiro inicial do retangulo está em t0
		lw 	t0, init
		add	t0,t0,s1	#Somando o valor de Xinicial
		sub	t0,t0,s2 	#Subtraindo o valor de Yinicial
	
	draw_full_rectangle_loop:
		# Pinta uma linha
		sw 	t1, 0(t0) 	# Colorindo o ponto atual
		addi	t0, t0, 4	# Pula para o próximo ponto
		addi	t2, t2, 1	# Adiciona o contador de linha
		bge	t2, s3, caboulinha	# Confere se já acabou a linha
		jal	draw_full_rectangle_loop	# Enquanto não acabou a linha, pinta
		
	caboulinha:
		# Muda a linha ou verifica se já acabou
		mv	t2, t4
		slli	t2, t2, 2	# Multiplica por 4	
		sub	t0, t0, t2 	# Volta para o começo da linha
		addi	t0, t0, -256	# Pula para linha anterior
		sub	t2, s3, t4	# Reseta o Contador de linha t2 = XFinal - DeltaX
		addi	t3, t3, 1	# Acrescenta contador de coluna
		bge	s4, t3, draw_full_rectangle_loop	# Enquanto não tiver chegado na coluna máxima
		ret
	
	
	#-------------------------------------------------------------------------
	# Funcao draw_empty_rectangle: recebe de input do teclado 2 pontos e cores rgb 
	# e desenha as bordas de  retângulo, tendo em vista que o X e o Y inciais são menor que os finais
	# Parametros:
	#	recebe do teclado
	# Registradores:
	#	s1 - Xi
	#	s2 - Yi
	#	s3 - Xf
	#	s4 - Yf
	#
	# A função foi implementada da seguinte maneira:
	# 1 - Coloca o ponteiro da imagem no ponto Xiniail, Yinicial
	# 2 - Para cada linha, acrescenta o ponteiro e pinta até chegar no Xfinal
	# 3 - Depois de preencher as colunas da linha, volta uma linha caso n tenha 
	#     chegado no Y final e repete o passo 2