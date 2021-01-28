section .data
msg db "olah,mundo!", LF	;10 na tabela ASCII indica o /n veja que foi definido LF como 10
tam equ $ -msg              ; faz  contagem de caracteres da string acima a ser imprimida
LF equ 10                   ; fazendo LF equivaler a  10 comando de saltar uma linha

section .txt 	; nome da diretiva .nome da diretiva
global main
main:			;inicio do programa (gcc)

mov edx,tam		;Tamanho da string			11 = tamanho
mov ecx,msg	;ponteiro
mov ebx,1		;Tela (destino)				1 = codigo para saida
mov eax,4		;Print string (Servico)		4 = codigo para impressao na tela

int 0x80		;Chamada ao sistema



				;encerra
mov eax,1  		;servico exit
int 0x80   		;chamada ao sistema
