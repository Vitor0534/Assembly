section .data
msg1 db "entre c/ string", LF	;10 na tabela ASCII indica o /n veja que foi definido LF como 10
tam equ $ -msg1              ; faz  contagem de caracteres da string acima a ser imprimida
LF equ 10                   ; fazendo LF equivaler a  10 comando de saltar uma linha

section .bss
msg2 resb 50

section .txt 	; nome da diretiva .nome da diretiva
global main
main:			;inicio do programa (gcc)


;orientação ao usuario
mov edx,tam		;Tamanho da string			
mov ecx,msg1	;ponteiro mensagem 1
mov ebx,1		;Tela (destino)				1 = codigo para saida
mov eax,4		;Print string (Servico)		4 = codigo para impressao na tela

int 0x80		;Chamada ao sistema

;carregando a string do teclado

mov edx,40
mov ecx,msg2
mov ebx,0
mov eax,3
int 0x80

;imprimir msg2

mov edx,50 		;Tamanho da string			
mov ecx,msg2	;ponteiro mensagem 1
mov ebx,1		;Tela (destino)				1 = codigo para saida
mov eax,4		;Print string (Servico)		4 = codigo para impressao na tela

int 0x80

				;encerra
mov eax,1  		;servico exit
int 0x80   		;chamada ao sistema
