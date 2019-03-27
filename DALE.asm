dica1 db "insira uma dica qualquer aqui", 13, 10, 0
dica2 db "insira uma dica qualquer aqui", 13, 10, 0
dica3 db "insira uma dica qualquer aqui", 13, 10, 0
dica4 db "insira uma dica qualquer aqui", 13, 10, 0
dica5 db "insira uma dica qualquer aqui", 13, 10, 0
dica6 db "insira uma dica qualquer aqui", 13, 10, 0
dica7 db "insira uma dica qualquer aqui", 13, 10, 0
dica8 db "insira uma dica qualquer aqui", 13, 10, 0
dica9 db "insira uma dica qualquer aqui", 13, 10, 0
dica10 db "insira uma dica qualquer aqui", 13, 10, 0

; função para printar cada uma das dicas

xor ax, ax ; zerando o conteudo do registrador ax
mov ds, ax
mov es, ax
xor si, si
mov si, dica1

printstring: ;tem que ter dado o mov si, dica antes de chamar a funcao
    .loop:
        lodsb ; bota o caractere de si no registrador AL e incrementa si
        cmp al, 0 ; checa para ver se chegou ao final da string
        je .endloop

        mov ah, 0 ; chama a interrupcao pra printar o caractere no modo video
        mov al, 12h
        int 10h

        mov ah, 0xb
        mov bh, 0
        mov bl, 7
        int 10h

        jmp .loop
    .endloop:
        ret
