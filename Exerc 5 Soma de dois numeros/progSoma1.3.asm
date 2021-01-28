			section .data
			msg1 db "entre c/ primeiro numero (até 6 algarismos)", LF	;10 na tabela ASCII indica o /n veja que foi definido LF como 10
			tam equ $ -msg1                         ; faz  contagem de caracteres da string acima a ser imprimida
			msg2 db "entre com o segundo numero (até 6 algarismos)", LF
			tam2 equ $ -msg2
			msg3 db "erro numero invalido, pode ter sito inserido um caracter ou sido ultrapassado o limite de 6 digitos"
			tam3 equ $ -msg3
			LF equ 10                               ; fazendo LF equivaler a  10 comando de saltar uma linha
			
			section .bss
			numero1 resb 100
			numero2 resb 100
			aux resb 100
			qdfixo resb 100
			qdfixo1 resb 100
			qdfixo2 resb 100
			qd resb 100
			qd1 resb 100                   ;qd recebera o tam da string inserida pelo usuário
			qd2 resb 100
			qdaux resb 100
			
			
			
			section .txt 	                        ; nome da diretiva .nome da diretiva
			global  _start
			
			_start:                                   ;inicio do programa (gcc)
			jmp primeiro			                        
			
			;tratamento de erro *************************************************
			inicio_prog:
			
			mov edx,tam3
			mov ecx,msg3
			call exib_str
			  
			mov eax,[aux]
			cmp [aux],eax
			je primeiro
			mov eax,[aux]
			cmp [aux],eax
			je segundo
			;**************************tratamento feito para mostrar as mensagens certas caso ocorra erro na validação
			
			
			
			primeiro:
			
			; primeiro numero***
			mov edx,tam
			mov ecx,msg1
			call exib_str          ;pede para inserir numero
			call entra_str         ;pega numero do teclado
			dec eax
			jz inicio_prog
			cmp eax,6
			ja inicio_prog
			mov [qd1],eax
			mov [qdfixo1],eax
			call valida_str        
			mov eax,[aux]
			mov [numero1],eax
			;*******************   toda essa parte pega primeiro numero valida e armazena em numero1
			
			
			
			segundo:
			
			
			;segundo numero
			mov edx,tam2
			mov ecx,msg2
			call exib_str          ;pede para inserir numero
			call entra_str         ;pega numero do teclado
			dec eax
			jz segundo
			cmp eax,6
			ja segundo
			mov [qd2],eax
			call valida_str
			mov eax,[aux]
			mov [numero2],eax  
			;********************  pega o segundo numero valida e armazena em numero2
			
			
			;parte da formatação
			
			;primeirio numero*****
		    mov ecx,[numero1]
			mov [aux],ecx
			mov eax,[qd1]
			;mov [qdaux],eax ;necessario caso vc estejas usando o formata_numero2
			mov [qdfixo],eax
			call formata_numero
			mov eax,[aux]
			mov [numero1],eax
			;********************* formata o primeiro numero para numero e armazena em numero1
			
			;segundo numero*******
			mov eax,[numero2]
			mov [aux],eax
			mov eax,[qd2]
			mov [qdfixo],eax
			;mov [qdaux],eax
			call formata_numero
			mov eax,[aux]
            mov [numero2],eax
			;*********************  formata o segundo numero para numero e armazena em numero
			
			
			;parte da soma********
			mov eax,[numero1]
			mov ebx,[numero2]
			add eax,ebx   ; soma eax,ebx e o resultado vai estar armazenado em eax 
			mov [aux],eax
			;*********************
			
           
            ;mov eax,[aux+0]
            ;add eax,48
            ;mov [aux],eax
            ; sub [aux],BYTE '0' 
            mov ebx,[aux]
            mov eax,0
            mov [aux],eax
            call formata_str
           ; mov eax,6
           ; mov [qdfixo],eax
           ; mov eax,[aux]
			mov edx,qd1
			mov ecx,aux
			call exib_str          ;pede para inserir numero
			
			; a parte de formatar para string vai ter que esperar, não sei onde fica o resto e a parte inteira da divisão ainda
			
			
			fim: ; parte do encerramento
			
							;encerra
			mov eax,1  		;servico exit
			int 0x80   		;chamada ao sistema
			
			
		
			
		    ;orientação ao usuario
			exib_str:
			;mov edx,tam		;Tamanho da string			
			;mov ecx,msg1	;ponteiro mensagem 1
			mov ebx,1		;Tela (destino)				1 = codigo para saida
			mov eax,4		;Print string (Servico)		4 = codigo para impressao na tela
			
			int 0x80		;Chamada ao sistema
			ret
			
			;carregando a string do teclado
			entra_str:
			mov edx,100
			mov ecx,aux
			mov ebx,0
			mov eax,3      ;instrução para pegar conteudo do teclado
			int 0x80 ;chamando sistema para modificar
		    ;mov [qd],eax ;movendo a quantidade de eax para qd que sera o tamanho da string
		    ret
		
		
				
		;validação do numero
		valida_str:
		mov esi,0; zerando o contador
		mov edi,eax
		inicio_valida:
		mov al,[aux+esi]; colocando posição no test
		sub al,48
		cmp al,0
		jb inicio_prog
		cmp al,9
		ja inicio_prog
		inc esi
		cmp esi,edi ;compara como o tamanho do vetor condição de parada
		je fim_valida
		
		jmp inicio_valida
		int 0x80
		fim_valida:
		ret
		;**********************************************************
		
		; procedimento para formatação da string para numero
		
		;passa a string para numero
		formata_numero:
		mov esi,0 ;zerando contador
		xor ebx,ebx
		mov ax,10
		
		;for{
		inicio_form:
		mul ebx
		mov edx,[aux+esi]
		sub edx,48
		add ebx,edx
		add esi,1
		cmp esi,[qdfixo]
		je fim_form
		jmp inicio_form
		;};
		
		int 0x80
		fim_form:
		mov [aux],ebx
		ret
		;********************************
		
		
		
			
	
	;passa numero para string**********************************
	formata_str:
	mov esi,[qdfixo]
	mov ecx,0
	mov eax,1
	mov ax,10
	
	marca1:
	mul eax   
	dec esi
	cmp esi,1
	je marca1_
	jmp marca2
	
	marca1_:
	mov esi,0
	mov ecx,eax

	mov eax,[qdfixo]
	sub eax,2
	mov [qdfixo],eax
	jmp marca2
	
	
	marca2:
    mov ax,[ecx]
	div ebx         ;ebx é o numero que quero converter
	add eax,48
	mov [aux+esi],eax ;peguei oque estava em eax e movi para o numero striung que quero exibir
	cmp esi,[qdfixo]
	jb abaixo
	add edx, 48
	add esi,1
	mov [aux+esi],edx
	int 0x80
	ret
	
	abaixo:
	mov ax,10
	div ecx      ;eu gostaria de dividir ecx por 10
	add esi,1
	jmp marca2
	
	;************************************************************
	
	

	
        
