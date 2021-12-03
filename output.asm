; file.asm - использование файлов в NASM
extern printf
extern fprintf

extern DivideGame
extern DivideCartoon
extern DivideDocumentary

extern GAME
extern CARTOON
extern DOCUMENTARY

global OutGame
OutGame:
section .data
    .outfmt db "It is Game: publication year = %d, film name = %s, director = %s. Division result = %g",10,0
section .bss
    .pgame  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленная функция деления игрового фильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pgame], rdi          ; сохраняется адрес игрового фильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление функции деления игрового фильма (адрес уже в rdi)
    call    DivideGame
    movsd   [.p], xmm0          ; сохранение

    ; Вывод информации об игровом фильме в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.pgame]        ; адрес игрового фильма
    mov     edx, [rax]          
    mov     ecx, [rax+4]  
    mov      r8, [rax+24]      
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

global OutCartoon
OutCartoon:
section .data
    .outfmt db "It is Cartoon: publication year = %d, type = %d, name = %d. Division result = %g",10,0
section .bss
    .pcartoon  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленная функция деления мультфильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pcartoon], rdi        ; сохраняется адрес мультфильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление функции деления мультфильма (адрес уже в rdi)
    call    DivideCartoon
    movsd   [.p], xmm0          ; сохранение

    ; Вывод информации о мультфильме в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.pcartoon]      ; адрес мультфильма
    mov     edx, [rax]          
    mov     ecx, [rax+4]        
    mov      r8, [rax+8]        
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

global OutDocumentary
OutDocumentary:
section .data
    .outfmt db "It is Documentary: publication year = %d, length = %d, name = %d. Division result = %g",10,0
section .bss
    .pdocumentary  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленная функция деления документального фильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pdocumentary], rdi        ; сохраняется адрес документального фильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление функции деления документального фильма (адрес уже в rdi)
    call    DivideDocumentary
    movsd   [.p], xmm0          ; сохранение

    ; Вывод информации о документальном фильме в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.pdocumentary]      ; адрес документального фильма
    mov     edx, [rax]          
    mov     ecx, [rax+4]        
    mov      r8, [rax+8]        
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

global OutFilm
OutFilm:
section .data
    .erFilm db "Incorrect film!",10,0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фильма
    mov eax, [rdi]
    cmp eax, [GAME]
    je gameOut
    cmp eax, [CARTOON]
    je cartoonOut
    cmp eax, [DOCUMENTARY]
    je documentaryOut
    mov rdi, .erFilm
    mov rax, 0
    call fprintf
    jmp     return
gameOut:
    ; Вывод игрового фильма
    add     rdi, 4
    call    OutGame
    jmp     return
cartoonOut:
    ; Вывод мультфильма
    add     rdi, 4
    call    OutCartoon
    jmp     return
documentaryOut:
    ; Вывод документального фильма
    add     rdi, 4
    call    OutDocumentary
return:
leave
ret

global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .pcont  resq    1   ; адрес контейнера
    .len    resd    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.len],   esi     ; сохраняется число элементов
    mov [.FILE],  rdx    ; сохраняется указатель на файл

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фильмов
    xor ecx, ecx            ; счетчик фильмов = 0
    mov rsi, rdx            ; перенос указателя на файл
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фильмы

    push rbx
    push rcx

    ; Вывод номера фильма
    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода фильма
    mov     edx, ecx        ; индекс текущего фильма
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf

    ; Вывод текущего ифильма
    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutFilm     

    pop rcx
    pop rbx
    inc ecx                 ; индекс следующего фильма

    mov     rax, [.pcont]
    add     rax, 44         ; адрес следующего фильма
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret

