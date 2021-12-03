//------------------------------------------------------------------------------
// inrnd.c - единица компиляции, вбирающая функции генерации случайных данных
//------------------------------------------------------------------------------

#include <stdlib.h>

#include "extdata.h"

// Случайный ввод параметров игрового фильма
void InRndGame(void *r) {
    int publication_year = rand() % 126 + 1896;
    *((int*)r) = publication_year;
    char name[20];    
    char director[20];
    int name_length = rand() % 19 + 1;
    for (int i = 0; i < name_length; ++i) {
        name[i] = 'a' + rand() % 26;
    }
    name[name_length] = '\0';
    int director_length = rand() % 19 + 1;
    for (int i = 0; i < director_length; ++i) {
        director[i] = 'a' + rand() % 26;
    }
    director[name_length] = '\0';
    int y = Random();
    *((char*)(r+intSize)) = name;
    *((char*)(r+intSize + 20)) = director;
}

// Случайный ввод параметров мультфильма
void InRndCartoon(void *t) {
    int publication_year = rand() % 126 + 1896;
    int name_length = rand() % 19 + 1;
    char name[20];     
    for (int i = 0; i < name_length; ++i) {
        name[i] = 'a' + rand() % 26;
    }
    name[name_length] = '\0';
    int tp = rand() % 3 + 1;
    *((int*)t) = publication_year;
    *((int*)(t+intSize)) = tp;
    *((int*)(t+2*intSize)) = name;
}

// Случайный ввод обобщенного фильма
int InRndFilm(void *s) {
    int k = rand() % 3 + 1;
    switch(k) {
        case 1:
            *((int*)s) = GAME;
            InRndGame(s+intSize);
            return 1;
        case 2:
            *((int*)s) = CARTOON;
            InRndCartoon(s+intSize);
            return 2;
        case 3:
            *((int*)s) = DOCUMENTARY;
            InRndDocumentary(s+intSize);
            return 3;
        default:
            return 0;
    }
}

// Случайный ввод содержимого контейнера
void InRndContainer(void *c, int *len, int size) {
    void *tmp = c;
    while(*len < size) {
        if(InRndFilm(tmp)) {
            tmp = tmp + filmSize;
            (*len)++;
        }
    }
}
