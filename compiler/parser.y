%define parse.trace
%define parse.error detailed

%{
    #include <stdio.h>
    #include <stdarg.h>
    #include <string>

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    void yyerror(const char* s) { fprintf(stderr, "\nPARSER ERROR at line %d: %s - %s\n", yylineno, yytext, s); }
%}

%code requires {
    enum class IntType { LONG, INTEGER, SHORT, NONE };
    struct IntLiteral { long long int value; IntType type; bool isUnsigned = false;
        IntLiteral(long long int value, IntType type, bool isUnsigned) : value(value), type(type), isUnsigned(isUnsigned) {}
    };

    enum class FloatType { DECIMAL, SINGLE, DOUBLE, NONE };
    struct FloatLiteral { double value; FloatType type;
        FloatLiteral(double value, FloatType type) : value(value), type(type) {}
    };
}

%union {
    IntLiteral*     intLiteral;
    FloatLiteral*   floatLiteral;
    std::string*    stringLiteral;
    char            charLiteral;
    bool            boolLiteral;
    std::string*    id;
}

%token <id>            ID
%token <intLiteral>    INT_LIT
%token <floatLiteral>  FLOAT_LIT
%token <stringLiteral> STR_LIT
%token <charLiteral>   CHAR_LIT
%token <boolLiteral>   BOOL_LIT

%token BOOLEAN BYTE CHAR DATE DECIMAL DOUBLE INTEGER LONG OBJECT SBYTE SHORT SINGLE STRING UINTEGER ULONG USHORT VARIANT
%token CBOOL CBYTE CCHAR CDATE CDBL CDEC CINT CLNG COBJ CSBYTE CSHORT CSNG CSTR CUINT CULNG CUSHORT CTYPE DIRECT_CAST TRY_CAST
%token IF THEN ELSE ELSEIF SELECT CASE FOR EACH NEXT TO STEP DO LOOP WHILE WEND UNTIL IN WHEN CONTINUE EXIT
%token CALL END GOTO GO_SUB RETURN STOP RESUME ERROR THROW TRY CATCH FINALLY WITH USING SYNC_LOCK REDIM ERASE PRESERVE ADD_HANDLER REMOVE_HANDLER RAISE_EVENT
%token DIM CONST STATIC FUNCTION SUB CLASS STRUCT MODULE NAMESPACE ENUM INTERFACE DELEGATE EVENT PROPERTY OPERATOR DECLARE LIB ALIAS ASSEMBLY IMPORTS OPTION GET SET INHERITS IMPLEMENTS HANDLES
%token PUBLIC PRIVATE PROTECTED FRIEND SHARED READONLY WRITE_ONLY OVERLOADS OVERRIDABLE OVERRIDES NOT_OVERRIDABLE MUST_OVERRIDE MUST_INHERIT NOT_INHERITABLE SHADOWS DEFAULT PARTIAL NARROWING WIDENING ITERATOR WITH_EVENTS
%token BYREF BYVAL OPTIONAL PARAMARRAY OUT AS OF
%token ME MYBASE MYCLASS NOTHING TYPE_OF GET_TYPE NAME_OF ADDRESS_OF GET_XML_NAMESPACE GLOBAL MID LIKE
%token BY GROUP INTO JOIN ON ORDER SKIP TAKE
%token ENDL

%token ADD_ASSIGN           "+="
%token SUB_ASSIGN           "-="
%token MUL_ASSIGN           "*="
%token DIV_ASSIGN           "/="
%token FLOORDIV_ASSIGN      "\\="
%token EXP_ASSIGN           "^="
%token STRCAT_ASSIGN        "&="
%token LSHIFT_ASSIGN        "<<="
%token RSHIFT_ASSIGN        ">>="
%token NEQ                  "<>"
%token LEQ                  "<="
%token GEQ                  ">="
%token LSHIFT               "<<"
%token RSHIFT               ">>"

%left NEW
%left OR OR_ELSE XOR
%left AND AND_ALSO
%right NOT
%left '=' "<>" "<=" ">=" '<' '>' IS ISNOT
%left "<<" ">>"
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

program: ecle members
       ;

members: class_declaration ecle
       | members class_declaration ecle
       ;

/* Classes */

class_declaration: access_modifier_e CLASS ID '(' ee OF ee generic_of_list ee ')' ecl INHERITS ID ecl class_body_e END CLASS
                 | access_modifier_e CLASS ID '(' ee OF ee generic_of_list ee ')' ecl class_body_e END CLASS
                 | access_modifier_e CLASS ID ecl INHERITS ID ecl class_body_e END CLASS
                 | access_modifier_e CLASS ID ecl class_body_e END CLASS
                 ;

access_modifier: PUBLIC
               | PRIVATE
               | PROTECTED
               ;

access_modifier_e: %empty
                 | access_modifier
                 ;

generic_of_list: ID
               | generic_of_list ',' ee ID
               ;

class_body: class_member
          | class_body class_member
          ;
       
class_body_e: %empty
            | class_body
            ;

class_member: field_declaration ecl
            | function_declaration
            | sub_declaration
            ;

/* Fields */

field_declaration: member_modifiers_e DIM shared_e var_declarator_list
                 | member_modifiers_e CONST shared_e var_declarator_list
                 | member_modifiers var_declarator_list
                 ;

member_modifiers: access_modifier
                | access_modifier SHARED
                | SHARED access_modifier_e
                ;

member_modifiers_e: %empty
                  | member_modifiers
                  ;

shared_e: %empty
        | SHARED
        ;

/* Expressions */

expr: postfix_expr
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
    | expr OR_ELSE ee expr
    | expr OR ee expr
    | expr XOR ee expr
    | expr MOD ee expr
    | expr "<<" ee expr
    | expr ">>" ee expr
    | expr IS ee expr
    | expr ISNOT ee expr
    | '+' expr %prec UNPLUS
    | '-' expr %prec UNMINUS
    | NOT expr
    ;

postfix_expr: primary_expr
            | access_expr
            ;

access_expr: postfix_expr call_args
           | postfix_expr '.' ee ID
           | postfix_expr '.' ee keyword
           ;

primary_expr: literal
            | ID
            | ME
            | primitive_type
            | '(' ee expr ee ')'
            | cast_operator '(' ee expr ee ')'
            | CTYPE '(' ee expr ',' ee type ee ')'
            | IF '(' ee expr ',' ee expr ee ')'
            | IF '(' ee expr ',' ee expr ',' ee expr ee ')'
            | base_member_access
            | new_expr
            ;

literal: INT_LIT | FLOAT_LIT | STR_LIT | CHAR_LIT | BOOL_LIT | NOTHING
       ;

base_member_access: MYBASE '.' ee ID
                  | MYBASE '.' ee keyword
                  | MYCLASS '.' ee ID
                  | MYCLASS '.' ee keyword
                  ;

cast_operator: CBOOL | CBYTE | CSBYTE | CUSHORT | CSHORT
             | CINT | CUINT | CLNG | CULNG | CCHAR
             | CSTR | CDEC | CSNG | CDBL | COBJ
             ;

new_expr: NEW ID                                                     %prec NEW
        | NEW ID call_args                                           %prec NEW
        | NEW ID call_args collection_initializer                    %prec NEW
        | NEW ID generic_arguments                                   %prec NEW
        | NEW ID generic_arguments call_args                         %prec NEW
        | NEW ID generic_arguments call_args collection_initializer  %prec NEW
        | NEW primitive_type                                         %prec NEW
        | NEW primitive_type array_modifier                          %prec NEW
        | NEW primitive_type array_modifier collection_initializer   %prec NEW
        ;

array_modifier: '(' ee ')'
              | '(' ee expr ee ')'
              ;

call_args: '(' ee ')'
         | '(' ee arg_list ee ')'
         ;

arg_list: expr_or_initializer
        | arg_list ',' ee expr_or_initializer
        ;

expr_or_initializer: expr
                   | collection_initializer
                   ;

collection_initializer: '{' ee expr_list ee '}'
                      | '{' ee '}'
                      ;

expr_list: expr
         | expr_list ',' ee expr
         ;

/* Simple statements */

simple_stmt: call_stmt
           | assignment_stmt
           | return_stmt
           | jump_stmt
           ;

call_stmt: ID
         | access_expr
         | base_member_access
         | CALL expr
         ;

assignment_stmt: lvalue '=' ee expr_or_initializer
               | lvalue compound_assign_op ee expr
               ;

lvalue: ID
      | access_expr
      | base_member_access
      ;

compound_assign_op: "+=" | "-=" | "*=" | "/=" | "\\=" | "^=" | "&=" | "<<=" | ">>="
                  ;

return_stmt: RETURN
           | RETURN expr_or_initializer
           ;

jump_stmt: CONTINUE DO | CONTINUE FOR | CONTINUE WHILE
         | EXIT DO | EXIT FOR | EXIT WHILE
         | EXIT SELECT
         ;

/* Statements and blocks */

stmt: simple_stmt ecl
    | if_stmt
    | select_stmt
    | for_stmt
    | do_stmt
    | while_stmt
    | var_declaration
    ;

block: stmt
     | block stmt
     ;

block_e: %empty
       | block
       ;

/* If */

if_stmt: IF expr THEN inline_stmts el
       | IF expr THEN inline_stmts ELSE inline_stmts el
       | IF expr THEN ecl block_e else_if_stmts END IF ecl
       | IF expr THEN ecl block_e else_if_stmts ELSE ecl block_e END IF ecl
       ;

inline_stmts: simple_stmt
            | inline_stmts ':' simple_stmt
            ;

else_if_stmts: %empty
             | else_if_stmts ELSEIF expr THEN ecl block_e
             ;

/* Select Case */

select_stmt: SELECT expr ecl case_stmts END SELECT ecl
           | SELECT CASE expr ecl case_stmts END SELECT ecl
           ;

case_stmts: %empty
          | CASE ELSE ecl block_e
          | case_condition_branches
          | case_condition_branches CASE ELSE ecl block_e
          ;

case_condition_branch: CASE case_clauses ecl block_e
                     ;

case_condition_branches: case_condition_branch
                       | case_condition_branches case_condition_branch
                       ;

case_clause: expr
           | expr TO expr
           | comparison_op ee expr
           | IS ee comparison_op ee expr
           ;

case_clauses: case_clause
            | case_clauses ',' ee case_clause
            ;

comparison_op: '=' | "<>" | '<' | '>' | "<=" | ">="
             ;

/* Loops */

while_stmt: WHILE expr ecl block_e END WHILE ecl
          | WHILE expr ecl block_e WEND ecl
          ;

for_stmt: FOR for_loop_variable '=' ee expr TO expr ecl block_e NEXT ecl
        | FOR for_loop_variable '=' ee expr TO expr STEP expr ecl block_e NEXT ecl
        | FOR EACH for_loop_variable IN ee expr_or_initializer ecl block_e NEXT ecl
        ;

for_loop_variable: ID
                 | ID AS type
                 ;

do_stmt: DO ecl block_e LOOP ecl
       | DO ecl block_e LOOP WHILE expr ecl
       | DO ecl block_e LOOP UNTIL expr ecl
       | DO WHILE expr ecl block_e LOOP ecl
       | DO UNTIL expr ecl block_e LOOP ecl
       ;

/* Variable declarations */

var_declaration: DIM var_declarator_list ecl
               | CONST var_declarator_list ecl
               ;

var_declarator_list: var_declarator
                   | var_name
                   | var_names
                   | var_declarator ',' ee var_declarator_list
                   ;

var_declarator: var_name AS type '=' ee expr_or_initializer
              | var_name AS type
              | var_name AS new_expr
              | var_name '=' ee expr_or_initializer
              | var_names AS type
              | var_names AS new_expr
              ;

var_name: ID
        | ID array_modifier
        ;

var_names: var_name ',' ee var_name
         | var_names ',' ee var_name
         ;

/* Types */

type: simple_type
    | array_type
    ;

simple_type: ID
           | primitive_type
           | generic_type
           ;

primitive_type: BYTE | SBYTE | USHORT | SHORT | UINTEGER | INTEGER | ULONG | LONG
              | BOOLEAN | CHAR | STRING | DECIMAL | SINGLE | DOUBLE | OBJECT
              ;

generic_type: ID generic_arguments
            ;

generic_arguments: '(' ee OF ee type_list ee ')'
                 ;

type_list: simple_type
         | type_list ',' ee simple_type
         ;

array_type: ID '(' ee ')'
          | primitive_type '(' ee ')'
          | generic_type '(' ee ')'
          ;

/* Methods */

function_declaration: member_modifiers_e FUNCTION ID parameter_clause_e AS type el block_e END FUNCTION ecl
                    | member_modifiers_e FUNCTION ID parameter_clause_e el block_e END FUNCTION ecl
                    ;

sub_declaration: member_modifiers_e SUB ID parameter_clause_e el block_e END SUB ecl
               ;

parameter_clause_e: %empty
                  | parameter_clause
                  ;

parameter_clause: '(' ee ')'
                | '(' ee parameter_list ee ')'
                ;

parameter_list: parameter
              | parameter_list ',' ee parameter
              ;

parameter: ID AS type
         | ID '(' ee ')' AS type
         | ID
         | ID '(' ee ')'
         | OPTIONAL ID AS type '=' ee expr
         ;

/* Keywords */

keyword: IF | THEN | ELSE | ELSEIF | END | SELECT | CASE | TO
       | FOR | EACH | WHILE | NEXT | IN | UNTIL | LOOP | DO | STEP
       | CALL | GOTO | CONTINUE | EXIT | STOP | RETURN | REDIM | ERASE
       | ME | MYBASE | MYCLASS | NEW | AS | OF
       | DIM | CONST | STATIC | FUNCTION | SUB | CLASS | STRUCT | INHERITS
       | BYREF | BYVAL | PARAMARRAY | OPTIONAL
       | access_modifier | SHARED | READONLY
       | primitive_type | cast_operator | CTYPE
       ;

/* Line breaks and statement separators */

el: ENDL
  | el ENDL
  ;

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
