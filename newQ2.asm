org 0x7c00 
jmp 0x0000:start

data:
    base times 11 db 0
	expoente times 11 db 0

start:
    mov di, base
    xor ax, ax ; zerando o conteudo do registrador ax
    mov ds, ax
    mov es, ax
    call get_string
	call dale
    mov si, base
    xor ax, ax
    
    
    ; ISSO AQUI SO SERVE PRA PRINTAR A BASE QUE EU ARMAZENEI
    mov si, base
    call printstring
    call dale
    
    ; ISSO AQUI SERVE PARA LER O EXPOENTE E PRINTAR ELE NA LINHA DEBAIXO
	xor di, di
	mov di, expoente
    xor si, si
    xor ax, ax
    call get_string
    call dale

	; ISSO AQUI VAI SERVIR PARA PRINTAR O EXPOENTE QUE EU ARMAZENEI
	mov si, expoente
	call printstring
	call dale

	;PRONTO TANTO BASE COMO EXPOENTE SALVOU OS DADOS DIREITINHO -- gloria
    
 

printstring:
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
        je .endloop

        mov ah, 0x0e ; funcao pra printar o caractere pressionado
        int 10h

        stosb ; carrega o caracter que estava em AL para o registrador DI
        inc cl
        jmp .loop
    .endloop:
        mov al, 0
        stosb 
        ret

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
