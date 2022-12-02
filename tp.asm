.text
.global main
 
main:   xor  $t6, $t6, $t6     # zera i
	xor  $t3, $t3, $t3     # zera j
	xor  $t9, $t9, $t9     # zera contador de vezes
	la   $s1, vet          # carrega o vet em $t1
	la   $s0, n
	lw   $s0, 0($s0)       # carrega o n em $t2
	xor  $s2, $s2, $s2
	xor  $s2, $s2, $s2

mod:    sll  $t1, $t0, 2       # $t1 = i * 4 : para endereçar save
        add  $t1, $t1, $s1     # $t1 = address of save[i]
        lw   $t2, 0($t1)       # $t2 = save[i]
        beq  $t0, $s0, end     # termina se i = vet.length
	xor  $t7, $t7, $t7     # zera as vezes da moda, temp
        blt  $t0, $s0, mod1    # salta para o loop interno da moda
        addi $t6, $t6, 1       # i = i + 1
        j    mod

mod1:   sll  $t4, $t3, 2       # $t1 = j * 4 : para endereçar save
        add  $t4, $t4, $s1     # $t1 = address of save[j]
        lw   $t5, 0($t4)       # $t0 = save[j]
        beq  $t0, $s0, mod     # termina se j = vet.length
        addi $t0, $t0, 1       # atualiza j
        beq  $t5, $t2, sum     # salta se vet[j] == vet[i]
        j    mod1

sum:    addi $t9, $t9, 1       # atualiza o contador
	blt  $s3, $t9, up      # salta se contador > n moda
	j    mod1

up: 	la   $t7, moda
	sw   $t2, 0($t7)       # atualiza moda
	xor  $s2, $s2, $s2     
	add  $s2, $s2, $t2
	la   $t8, vezes
	sw   $t6, 0($t8)       # atualiza n moda
	xor  $s3, $s3, $s3     
	add  $s3, $s3, $t6
	j    mod1
	
end:    j   end

.data
n:        .word 14
mediana:  .word 0
media:    .word 0
moda:     .word 0       
vezes:    .word 0
vet:      .word 7 20 8 5 1 8 4 2 5 5 14 12 3 8
