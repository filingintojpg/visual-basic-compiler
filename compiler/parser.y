%define parse.trace
%define parse.error detailed

%{
    #include <stdio.h>
    #include <stdarg.h>
    #include <string>

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    int parserErrors = 0;
    void yyerror(const char* s) { parserErrors++; fprintf(stderr, "\nPARSER ERROR at line %d: %s - %s\n", yylineno, yytext, s); }
%}

%union {
    std::string* id;
    int          intLiteral;
    float        floatLiteral;
    std::string* stringLiteral;
    char         charLiteral;
    bool         boolLiteral;
}

%printer { fprintf(yyo, "\"%s\"", $$->c_str()); } <id>
%printer { fprintf(yyo, "%d",     $$);          } <intLiteral>
%printer { fprintf(yyo, "%f",     $$);          } <floatLiteral>
%printer { fprintf(yyo, "\"%s\"", $$->c_str()); } <stringLiteral>
%printer { fprintf(yyo, "%c",     $$);          } <charLiteral>
%printer { fprintf(yyo, "%d",     $$);          } <boolLiteral>

%token <id>            ID
%token <intLiteral>    INT_LIT
%token <floatLiteral>  FLOAT_LIT
%token <stringLiteral> STR_LIT
%token <charLiteral>   CHAR_LIT
%token <boolLiteral>   BOOL_LIT

%token BOOLEAN CHAR INTEGER SINGLE STRING
%token CBOOL CCHAR CINT CSNG CSTR CTYPE
%token IF THEN ELSE ELSEIF SELECT CASE FOR EACH NEXT TO STEP DO LOOP WHILE UNTIL IN CONTINUE EXIT
%token DIM CONST FUNCTION SUB CLASS INHERITS CALL END RETURN
%token PUBLIC PRIVATE PROTECTED SHARED
%token ME MYBASE MYCLASS NEW NOTHING OPTIONAL AS
%token ENDL

%token ADD_ASSIGN           "+="
%token SUB_ASSIGN           "-="
%token MUL_ASSIGN           "*="
%token DIV_ASSIGN           "/="
%token FLOORDIV_ASSIGN      "\\="
%token EXP_ASSIGN           "^="
%token STRCAT_ASSIGN        "&="
%token NEQ                  "<>"
%token LEQ                  "<="
%token GEQ                  ">="

%left OR OR_ELSE
%left AND AND_ALSO
%right NOT
%left '=' "<>" "<=" ">=" '<' '>' IS ISNOT
%left '&'
%left '+' '-'
%left MOD
%left '\\'
%left '/' '*'
%right UNMINUS UNPLUS
%left '^'
%left '.'
%nonassoc '(' ')' '{' '}'

%start program

%%

/* Program */

program: ecle members ecle
       ;

members: class_declaration
       | members ecle class_declaration
       ;

/* Classes */

class_declaration: access_modifier CLASS ID ecl INHERITS ID class_body_e END CLASS
                 | access_modifier CLASS ID class_body_e END CLASS
                 | CLASS ID ecl INHERITS ID class_body_e END CLASS
                 | CLASS ID class_body_e END CLASS
                 ;

access_modifier: PUBLIC
               | PRIVATE
               | PROTECTED
               ;

class_body: class_member ecl
          | class_body class_member ecl
          ;

class_body_e: ecl
            | ecl class_body
            ;

class_member: field_declaration
            | function_declaration
            | sub_declaration
            ;

/* Fields */

field_declaration: member_modifiers DIM SHARED var_declaration
                 | member_modifiers DIM var_declaration
                 | member_modifiers CONST SHARED var_declaration
                 | member_modifiers CONST var_declaration
                 | DIM SHARED var_declaration // По умолчанию Private
                 | DIM var_declaration
                 | CONST SHARED var_declaration
                 | CONST var_declaration
                 | member_modifiers var_declaration
                 ;

member_modifiers: access_modifier
                | SHARED
                | access_modifier SHARED
                | SHARED access_modifier
                ;

/* Methods */

function_declaration: member_modifiers FUNCTION ID '(' parameter_list_e ')' AS type block_e END FUNCTION
                    | member_modifiers FUNCTION ID AS type block_e END FUNCTION // Функцию без аргументов можно объявить без скобок
                    | FUNCTION ID '(' parameter_list_e ')' AS type block_e END FUNCTION // По умолчанию Public
                    | FUNCTION ID AS type block_e END FUNCTION
                    ;

sub_declaration: member_modifiers SUB ID '(' parameter_list_e ')' block_e END SUB
               | member_modifiers SUB NEW '(' parameter_list_e ')' block_e END SUB // Конструктор
               | member_modifiers SUB ID block_e END SUB // Процедуру без аргументов можно объявить без скобок
               | member_modifiers SUB NEW block_e END SUB
               | SUB ID '(' parameter_list_e ')' block_e END SUB // По умолчанию Public
               | SUB NEW '(' parameter_list_e ')' block_e END SUB
               | SUB ID block_e END SUB
               | SUB NEW block_e END SUB
               ;

parameter_list: parameter
              | parameter_list ',' ee parameter
              ;

parameter_list_e: ee
                | parameter_list ee
                ;

parameter: ID AS type
         | ID '(' ee ')' AS simple_type
         | OPTIONAL ID AS type '=' ee expr
         ;

/* Statements */

block: stmt ecl
     | block stmt ecl
     ;

block_e: ecl
       | ecl block
       ;

stmt: expr              // Вызов метода или присваивание expr = expr
    | CALL expr         // Вызов метода
    | expr "+=" ee expr
    | expr "-=" ee expr
    | expr "*=" ee expr
    | expr "/=" ee expr
    | expr "\\=" ee expr
    | expr "^=" ee expr
    | expr "&=" ee expr
    | RETURN
    | RETURN expr
    | CONTINUE DO       // Находят ближайший по вложенности такой цикл и приступают к следующей его итерации
    | CONTINUE FOR
    | CONTINUE WHILE
    | EXIT DO           // Находят ближайший по вложенности такой цикл и выходят из всех циклов вплоть до нужного
    | EXIT FOR
    | EXIT WHILE
    | EXIT SELECT
    | EXIT FUNCTION     // Возвращает дефолт значение для возвращаемого типа: для Integer и Single 0, для Boolean False, для String Nothing и т. д.
    | EXIT SUB
    | IF expr THEN block_e else_if_stmts END IF
    | IF expr THEN block_e else_if_stmts ELSE block_e END IF
    | SELECT CASE expr ecl case_stmts END SELECT
    | SELECT CASE expr ecl case_stmts CASE ELSE block_e END SELECT
    | FOR ID AS simple_type '=' ee expr TO expr STEP expr block_e NEXT
    | FOR ID AS simple_type '=' ee expr TO expr block_e NEXT
    | FOR ID '=' ee expr TO expr STEP expr block_e NEXT
    | FOR ID '=' ee expr TO expr block_e NEXT
    | FOR EACH ID AS simple_type IN ee expr block_e NEXT
    | FOR EACH ID IN ee expr block_e NEXT
    | WHILE expr block_e END WHILE
    | DO block_e LOOP
    | DO block_e LOOP WHILE expr
    | DO block_e LOOP UNTIL expr
    | DO WHILE expr block_e LOOP
    | DO UNTIL expr block_e LOOP
    | DIM var_declaration
    | CONST var_declaration
    ;

/* If */

else_if_stmts: %empty
             | else_if_stmts ELSEIF expr THEN block_e
             ;

/* Select Case */

case_stmts: %empty
          | case_stmts CASE case_exprs block_e
          ;

case_exprs: case_expr
          | case_exprs ',' ee case_expr
          ;

case_expr: expr
         | expr TO expr
         | is_e '=' ee expr
         | is_e "<>" ee expr
         | is_e '<' ee expr
         | is_e '>' ee expr
         | is_e "<=" ee expr
         | is_e ">=" ee expr
         ;

is_e: %empty
    | IS ee
    ;

/* Variable declarations */

var_declaration: var_declarator
               | var_declaration ',' ee var_declarator
               ;

var_declarator: ID '=' ee expr                                      // x = 1, x = MyFunc(), x = {1, 2, 3}, ...
              | ID AS type                                          // x As Integer, x As Integer(), x As MyType, x As MyType()
              | ID AS type '=' ee expr                              // x As MyType = 1, x As MyType() = {1, 2, 3}, ...
              | ID AS NEW ID                                        // x As New MyType
              | ID AS NEW ID '(' expr_list_e ')'                    // x As New MyType(1, true)
              | ID AS NEW primitive_type                            // x As New Integer
              | ID AS NEW primitive_type '(' ee ')'                 // x As New Integer()
              | ID '(' expr_list_e ')' AS simple_type               // x() As MyType, x(2) As MyType
              | ID '(' expr_list_e ')' AS simple_type '=' ee expr   // x() As MyType = {1, 2, 3}
              ;

/* Expressions */

expr: ID
    | INT_LIT
    | FLOAT_LIT
    | STR_LIT
    | CHAR_LIT
    | BOOL_LIT
    | NOTHING
    | ME        // this
    | INTEGER   // Примитивные типы являеются expr, так как имеют свои статические поля и методы
    | BOOLEAN
    | CHAR
    | STRING
    | SINGLE
    | expr '+' ee expr
    | expr '-' ee expr
    | expr '*' ee expr
    | expr '/' ee expr
    | expr '\\' ee expr
    | expr '^' ee expr
    | expr '&' ee expr
    | expr '>' ee expr
    | expr '<' ee expr
    | expr '=' ee expr
    | expr "<>" ee expr
    | expr "<=" ee expr
    | expr ">=" ee expr
    | expr AND ee expr
    | expr AND_ALSO ee expr
    | expr OR ee expr
    | expr OR_ELSE ee expr
    | expr MOD ee expr
    | expr IS ee expr
    | expr ISNOT ee expr
    | NOT expr
    | '+' expr %prec UNPLUS
    | '-' expr %prec UNMINUS
    | '(' ee expr ee ')'
    | ID '(' expr_list_e ')' // Вызов метода или индексация одномерного массива
    | expr '.' ee id_or_kw
    | expr '.' ee id_or_kw '(' expr_list_e ')'
    | MYBASE '.' ee id_or_kw
    | MYBASE '.' ee id_or_kw '(' expr_list_e ')'
    | MYCLASS '.' ee id_or_kw
    | MYCLASS '.' ee id_or_kw '(' expr_list_e ')'
    | cast_operator '(' ee expr ee ')'              // Оператор преобразования в другой тип, не функция
    | CTYPE '(' ee expr ',' ee type ee ')'          // Оператор преобразования в другой тип, не функция
    | IF '(' ee expr ',' ee expr ',' ee expr ee ')' // Тернарный оператор
    | IF '(' ee expr ',' ee expr ee ')'             // Не тернарный оператор: если expr_1 является NOTHING, то выбрать expr_2
    | NEW ID                                                        // Объект: New MyType
    | NEW ID '(' expr_list_e ')'                                    // Объект: New MyType(1, true)
    | NEW ID '(' expr_list_e ')' '{' expr_list_e '}'                // Массив: New MyType() {1, 2, 3}, New MyType(2) {1, 2, 3}
    | NEW primitive_type                                            // Объект: New Integer
    | NEW primitive_type '(' expr_list_e ')'                        // Объект: New Integer(5)
    | NEW primitive_type '(' expr_list_e ')' '{' expr_list_e '}'    // Массив: New Integer() {1, 2, 3}, New Integer(2) {1, 2, 3}
    | '{' expr_list_e '}'
    ;

expr_list: ee expr
         | expr_list ',' ee expr
         ;

expr_list_e: ee
           | expr_list ee
           ;

cast_operator: CBOOL | CINT | CCHAR | CSTR | CSNG
             ;

/* Types */

type: simple_type
    | simple_type '(' ee ')'
    ;

simple_type: ID
           | primitive_type
           ;

primitive_type: INTEGER | BOOLEAN | CHAR | STRING | SINGLE
              ;

/* Keywords */

id_or_kw: ID
        | IF | THEN | ELSE | ELSEIF | END | SELECT | CASE | TO
        | FOR | EACH | WHILE | NEXT | IN | UNTIL | LOOP | DO | STEP
        | ME | MYBASE | MYCLASS | NEW | AS | OPTIONAL
        | DIM | CONST | FUNCTION | SUB | CLASS | INHERITS | CALL | CONTINUE | EXIT | RETURN
        | PUBLIC | PRIVATE | PROTECTED | SHARED
        | INTEGER | BOOLEAN | CHAR | STRING | SINGLE
        | CBOOL | CINT | CCHAR | CSTR | CSNG | CTYPE
        ;

/* Line breaks and statement separators */

ee: %empty
  | ENDL
  ;

ec: ENDL
  | ':'
  ;

ecl: ec
   | ecl ec
   ;

ecle: %empty
    | ecl
    ;

%%
