.data
	filename: .asciiz "C:\\Users\\Pichau\\Desktop\\LM\\teste.txt" #42 bytes (0x10010000)
	buffer: .space 1024 #1024 bytes (0x1001002A)
.text

main:	
	#s0 = fopen(filename, "r")
	addi $v0, $zero, 13 #syscall de abrir arquivo
	lui $a0, 0x1001 #carrega o filename em $a0
   	ori $a0, $a0, 0x0000
	addi $a1, $zero, 0 
	addi $a2, $zero, 0 #abre pra leitura
	syscall
	add $s0, $v0, $zero #salva em $s0
	# -------------------------------------
	
	#ler
	addi $v0, $zero, 14 #ler de um arquivo
	add $a0, $zero, $s0 #passar onde esta o file descriptor
	lui $a1, 0x1001 #carrega o buffer para $a1
	ori $a1, $a1, 0x002A
	addi $a2, $zero, 1024
	syscall
	add $s1, $a1, $zero #s1 aponta para os dados lidos
	add $s2, $v0, $zero #s2 = tamanho do arquivo
	# --------------------------------------
	

	add $s3, $zero, $s1 #s5 sera o ponteiro que vai percorrer o buffer
	#loop para ler as linhas
	read_line_loop:
		# int s3 = malloc( 200 )
		addi $v0, $zero, 9 #sbrk
		addi $a0, $zero, 200 #200 bytes (50 inteiros)
		syscall
		add $s4, $zero, $v0 #s3 tem o ponteiro para o inicio do vetor
		# ----------------------
		add $s5, $zero, $zero #s4 vai armazenar o tamanho total do vetor	
	
			read_number_loop: #ler os bytes e transformar em um inteiro
				lb $s6, 0($s3) #carrega o prox byte em s6
				addi $s3, $s3, 1 #avanca s5

				#ignorar se for \0
				#addi $t0, $zero, 0x00          # \0
				#beq $s6, $t0, read_number_loop # ignorar \0				
				
				# o sistema windows usa \r\n para newlines.
				addi $t0, $zero, 0x0D # \r
				beq $s6, $t0, read_number_loop # se for \r, pular iteracao
							       # pq ele vai vir seguido de um \n
			
				addi $t0, $zero, 0x0A # \n para portabilizar caso nao for windows (nao testei)
				beq $s6, $t0, call_polygon_function
				
				addi $t0, $zero, 0x2B # +, mudar depois
				beq $s6, $t0, call_polygon_function #se for EOF tambem acabou

				
				#if (s6 == ' ') s4++; continue; 
				addi $t0, $zero, 0x20 # espaco
				bne $s6, $t0, read_byte #se nao for um espaco, ler normalmente
				addi $s5, $s5, 4 #ir para proximos 4 bytes do vetor
				j read_number_loop
				#------------------------------

				read_byte:
				add $t2, $s4, $s5
				lw $t0, 0($t2) #pega o numero atual
				addi $t1, $zero, 10
				mul $t0, $t0, $t1 #multiplica ele por 10

				addi $s6, $s6, -0x30 # subtrai '0' do byte lido, para converter para inteiro
				add $t0, $t0, $s6 #soma o valor multiplicado por 10 com o inteiro lido
				sw $t0, 0($t2) #rearmazena o valor
				
				j read_number_loop
				#-----------------

				call_polygon_function: #colocar os argumentos no lugar certo
				addi $s5, $s5, 4 #incrementar o tamanho, por conta do numero passado
				add $a0, $zero, $s4 #passar o vetor
				add $a1, $zero, $s5 #passar o tamanho do vetor
				add $a2, $zero, $s6 #passar o byte para saber se eh \n ou EOF
				j draw_polygon
				
				
				
			#----------------------------------
				
				
				

		
	# ----------------------
	read_line_end:

	lb $s6, 0($s3) #carrega o prox byte em s6

	addi $v0, $zero, 10
	syscall


	
#-----------------------


	
#funcao para desenhar os poligonos
draw_polygon: # (int *a0, size_t a1, char a2)

	addi $sp, $sp, -16 # salvar 4 inteiros
	sw $s0, 0($sp) 	   # salva s0 na posicao 0 do sp
	sw $s1, 4($sp)     # salva s1 na posicao 4 do sp
	sw $s2, 8($sp)     # salva s2 na posicao 8 do sp
	sw $s3, 12($sp)    # salva s3 na posicao 12 do sp

	add $s0, $zero, $zero    # contador do array
	add $s1, $zero, $a0      # inicio do array
	add $s2, $zero, $a1      # tamanho do array
	add $s3, $zero, $a2      # caracter '\n' ou '\0' (para saber se o codigo deve acabar ou continuar)

	polygon_loop:
		beq $s0, $s2, polygon_loop_end  # condicao de parada (contador == tamanho)
		
		add $t0, $s1, $s0 		# calcular o endereco com offset ( arr* + offset )
		lw $t1, 0($t0)             	# carrega o valor de *arr_offset em t1
		
		# processamento (descobrir coordenadas, desenhar, etc)
		addi $v0, $zero, 1         	
		add $a0, $zero, $t1     
		syscall                    
		# ----------------------------------------------------

		addi $s0, $s0, 4	# incremento do contador do array
		j polygon_loop		# volta o loop (ate s0 atingir s2)
	polygon_loop_end:

	add $t0, $zero, $s3 #salvar s3 porque ele sera recuperado

	lw $s0, 0($sp) 	    #recarrega o que foi salvo no inicio do procedimento
	lw $s1, 4($sp)     
	lw $s2, 8($sp)     
	lw $s3, 12($sp)
	addi $sp, $sp, 16   # desaloca sp

	addi $t1, $zero, 0x0A               # caracter ascii de \n
	beq $t0, $t1, read_line_loop        #ainda nao acabou, continuar

	j read_line_end                     #eh uma flag de finalizacao, acabou

#---------------------------------
	
	
