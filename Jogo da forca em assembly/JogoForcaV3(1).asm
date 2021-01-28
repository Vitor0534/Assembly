;Jogo da Forca





;---------------------Dados inicializados-------------------------------
section .data

msgInicio db "-------Jogo da Forca------",LF,"-------Descrição----------",LF,"1)Você possui 6 tentativas",LF,"2)Ao informar mais de um caracter por vez é considerado um chute",LF,"3)A cada erro você perdi uma tentativa",LF,"4)A cada erro resulta em uma parte do seu carinha",LF,"Que os Jogos Começem",LF,LF
tamInicio equ $-msgInicio

msgErroPalavra db "ERRO: você inseriu uma plavra invalida", LF, "a palavra que você inseriu pode conter algo que não seja nem ifem nem letras comuns",LF
tamMsgErroPalavra equ $ -msgErroPalavra

msgErroLetra db "A letra inseria é invalida:",LF,"pode ter sido inserido algo que não seja nem letra comuns nem ifem",LF
tamMsgErroLetra equ $ -msgErroLetra

msgParabens db "Parabéns, você ganhou o jogo :)",LF
tamParabens equ $-msgParabens

msgInfoDica db "Isira uma dica para a palavra, ou se preferir, insira 0 para seguir o jogo sem dicas",LF
tamMsgInfoDica equ $-msgInfoDica

msgDica db "A dica da palavra é: ",LF
tamMsgDica equ $ -msgDica

msgGameOver db "Game Over!",LF
tamMsgGameOver equ $ -msgGameOver

msgInfoPalavra db "Informe a palavra: ",LF
tamInfoPalavra equ $-msgInfoPalavra

msgInfoLetra db "Informe uma letra: ", LF
tamInfoLetra equ $-msgInfoLetra

msgLetraUsada db "Letra já utilizada, informe novamente", LF
tamLetraUsada equ $ -msgLetraUsada

msgInfoLetrasUsadas db "Letras já usadas: "
tamMsgInfoLetrasUsadas equ $ -msgInfoLetrasUsadas

msgPalavra db "A palavra era: "
tamPalavra equ $- msgPalavra

forca db "-| ",LF

clear db 27,"[H",27,"[J"

pula_linha db " ",LF

LF equ 10				;Definindo o \n

;---------------------Dados não inicializados---------------------------
section .bss

palavra resb 100		;Reservando a palavra
qtd resd 1				;Armazenara a quantidade de caracteres informados
palavra_ resb 100		;Sera o que aparecera para o jogador
dica resb 100           ;Sera a dica opcional que o usuário pode inserir
qtdDica resd 1          ;Armazena o tamanho da dica
letra resb 100			;A letra que será informada pelo jogador
vt resd 1				;Variavel controladora de algumas funções
erros resd 1            ;Variavel que conta os erros do jogador ela pode chegar até 6
acertos resd 1          ;Variavel que conta os acertos do jogador, o jogador ganha quando acertos==qtd
letrasUsadas resb 100   ;Variavel representará uma lista das letras ja inseridas pelo usuário, se ele repetir alguma letra seŕa avisad (eu sou bonzinho de mais nuss )
qtdUsadas resd 1        ;Variavel que representa a quantidade de letras ja inseridas


;------Carinha------	;Composição da ascii art do enforcado
cabeca resd 10			;Definição da cabeça
tronco resd 10			;Definição do tronco
pernas resd 10			;Definição das pernas

;---------------------Programa principal--------------------------------
section .text

xor edi,edi				;Variavel que controlará o vetor de letras já utilizadas

global _start
_start:

;Informando o usuario
mov ecx,msgInicio
mov edx,tamInicio
call out_str

_start2:

;Pedindo a Palavra ao Usuário
mov edx,tamInfoPalavra
mov ecx,msgInfoPalavra
call out_str

;Entrada da palavra que será utilizada no jogo
mov ecx,palavra			;O procedimento sera utilizado varias vezes
call in_str				;O usuario informa a palavra
dec eax					;Retirando o enter
cmp eax,0
jmp _start2
mov [qtd],eax			;Guardando em qtd a quantidade de caracteres

call clear_screen		;Limpando a tela



eax0Dica: ;caso o usuario insira somente o enter

;Pedindo a Dica ao Usuário

mov edx,tamMsgInfoDica
mov ecx,msgInfoDica
call out_str

;Entrada da dica que será utilizada no jogo
mov ecx,dica		    ;O procedimento sera utilizado varias vezes
call in_str				;O usuario informa a dica
dec eax					;Retirando o enter
cmp eax,0
jmp eax0Dica
mov [qtdDica],eax			;Guardando em qtdDica a quantidade de caracteres

call clear_screen		;Limpando a tela


call iniciar_palavra	      ;Criando a palavra  que aparecera para o jogador
mov [erros], dword 0          ;Iniciando o jogo com 0 erros
mov [acertos], dword 0        ;Iniciando o jogo com 0 acertos
mov [letrasUsadas], dword 0   ;Inicia a lista de letras informada com 0
mov [qtdUsadas], dword 0      ;Inica o tamanho da lista de usadas com 0

loopJogo:                     ;Ponto de inicio do jogo após informada a palavra
	
	;Pula uma linha
	mov edx,2
	mov ecx,pula_linha
	call out_str
	
	call imprimeDica
	
	
	;Pula uma linha
	mov edx,2
	mov ecx,pula_linha
	call out_str
	
	call imprimeCarinha		   ;Imprimindo a ASCII art do carinha
	
	;Pula uma linha
	mov edx,2
	mov ecx,pula_linha
	call out_str
	
	;Pula uma linha
	mov edx,2
	mov ecx,pula_linha
	call out_str

	;Mostra ao jogador a palavra composta por _, e as letras que o mesmo acertou
	mov edx,[qtd]			
	mov ecx,palavra_
	call out_str
	
	;Pula uma linha
	mov edx,2
	mov ecx,pula_linha
	call out_str
	
	cmp [erros], dword 6   	    ;Verificando a quantidade maxima de erros
	je GameOver

	;Informa o jogador sobre a entrada da letra
	retVerificacaoLetra:
	mov edx,tamInfoLetra
	mov ecx,msgInfoLetra
	call out_str

	;Disponibiliza o teclado para o jogador informar a letra
	mov ecx,letra
	call in_str
	
	dec eax						;Retirando o Enter
	cmp eax,1					;Verificando se o Jogador chutou a palavra
	ja conferePalavra			;Procedimento que trata caso o usuario chutar a palavra
	call letraParaMaiuscula
	
	mov al,[letra+0]       		;Guardando em al, a letra informada
	cmp [qtdUsadas], dword 0 
	je colocaPrimeiraUsada
	jne pesquisaUsadas

	labelBusca:
		call busca				;Busca o caracter informado pelo usuario
		
		;verifica se ouve algum acerto
		cmp [vt], dword 0    
		je incrimentaErro 	
		
		;Verificando se o jogador ganhou o jogo
		mov eax,[qtd]
		cmp [acertos],eax
		je GameVictore


		call proc_letrasUsadas
		
	jmp  loopJogo
call fim


;----------------------Procedimentos------------------------------------

proc_letrasUsadas:
		;Mostra ao jogador as letras informadas
		mov edx,tamMsgInfoLetrasUsadas
		mov ecx,msgInfoLetrasUsadas
		call out_str
		
		;Mostra ao jogador a quantidade de letras informadas
		mov edx,[qtdUsadas]
		mov ecx,letrasUsadas
		call out_str
ret


conferePalavra:
	mov eax,[letra]
	cmp eax,[palavra]
	je GameVictore
	jne incrimentaErro
ret

out_str:
	mov ebx,1			;Serviço 1 indica que usaremos a tela/monitor
	mov eax,4			;Serviço 4 indica que algo será impresso na tela/monitor
int 0x80				;Chamada ao sistema para executar o procedimento
ret						;Fim, retorna ao boloco que chamou o procedimento

in_str:
	mov edx,100			;100 define a quantidade de "espaços" que o usário poderá informar onde cada digito ocupa um espaço é maior pq o user não é ideal
	mov ebx,0			;FD = file descriptor = leitor de arquivo, *
	mov eax,3			;3 = ler do teclado, disponibiliza o teclado para o usuário informar a entrada
int 0x80				;Chamada ao sistema para executar o procedimento
ret	

fim:					;Fim do programa			
	mov eax,1			;1 indica serviço exit para sair do programa
	int 0x80
ret

iniciar_palavra:				;Criar a palavra que aparecera para o usuario
	xor esi,esi					;Zerando o contador
	mov al,'_'					;Definindo o caracter que aparecerá
	ini:	
		mov [palavra_+esi],al	;Colocando '_' na palavra
		inc esi					;Incrementando o contador
		cmp esi,[qtd]
		jne ini
		jmp sair_ini
	sair_ini:
		ret

busca:							;Busca a letra informada pelo jogador na palavra a letra esta em eax
	xor esi,esi
	mov [vt],dword 0			;inicializando a variavel contadora
	mov al,[letra+0]			;Guardando em eax a letra informada ja foi guardada em eax antes da chamada a função
	busca_letra:				;procedimento que busca a letra na palavra
		cmp al,[palavra+esi]	;Comparando cada caracter
		je mudar_letra			;Se encontrar o caracter o mesmo é mudado em palavra_
		inc_esi:
		inc esi
		cmp esi,[qtd]
		jne busca_letra
int 0x80
ret
	
	
;procedimento para mudar a letra em sua devida posição na palavra_	
mudar_letra:
	mov [palavra_ + esi],al		;Colocando a letra informada que pertenci a palavra na palavra que apareci para o jogador
	inc dword[vt]               ;Incrementando a variavel de controle
	inc dword[acertos]          ;Incrementando a quantidade de acertos do jogador 
jmp inc_esi
	
	
	
;Incrementando a quantidade de erros
incrimentaErro:
	call montaCarinha			;Faz a relação erro carinha e monta a ASCII art do mesmo
	inc dword [erros]			;Incrementando os erros
	call proc_letrasUsadas		;Informando as letras já utilizadas
jmp loopJogo

colocaPrimeiraUsada:
	mov [letrasUsadas+edi],al  	;Adiciona a letra que esta em al na lista de usadas
	inc dword [qtdUsadas]       ;Aumenta 1 no tamanho da lista de usadas
	inc edi						;Incrementando o controlador da lista de letras usadas
jmp labelBusca


pesquisaUsadas:
  	xor esi,esi
	busca_letraUsada:				;Procedimento que busca a letra na lista de palavra
		cmp al,[letrasUsadas + esi]	;Comparando cada caracter
		je msgUsada					;Se ela já tiver sido usada Informa o jogador
		inc esi
		cmp esi,[qtdUsadas]
		jne busca_letraUsada
		mov [letrasUsadas+edi],al   ;Caso a letra não const na lista ela será adicionada na lista 
		inc dword [qtdUsadas]       ;Incrementa o tamanho da lista de letras usadas
		inc edi						;Incrementa a variavel de controle da lista de letras usadas
		sairPesquisa:
			jmp labelBusca

msgUsada:							;Procedimento para tratar o caso de o jogador informar uma letra já usada
	mov edx,tamLetraUsada
	mov ecx,msgLetraUsada
	call out_str
jmp sairPesquisa


GameOver:							;Informa que o Jogador Perdeu o Jogo erevela a palavra

	;Pula uma linha
	mov edx,2
	mov ecx,pula_linha
	call out_str

	mov edx,tamMsgGameOver
	mov ecx,msgGameOver
	call out_str
	
	mov edx,tamPalavra
	mov ecx,msgPalavra
	call out_str
	
	;Mostrando a palavra escondida 
	mov edx,[qtd]
	mov ecx,palavra
	call out_str
jmp fim  

GameVictore:
	mov edx,tamParabens
	mov ecx,msgParabens
	call out_str
jmp fim  

clear_screen:						;Procedimento para limpar a tela				
	mov edx,7
	mov ecx,clear
	mov ebx,1
	mov eax,4
int 0x80
ret

;Procedimento que monta o carinha a partir de comparações e redefinições das 
;strings que o mesmo é composto
montaCarinha:
	cmp [erros],dword 0
	je colocaCabeca
	
	cmp [erros],dword 1
	je colocaTronco
	
	cmp [erros],dword 2
	je colocaBracoEsquerdo
	
	cmp [erros],dword 3
	je colocaBracoDireito
	
	cmp [erros],dword 4
	je colocaPernaEsquerda
	
	cmp [erros],dword 5
	je colocaPernaDireita
	
	sairMontaCarinha:
		ret

colocaCabeca:
	mov [cabeca+0],dword " "
	mov [cabeca+1],dword "o"
	mov [cabeca+2],dword " "
jmp sairMontaCarinha

colocaTronco:
	mov [tronco+0], dword " "
	mov [tronco+1], dword "|"
	mov [tronco+2], dword " "
jmp sairMontaCarinha


colocaBracoEsquerdo:
	mov [tronco+0],dword "/"
	mov [tronco+1], dword "|"
	mov [tronco+2], dword " "
jmp sairMontaCarinha


colocaBracoDireito:
	mov [tronco+0],dword "/"
	mov [tronco+1], dword "|"
	mov [tronco+2], dword "\ "
jmp sairMontaCarinha

colocaPernaEsquerda:
	mov [pernas+0],dword "/"
	mov [pernas+1],dword " "
	mov [pernas+2],dword " "
jmp sairMontaCarinha

colocaPernaDireita:
	mov [pernas+0],dword "/"
	mov [pernas+1],dword " "
	mov [pernas+2],dword "\ "
jmp sairMontaCarinha

;Imprime o carinha conforme o layout
imprimeCarinha:
	mov edx,3
	mov ecx,forca
	call out_str
	
	;Pula uma linha
	mov edx,2
	mov ecx,pula_linha
	call out_str
	
	mov edx,3
	mov ecx,cabeca
	call out_str
	
	;Pula uma linha
	mov edx,2
	mov ecx,pula_linha
	call out_str
	
	mov edx,3
	mov ecx,tronco
	call out_str
	
	;Pula uma linha
	mov edx,2
	mov ecx,pula_linha
	call out_str
	
	mov edx,3
	mov ecx,pernas
	call out_str
	
ret

transformaMaiuscula:
  xor esi,esi      ;zerando contador
  
  ponto:
  cmp esi,[qtd] ;verifica se esi é igual ao tamnho da palavra iserida
  je fimFunc
  
  mov al,[palavra+esi]
  cmp al,96
  ja acima   ;campo das minusculas
  jb abaixo  ;campo das maiusculas
  
  acima:   ;verifica se a letra esta dentro do campo de minusculas e subtrai 32
  cmp al,122
  ja erroPalavra
  sub al,32
  mov [palavra+esi],al
  inc esi
  jmp ponto
  
  abaixo: ;verifica se ela esta no campo de maiusculas e continua o prog
  cmp al,90
  ja erroPalavra
  cmp al,65
  jb ifem
  pass:   ;ponto de retorno do procedimento de ferificação de ifem
  inc esi
  jmp ponto
  
  
  ifem:   ; verifica se a letra é um ifem e continua o procedimento
  cmp al,45
  jne erroPalavra
  jmp pass ;caso seja um ifem (sinal de menos) ele volta para o pass e continua normalmente
  
  fimFunc:  ;fim do procedimento de conversão para maiusculas
  ret
  
  
  
  erroPalavra:
	mov edx,tamMsgErroPalavra
	mov ecx,msgErroPalavra
	call out_str
  jmp _start2
  
  erroLetra:
    mov edx,tamMsgErroLetra
	mov ecx,msgErroLetra
	call out_str
  jmp retVerificacaoLetra
  

letraParaMaiuscula:
  mov al,[letra+0]
  cmp al,96
  ja menos32
  jb maisc
  
  menos32:
    cmp al,122
    ja erroLetra
    sub al,32    ;caso a letra seja uma minuscula ele converta para maiuscula
    mov [letra+0],al
  jmp fimLetra
  
  maisc:
     cmp al,65
     jb ifemLetra
  jmp fimLetra
  
  ifemLetra:   ; verifica se a letra é um ifem e continua o procedimento
  cmp al,45
  jne erroLetra
  jmp fimLetra ;caso seja um ifem (sinal de menos) ele termina a verificação
  
 fimLetra:
 ret
    
 
imprimeDica:

   cmp [dica], dword 0   ;verifica se existe uma dica a ser mostrada
   je  finalDica         
   
   mov edx,tamMsgDica
   mov ecx,msgDica
   call out_str
   jmp finalDica
    
finalDica:    ;final do procedimento
ret

