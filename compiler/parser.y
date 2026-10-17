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

field_declaration: member_modifiers DIM SHARED var_declarator_list
                 | member_modifiers DIM var_declarator_list
                 | member_modifiers CONST SHARED var_declarator_list
                 | member_modifiers CONST var_declarator_list
                 | DIM SHARED var_declarator_list
                 | DIM var_declarator_list
                 | CONST SHARED var_declarator_list
                 | CONST var_declarator_list
                 | member_modifiers var_declarator_list
                 ;

member_modifiers: access_modifier
                | SHARED
                | access_modifier SHARED
                | SHARED access_modifier
                ;

/* Methods */

function_declaration: member_modifiers FUNCTION ID '(' parameter_list_e ')' AS type block_e END FUNCTION
                    | member_modifiers FUNCTION ID '(' parameter_list_e ')' block_e END FUNCTION
                    | member_modifiers FUNCTION ID AS type block_e END FUNCTION
                    | member_modifiers FUNCTION ID block_e END FUNCTION
                    | FUNCTION ID '(' parameter_list_e ')' AS type block_e END FUNCTION
                    | FUNCTION ID '(' parameter_list_e ')' block_e END FUNCTION
                    | FUNCTION ID AS type block_e END FUNCTION
                    | FUNCTION ID block_e END FUNCTION
                    ;

sub_declaration: member_modifiers SUB ID '(' parameter_list_e ')' block_e END SUB
               | member_modifiers SUB ID block_e END SUB
               | SUB ID '(' parameter_list_e ')' block_e END SUB
               | SUB ID block_e END SUB
               ;

parameter_list: parameter
              | parameter_list ',' ee parameter
              ;

parameter_list_e: ee
                | parameter_list ee
                ;

parameter: ID
         | ID AS simple_type
         | ID AS array_type
         | ID '(' ee ')'
         | ID '(' ee ')' AS simple_type
         | OPTIONAL ID '=' ee expr
         | OPTIONAL ID AS simple_type '=' ee expr
         ;

/* Statements */

block: stmt ecl
     | block stmt ecl
     ;

block_e: ecl
       | ecl block
       ;

stmt: ID
    | access_expr
    | base_member_access
    | CALL expr
    | lvalue '=' ee expr_or_initializer
    | lvalue "+=" ee expr
    | lvalue "-=" ee expr
    | lvalue "*=" ee expr
    | lvalue "/=" ee expr
    | lvalue "\\=" ee expr
    | lvalue "^=" ee expr
    | lvalue "&=" ee expr
    | lvalue "<<=" ee expr
    | lvalue ">>=" ee expr
    | RETURN
    | RETURN expr_or_initializer
    | CONTINUE DO
    | CONTINUE FOR
    | CONTINUE WHILE
    | EXIT DO
    | EXIT FOR
    | EXIT WHILE
    | EXIT SELECT
    | IF expr THEN block_e else_if_stmts END IF
    | IF expr THEN block_e else_if_stmts ELSE block_e END IF
    | SELECT CASE expr ecl case_stmts END SELECT
    | FOR ID AS simple_type '=' ee expr TO expr STEP expr block_e NEXT
    | FOR ID AS simple_type '=' ee expr TO expr block_e NEXT
    | FOR ID '=' ee expr TO expr STEP expr block_e NEXT
    | FOR ID '=' ee expr TO expr block_e NEXT
    | FOR EACH ID AS simple_type IN ee expr_or_initializer block_e NEXT
    | FOR EACH ID IN ee expr_or_initializer block_e NEXT
    | WHILE expr block_e END WHILE
    | DO block_e LOOP
    | DO block_e LOOP WHILE expr
    | DO block_e LOOP UNTIL expr
    | DO WHILE expr block_e LOOP
    | DO UNTIL expr block_e LOOP
    | DIM var_declarator_list
    | CONST var_declarator_list
    ;

lvalue: ID
      | access_expr
      | base_member_access
      ;

/* If */

else_if_stmts: %empty
             | else_if_stmts ELSEIF expr THEN block_e
             ;

/* Select Case */

case_stmts: %empty
          | case_stmts CASE case_exprs block_e
          | case_stmts CASE ELSE block_e
          ;

case_exprs: case_expr
          | case_exprs ',' ee case_expr
          ;

case_expr: expr
         | expr TO expr
         | is_e '=' ee expr
         | is_e "<>" ee expr
         | is_e "<" ee expr
         | is_e ">" ee expr
         | is_e "<=" ee expr
         | is_e ">=" ee expr
         ;

is_e: %empty
    | IS ee
    ;

/* Variable declarations */

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
           ;

primitive_type: BYTE | SBYTE | USHORT | SHORT | UINTEGER | INTEGER | ULONG | LONG
              | BOOLEAN | CHAR | STRING | DECIMAL | SINGLE | DOUBLE | OBJECT
              ;

type_list: simple_type
         | type_list ',' ee simple_type
         ;

array_type: ID '(' ee ')'
          | primitive_type '(' ee ')'
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
