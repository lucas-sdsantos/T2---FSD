.text
.global main
 
.text
.globl main

main:   la $s1, vet         # coloca vet em $s1
	la $s0, n
	lw $s0,0($s0)       # coloca n em $s0
	xor $s3, $s3, $s3   # inicia o somatorio dos valores no vetor
	xor $t9, $t9, $t9   # inicia i = 0 
	
soma:   beq  $t9, $s0, med
	sll  $t8, $t9, 2    # $t1 = i * 4 : para endereÃ§ar vet
        add  $t8, $t8, $s1  # $t1 = address of vet[i]
        lw   $t7, 0($t8)    # $t0 = vet[i]
        add  $s3, $s3, $t7  # soma vet[i] ao somatório
        addi $t9, $t9, 1    # incrementa i
        j    soma

med:    addi $t6, $s0, 0
	jal  divider   # resposta em $v0 e $v1
	
fim:    j   fim

divider: lui $t0, 0x8000    # máscara para isolar bit mais significativo
	 li $t1, 32         # contador de iterações
	 xor $v0, $v0, $v0  # registrador P($v0)-A($v1) com 0 e o dividendo ($s3)
 	 add $v1, $s3, $0
 	 
dloop:  and $t2, $v1, $t0 # isola em t2 o bit mais significativo do reg 'A' ($v1)
        sll $v0, $v0, 1   # desloca para a esquerda o registrado P-A
        sll $v1, $v1, 1
        beq $t2, $0, di1
	ori $v0, $v0, 1   # coloca 1 no bit menos significativo do registador 'P'($v0)

di1:    sub $t2, $v0, $t6 # subtrai 'P'($v0) do divisor ($t6)
	blt $t2, $0, di2
	add $v0, $t2, $0 # se subtração positiva,'P'($v0) recebe o valor da subtração
	ori $v1, $v1, 1 # e 'A'($v1) recebe 1 no bit menos significativo

di2:    addi $t1, $t1, -1   # decrementa o número de iterações
	bne  $t1, $0, dloop
	la   $t3, media
	sw   $v1, 0($t3)
	jr   $ra

.data
n:        .word 14
mediana:  .word 0
media:    .word 0
moda:     .word 0       
vezes:    .word 0
vet:      .word 1 19 10 5 17 8 9 20 19 11 3 10 2 20
