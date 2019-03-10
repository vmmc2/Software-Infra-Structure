org 0x7c00 
jmp 0x0000:start


start:
    base dw 0
    xor ax, ax ; zerando o conteudo do registrador ax
    mov ds, ax
    mov es, ax
    call get_string
    call printstring
    xor si, si
    xor di, di
    xor ax, ax
    call dale
    mov di, word[base]
    mov si, di
    call printstring
    call dale
    xor si, si
    xor di, di
    xor ax, ax
    call get_string
    call printstring
    
 

printstring:
    mov word[base], di
    .loop:
        lodsb ; bota o caractere em AL
        cmp al, 0 ; se tiver chegado ao final da string acabou
        je .endloop

        mov ah, 0x0e
        int 10h
        jmp .loop
    .endloop:
        ret

get_string:
    xor cl, cl ;limpa o registrador de contagem
    .loop:
        mov ah, 0
        int 16h ;interrrupcao para poder ler o caractere

        cmp al, 0x08 ; compara pra ver se foi o backspace que foi pressionado
        je .backspace


        cmp al, 0x0d ; compara pra ver se foi o enter que foi pressionado
        ; se sim, entao acabou a leitura
        je dale

        mov ah, 0x0e ; funcao pra printar o caractere pressionado
        int 10h

        stosb ; carrega o caracter que estava em AL para o registrador DI
        inc cl
        jmp .loop

.backspace:
    cmp cl, 0 ; se eu tiver no inicio da string eu ignoro o enter que foi pressionado
    je .loop  ; e volto pra leitura de dados
    
    dec di
    mov byte[di], 0
    dec cl

    mov ah, 0x0e
    mov al, 0x08
    int 10h

    mov al, ' '
    int 10h

    mov al, 0x08
    int 10h

    jmp .loop

dale:
    mov al, 0
    stosb

    mov ah, 0x0e
    mov al, 0x0d
    int 0x10
    mov al, 0x0a
    int 0x10

    ret


done:
    jmp $
    times 510-($-$$) db 0	
    dw 0xaa55	
; preenche o resto do setor com zeros 		
; coloca a assinatura de boot no final
; do setor (x86 : little endian)
