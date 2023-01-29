.data
string: .asciiz "meu professor e muito bom"
.text
# Tornar maiúsculo é subtrair 32 do byte (ASCII)
li $t2, 0
capitalizar:
lbu $t1, string($t2)
addi, $t1, $t1, -32
sb, $t1, string($t2)
# Verificar se encontrou o espaço 32
varrer:
lbu $t1, string($t2)
beq, $t1, 32, incrementa
beq, $t1, 0, fim
addi $t2, $t2, 1
j varrer
incrementa:
addi $t2, $t2, 1 # move o ponteiro para capitalizar
j capitalizar
fim:
li $v0, 4
la $a0, string
syscall
