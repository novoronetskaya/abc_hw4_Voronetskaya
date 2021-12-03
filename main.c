//------------------------------------------------------------------------------
// main.cpp - содержит главную функцию, 
// обеспечивающую простое тестирование
//------------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h> // для функций rand() и srand()
#include <time.h>   // для функции time()
#include <string.h>

#include "data.h"

void errMessage1() {
    printf("incorrect command line!\n"
           "  Waited:\n"
           "     command -f infile outfile01 outfile02\n"
           "  Or:\n"
           "     command -n number outfile01 outfile02\n");
}

void errMessage2() {
    printf("incorrect qualifier value!\n"
            "  Waited:\n"
            "     command -f infile outfile01 outfile02\n"
            "  Or:\n"
            "     command -n number outfile01 outfile02\n");
}

//------------------------------------------------------------------------------
int main(int argc, char* argv[]) {
    unsigned char cont[maxSize];
    // Количество элементов в массиве
    int len = 0;

    printf("intSize = %d\n", intSize);
    printf("gameSize = %d\n", gameSize);
    printf("cartoonSize = %d\n", cartoonSize);
    printf("documentarySize = %d\n", documentarySize);
    printf("filmSize = %d\n", filmSize);
    printf("maxSize = %d\n", maxSize);
    printf("GAME = %d\n", GAME);
    printf("CARTOON = %d\n", CARTOON);
    printf("DOCUMENTARY = %d\n", DOCUMENTARY);
    printf("Size of container = %d\n", sizeof(cont));


    if(argc != 5) {
        errMessage1();
        return 1;
    }

    printf("Start\n");

    if(!strcmp(argv[1], "-f")) {
        FILE* ifst = fopen(argv[2], "r");
        InContainer(cont, &len, ifst);
    }
    else if(!strcmp(argv[1], "-n")) {
        int size = atoi(argv[2]);
        if((size < 1) || (size > 10000)) { 
            printf("incorrect numer of films = %d. Set 0 < number <= 10000\n",
                   size);
            return 3;
        }
        // системные часы в качестве инициализатора
        srand((unsigned int)(time(0)));
        // Заполнение контейнера генератором случайных чисел
        InRndContainer(cont, &len, size);
    }
    else {
        errMessage2();
        return 2;
    }

    // Вывод содержимого контейнера в файл
    fprintf(stdout, "Filled container:\n");
    OutContainer(cont, len, stdout);
    FILE* ofst1 = fopen(argv[3], "w");
    fprintf(ofst1, "Filled container:\n");
    OutContainer(cont, len, ofst1);
    fclose(ofst1);

    // The 2nd part of task
    FILE* ofst2 = fopen(argv[4], "w");
    clock_t start = clock();
    double average = DivideContainer(cont, len);
    clock_t end = clock();
    double calcTime = ((double)(end - start)) / (CLOCKS_PER_SEC + 1.0);

    fprintf(stdout, "Division result average = %g\nCalculaton time = %g\n", average, calcTime);
    fprintf(ofst2, "Division result average = %g\nCalculaton time = %g\n", average, calcTime);
    fclose(ofst2);

    printf("Stop\n");
    return 0;
}
