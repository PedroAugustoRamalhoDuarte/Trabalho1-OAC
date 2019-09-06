.data
	xInicial:	.asciz	"Digite um valor para o X inicial(0 a 63): "
	yInicial:	.asciz	"Digite um valor para o Y inicial(0 a 63):"
	xFinal:		.asciz	"Digite um valor para o X final(0 a 63):"
	yFinal:		.asciz	"Digite um valor para o Y final(0 a 63):"
	str4:		.asciz	"Coloque a intencidade do Vermelho:"
	str5:		.asciz	"Coloque a intencidade do Verde:"
	str6:		.asciz	"Coloque a intencidade do Azul:"
	
.text

	#-------------------------------------------------------------------------
	# Funcao draw_full_rectangle: recebe de input do teclado 2 pontos e cores rgb 
	# e desenha um retângulo
	# Parametros:
	#	recebe do teclado
	# Registradores:
	#	s1 - Xi
	#	s2 - Yi
	#	s3 - Xf
	#	s4 - Yf
	#
	# A função foi implementada ... (explicação da função)
	
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
		
		# Coleta a cor RGB do teclado
		