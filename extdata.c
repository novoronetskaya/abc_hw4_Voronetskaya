#ifndef __extdata__
#define __extdata__

//------------------------------------------------------------------------------
// extdata.h - Описание внешних данных
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Раздел констант
//------------------------------------------------------------------------------

// Константа, определяющая размер целого числа
extern int const intSize;
// Константа, задающая размер для игрового фильма
extern int const gameSize;
// Константа, задающая размер для мультфильма
extern int const cartoonSize;
// Константа, задающая размер для документального фильма
extern int const documentarySize;
// Константа, задающая размер для фильма
extern int const filmSize;
// Константа, определяющая размерность массива фигур
extern int const maxSize;
// Константа, задающая признак игрового фильма
extern int const GAME;
// Константа, задающая признак мультфильма
extern int const CARTOON;
// Константа, задающая признак документального фильма
extern int const DOCUMENTARY;

//------------------------------------------------------------------------------
// Раздел данных
//------------------------------------------------------------------------------

// Количество элементов в массиве
// external int len;

//------------------------------------------------------------------------------
// Раздел выделяемой памяти
//------------------------------------------------------------------------------

// Массив используемый для хранения данных
//external int cont[];



//------------------------------------------------------------------------------
// Описание используемых функций
//------------------------------------------------------------------------------

// Ввод содержимого контейнера из указанного файла
//void InContainer(void *c, int *len, FILE *ifst);
// Случайный ввод содержимого контейнера
//void InRndContainer(void *c, int *len, int size);
// Вывод содержимого контейнера в файл
//void OutContainer(void *c, int len, FILE *ofst);
// Вычисление среднего значения функции нахождения частного
// от деления года выхода на длину названия для всех фильмов в контейнере
//double DivideYearByLengthAverage(void *c, int len);

#endif
