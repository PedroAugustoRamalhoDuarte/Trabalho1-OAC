.data
	str0:	.asciz	"Digite um número: "
	str1:	.asciz	"Digite um valor para X:"
	str2:	.asciz	"Digite um valor para Y:"
	str3:	.asciz	"Coloque a intencidade do Vermelho:"
	str4:	.asciz	"Coloque a intencidade do Verde:"
	str5:	.asciz	"Coloque a intencidade do Azul:"
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
		li	a7, 5		#a7 = 5 -> definição da chamada de sistema para ler número inteiro
		ecall			#realiza a chamada de sistema
		mv	t0, a0 		#
	.end_macro
	
	
	
	draw_point:
		print_string(str1)
		input_int()
		mv 	s1, t0		#s1 = X
		
		
		print_string(str2)
		input_int()
		mv 	s2, t0		#s2 = Y
		
		
		
		print_string(str3)
		input_int()
		mv 	s3, t0		#s3 = R
		slli	s3,s3,8		#movendos bits para poder encaixar o verde
		
		print_string(str4)
		input_int()
		add 	s3,s3,t0	#colocando o verde no numero
		slli	s3,s3,8		#movendos bits para poder encaixar o azul
		
		print_string(str5)
		input_int()
		add 	s3,s3,t0	#colocando o verde no numero
		
		
		slli	s2,s2,8		#s2 = s2 * 4 * 64
		slli	s1,s1,2		#s1 = s1 * 4
		
		
		
		lw 	t0, init
		add	t0,t0,s1	#Somando o valor de X
		sub	t0,t0,s2 	#Subtraindo o valor de Y
		#li 	t1, 0x00FF0000	#Carregando a Cor
		mv	t1,s3		#Carregando a Cor
		sw 	t1, 0(t0) 	#Colocando o ponto na memoria
		
		
		
