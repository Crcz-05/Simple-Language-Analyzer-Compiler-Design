%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 100

char tokens[MAX][50];
char lex_errors[MAX][50];
int token_count = 0;
int lex_error_count = 0;
%}

DIGIT       [0-9]
LETTER      [a-zA-Z]

%%

"int" {
    strcpy(tokens[token_count++], "int -> KEYWORD");
    return INT;
}

"," {
    strcpy(tokens[token_count++], ", -> SEPARATOR");
    return ',';
}

";" {
    strcpy(tokens[token_count++], "; -> SEPARATOR");
    return ';';
}

"=" {
    strcpy(tokens[token_count++], "= -> OPERATOR");
    return ASSIGN;
}

"+" {
    strcpy(tokens[token_count++], "+ -> OPERATOR");
    return PLUS;
}

{DIGIT}+ {
    char temp[50];
    sprintf(temp, "%s -> NUMBER", yytext);
    strcpy(tokens[token_count++], temp);
    yylval.num = atoi(yytext);
    return NUMBER;
}

{LETTER}({LETTER}|{DIGIT})* {
    char temp[50];
    sprintf(temp, "%s -> IDENTIFIER", yytext);
    strcpy(tokens[token_count++], temp);
    yylval.str = strdup(yytext);
    return ID;
}

[ \t\n]+ ;

. {
    char temp[50];
    sprintf(temp, "Invalid token: %s", yytext);
    strcpy(lex_errors[lex_error_count++], temp);
}

%%

int yywrap() { return 1; }