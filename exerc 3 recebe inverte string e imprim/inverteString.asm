	section .data
	msg1 db "entre c/ string", LF	;10 na tabela ASCII indica o /n veja que foi definido LF como 10
	tam equ $ -msg1              ; faz  contagem de caracteres da string acima a ser imprimida
	LF equ 10                   ; fazendo LF equivaler a  10 comando de saltar uma linha
	
	section .bss
	str1 resb 100
	str2 resb 100
	;pont1 resb 100  ;sera iniciado em 0
	;pont2 resb 100  ;sera iniciado com a qd
	qd resb 100     ;qd recebera o tam da string inserida pelo usuário
	
	
	
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
	
	mov edx,100
	mov ecx,str1
	mov ebx,0
	mov eax,3
	int 0x80 ;chamando sistema para modificar
    mov [qd],eax ;movendo a quantidade de eax para qd que sera o tamanho da string
	
	
	;inicializando os ponteiro esi e edi
	mov esi,0     ;inicializando pont1 com 0
	mov edi,[qd]   ;incializando pont2 com tam
	int 0x80 
	
	
	;laço de repetição para inverter string
	
	inifor:  ;definição tipo o ponto de retorno do for
	dec edi 
	
	
	jz conti  ; pula se edi for zero, equivalente ao if
	
	mov al,[str1 + esi]
	mov [str2 + edi],al
	inc esi
	
	jmp inifor ; jumper para voltar a inifor
	
	conti:  ; fim do for
	
	
	
	
	;imprimir str2 a inverção
	
	mov edx,[qd]     ;Tamanho da string			
	mov ecx,str2	;ponteiro mensagem 1
	mov ebx,1		;Tela (destino)				1 = codigo para saida
	mov eax,4		;Print string (Servico)		4 = codigo para impressao na tela
	
	int 0x80
	
					;encerra
	mov eax,1  		;servico exit
	int 0x80   		;chamada ao sistema
	
