.data
	xInicial:	.asciz	"Digite um valor para o X inicial(0 a 63): "
	yInicial:	.asciz	"Digite um valor para o Y inicial(0 a 63):"
	xFinal:		.asciz	"Digite um valor para o X final(0 a 63):"
	yFinal:		.asciz	"Digite um valor para o Y final(0 a 63):"
	msgOutOfRange:	.asciz  "Por gentileza coloque os valores de X e Y, iniciais e finais, entre 0 e 63"
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
	
	main:
		# Coleta os pontos do retângulo
		print_string(xInicial)
		input_int()
		mv a1, t0	# S1 = XInicial
		
		print_string(yInicial)
		input_int()
		mv a2, t0	# S2 = YInicial
		
		print_string(xFinal)
		input_int()
		mv a3, t0	# S3 = XFinal
		
		print_string(yFinal)
		input_int()
		mv a4, t0	# S4 = YFinal
		
		# Coleta a cor RGB do teclado
		li a5, 0x00FF0000	
		
		jal draw_empty_rectangle
		nop
		
		li a7, 10
		ecall
		
		
	#-------------------------------------------------------------------------
	# Funcao verifica_x_y: Verifica se todos os valores de entrada estão entre 0 e 63,
	# e coloca o menor entre os X no a1 e o menor entre o Y no a2
	# Parametros:
	#	a1 - Xi
	#	a2 - Yi
	#	a3 - Xf
	#	a4 - Yf
	# Retorno:
	# 	a0 = 0, verificação falha
	verifica_x_y:
		# Inicializa o retorno como não falha
		li a0, 1
		
		# Auxiliar de comparação
		li t5, 63
		
		# Primeiro verifica se são maiores 63
		bgt a1, t5, verifica_x_y_error
		bgt a2, t5, verifica_x_y_error
		bgt a3, t5, verifica_x_y_error
		bgt a4, t5, verifica_x_y_error
		nop
		
		# Agora verifica se são menores que 0
		bltz a1, verifica_x_y_error
		bltz a2, verifica_x_y_error
		bltz a3, verifica_x_y_error
		bltz a4, verifica_x_y_error
		nop
		
	verifica_x_y_adequado:	
		# Agora ajusta para o a1 e o a2 serem os menores que a3 e a4, 
		bgt a1, a3, verifica_x_y_swap_x
		bgt a2, a4, verifica_x_y_swap_y
		nop
		
		ret
		
	verifica_x_y_swap_x:
		# Troca os valores de X
		mv t5, a1
		mv a1, a3
		mv a3, t5
		b verifica_x_y_adequado
		nop
		
	verifica_x_y_swap_y:
		# Troca os valoers de Y
		mv t5, a2
		mv a2, a4
		mv a4, t5
		b verifica_x_y_adequado
		nop
		
	verifica_x_y_error:
		print_string(msgOutOfRange)
		li a0, 0
		ret
		
	#-----------------------------------------------------------------
	# Funcao draw_full_rectangle: Recebe de parametro 4 pontos e uma cor RGB
	# e desenha um retângulo preenchido, tendo em vista que o X e o Y inciais são menores que os finais.
	# Parametros:
	#	a1 - Xi
	#	a2 - Yi
	#	a3 - Xf
	#	a4 - Yf
	#	a5 - Cor RGB
	#
	# A função foi implementada da seguinte maneira:
	# 1 - Coloca o ponteiro da imagem no ponto Xiniail, Yinicial
	# 2 - Para cada linha, acrescenta o ponteiro e pinta até chegar no Xfinal
	# 3 - Depois de preencher as colunas da linha, volta uma linha caso n tenha 
	#     chegado no Y final e repete o passo 2
	 
	draw_full_rectangle:
	
		# Chama a sub-rotina que verifica se as entradas da função estão de acordo, e modifca dentro do possível
		mv	s10, ra		# Armazena o endereço da main em s10
		jal 	verifica_x_y
		
		# Verifica se a subrotina verifica_x_y retornou error
		beqz    a0, draw_full_rectangle_error
		
		# Auxiliares lógicos
		sub	t4, a3, a1	# Delta X
		
		# Auxiliares para contar linha
		addi	t2, a1, 0	# t2 contador para pontos na linha
		addi	t3, a2, 0	# t3 contador para pontos na coluna
		
		# Multiplica para somar certo os ponteiros
		slli	a2, a2, 8	# a2 = a2 * 4 * 64
		slli	a1, a1, 2	# a1 = a1 * 4
	
		# Cor está em t1, ponteiro inicial do retangulo está em t0
		lw 	t0, init
		add	t0, t0, a1	# Somando o valor de Xinicial
		sub	t0, t0, a2 	# Subtraindo o valor de Yinicial
	
	draw_full_rectangle_loop:
		# Pinta uma linha
		sw 	a5, 0(t0) 	# Colorindo o ponto atual
		addi	t0, t0, 4	# Pula para o próximo ponto
		addi	t2, t2, 1	# Adiciona o contador de linha
		bgt 	t2, a3, draw_full_rectangle_caboulinha	# Confere se já acabou a linha
		b	draw_full_rectangle_loop	# Enquanto não acabou a linha, pinta
		nop
		
	draw_full_rectangle_caboulinha:
		# Muda a linha ou verifica se já acabou
		
		# Volta para o começo da linha usando t2 de auxiliar
		mv	t2, t4
		slli	t2, t2, 2	# Multiplica por 4	
		sub	t0, t0, t2 
			
		addi	t0, t0, -260	# Pula para linha anterior (- 256(linha) - 4(loop soma 4 antes de conferir se acabou)),
		sub	t2, a3, t4	# Reseta o Contador de linha t2 = XFinal - DeltaX
		addi	t3, t3, 1	# Acrescenta contador de coluna
		bge	a4, t3, draw_full_rectangle_loop	# Enquanto não tiver chegado na coluna máxima
		jr	s10		# Retorna para main
		
	draw_full_rectangle_error:
		jr	s10		# Retorna para main
	#-----------------------------------------------------------------
	
	
	#-------------------------------------------------------------------------
	# Funcao draw_empty_rectangle: Recebe 2 pontos de parametro, cores RGB
	# e desenha as bordas de  retângulo, tendo em vista que o X e o Y inciais são menores que os finais
	# Parametros:
	#	a1 - Xi
	#	a2 - Yi
	#	a3 - Xf
	#	a4 - Yf
	#	a5 - Cor RGB
	#
	# A função foi implementada da seguinte maneira:
	# 1 - Coloca o ponteiro da imagem no ponto Xinicial, Yinicial
	# 2 - Colore a coluna da esquerda, subtraindo 256 do ponteiro da imagem e pintando dentro do range recebido por parametro
	# 3 - Colore a linha de cima, somando 4 do ponteiro da imagem resultado da operação de cima dentro do range
	# 5 - Retorna o ponteiro da imagem para posição Xinicial, Yinicial
	# 6 - Colore a linha de baixo, da mesma maneira do item 3
	# 7 - Colore a coluna da direita, da mesma maneira do item 2
	
	draw_empty_rectangle:
		# Guarda o endereço de retorno para main
		mv	s10, ra
		jal 	verifica_x_y
		
		# Verifica se a subrotina verifica_x_y retornou error
		beqz    a0, draw_full_rectangle_error
		
		# Auxiliares lógicos
		sub	t4, a3, a1	# Delta X
		sub	t5, a4, a2	# Delta Y
		
		# Multiplica para somar certo os ponteiros
		slli	a2, a2, 8		#a2 = a2 * 4 * 64
		slli	a1, a1, 2		#a1 = a1 * 4
	
		# Colocando Ponteiro Inicial do retângulo em t0
		lw 	t0, init
		add	t0, t0, a1	# Somando o valor de Xinicial
		sub	t0, t0, a2 	# Subtraindo o valor de Yinicial
		
		# Colore a coluna da esquerda
		addi	a3, x0, 0
		jal draw_empty_rectangle_colum
		
		# Colore a linha de cima
		addi	t0, t0, 256
		addi	a3, x0, 0
		jal draw_empty_rectangle_line
		
		# Colocando Ponteiro Inicial do retângulo em t0
		lw 	t0, init
		add	t0, t0, a1
		sub	t0, t0, a2
			
		# Colore a linha de baixo
		addi	a3, x0, 0
		jal draw_empty_rectangle_line
		
		# Colore a coluna da direita
		addi	t0, t0, -4
		addi	a3, x0, 0
		jal draw_empty_rectangle_colum
		
		jr	s10	# Retorna para main
		
	# Desenha uma coluna, com ponto inicial t0, cor a5 e tamanho t5. OBS: Necessário a3 zerado
	draw_empty_rectangle_colum:
		sw 	a5, 0(t0) 	# Colorindo o ponto atual
		addi	t0, t0, -256	# Pula para o ponto na linha anterior
		addi	a3, a3, 1	# Adiciona o contador de linha
		bge 	t5, a3, draw_empty_rectangle_colum	# Confere se já acabou a linha
		ret	
	
	# Desenha uma linha, com ponto inicial t0, cor a5 e tamanho t4. OBS: Necessário a3 zerado	
	draw_empty_rectangle_line:
		sw 	a5, 0(t0) 	# Colorindo o ponto atual
		addi	t0, t0, 4	# Pula para o próximo ponto
		addi	a3, a3, 1	# Adiciona o contador de linha
		bge 	t4, a3, draw_empty_rectangle_line	# Confere se já acabou a linha
		ret	
