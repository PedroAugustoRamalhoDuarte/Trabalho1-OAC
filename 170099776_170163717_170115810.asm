#-------------------------------------------------------------------------
#		Organização e Arquitetura de Computadores - Turma C 
#			Trabalho 1 - Assembly RISC-V
#
# Nome: Ariel Batista da Silva			Matrícula: 170099776
# Nome: Pedro Augusto Ramalho Duarte		Matrícula: 170163717
# Nome: Waliff Cordeiro Bandeira		Matrícula: 170115810


#-------------------------------------------------------------------------
# Dados
.data

menu:		.asciz	"• Defina o número opção desejada: \n 1. Obtém ponto\n2. Desenha ponto\n3. Desenha retângulo com preenchimento\n4. Desenha retângulo sem preenchimento\n5. Converte para negativo da imagem\n6. Converte imagem para tons de vermelho\n7. Carrega imagem\n8. Encerra\n"
menu_erro:	.asciz	"Opção não disponivel, porfavor digite um número válido\n"

init:		.word	0x10043F00	# 0x10040000 + 64x63

dp1:		.asciz	"Digite um valor para X(0 a 63):"
dp2:		.asciz	"Digite um valor para Y(0 a 63):"

ret1_xInicial:	.asciz	"Digite um valor para o X inicial(0 a 63): "
ret2_yInicial:	.asciz	"Digite um valor para o Y inicial(0 a 63):"
ret3_xFinal:		.asciz	"Digite um valor para o X final(0 a 63):"
ret4_yFinal:		.asciz	"Digite um valor para o Y final(0 a 63):"

cor1:		.asciz	"Coloque a intencidade do Vermelho:"
cor2:		.asciz	"Coloque a intencidade do Verde:"
cor3:		.asciz	"Coloque a intencidade do Azul:"
#
#-------------------------------------------------------------------------






#-------------------------------------------------------------------------
# Programa
.text


#-------------------------------------------------------------------------
# Macros

.macro	print_string($arg)
		#chamada de sistema para imprimir strings na tela -> definida por a7=4 
		#parâmetros: a0 -> endereço da string que se quer imprimir
		#retorno: imprime uma string no console
		li	a7, 4		#a7=4 -> definição da chamada de sistema para imprimir strings na tela
		la	a0, $arg	#a0=endereço da string passada com parametro
		ecall			#realiza a chamada de sistema
.end_macro
		
		#chamada de sistema ler um valor do console e guardar no registrador passdo como parâmetro -> definida por a7=7
		#parâmetros: Onde o valor vai ser guardado
		#retorno: salva o o valor inserido no console no registro passdo como parametro
	
	
.macro	input_int($arg) 
		li	a7, 5		#a7 = 5 -> definição da chamada de sistema para ler número inteiro
		ecall			#realiza a chamada de sistema
		mv	$arg, a0 		#
.end_macro
	
	
.macro	input_Cor($arg)
		print_string(cor1)
		input_int(t1)
		mv 	$arg, t1		#arg = R
		slli	$arg,$arg,8		#movendos bits para poder encaixar o verde
		
		print_string(cor2)
		input_int(t1)
		add 	$arg,$arg,t1		#colocando o verde no numero
		slli	$arg,$arg,8		#movendos bits para poder encaixar o azul
		
		print_string(cor3)
		input_int(t1)
		add 	$arg,$arg,t1		#colocando o verde no numero
.end_macro
#
#-------------------------------------------------------------------------



Menu:		li	t0,1
		print_string(menu)
		input_int(t1)
		
		beq	t0,t1,ObtemPonto	#Vendo se é a opção 1	
		addi	t0,t0,1
		beq	t0,t1,DesenhaPonto	#Vendo se é a opção 2
		addi	t0,t0,1
		beq	t0,t1,DesenhaRetPre	#Vendo se é a opção 3
		addi	t0,t0,1
		beq	t0,t1,DesenhaRetVaz	#Vendo se é a opção 4
		addi	t0,t0,1
		beq	t0,t1,Negativo		#Vendo se é a opção 5
		addi	t0,t0,1
		beq	t0,t1,Vermelho		#Vendo se é a opção 6
		addi	t0,t0,1
		beq	t0,t1,LoadImage		#Vendo se é a opção 7
		addi	t0,t0,1
		beq	t0,t1,Sair		#Vendo se é a opção 8
		
		print_string(menu_erro)		#Mostrar mensagem de erro caso nao exita a opção inserida
		b	Menu			#Voltando para o Menu
		


ObtemPonto:
		print_string(dp1)
		input_int(s1)			#s1 = x
		
		print_string(dp2)
		input_int(s2)			#s2 = y
		
		lw 	t0, init
		add	t0,t0,s1		#Somando o valor de X
		sub	t0,t0,s2 		#Subtraindo o valor de Y
		lw	s3,0(t0)		#pegando o valor da cor daquele pixel 0x00RRGGBB
		
		b	Menu

DesenhaPonto:
		print_string(dp1)
		input_int(s1)		#s1 = X
		
		
		print_string(dp2)
		input_int(s2)		#s2 = Y
		
		
		input_Cor(s3)		#s3 = cor do ponto
		
		jal	draw_point	#Chamando a funcao
		
		b	Menu
		
DesenhaRetPre:
		# Coleta os pontos do retângulo
		print_string(ret1_xInicial)
		input_int(s1)		# S1 = XInicial
		
		print_string(ret2_yInicial)
		input_int(s2)		# S2 = YInicial
		
		print_string(ret3_xFinal)
		input_int(s3)		# S3 = XFinal
		
		print_string(ret4_yFinal)
		input_int(s4)		# S4 = YFinal
		
		# Coleta a cor RGB do teclado
		input_Cor(s5)		#s5 = cor do ponto	
		
		call	draw_full_rectangle
		
		b	Menu

DesenhaRetVaz:
		b	Menu

Negativo:
		b	Menu

Vermelho:
		b	Menu

LoadImage:
		b	Menu

Sair:
		ebreak
		
		
		
		
#-------------------------------------------------------------------------
# Funcoes

	#-----------------------------------------------------------------
	# Funcao draw_point: Recebe de parametro as coordenadas de um ponto 
	# e uma cor e desenha nesse ponto e nessa cor
	# Parâmetros:
	# s1 - X
	# s2 - Y
	# s3 - Cor RGB


	draw_point:
		slli	s2,s2,8		#s2 = s2 * 4 * 64 Ajustando valores para encaixar na memoria
		slli	s1,s1,2		#s1 = s1 * 4	  Ajustando valores para encaixar na memoria
		
		lw 	t0, init	#carregando o endereço do ponto (0,0)
		add	t0,t0,s1	#Somando o valor de X
		sub	t0,t0,s2 	#Subtraindo o valor de Y
		mv	t1,s3		#Carregando a Cor
		sw 	t1,0(t0) 	#Colocando o ponto na memoria
		
		ret

	#-----------------------------------------------------------------
	# Funcao draw_full_rectangle: Recebe de parametro 4 pontos e uma cor RGB
	# e desenha um retângulo preenchido, tendo em vista que o X e o Y inciais são menores que os finais.
	# Parametros:
	#	s1 - Xi
	#	s2 - Yi
	#	s3 - Xf
	#	s4 - Yf
	#	s5 - Cor RGB
	#
	# A função foi implementada da seguinte maneira:
	# 1 - Coloca o ponteiro da imagem no ponto Xiniail, Yinicial
	# 2 - Para cada linha, acrescenta o ponteiro e pinta até chegar no Xfinal
	# 3 - Depois de preencher as colunas da linha, volta uma linha caso n tenha 
	#     chegado no Y final e repete o passo 2
	 
	draw_full_rectangle:		
		# Auxiliares lógicos
		sub	t4, s3, s1	# Delta X
		
		# Auxiliares para contar linha
		addi	t2, s1, 0	# t2 contador para pontos na linha
		addi	t3, s2, 0	# t3 contador para pontos na coluna
		
		# Multiplica para somar certo os ponteiros
		slli	s2, s2, 8		#s2 = s2 * 4 * 64
		slli	s1, s1, 2		#s1 = s1 * 4
	
		# Cor está em t1, ponteiro inicial do retangulo está em t0
		lw 	t0, init
		add	t0, t0, s1	# Somando o valor de Xinicial
		sub	t0, t0, s2 	# Subtraindo o valor de Yinicial
	
	draw_full_rectangle_loop:
		# Pinta uma linha
		sw 	s5, 0(t0) 	# Colorindo o ponto atual
		addi	t0, t0, 4	# Pula para o próximo ponto
		addi	t2, t2, 1	# Adiciona o contador de linha
		bgt 	t2, s3, caboulinha	# Confere se já acabou a linha
		b	draw_full_rectangle_loop	# Enquanto não acabou a linha, pinta
		
	caboulinha:
		# Muda a linha ou verifica se já acabou
		mv	t2, t4
		slli	t2, t2, 2	# Multiplica por 4	
		sub	t0, t0, t2 	# Volta para o começo da linha
		addi	t0, t0, -260	# Pula para linha anterior (- 256(linha) - 4(loop soma 4 antes de conferir se acabou)),
		sub	t2, s3, t4	# Reseta o Contador de linha t2 = XFinal - DeltaX
		addi	t3, t3, 1	# Acrescenta contador de coluna
		bge	s4, t3, draw_full_rectangle_loop	# Enquanto não tiver chegado na coluna máxima
		ret
	#
	#-----------------------------------------------------------------

#
#-------------------------------------------------------------------------
		
		
					
		
		
			



