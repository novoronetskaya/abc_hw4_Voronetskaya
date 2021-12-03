; file.asm - использование файлов в NASM
extern printf
extern fscanf

extern GAME
extern CARTOON
extern DOCUMENTARY

global InGame
InGame:
section .data
    .infmt db "%d%s%s",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .pgame  resq    1   ; адрес игрового фильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pgame], rdi          ; сохраняется адрес игрового фильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод игрового фильма из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.pgame]       
    mov     rcx, [.pgame]
    add     rcx, 4              
    mov     r8, [.pgame]
    add     r8, 24  
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

global InCartoon
InCartoon:
section .data
    .infmt db "%d%d%s",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .cartoon  resq    1   ; адрес мультфильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.cartoon], rdi          ; сохраняется адрес мультфильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод мультфильма из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.cartoon]      
    mov     rcx, [.cartoon]
    add     rcx, 4              
    mov     r8, [.cartoon]
    add     r8, 8               
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

global InDocumentary
InDocumentary:
section .data
    .infmt db "%d%d%s",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .documentary  resq    1   ; адрес документального фильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.documentary], rdi          ; сохраняется адрес документального фильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод документального фильма из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.documentary]       
    mov     rcx, [.documentary]
    add     rcx, 4              
    mov     r8, [.documentary]
    add     r8, 8               
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

global InFilm
InFilm:
section .data
    .tagFormat   db      "%d",0
    .tagOutFmt   db     "Tag is: %d",10,0
section .bss
    .FILE       resq    1   ; временное хранение указателя на файл
    .pfilm     resq    1   ; адрес фильма
    .filmTag   resd    1   ; признак фильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pfilm], rdi          ; сохраняется адрес фильма
    mov     [.FILE], rsi            ; сохраняется указатель на файл

    ; чтение признака фильма и его обработка
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pfilm]      ; адрес начала фильма (его признак)
    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fscanf

    mov rcx, [.pfilm]          ; загрузка адреса начала фильма
    mov eax, [rcx]              ; и получение прочитанного признака
    cmp eax, [GAME]
    je .gameIn
    cmp eax, [CARTOON]
    je .cartoonIn
    cmp eax, [DOCUMENTARY]
    je .documentaryIn
    xor eax, eax    ; Некорректный признак - обнуление кода возврата
    jmp     .return
.gameIn:
    ; Ввод игрового фильма
    mov     rdi, [.pfilm]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InGame
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.cartoonIn:
    ; Ввод мультфильма
    mov     rdi, [.pfilm]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InCartoon
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.documentaryIn:
    ; Ввод документального фильма
    mov     rdi, [.pfilm]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InDocumentary
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.return:

leave
ret

global InContainer
InContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.FILE], rdx    ; сохраняется указатель на файл
    ; В rdi адрес начала контейнера
    xor rbx, rbx        ; число фильмов = 0
    mov rsi, rdx        ; перенос указателя на файл
.loop:
    ; сохранение рабочих регистров
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0      
    call    InFilm     ; ввод фильма
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rbx
    inc rbx

    pop rdi
    add rdi, 44             ; адрес следующего фильма
    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret

