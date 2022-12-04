.text
.global main

main:   
	la   $s1, vet         # endereça vet em $s1
	la   $s0, n	         # endereça n
	lw   $s0,0($s0)       # gurada n em $s0
	xor  $t9, $t9, $t9    # inicia o somatorio ddo vetor
	xor  $s4, $s4, $s4    # inicia i = 0
	
#inicio do calculo de média
somatorio:   
	beq  $s4, $s0, mediaCalc 
	sll  $t8, $s4, 2     # $t1 = i * 4 : para endereÃƒÂ§ar vet
	add  $t8, $t8, $s1   # $t1 = address of vet[i]
	lw   $t7, 0($t8)     # $t0 = vet[i]
	add  $t9, $t9, $t7   # soma vet[i] ao somatÃ³rio
	addi $s4, $s4, 1     # incrementa i
	j    somatorio

mediaCalc:    
	addi $t8, $s0, 0
	jal  divider        # resposta em $v0 e $v1
	addi $t0, $v1, 0
	la   $t1, media
	sw   $t0, 0($t1)
	j    bubbleSort
# fim do calculo de média

# divisão do somatório
divider: 
	lui  $t0, 0x8000     # mÃ¡scara para isolar bit mais significativo
	li   $t1, 32          # contador de iteraÃ§Ãµes
	xor  $v0, $v0, $v0   # registrador P($v0)-A($v1) com 0 e o dividendo ($t9)
	add  $v1, $t9, $0
 	 
dloop:  
	and  $t2, $v1, $t0    # isola em t2 o bit mais significativo do reg 'A' ($v1)
	sll  $v0, $v0, 1      # desloca para a esquerda o registrado P-A
	sll  $v1, $v1, 1
	beq  $t2, $0, di1
	ori  $v0, $v0, 1      # coloca 1 no bit menos significativo do registador 'P'($v0)

di1:    
	sub  $t2, $v0, $t8    # subtrai 'P'($v0) do divisor ($t8)
	blt  $t2, $0, di2 
	add  $v0, $t2, $0     # se subtraÃ§Ã£o positiva,'P'($v0) recebe o valor da subtraÃ§Ã£o
	ori  $v1, $v1, 1      # e 'A'($v1) recebe 1 no bit menos significativo

di2:    
	addi $t1, $t1, -1    # decrementa o nÃºmero de iteraÃ§Ãµes
	bne  $t1, $0, dloop
	jr   $ra
# fim da divisão

#inicio da ordenação do vetor
bubbleSort:   
	xor  $s4, $s4, $s4   # i = 0
	subi $t0, $s0, 1     # n - 1
	j    l1Sort
	
l1Sort:     
	beq  $s4, $t0, mediCalc  # termina o loop se i = n - 1 e vai para o calculo de mediana
	xor  $t1, $t1, $t1   # j = 0
	sub  $t3, $t0, $s4   # n - i - 1
	blt  $s4, $t0, l2Sort    # vai para o loop interno
	addi $s4, $s4, 1     # incrementa i
	j    l1Sort
	
l2Sort:	
	sll  $t4, $t1, 2      # $t4 = j * 4 : para endereÃƒÂ§ar vet
	add  $t4, $t4, $s1    # $t4 = address of vet[j]
	lw   $t5, 0($t4)      # $t5 = vet[j]
	addi $t2, $t1, 1      # j + 1
	sll  $t6, $t2, 2     # $t6 = (j+1) * 4 : para endereÃƒÂ§ar vet
	add  $t6, $t6, $s1   # $t6 = address of vet[j+1]
	lw   $t7, 0($t6)     # $t7 = vet[j+1]
	beq  $t1, $t3, incrL1# quebra se j = n -i -1
	blt  $t7, $t5, swap  # atualiza o vetor
	addi $t1, $t1, 1     # incrementa j
	j    l2Sort
	
incrL1:   
	addi $s4, $s4, 1     # incrementa i
	j    l1Sort

swap:   
	sw   $t7, 0($t4)     # coloca vet[j+1] em vet[j]
	sw   $t5, 0($t6)     # coloca vet[j] em vet[j+1] 
	addi $t1, $t1, 1     # incrementa j
	j    l2Sort
#fim da ordenação
	
mediCalc:   
	srl  $t0, $s0, 1      # $t0 = n / 2
	sub  $t1, $s0, $t0    # $t1 = n - $t0
	beq  $t1, $t0, par    # se as duas metades são iguais: par
	#senão
	sll  $t2, $t0, 2      # t0*4 para endereçar o vet
	add  $t2, $t2, $s1    # edereça o vet
	lw   $t3  0($t2)      # pega o valor endereçado no meio do vetor
	la   $t4, mediana     
	sw   $t3, 0($t4)      # grava o valor na mediana
	j    mod

par:    
	sll  $t2, $t0, 2      # t0*4 para endereçar o vet
	add  $t2, $t2, $s1    # edereça o vet[n/2]
	lw   $t3  0($t2)      # pega o valor de vet[n/2]
	subi $t4, $t2, 4      # subtrai 4 de t3 para obter vet[n/2-1]
	lw   $t5  0($t4)      # pega o valor de vet[n/2-1]
	add  $t6, $t3, $t5    # soma os valores
	srl  $t6, $t6, 1      # divide os valores por 2
	la   $t7, mediana     
	sw   $t6, 0($t7)      # grava o valor na mediana
	j    mod

mod:    
	la   $s2, moda         # endereça moda
	la   $s3, vezes        # endereça vezes
	lw   $s5, 0($s3)       # vezes da moda
	xor  $t0, $t0, $t0     # i = 0 
	j    l1Mod

l1Mod:    
	beq  $t0, $s0, fim    # termina o loop se i = n
	xor  $t8, $t8, $t8     # inicia vezes atual em 0
	#lw  $s5, 0($s3)            # valor de vezes repetidas
	#add  $t1, $t1, $s1     # $t1 = address of vet[i]
	#lw   $t2, 0($t1)       # $t2 = vet[i]
	xor  $t3, $t3, $t3     # j = 0
	#j    l2i

l2Mod:    
	beq  $t3, $s0, fim1
	sll  $t1, $t0, 2       # $t1 = i * 4 : para endereçar vet
	add  $t1, $t1, $s1     # $t1 = address of vet[i]
	lw   $t2, 0($t1)       # $t2 = vet[i]
	sll  $t4, $t3, 2       # $t4 = j * 4 : para endereçar vet
	add  $t4, $t4, $s1     # $t4 = address of vet[j]
	lw   $t5, 0($t4)       # $t5 = vet[j]
	bne  $t5, $t2, fim2
	addi $t8, $t8, 1
	j    fim2
        
fim1:   
	addi $t0, $t0, 1
	lw   $t7, 0($s3)
	blt  $t8, $t7, l1Mod
	sw   $t8, 0($s3)
	sw   $t2, 0($s2)
	j    l1Mod
       
fim2:   
	addi $t3, $t3, 1
	j    l2Mod

fim:    
	j   fim
       
.data
n:        .word 14
#n:        .word 13
mediana:  .word 0
media:    .word 0
moda:     .word 0       
vezes:    .word 0
vet:      .word 1 19 10 5 17 8 9 20 19 11 3 10 2 20
#vet:      .word 5 14 17 4 12 11 9 5 2 1 16 4 8