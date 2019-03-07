org 0x7c00 
jmp 0x0000:start

variavel db 1

entrada db 'Por favor digite um numero que sera a base', 13, 10, 0 ;reservando espaço na memoria para a string
entrada2 db 'Digite o numero que servira como expoente', 13, 10, 0
result db '1', 13, 10, 0

start:
	xor ax, ax
    xor di, di
    xor al, al
    mov cl, 0
	mov dx, ax
    mov es, ax
    mov si, entrada ; faz com que o registrador si aponte para o inicio da string de nome entrada
    call print1 ;funcao responsavel por printar string entrada (chamada de função)
    xor si, si ; limpando agora oq estava presente no registrador si
    call scanfbase ; funcao para ler o primeiro numero (base)
start2:
    xor ax, ax
    xor di, di
    xor al, al
    mov cl, 0
	mov dx, ax
    mov es, ax
    call _endl ;pulando uma linha pra poder printar a entrada 2    
    mov si, entrada2
    call print1
    xor si, si
    call scanfbase2
    jmp expoente

;-------- INICIO DA PUTARIA --------------------------------------------------------------
;funcao auxiliar pq tava dando merda com o jump pra start2
print2:
    call _endl
    .okk:
        lodsb
        cmp cl, 0
        je done
        dec cl
        call putchar
    jmp .okk 

scanfbase2: ; funcao maior responsavel por ler uma string. na verdade ela eh um loop gigante de getchars
    call getchar ;chama a funcao getchar que lê um caractere por vez
    cmp al, 0x0d ;compara pra ver se o caractere digitado foi um enter
    je print2
    stosb ; salva em DI o que estava presente no registrador AL e move o ponteiro para
    ; a proxima posicao
    inc cl ; eh um registrador que funciona como um contador que guarda quantos caracteres
    ; foram digitados pelo usuario
    call putchar ; toda vez que eu ler um caractere, eu tenho que printa-lo
    jmp scanfbase2 
;-------- FIM DA PUTARIA ----------------------------------------------------------------

print1:
    lodsb; sempre carrega algo do registrador si ou di no registrador al.
    cmp al, 0
    je .done
    mov ah, 0eh; interrupcao para imprimir um caractere
    int 10h
    jmp print1; volta pra print1 pra imprimir o prox caractere
    .done:
        ret

print:
    call _endl
    .ok:
        lodsb ; carrega uma letra da string no registrador al e passa para o prox caractere
        mov byte[variavel], al
        cmp cl, 0 ;checa pra ver se eu cheguei ao fina de uma string. toda string é delimitafa pelo caractere \0
        je start2 ;se tiver chegado, cabou-se  ---- je == jump if equal
        ;agora eu tenho que printar o que foi carregado no meu registrador al (no caso, o caractere que foi carregado no registrador al)
        ;chama uma interrupcao pra printar o caractere
        dec cl
        call putchar
    jmp .ok
    

getchar: ; funcao para ler um caractere por vez
    mov ah, 0
    int 16h
    ret

putchar: ; funcao para printar caracter por caracter
    mov ah, 0eh
    int 10h
    ret

scanfbase: ; funcao maior responsavel por ler uma string. na verdade ela eh um loop gigante de getchars
    call getchar ;chama a funcao getchar que lê um caractere por vez
    cmp al, 0x0d ;compara pra ver se o caractere digitado foi um enter
    je print
    stosb ; salva em DI o que estava presente no registrador AL e move o ponteiro para
    ; a proxima posicao
    inc cl ; eh um registrador que funciona como um contador que guarda quantos caracteres
    ; foram digitados pelo usuario
    call putchar ; toda vez que eu ler um caractere, eu tenho que printa-lo
    jmp scanfbase  

_endl:
    mov al, 0x0a
    call putchar
    mov al, 0x0d
    call putchar
    ret

expoente:
    xor si, si
    lodsb ; ta carregando no registrador al o expoente da potenciacao
    mov ah, byte[variavel] ; ta carregando no registrador ah a base da potenciacao
    ;so que agora eu tenho que trocar al com ah
    ;de tal forma que:
    ; al == base e ah == expoente
    mov dl, al
    mov al, ah
    mov ah, dl
    ; al == base e ah == expoente
    cmp ah, 0
    je caso0
    cmp ah, 1
    je caso1
    cmp ah, 1
    ja casofinal
    caso0:
        mov si, result
        call _endl
        call print1
    caso1:
        call _endl
        call print1
    casofinal:

    jmp done


done:
    jmp $
    times 510-($-$$) db 0		; preenche o resto do setor com zeros 
    dw 0xaa55			; coloca a assinatura de boot no final
				; do setor (x86 : little endian)
