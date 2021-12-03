extern GAME
extern CARTOON
extern DOCUMENTARY

global DivideGame
DivideGame:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес игрового фильма
    mov  eax, [rdi]
    mov  rdi, [rdi+4]    ;смещение на размер целого
    call strlen
    div ebx 		 ; в регистре ebx - вычисленная длина строки
    cvtsi2sd    xmm0, eax

leave
ret

global DivideCartoon
DivideCartoon:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес мультфильма
    mov  eax, [rdi]
    mov  rdi, [rdi+8]    
    call strlen
    div ebx ; в регистре ebx - вычисленная длина строки
    cvtsi2sd    xmm0, eax

leave
ret

global DivideDocumentary
DivideDocumentary:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес документального фильма
    mov  eax, [rdi]
    mov  rdi, [rdi+8]    
    call strlen
    div ebx ; в регистре ebx - вычисленная длина строки
    cvtsi2sd    xmm0, eax

leave
ret

global DivideFilm
DivideFilm:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фильма
    mov eax, [rdi]
    cmp eax, [GAME]
    je gameDivision
    cmp eax, [CARTOON]
    je cartoonDivision
    cmp eax, [DOCUMENTARY]
    je documentaryDivision
    xor eax, eax
    cvtsi2sd    xmm0, eax
    jmp     return
gameDivision:
    ; Вычисление функции игрового фильма
    add     rdi, 4
    call    DivideGame
    jmp     return
cartoonDivision:
    ; Вычисление функции мультфильма
    add     rdi, 4
    call    DivideCartoon
    jmp	    return
documentaryDivision:
    ; Вычисление функции документального фильма
    add     rdi, 4
    call    DivideDocumentary
return:
leave
ret

global DivideContainer
DivideContainer:
section .data
    .sum    dq  0.0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фильмов
    xor rcx, rcx            ; счетчик фильмов
    movsd xmm1, [.sum]      ; перенос накопителя суммы в регистр 1
.loop:
    cmp rcx, rbx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фильмы

    mov r10, rdi            ; сохранение начала фильма
    call DivideFIlm     ; Получение функции первого фильма
    addsd xmm1, xmm0        ; накопление суммы
    inc rcx                 ; индекс следующего фильма
    add r10, 16             ; адрес следующего фильма
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop
.return:
    divsd xmm1, rcx
    movsd xmm0, xmm1
leave
ret

strlen:
    ; Адрес сообщения уже загружен в rdi
    mov ecx, -1     ; ecx должен быть < 0
    xor al, al      ; конечный символ = 0
    cld             ; направление обхода от начала к концу
    repne   scasb   
    neg ecx
    sub ecx, 2      ; ecx = length(msg)
    mov ebx, ecx
    ret