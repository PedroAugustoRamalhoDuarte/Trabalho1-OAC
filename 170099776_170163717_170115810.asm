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
menu_volta:	.asciz	"\nPrecione enter para voltar para o Menu\n"
msgOutOfRange:	.asciz  "Input com range incorreto, por gentileza coloque um número entre: 0 e "

init:		.word	0x10043F00	# 0x10040000 + 64x63

dp1:		.asciz	"Digite um valor para X(0 a 63):"
dp2:		.asciz	"Digite um valor para Y(0 a 63):"

ret1_xInicial:	.asciz	"Digite um valor para o X inicial(0 a 63): "
ret2_yInicial:	.asciz	"Digite um valor para o Y inicial(0 a 63):"
ret3_xFinal:	.asciz	"Digite um valor para o X final(0 a 63):"
ret4_yFinal:	.asciz	"Digite um valor para o Y final(0 a 63):"

cor1:		.asciz	"Coloque a intencidade do Vermelho:"
cor2:		.asciz	"Coloque a intencidade do Verde:"
cor3:		.asciz	"Coloque a intencidade do Azul:"

mR:		.asciz	"R= "
mG:		.asciz	"G= "
mB:		.asciz	"B= "
mN:		.asciz	"\n"

image_name:   	.asciz "lenaeye.raw"	# nome da imagem a ser carregada
address: 	.word   0x10040000			# endereco do bitmap display na memoria	
buffer:		.word   0				# configuracao default do RARS
size:		.word	4096				# numero de pixels da imagem
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

.macro	input_string($arg) 
		li	a7, 8		#a7 = 8 -> definição da chamada de sistema para ler uma string
		ecall			#realiza a chamada de sistema
		mv	$arg, a0 		#
.end_macro
			
	
.macro	input_int($arg) 
		li	a7, 5		#a7 = 5 -> definição da chamada de sistema para ler número inteiro
		ecall			#realiza a chamada de sistema
		mv	$arg, a0 		#
.end_macro
	
	
.macro	input_Cor($arg)
		print_string(cor1)
		input_int(t1)
		# Verifica se a entrada está entre 0 e 255
		li	s11, 255
		jal	input_range
		
		mv 	$arg, t1		#arg = R
		slli	$arg,$arg,8		#movendos bits para poder encaixar o verde
		
		print_string(cor2)
		input_int(t1)
		# Verifica se a entrada está entre 0 e 255
		li	s11, 255
		jal	input_range
		
		add 	$arg,$arg,t1		#colocando o verde no numero
		slli	$arg,$arg,8		#movendos bits para poder encaixar o azul
		
		print_string(cor3)
		input_int(t1)
		# Verifica se a entrada está entre 0 e 255
		li	s11, 255
		jal	input_range
		
		add 	$arg,$arg,t1		#colocando o verde no numero
.end_macro

.macro	print_int($arg)
		#chamada de sistema para imprimir interios na tela -> definida por a7=1 
		#parâmetros: a0 -> o valor a imprimir
		#retorno: imprime um inteiro no console
		li	a7, 1		#a7=1 -> definição da chamada de sistema para imprimir inteiros na tela
		mv	a0, $arg	#a0=numero passado como parametro
		ecall

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
		# Limite máximo do input = 63
		li	s11, 63
		
		print_string(dp1)
		input_int(t1)
		jal	input_range	# Verifica se o input está entre 0 e 63	
		mv	s1, t1		#s1 = X
		
		print_string(dp2)
		input_int(t1)	
		jal	input_range	# Verifica se o input está entre 0 e 63
		mv	s2, t1		#s2 = Y
		
		jal	get_point
		
		
		b	Menu


DesenhaPonto:
		# Limite máximo do input = 63
		li	s11, 63
		
		print_string(dp1)
		input_int(t1)
		jal	input_range	# Verifica se o input está entre 0 e 63	
		mv	s1, t1		#s1 = X
		
		print_string(dp2)
		input_int(t1)	
		jal	input_range	# Verifica se o input está entre 0 e 63
		mv	s2, t1		#s2 = Y
		
		input_Cor(s3)		#s3 = cor do ponto
		
		jal	draw_point	#Chamando a funcao
		
		b	Menu
		
DesenhaRetPre:
		# Limite máximo do input = 63
		li	s11, 63
		
		# Coleta os pontos do retângulo
		print_string(ret1_xInicial)
		input_int(t1)			
		jal input_range			# Verifica se o input está entre 0 e 63
		mv	a1, t1			# a1 = XInicial
		
		print_string(ret2_yInicial)
		input_int(t1)
		jal input_range			# Verifica se o input está entre 0 e 63		
		mv	a2, t1			# a2 = YInicial
		
		print_string(ret3_xFinal)
		input_int(t1)
		jal input_range			# Verifica se o input está entre 0 e 63			
		mv	a3, t1			# a3 = XFinal
		
		print_string(ret4_yFinal)
		input_int(t1)
		jal input_range			# Verifica se o input está entre 0 e 63			
		mv	a4, t1			# a4 = YFinal
		
		# Coleta a cor RGB do teclado
		input_Cor(a5)			# a5 = cor da borda do retângulo
		
		call	draw_full_rectangle
		
		b	Menu

DesenhaRetVaz:
		# Limite máximo do input = 63
		li	s11, 63
		
		# Coleta os pontos do retângulo
		print_string(ret1_xInicial)
		input_int(t1)			
		jal input_range			# Verifica se o input está entre 0 e 63
		mv	a1, t1			# a1 = XInicial
		
		print_string(ret2_yInicial)
		input_int(t1)
		jal input_range			# Verifica se o input está entre 0 e 63		
		mv	a2, t1			# a2 = YInicial
		
		print_string(ret3_xFinal)
		input_int(t1)
		jal input_range			# Verifica se o input está entre 0 e 63			
		mv	a3, t1			# a3 = XFinal
		
		print_string(ret4_yFinal)
		input_int(t1)
		jal input_range			# Verifica se o input está entre 0 e 63			
		mv	a4, t1			# a4 = YFinal
		
		# Coleta a cor RGB do teclado
		input_Cor(a5)			# a5 = cor da borda do retângulo
		
		call	draw_empty_rectangle
		
		b	Menu
Negativo:
		# Chama a sub rotina convert_negative	
		jal 	convert_negative
		b	Menu

Vermelho:	
		# Chama a sub rotina convert_redtones	
		jal	convert_redtones
		b	Menu

LoadImage:
		# define parâmetros e chama a função para carregar a imagem
		la 	a0, image_name
		lw 	a1, address
		la 	a2, buffer
		lw 	a3, size
		jal 	load_image
		b	Menu

Sair:
		# Encerra o programa
		li 	a7, 10
		ecall
		
		
		
		
#-------------------------------------------------------------------------
# Funcoes

#-------------------------------------------------------------------------
# Subrotinas auxiliares
	
	#---------------------------------------------------------------
	# Funcao input_range: verifica se o t1 está entre 0 e o valor do registrador s11,
	# caso esteja dentro do esperado n faz nada, caso esteja fora do range volta ao menu
	# Parâmetros:
	# a2 - Valor máximo do input
	#
	# A função foi implementada da seguinte maneira:
	# if (t1 < 0 and t1 > s11){
	# 	menu();
	# }	
	input_range:
		# Primeiro verifica se o input é menor que s11
		bgt t1, s11, input_range_error
		nop
		
		# Agora verifica se é menor que 0
		bltz t1, input_range_error
		
		ret
		
	input_range_error:
		print_string(msgOutOfRange)
		print_int(s11)
		print_string(menu_volta)
		input_string(t0)		#Trava o sistema para a pessoa ver o resultado
		b	Menu
#-------------------------------------------------------------------------	
		
	#-----------------------------------------------------------------
	# Funcao get_point: Recebe como parametro as conrdenadas de um ponto
	# e imprime no console as suas componentes de cor.
	# Parâmetros:
	# s1 - X
	# s2 - Y
	#
	# A função foi implementada da seguinte maneira:
	#
	# 1 - Desloca o ponteiro para a posicao determinada por X e Y.
	# 2 - Da um load na word que esta naquela regiao de memoria.
	# 3 - Atravez de deslocamento vai limpando os bits nao necessarios 
	# para cada cor.
	# 4 - Imprime no console o resultado.
	
	
	
	get_point:
		slli	s2,s2,8		#s2 = s2 * 4 * 64 Ajustando valores para encaixar na memoria
		slli	s1,s1,2		#s1 = s1 * 4	  Ajustando valores para encaixar na memoria
		
		lw 	t0, init	#carregando o endereço do ponto (0,0)
		add	t0,t0,s1	#Somando o valor de X
		sub	t0,t0,s2 	#Subtraindo o valor de Y
		mv	t1,s3		#Carregando a Cor
		lw 	s4,0(t0) 	#Colocando o ponto na memoria
		
		mv	t2,s4		#Colocando a cor numa auxiliar
		slli	t2,t2,8		#Apagando o byte da esquerda
		srli	t2,t2,24	#Movendo o byte para mostrar na tela
		print_string(mR)
		print_int(t2)
		print_string(mN)
		
		mv	t2,s4		#Colocando a cor numa auxiliar
		slli	t2,t2,16	#Apagando o byte da esquerda
		srli	t2,t2,24	#Movendo o byte para mostrar na tela
		print_string(mG)
		print_int(t2)
		print_string(mN)
		
		mv	t2,s4		#Colocando a cor numa auxiliar
		slli	t2,t2,24	#Apagando o byte da esquerda
		srli	t2,t2,24	#Movendo o byte para mostrar na tela
		print_string(mB)
		print_int(t2)
		print_string(mN)
		
		print_string(menu_volta)
		input_string(t0)		#Trava o sistema para a pessoa ver o resultado
		ret
	
	#-----------------------------------------------------------------
	# Funcao draw_point: Recebe de parametro as coordenadas de um ponto 
	# e uma cor e desenha nesse ponto e nessa cor
	# Parâmetros:
	# s1 - X
	# s2 - Y
	# s3 - Cor RGB
	#
	# A função foi implementada da seguinte maneira:
	#
	# 1 - Desloca o ponteiro para a posicao determinada por X e Y.
	# 2 - Salva a cor recebida por paramametro naquela posicção de memoria 
	# que o ponteiro aponta.


	draw_point:
		slli	s2,s2,8		#s2 = s2 * 4 * 64 Ajustando valores para encaixar na memoria
		slli	s1,s1,2		#s1 = s1 * 4	  Ajustando valores para encaixar na memoria
		
		lw 	t0, init	#carregando o endereço do ponto (0,0)
		add	t0,t0,s1	#Somando o valor de X
		sub	t0,t0,s2 	#Subtraindo o valor de Y
		mv	t1,s3		#Carregando a Cor
		sw 	t1,0(t0) 	#Colocando o ponto na memoria
		
		ret
	
	
	#
	#-----------------------------------------------------------------


#-------------------------------------------------------------------------
# Funcões Retangulo

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
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
# Sub Rotinas para operações com imagens

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
		lw 	a1, address
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
		ret					# retorna pra rotina principal
		
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
		# Máscara e tamanho da imagem - Quando declarei no .data deu ruim
		li 	s8, 4096			# Tamanho da imagem - Quantidade de words que serão acessadas
		li 	s7, 0x00FF0000			# Máscara que mantém apenas a informação do vermelho (RGB)
		lw 	a1, address
		
	convert_redtones_loop:	
		lw 	s0,0(a1)			# pega o valor da imagem em 1 word
		and	s0,s7,s0			# aplica a máscara
		sw 	s0,0(a1)			# devolve o valor/cor da word para o endereço/imagem
		addi	a1,a1,4				# aponta para a próxima word da imagem		
		blez 	s8, cabouImagem			# verifica se o contador s8 chegou em 0 para encerrar o programa
		addi 	s8, s8, -1			# decrementa o contador 
		b 	convert_redtones_loop		# continua enquanto não acabar a imagem
#------------------------------------------------------------------------

#
#-------------------------------------------------------------------------
		
		
					
		
		
			



