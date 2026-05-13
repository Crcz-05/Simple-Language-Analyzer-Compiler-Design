%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

extern char tokens[][50];
extern int token_count;
extern char lex_errors[][50];
extern int lex_error_count;

int syntax_error = 0;
int semantic_error = 0;

void yyerror(const char *s);
int yylex();

/* ===== TREE STRUCTURE ===== */
typedef struct node {
    char data[50];
    struct node *left, *right;
} node;

node* createNode(char *val) {
    node* newnode = (node*)malloc(sizeof(node));
    strcpy(newnode->data, val);
    newnode->left = newnode->right = NULL;
    return newnode;
}

node *root = NULL;

/* ===== PRINT TREE ===== */
void printTree(node* root, int level) {
    if (root == NULL) return;

    // Print root
    if (level == 0) {
        printf("        %s\n", root->data);
    }

    // If children exist
    if (root->left || root->right) {
        printf("       / \\\n");

        // Left and right values
        if (root->left && root->right) {
            printf("     %s   %s\n", root->left->data, root->right->data);
        }
        else if (root->left) {
            printf("     %s\n", root->left->data);
        }
        else if (root->right) {
            printf("         %s\n", root->right->data);
        }
    }

    // Handle deeper level (only for right side expressions like +)
    if (root->right && (root->right->left || root->right->right)) {
        printf("         / \\\n");
        printf("       %s   %s\n",
               root->right->left ? root->right->left->data : " ",
               root->right->right ? root->right->right->data : " ");
    }
}
%}

%union {
    int num;
    char *str;
    struct node *nd;
}

%token <str> ID
%token <num> NUMBER
%token INT
%token ASSIGN PLUS

%type <nd> expression term assignment

%%

program:
    program statement
    |
    ;

statement:
      declaration
    | assignment
    ;

declaration:
    INT id_list ';'
    ;

id_list:
      ID {
            if(!insertSymbol($1)) {
                printf("[SEMANTIC ERROR] %s already declared\n", $1);
                semantic_error = 1;
            }
         }
    | id_list ',' ID {
            if(!insertSymbol($3)) {
                printf("[SEMANTIC ERROR] %s already declared\n", $3);
                semantic_error = 1;
            }
         }
    ;

assignment:
    ID ASSIGN expression ';' {
        if(!isDeclared($1)) {
            printf("[SEMANTIC ERROR] %s not declared\n", $1);
            semantic_error = 1;
        }

        node *idNode = createNode($1);
        node *assignNode = createNode("=");

        assignNode->left = idNode;
        assignNode->right = $3;

        root = assignNode;
        $$ = assignNode;
    }
;

expression:
      expression PLUS term {
            node *plusNode = createNode("+");
            plusNode->left = $1;
            plusNode->right = $3;
            $$ = plusNode;
      }
    | term {
            $$ = $1;
      }
;

term:
      ID {
            if(!isDeclared($1)) {
                printf("[SEMANTIC ERROR] %s not declared\n", $1);
                semantic_error = 1;
            }
            $$ = createNode($1);
      }
    | NUMBER {
            char temp[20];
            sprintf(temp, "%d", $1);
            $$ = createNode(temp);
      }
;

%%

void yyerror(const char *s) {
    syntax_error = 1;
}

int main() {
    printf("Enter code:\n");
    yyparse();

    /* ===== LEXICAL ===== */
    printf("\n--- LEXICAL ANALYSIS ---\n");
    if(lex_error_count > 0) {
        for(int i=0;i<lex_error_count;i++)
            printf("[LEXICAL ERROR] %s\n", lex_errors[i]);
    } else {
        for(int i=0;i<token_count;i++)
            printf("%s\n", tokens[i]);
    }

    /* ===== SYNTAX ===== */
    printf("\n--- SYNTAX ANALYSIS ---\n");
    if(syntax_error)
        printf("[SYNTAX ERROR]\n");
    else {
        printf("No Syntax Error\n");

        printf("\n--- PARSE TREE ---\n");
        printTree(root, 0);
    }

    /* ===== SEMANTIC ===== */
    printf("\n--- SEMANTIC ANALYSIS ---\n");
    if(semantic_error)
        printf("Semantic errors occurred\n");
    else
        printf("No Semantic Error\n");

    /* ===== SYMBOL TABLE ===== */
    printf("\n--- SYMBOL TABLE ---\n");
    displayTable();

    return 0;
}