%define parse.trace
%define parse.error detailed

%{
    #include <stdio.h>
    #include <stdarg.h>

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    bool DEBUG_PARSER;

    void parsprint(const char *format, ...);
    void yyerror(const char *s);
%}

%start program



%%

program: /* empty */
       ;

%%

    /* Functions */

    /* Debugging */

void parsprint(const char *format, ...) {
    if (!DEBUG_PARSER) return;

    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
    printf("\n");
}

void yyerror(const char* s) {
    fprintf(stderr, "\nPARSER ERROR at line %d: %s\n%s\n", yylineno, yytext, s);
}
