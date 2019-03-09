org 0x7c00 
jmp 0x0000:start

start:
    xor di, di
    xor si, si
	xor ax, ax ;zerando o conteudo de cada um dos registradores. xor == mais rapido
	mov ds, ax
    mov es, ax
    ;---------Passo 1: Ler o numero que vai ser a base da potenciacao-------------------------------------
	call getchar ;teoricamente, como a gente vai digitar so um caractere (um digito) da pra ignorar o ent
    ;do usuario
    ;o numero ficou salvo no registrador AL como um caractere.
    ;Exemplo: Se eu digitei 3, no registrador AL eu tenho guardado: '3'
    mov bx, al ; To movendo a base da exponenciacao para o registrador BX
    call _endl ;pulei uma linha e coloquei o cursor no inicio
    call putchar ;printei o caractere que tava em AL (a base)
    call _endl ;pulei outra linha
    ;---------Passo 2: Ler o numero que vai ser o expoente da potenciacao-------------------------------------
    call getchar
    mov cx, al; To movendo o expoente da potenciacao para o registrador CX
    call _endl
    call putchar
    call _endl
    jmp done

getchar:
    mov ah, 0x00
    int 10h
    ret

_endl:
    mov al, 0x0a ; 0x0a == caractere de mudanca de linha '\n' pula pra prox linha e mantem a coluna
    call putchar
    mov al, 0x0d ; 0x0d == caractere '\r' pula para a coluna inicial.
    ; dps disso o cursor vai estar na margem esquerda da tela.
    call putchar
    ret

putchar: ; a funcao putchar vai printar o caractere que estiver salvo no registrador AL
	mov ah, 0x0e
	int 10h
	ret

	

jmp $
times 510-($-$$) db 0	
dw 0xaa55	
; preenche o resto do setor com zeros 		
; coloca a assinatura de boot no final
; do setor (x86 : little endian)
