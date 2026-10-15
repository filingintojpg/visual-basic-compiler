%define parse.trace
%define parse.error detailed

%{
    #include <stdio.h>
    #include <stdarg.h>
    #include <string>

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    void yyerror(const char* s) {
        fprintf(stderr, "\nPARSER ERROR at line %d: %s - %s\n", yylineno, yytext, s);
    }
%}

%start program

/* Types */
%token BOOLEAN BYTE CHAR DATE DECIMAL DOUBLE INTEGER LONG OBJECT SBYTE SHORT
       SINGLE STRING UINTEGER ULONG USHORT VARIANT

/* Conversions */
%token CBOOL CBYTE CCHAR CDATE CDBL CDEC CINT CLNG COBJ CSBYTE CSHORT CSNG
       CSTR CUINT CULNG CUSHORT CTYPE DIRECT_CAST TRY_CAST

/* Conditions and loops */
%token IF THEN ELSE ELSEIF SELECT CASE FOR EACH NEXT TO STEP DO LOOP WHILE
       WEND UNTIL IN WHEN CONTINUE EXIT

/* Other statements */
%token CALL END GOTO GO_SUB RETURN STOP RESUME ERROR THROW TRY CATCH FINALLY
       WITH USING SYNC_LOCK REDIM ERASE PRESERVE ADD_HANDLER REMOVE_HANDLER
       RAISE_EVENT

/* Declarations */
%token DIM CONST STATIC FUNCTION SUB CLASS STRUCT MODULE NAMESPACE ENUM
       INTERFACE DELEGATE EVENT PROPERTY OPERATOR DECLARE LIB ALIAS ASSEMBLY
       IMPORTS OPTION GET SET INHERITS IMPLEMENTS HANDLES

/* Modifiers */
%token PUBLIC PRIVATE PROTECTED FRIEND SHARED READONLY WRITE_ONLY OVERLOADS
       OVERRIDABLE OVERRIDES NOT_OVERRIDABLE MUST_OVERRIDE MUST_INHERIT
       NOT_INHERITABLE SHADOWS DEFAULT PARTIAL NARROWING WIDENING ITERATOR
       WITH_EVENTS

/* Parameters and types */
%token BYREF BYVAL OPTIONAL PARAMARRAY OUT AS OF

/* Expressions */
%token ME MYBASE MYCLASS NOTHING TYPE_OF GET_TYPE NAME_OF ADDRESS_OF
       GET_XML_NAMESPACE GLOBAL MID LIKE

/* Query */
%token BY GROUP INTO JOIN ON ORDER SKIP TAKE

/* Assignment operators */
%token ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN FLOORDIV_ASSIGN
       EXP_ASSIGN STRCAT_ASSIGN LSHIFT_ASSIGN RSHIFT_ASSIGN

/* Separators */
%token ENDL

/* Identifiers and literals */
%token <id>            ID
%token <intLiteral>    INT_LIT
%token <floatLiteral>  FLOAT_LIT
%token <stringLiteral> STR_LIT
%token <charLiteral>   CHAR_LIT
%token <boolLiteral>   BOOL_LIT

%left NEW
%left OR OR_ELSE XOR
%left AND AND_ALSO
%right NOT
%left '=' NEQ LEQ GEQ '<' '>' IS ISNOT
%left LSHIFT RSHIFT
%left '&'
%left '+' '-'
%left MOD
%left '\\'
%left '/' '*'
%right UNMINUS UNPLUS
%left '^'
%left '.'
%nonassoc '(' ')' '{' '}'

%code requires {
    enum class IntType { LONG, INTEGER, SHORT, NONE };
    enum class FloatType { DECIMAL, SINGLE, DOUBLE, NONE };

    struct IntLiteral {
        long long int   value;
        IntType         type;
        bool            isUnsigned = false;

        IntLiteral() : value(0), type(IntType::INTEGER) {}
        IntLiteral(long long int value, IntType type, bool isUnsigned) : value(value), type(type), isUnsigned(isUnsigned) {}
    };

    struct FloatLiteral {
        double value;
        FloatType type;

        FloatLiteral() : value(0.0), type(FloatType::DOUBLE) {}
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

%%

/* ======================================================================
 *  Program
 * ====================================================================== */

program: endlc_list_e program_members
       ;

program_members: program_member
               | program_members program_member
               ;

program_member: class_declaration endlc_list_e
              ;

/* ======================================================================
 *  Line breaks and statement separators
 * ====================================================================== */

endl_list: ENDL
         | endl_list ENDL
         ;

endl_e: /* empty */
      | ENDL
      ;

endlc: ENDL
     | ':'
     ;

endlc_list: endlc
          | endlc_list endlc
          ;

endlc_list_e: /* empty */
            | endlc_list
            ;

/* ======================================================================
 *  Keywords
 * ====================================================================== */

kw: IF | THEN | ELSE | ELSEIF | END | SELECT | CASE | TO
  | FOR | EACH | WHILE | NEXT | IN | UNTIL | LOOP | DO | STEP
  | CALL | GOTO | CONTINUE | EXIT | STOP | RETURN | REDIM | ERASE
  | ME | MYBASE | MYCLASS | NEW | AS | OF
  | DIM | CONST | STATIC | FUNCTION | SUB | CLASS | STRUCT | INHERITS
  | BYREF | BYVAL | PARAMARRAY | OPTIONAL
  | access_modifier | SHARED | READONLY
  | primitive_type | cast_operator | CTYPE
  ;

/* ======================================================================
 *  Expressions
 * ====================================================================== */

expr: postfix_expr
    | expr '+' endl_e expr
    | expr '-' endl_e expr
    | expr '*' endl_e expr
    | expr '/' endl_e expr
    | expr '\\' endl_e expr
    | expr '^' endl_e expr
    | expr '&' endl_e expr
    | expr '>' endl_e expr
    | expr '<' endl_e expr
    | expr '=' endl_e expr
    | expr NEQ endl_e expr
    | expr LEQ endl_e expr
    | expr GEQ endl_e expr
    | expr AND endl_e expr
    | expr AND_ALSO endl_e expr
    | expr OR_ELSE endl_e expr
    | expr OR endl_e expr
    | expr XOR endl_e expr
    | expr MOD endl_e expr
    | expr LSHIFT endl_e expr
    | expr RSHIFT endl_e expr
    | expr IS endl_e expr
    | expr ISNOT endl_e expr
    | '+' expr %prec UNPLUS
    | '-' expr %prec UNMINUS
    | NOT expr
    ;

postfix_expr: primary_expr
            | access_expr
            ;

access_expr: postfix_expr call_args
           | postfix_expr '.' endl_e ID
           | postfix_expr '.' endl_e kw
           ;

primary_expr: literal
            | ID
            | ME
            | primitive_type
            | '(' endl_e expr endl_e ')'
            | cast_operator '(' endl_e expr endl_e ')'
            | CTYPE '(' endl_e expr ',' endl_e type endl_e ')'
            | IF '(' endl_e expr ',' endl_e expr endl_e ')'
            | IF '(' endl_e expr ',' endl_e expr ',' endl_e expr endl_e ')'
            | base_member_access
            | new_expr
            ;

literal: INT_LIT | FLOAT_LIT | STR_LIT | CHAR_LIT | BOOL_LIT | NOTHING
       ;

base_member_access: MYBASE '.' endl_e ID
                  | MYBASE '.' endl_e kw
                  | MYCLASS '.' endl_e ID
                  | MYCLASS '.' endl_e kw
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

array_modifier: '(' endl_e ')'
              | '(' endl_e expr endl_e ')'
              ;

call_args: '(' endl_e ')'
         | '(' endl_e arg_list endl_e ')'
         ;

arg_list: expr_or_initializer
        | arg_list ',' endl_e expr_or_initializer
        ;

expr_or_initializer: expr
                   | collection_initializer
                   ;

collection_initializer: '{' endl_e expr_list endl_e '}'
                      | '{' endl_e '}'
                      ;

expr_list: expr
         | expr_list ',' endl_e expr
         ;

/* ======================================================================
 *  Simple statements
 * ====================================================================== */

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

assignment_stmt: lvalue '=' endl_e expr_or_initializer
               | lvalue compound_assign_op endl_e expr
               ;

lvalue: ID
      | access_expr
      | base_member_access
      ;

compound_assign_op: ADD_ASSIGN | SUB_ASSIGN | MUL_ASSIGN | DIV_ASSIGN | FLOORDIV_ASSIGN
                  | EXP_ASSIGN | STRCAT_ASSIGN | LSHIFT_ASSIGN | RSHIFT_ASSIGN
                  ;

return_stmt: RETURN
           | RETURN expr_or_initializer
           ;

jump_stmt: CONTINUE DO | CONTINUE FOR | CONTINUE WHILE
         | EXIT DO | EXIT FOR | EXIT WHILE
         | EXIT SELECT
         ;

/* ======================================================================
 *  Statements and blocks
 * ====================================================================== */

stmt: simple_stmt endlc_list
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

block_e: /* empty */
       | block
       ;

/* ======================================================================
 *  If
 * ====================================================================== */

if_stmt: IF expr THEN inline_stmts endl_list
       | IF expr THEN inline_stmts ELSE inline_stmts endl_list
       | IF expr THEN endlc_list block_e else_if_stmts END IF endlc_list
       | IF expr THEN endlc_list block_e else_if_stmts ELSE endlc_list block_e END IF endlc_list
       ;

inline_stmts: simple_stmt
            | inline_stmts ':' simple_stmt
            ;

else_if_stmts: /* empty */
             | else_if_stmts ELSEIF expr THEN endlc_list block_e
             ;

/* ======================================================================
 *  Select Case
 * ====================================================================== */

select_stmt: SELECT expr endlc_list case_stmts END SELECT endlc_list
           | SELECT CASE expr endlc_list case_stmts END SELECT endlc_list
           ;

case_stmts: /* empty */
          | CASE ELSE endlc_list block_e
          | case_condition_branches
          | case_condition_branches CASE ELSE endlc_list block_e
          ;

case_condition_branch: CASE case_clauses endlc_list block_e
                     ;

case_condition_branches: case_condition_branch
                       | case_condition_branches case_condition_branch
                       ;

case_clause: expr
           | expr TO expr
           | comparison_op endl_e expr
           | IS endl_e comparison_op endl_e expr
           ;

case_clauses: case_clause
            | case_clauses ',' endl_e case_clause
            ;

comparison_op: '=' | NEQ | '<' | '>' | LEQ | GEQ
             ;

/* ======================================================================
 *  Loops
 * ====================================================================== */

while_stmt: WHILE expr endlc_list block_e END WHILE endlc_list
          | WHILE expr endlc_list block_e WEND endlc_list
          ;

for_stmt: FOR for_loop_variable '=' endl_e expr TO expr endlc_list block_e NEXT endlc_list
        | FOR for_loop_variable '=' endl_e expr TO expr STEP expr endlc_list block_e NEXT endlc_list
        | FOR EACH for_loop_variable IN endl_e expr_or_initializer endlc_list block_e NEXT endlc_list
        ;

for_loop_variable: ID
                 | ID AS type
                 ;

do_stmt: DO endlc_list block_e LOOP endlc_list
       | DO endlc_list block_e LOOP WHILE expr endlc_list
       | DO endlc_list block_e LOOP UNTIL expr endlc_list
       | DO WHILE expr endlc_list block_e LOOP endlc_list
       | DO UNTIL expr endlc_list block_e LOOP endlc_list
       ;

/* ======================================================================
 *  Variable declarations
 * ====================================================================== */

var_declaration: DIM var_declarator_list endlc_list
               | CONST var_declarator_list endlc_list
               ;

var_declarator_list: var_declarator
                   | var_name
                   | var_names
                   | var_declarator ',' endl_e var_declarator_list
                   ;

var_declarator: var_name AS type '=' endl_e expr_or_initializer
              | var_name AS type
              | var_name AS new_expr
              | var_name '=' endl_e expr_or_initializer
              | var_names AS type
              | var_names AS new_expr
              ;

var_name: ID
        | ID array_modifier
        ;

var_names: var_name ',' endl_e var_name
         | var_names ',' endl_e var_name
         ;

/* ======================================================================
 *  Types
 * ====================================================================== */

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

generic_arguments: '(' endl_e OF endl_e type_list endl_e ')'
                 ;

type_list: simple_type
         | type_list ',' endl_e simple_type
         ;

array_type: ID '(' endl_e ')'
          | primitive_type '(' endl_e ')'
          | generic_type '(' endl_e ')'
          ;

/* ======================================================================
 *  Classes and their members
 * ====================================================================== */

class_declaration: class_modifiers_e CLASS ID type_parameters_e endlc_list
                   inherits_e structure_body_e END CLASS
                 ;

type_parameters_e: /* empty */
                 | type_parameters
                 ;

type_parameters: '(' endl_e OF endl_e id_list endl_e ')'
               ;

id_list: ID
       | id_list ',' endl_e ID
       ;

inherits_e: /* empty */
          | INHERITS ID endlc_list
          ;

structure_body_e: /* empty */
                | structure_body
                ;

structure_body: structure_member
              | structure_body structure_member
              ;

structure_member: function_declaration
                | sub_declaration
                | field_declaration
                ;

access_modifier: PUBLIC
               | PRIVATE
               | PROTECTED
               ;

class_modifiers_e: /* empty */
                 | access_modifier
                 ;

member_modifiers: access_modifier
                | SHARED
                | access_modifier SHARED
                | SHARED access_modifier
                ;

member_modifiers_e: /* empty */
                  | member_modifiers
                  ;

field_declaration: member_modifiers_e DIM shared_e var_declarator_list endlc_list
                 | member_modifiers_e CONST shared_e var_declarator_list endlc_list
                 | member_modifiers var_declarator_list endlc_list
                 ;

shared_e: /* empty */
        | SHARED
        ;

/* ======================================================================
 *  Methods
 * ====================================================================== */

function_declaration: member_modifiers_e function_signature endl_list block_e END FUNCTION endlc_list
                    ;

sub_declaration: member_modifiers_e sub_signature endl_list block_e END SUB endlc_list
               ;

function_signature: FUNCTION ID parameter_clause_e return_type_e
                  ;

sub_signature: SUB ID parameter_clause_e
             ;

return_type_e: /* empty */
             | AS type
             ;

parameter_clause_e: /* empty */
                  | parameter_clause
                  ;

parameter_clause: '(' endl_e ')'
                | '(' endl_e parameter_list endl_e ')'
                ;

parameter_list: parameter
              | parameter_list ',' endl_e parameter
              ;

parameter: param_name AS type
         | param_name
         ;

param_name: ID
          | ID '(' endl_e ')'
          ;

%%
