.text
	.global main

main:   la  $s1, vet         # coloca vet em $s1
	la  $s0, n
	lw  $s0,0($s0)       # coloca n em $s0
	xor $t9, $t9, $t9    # inicia o somatorio dos valores em zero
	xor $s4, $s4, $s4    # inicia i = 0
	
soma:   beq  $s4, $s0, med 
	sll  $t8, $s4, 2     # $t1 = i * 4 : para endereÃ§ar vet
        add  $t8, $t8, $s1   # $t1 = address of vet[i]
        lw   $t7, 0($t8)     # $t0 = vet[i]
        add  $t9, $t9, $t7   # soma vet[i] ao somatório
        addi $s4, $s4, 1     # incrementa i
        j    soma

med:    addi $t8, $s0, 0
	jal  divider        # resposta em $v0 e $v1
	addi $t0, $v1, 0
	la   $t1, media
	sw   $t0, 0($t1)
	j    sort
	
fim:    j   fim

divider: lui $t0, 0x8000     # máscara para isolar bit mais significativo
	 li $t1, 32          # contador de iterações
	 xor $v0, $v0, $v0   # registrador P($v0)-A($v1) com 0 e o dividendo ($t9)
 	 add $v1, $t9, $0
 	 
dloop:  and $t2, $v1, $t0    # isola em t2 o bit mais significativo do reg 'A' ($v1)
        sll $v0, $v0, 1      # desloca para a esquerda o registrado P-A
        sll $v1, $v1, 1
        beq $t2, $0, di1
	ori $v0, $v0, 1      # coloca 1 no bit menos significativo do registador 'P'($v0)

di1:    sub $t2, $v0, $t8    # subtrai 'P'($v0) do divisor ($t8)
	blt $t2, $0, di2 
	add $v0, $t2, $0     # se subtração positiva,'P'($v0) recebe o valor da subtração
	ori $v1, $v1, 1      # e 'A'($v1) recebe 1 no bit menos significativo

di2:    addi $t1, $t1, -1    # decrementa o número de iterações
	bne  $t1, $0, dloop
	jr   $ra

sort:   xor  $s4, $s4, $s4   # i = 0
	subi $t0, $s0, 1     # n - 1
	j    l1
	
l1:     beq  $s4, $t0, medi  # termina o loop se i = n - 1
	xor  $t1, $t1, $t1   # j = 0
	sub  $t3, $t0, $s4   # n - i - 1
	blt  $s4, $t0, l2    # vai para o loop interno
	addi $s4, $s4, 1     # incrementa i
	j    l1
	
l2:	sll  $t4, $t1, 2     # $t4 = j * 4 : para endereÃ§ar vet
        add  $t4, $t4, $s1   # $t4 = address of vet[j]
        lw   $t5, 0($t4)     # $t5 = vet[j]
        addi $t2, $t1, 1     # j + 1
        sll  $t6, $t2, 2     # $t6 = (j+1) * 4 : para endereÃ§ar vet
        add  $t6, $t6, $s1   # $t6 = address of vet[j+1]
        lw   $t7, 0($t6)     # $t7 = vet[j+1]
        beq  $t1, $t3, incr  # quebra se j = n -i -1
        blt  $t7, $t5, swap  # atualiza o vetor
	addi $t1, $t1, 1     # incrementa j
	j    l2
	
incr:   addi $s4, $s4, 1     # incrementa i
	j    l1

swap:   sw   $t7, 0($t4)     # coloca vet[j+1] em vet[j]
	sw   $t5, 0($t6)     # coloca vet[j] em vet[j+1] 
	addi $t1, $t1, 1     # incrementa j
	j    l2
	
medi:   srl  $t0, $s0, 1      # $t0 = n / 2
	sub  $t1, $s0, $t0    # $t1 = n - $t0
	beq  $t1, $t0, par    # se as duas metades s�o iguais: par
	#sen�o
	sll  $t2, $t0, 2      # t0*4 para endere�ar o vet
	add  $t2, $t2, $s1    # edere�a o vet
	lw   $t3  0($t2)      # pega o valor endere�ado no meio do vetor
	la   $t4, mediana     
	sw   $t3, 0($t4)      # grava o valor na mediana
	j    fim

par:    sll  $t2, $t0, 2      # t0*4 para endere�ar o vet
	add  $t2, $t2, $s1    # edere�a o vet[n/2]
	lw   $t3  0($t2)      # pega o valor de vet[n/2]
	subi $t4, $t2, 4      # subtrai 4 de t3 para obter vet[n/2-1]
	lw   $t5  0($t4)      # pega o valor de vet[n/2-1]
	add  $t6, $t3, $t5    # soma os valores
	srl  $t6, $t6, 1      # divide os valores por 2
	la   $t7, mediana     
	sw   $t6, 0($t7)      # grava o valor na mediana
	j    fim

mod:    

.data
n:        .word 14
mediana:  .word 0
media:    .word 0
moda:     .word 0       
vezes:    .word 0
vet:      .word 1 19 10 5 17 8 9 20 19 11 3 10 2 20
