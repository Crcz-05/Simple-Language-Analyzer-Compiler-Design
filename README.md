Mini Compiler & Language Analyzer
A simple compiler design project using LEX (Flex), YACC (Bison), and C for analyzing small statement-based programs.

🚀 Features


1.Lexical Analysis


2.Syntax Analysis


3.Semantic Analysis


4.Error Handling


5.Parse Tree Generation


6.Symbol Table Management



📌 Supported Statements
int a,b;a = b + 5;

⚙️ Technologies Used


C Language


Flex (LEX)


Bison (YACC)


GCC Compiler



📂 Project Files

lexer.l            
 → Lexical Analyzer 
 
parser.y            
 → Syntax & Semantic Analyzer 
symbol_table.c     
 → Symbol Table Functions 
symbol_table.h     
 → Header File

🛠 How to Run
bison -d parser.y
flex lexer.l
gcc lex.yy.c parser.tab.c symbol_table.c -o compiler
./compiler

🌳 Project Output


Tokens


Lexical Errors


Syntax Validation


Semantic Errors


Parse Tree


Symbol Table



🎯 Concepts Used


Tokens & Lexemes


Regular Expressions


Context-Free Grammar


LALR Parsing


Shift-Reduce Parsing


Parse Trees


Symbol Tables



📚 Compiler Phases Implemented


Lexical Analysis


Syntax Analysis


Semantic Analysis

