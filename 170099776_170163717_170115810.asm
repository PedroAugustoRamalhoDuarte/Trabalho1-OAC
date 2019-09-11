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

dp1:		.asciz	"Digite um valor para X(0 a 63):"
dp2:		.asciz	"Digite um valor para Y(0 a 63):"

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
		la	a0, $arg	#a0=endereço da string "str0"
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
		
		beq	t0,t1,ObtemPonto
		addi	t0,t0,1
		beq	t0,t1,DesenhaPonto
		addi	t0,t0,1
		beq	t0,t1,DesenhaRetPre
		addi	t0,t0,1
		beq	t0,t1,DesenhaRetVaz
		addi	t0,t0,1
		beq	t0,t1,Negativo
		addi	t0,t0,1
		beq	t0,t1,Vermelho
		addi	t0,t0,1
		beq	t0,t1,LoadImage
		addi	t0,t0,1
		beq	t0,t1,Sair
		
		print_string(menu_erro)
		b	Menu
		


ObtemPonto:
		b	Menu

DesenhaPonto:
		b	Menu
		
DesenhaRetPre:
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

		
		
					
		
		
			



