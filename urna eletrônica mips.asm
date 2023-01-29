.data

# Urna Eletrônica - Assembly para MIPS
# Autores: Heitor Silva Avila e Wellington Gomes Machado
# Turma: M1 - Arquitetura e Organização de Computadores

# Optamos pelo console e não uma interface gráfica, pelo fato de que os valores de $v0 acima de 30 são exclusivos para o simulador MARS
# Referência: https://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html

# Referência externa para manipular elementos em vetor (perceba que não é o MARS):
# https://www.youtube.com/watch?v=8y4-Ea17r9c

# Código-fonte disponível para melhoria, consulta e/ou estudo em:
# https://github.com/heitorzxc/aoc1/tree/main/final-project

votos:	.word 256,50,100,40,88

# (Total)
# Válidos + Nulos
# (Governador)
# ViniciusBorges -------- 33
# IndianoDoYT ------- 77
# (Presidente)
# LucianoAgostini: -------- 26
# LinusTorvals: ----- 90

# Strings de interface
bemvindo:	.asciiz "\n Urna Eletrônica de AOC1 \n Versão 13.9.7 - Turma M1 - Heitor e Wellington. \n Mesário: Esta urna está configurada para as eleições de 28/11/2022. \n Se não estiver na configuração correta, por favor, acione o T.I. para substituição do software. \n"
menuPrincipal:	.asciiz "\n 1 - Zerésima / Boletim \n 2 - Abertura \n 3 - Clear \n 4 - Desligar \n > "
votoGov:	.asciiz "\n Digite o voto para governador: \n 2 dígitos > "
votoPres:	.asciiz "\n Digite o voto para presidente: \n 2 dígitos > "
confirma:	.asciiz "\n Confirma o voto? \n 1 - Sim / 2 - Não \n > "
erro: .asciiz "\n Opção inválida! \n"
vetorLimparTela: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
zeresima1:	.asciiz "\n Emissão da zerésima \n Quantidade de eleitores: "
zeresima2:	.asciiz "\n ViniciusBorges (33): "
zeresima3:	.asciiz "\n IndianoDoYT (77): "
zeresima4:	.asciiz "\n LucianoAgostini (26): "
zeresima5:	.asciiz "\n LinusTorvals (90): "
quebraLinha:	.asciiz "\n\n\n "
clear1:	.asciiz "\n\ Esse procedimento é irreversível e só deve ser feito se solicitado pelo TI. \n Deseja continuar? \n 1 - SIM, 2 - NÃO \n > "
clear2: .asciiz "\n Limpando o conteúdo da memória... \n"

.text

iniciar:

# Garante que não tenha lixo no display (ex: rodar mais de 1x)
    jal     limparTela
    nop

    li      $v0,                4
    la      $a0,                bemvindo
    syscall

    jal     delay
    nop

exibeMenu:

    li      $v0,                4
    la      $a0,                menuPrincipal
    syscall

    li      $v0,                5
    syscall

    beq     $v0,                1,                  zeresima
    beq     $v0,                2,                  abertura
    beq     $v0,                3,                  clear
    beq     $v0,                4,                  desligar

# Se não foi informada opção correta, retorna

    li      $v0,                4
    la      $a0,                erro
    syscall

    j       exibeMenu
    nop

# Função de abertura da urna (receber votos)
abertura:

    jal     limparTela
    nop

# Assim que recebe a informação de que vai receber um voto, incrementa o número de eleitores.
    jal     votoTotal
    nop

solicitaVotoGov:

# Imprime string
    li      $v0,                4
    la      $a0,                votoGov
    syscall

# Lê inteiro
    li      $v0,                5
    syscall

# Movendo para confirmar
    move    $t9,                $v0

    jal     delay
    nop

# Confirma o voto?
    li      $v0,                4
    la      $a0,                confirma
    syscall

# Lê inteiro
    li      $v0,                5
    syscall

# Se não confirmou (1), vai pedir de novo
    bne     $v0,                1,                  solicitaVotoGov

# Se o voto for 33 ou 77, faz jump
    beq     $t9,                33,                 voto33
    beq     $t9,                77,                 voto77

recursaoVotoGov:
    nop

solicitaVotoPres:

# Imprime string
    li      $v0,                4
    la      $a0,                votoPres
    syscall

# Lê inteiro
    li      $v0,                5
    syscall

# Movendo para confirmar
    move    $t9,                $v0

    jal     delay
    nop

# Confirma o voto?
    li      $v0,                4
    la      $a0,                confirma
    syscall

# Lê inteiro
    li      $v0,                5
    syscall

# Se não confirmou (1), vai pedir de novo
    bne     $v0,                1,                  solicitaVotoPres

# Se o voto for 26 ou 90, faz jump
    beq     $t9,                26,                 voto26
    beq     $t9,                90,                 voto90

recursaoVotoPres:
    nop

    jal     delay
    nop

    jal     limparTela
    nop

    j       exibeMenu
    nop

votoTotal:

    lw      $t1,                votos+0                                 # Carrega o valor em $t1
    addi    $t1,                $t1,                1                   # Conta mais um eleitor
    sw      $t1,                votos+0                                 # Escreve no vetor
    jr      $ra
    nop

voto33:

    lw      $t1,                votos+4                                 # Carrega o valor em $t1
    addi    $t1,                $t1,                1                   # Contabiliza o voto
    sw      $t1,                votos+4                                 # Escreve no vetor
    j       recursaoVotoGov
    nop

voto77:

    lw      $t1,                votos+8                                 # Carrega o valor em $t1
    addi    $t1,                $t1,                1                   # Contabiliza o voto
    sw      $t1,                votos+8                                 # Escreve no vetor
    j       recursaoVotoGov
    nop

voto26:

    lw      $t1,                votos+12                                # Carrega o valor em $t1
    addi    $t1,                $t1,                1                   # Contabiliza o voto
    sw      $t1,                votos+12                                # Escreve no vetor
    j       recursaoVotoPres
    nop

voto90:

    lw      $t1,                votos+16                                # Carrega o valor em $t1
    addi    $t1,                $t1,                1                   # Contabiliza o voto
    sw      $t1,                votos+16                                # Escreve no vetor
    j       recursaoVotoPres
    nop

# Subrotina que gera um delay de 2 segundos na urna
delay:

# Delay 2 segundos
    li      $v0,                32
    li      $a0,                2000
    syscall

    jr      $ra
    nop

# Função que imprime o conteúdo do vetor
zeresima:

    jal     limparTela
    nop

    li      $v0,                4
    la      $a0,                zeresima1
    syscall

    jal     delay
    nop

    lw      $a0,                votos+0                                 # Carrega o valor em $t1
    li      $v0,                1
    syscall

    li      $v0,                4
    la      $a0,                zeresima2
    syscall

    jal     delay
    nop

    lw      $a0,                votos+4                                 # Carrega o valor em $t1
    li      $v0,                1
    syscall

    li      $v0,                4
    la      $a0,                zeresima3
    syscall

    jal     delay
    nop

    lw      $a0,                votos+8                                 # Carrega o valor em $t1
    li      $v0,                1
    syscall

    li      $v0,                4
    la      $a0,                zeresima4
    syscall

    jal     delay
    nop

    lw      $a0,                votos+12                                # Carrega o valor em $t1
    li      $v0,                1
    syscall

    li      $v0,                4
    la      $a0,                zeresima5
    syscall

    jal     delay
    nop

    lw      $a0,                votos+16                                # Carrega o valor em $t1
    li      $v0,                1
    syscall

    li      $v0,                4
    la      $a0,                quebraLinha
    syscall

    jal     delay
    nop

    j       exibeMenu
    nop

# Função que zera o vetor
clear:

    jal     limparTela
    nop

# Tela de confirmação
    li      $v0,                4
    la      $a0,                quebraLinha
    syscall

    la      $a0,                clear1
    syscall

    li      $v0,                5
    syscall

# Se não for confirmado, volta o menu sem limpar nada
    bne     $v0,                1,                  exibeMenu

    li      $v0,                4
    la      $a0,                clear2
    syscall

    li      $t1,                0
    sw      $t1,                votos+0
    sw      $t1,                votos+4
    sw      $t1,                votos+8
    sw      $t1,                votos+12
    sw      $t1,                votos+16

    jal     delay
    nop

    jal     limparTela
    nop

    j       iniciar
    nop

desligar:

    li      $v0,                10
    syscall
    nop

limparTela:

    li      $v0,                4
    la      $a0,                vetorLimparTela
    syscall

    jr      $ra
    nop
