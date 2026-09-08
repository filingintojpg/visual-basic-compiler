%option noyywrap
%option never-interactive
%option yylineno

DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT}|_)*|_({LETTER}|{DIGIT}|_)+
ESCAPED_ID  \[{ID}\]

NUMBER_INTEGER  {DIGIT}+
NUMBER_FLOAT    {DIGIT}*\.{DIGIT}+
NUMBER_EXPONENT ({NUMBER_INTEGER}|{NUMBER_FLOAT})[Ee][+-]?{NUMBER_INTEGER}

NUMBER_DECIMAL      [1-9]{DIGIT}*|0
NUMBER_HEXADECIMAL  &[Hh][a-fA-F0-9]+
NUMBER_OCTAL        &[Oo][0-7]+
NUMBER_BINARY       &[Bb][01]+

INTEGER_TYPE_CHARACTER          [%]
SINGLE_TYPE_CHARACTER           [!]
INTEGER_LITERAL_TYPE_CHARACTER  [Ii]
SINGLE_LITERAL_TYPE_CHARACTER   [Ff]

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
