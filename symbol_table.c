#include <stdio.h>
#include <string.h>
#include "symbol_table.h"

#define MAX 100

struct Symbol {
    char name[50];
    char type[20];
};

struct Symbol table[MAX];
int count = 0;

int isDeclared(char *name) {
    for(int i = 0; i < count; i++) {
        if(strcmp(table[i].name, name) == 0)
            return 1;
    }
    return 0;
}

int insertSymbol(char *name) {
    if(isDeclared(name))
        return 0;

    strcpy(table[count].name, name);
    strcpy(table[count].type, "IDENTIFIER");   // store token type
    count++;
    return 1;
}

void displayTable() {
    for(int i = 0; i < count; i++) {
        printf("%d: %s -> %s\n", i+1, table[i].name, table[i].type);
    }
}