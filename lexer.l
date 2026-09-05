%option noyywrap
%option yylineno

DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT}|_)*
INTEGER     {DIGIT}+

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    /* Token definitions will be here */
%}

%%

    /* Whitespace and comments */

    /* Keywords */

    /* Operators */

    /* Separators */

    /* Literals */

    /* Identifiers */

    /* Errors */

%%

    /* Auxiliary C/C++ code */
