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

%token ADD_HANDLER
%token ADDRESS_OF
%token ALIAS
%token AS
%token ASSEMBLY
%token BOOLEAN
%token BY
%token BYREF
%token BYTE
%token BYVAL
%token CALL
%token CASE
%token CATCH
%token CBOOL
%token CBYTE
%token CCHAR
%token CDATE
%token CDBL
%token CDEC
%token CHAR
%token CINT
%token CLASS
%token CLNG
%token COBJ
%token CONST
%token CONTINUE
%token CSBYTE
%token CSHORT
%token CSNG
%token CSTR
%token CTYPE
%token CUINT
%token CULNG
%token CUSHORT
%token DATE
%token DECIMAL
%token DECLARE
%token DEFAULT
%token DELEGATE
%token DIM
%token DIRECT_CAST
%token DO
%token DOUBLE
%token EACH
%token ELSE
%token ELSEIF
%token END
%token ENUM
%token ERASE
%token ERROR
%token EVENT
%token EXIT
%token FINALLY
%token FOR
%token FRIEND
%token FUNCTION
%token GET
%token GET_TYPE
%token GET_XML_NAMESPACE
%token GLOBAL
%token GO_SUB
%token GOTO
%token GROUP
%token HANDLES
%token IF
%token IMPLEMENTS
%token IMPORTS
%token IN
%token INHERITS
%token INTEGER
%token INTERFACE
%token INTO
%token ITERATOR
%token JOIN
%token LIB
%token LONG
%token LOOP
%token ME
%token MID
%token MODULE
%token MUST_INHERIT
%token MUST_OVERRIDE
%token MYBASE
%token MYCLASS
%token NAME_OF
%token NAMESPACE
%token NARROWING
%token NEXT
%token NOTHING
%token NOT_INHERITABLE
%token NOT_OVERRIDABLE
%token OBJECT
%token OF
%token ON
%token OPERATOR
%token OPTION
%token OPTIONAL
%token ORDER
%token OUT
%token OVERLOADS
%token OVERRIDABLE
%token OVERRIDES
%token PARAMARRAY
%token PARTIAL
%token PRESERVE
%token PRIVATE
%token PROPERTY
%token PROTECTED
%token PUBLIC
%token RAISE_EVENT
%token READONLY
%token REDIM
%token REMOVE_HANDLER
%token RESUME
%token RETURN
%token SBYTE
%token SELECT
%token SET
%token SHADOWS
%token SHARED
%token SHORT
%token SINGLE
%token SKIP
%token STATIC
%token STEP
%token STOP
%token STRING
%token STRUCT
%token SUB
%token SYNC_LOCK
%token TAKE
%token THEN
%token THROW
%token TO
%token TRY
%token TRY_CAST
%token TYPE_OF
%token UINTEGER
%token ULONG
%token UNTIL
%token USHORT
%token USING
%token VARIANT
%token WEND
%token WHEN
%token WHILE
%token WIDENING
%token WITH
%token WITH_EVENTS
%token WRITE_ONLY

%token <id>            ID
%token <intLiteral>    INT_LIT
%token <floatLiteral>  FLOAT_LIT
%token <stringLiteral> STR_LIT
%token <charLiteral>   CHAR_LIT
%token <boolLiteral>   BOOL_LIT

%token ADD_ASSIGN
%token SUB_ASSIGN
%token MUL_ASSIGN
%token DIV_ASSIGN
%token FLOORDIV_ASSIGN
%token EXP_ASSIGN
%token STRCAT_ASSIGN
%token LSHIFT_ASSIGN
%token RSHIFT_ASSIGN
%token ENDL

%precedence NEW
%left  OR OR_ELSE XOR
%left  AND AND_ALSO
%right NOT
%left  '=' NEQ LEQ GEQ '<' '>' IS ISNOT LIKE
%left  LSHIFT RSHIFT
%left  '&'
%left  '+' '-'
%left  MOD
%left  '\\'
%left  '/' '*'
%right UNMINUS UNPLUS
%left  '^'
%left  '.'
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

empty_parens: '(' endl_e ')'
            ;


/* ======================================================================
 *  Keywords allowed as a member name after '.'
 * ====================================================================== */

member_access_member: ID
                    | kw
                    ;

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
           | postfix_expr '.' endl_e member_access_member
           ;

call_args: empty_parens
         | '(' endl_e arg_list endl_e ')'
         ;

primary_expr: literal
            | ID
            | ME
            | primitive_type
            | '(' endl_e expr endl_e ')'
            | cast_operator '(' endl_e expr endl_e ')'
            | CTYPE '(' endl_e expr ',' endl_e type_name endl_e ')'
            | conditional_expr
            | base_member_access
            | new_expr
            ;

literal: INT_LIT
       | FLOAT_LIT
       | STR_LIT
       | CHAR_LIT
       | BOOL_LIT
       | NOTHING
       ;

conditional_expr: IF '(' endl_e expr ',' endl_e expr ',' endl_e expr endl_e ')'
                | IF '(' endl_e expr ',' endl_e expr endl_e ')'
                ;

base_member_access: base_kw '.' endl_e member_access_member
                  ;

base_kw: MYBASE
       | MYCLASS
       ;

cast_operator: CBOOL
             | CBYTE
             | CSBYTE
             | CUSHORT
             | CSHORT
             | CINT
             | CUINT
             | CLNG
             | CULNG
             | CCHAR
             | CSTR
             | CDEC
             | CSNG
             | CDBL
             | COBJ
             ;

new_expr: NEW ID                                                     %prec NEW
        | NEW ID call_args                                           %prec NEW
        | NEW ID call_args collection_initializer                    %prec NEW
        | NEW ID type_arguments                                      %prec NEW
        | NEW ID type_arguments call_args                            %prec NEW
        | NEW ID type_arguments call_args collection_initializer     %prec NEW
        | NEW primitive_type                                         %prec NEW
        | NEW primitive_type array_modifier                          %prec NEW
        | NEW primitive_type array_modifier collection_initializer   %prec NEW
        ;

array_modifier: empty_parens
              | '(' endl_e expr endl_e ')'
              ;

collection_initializer: '{' endl_e expr_list endl_e '}'
                      | '{' endl_e '}'
                      ;

expr_list: expr
         | expr_list ',' endl_e expr
         ;

expr_or_initializer: expr
                   | collection_initializer
                   ;

arg_list: expr_or_initializer
        | arg_list ',' endl_e expr_or_initializer
        ;


/* ======================================================================
 *  Simple statements
 * ====================================================================== */

simple_stmt: call_stmt
           | assignment_stmt
           | return_stmt
           | loop_jump_stmt
           ;

call_stmt: CALL expr
         | ID
         | access_expr
         ;

assignment_stmt: lvalue '=' endl_e expr_or_initializer
               | lvalue compound_assign_op endl_e expr
               ;

lvalue: ID
      | access_expr
      | base_member_access
      ;

compound_assign_op: ADD_ASSIGN
                  | SUB_ASSIGN
                  | MUL_ASSIGN
                  | DIV_ASSIGN
                  | FLOORDIV_ASSIGN
                  | EXP_ASSIGN
                  | STRCAT_ASSIGN
                  | LSHIFT_ASSIGN
                  | RSHIFT_ASSIGN
                  ;

return_stmt: RETURN
           | RETURN expr_or_initializer
           ;

loop_jump_stmt: CONTINUE loop_kind
              | EXIT loop_kind
              | EXIT SELECT
              ;

loop_kind: DO
         | FOR
         | WHILE
         ;


/* ======================================================================
 *  Statements and blocks
 * ====================================================================== */

block: stmt
     | block stmt
     ;

block_e: /* empty */
       | block
       ;

stmt: simple_stmt endlc_list
    | if_stmt
    | select_stmt
    | for_stmt
    | do_stmt
    | while_stmt
    | var_declaration
    ;

inline_stmts: simple_stmt
            | inline_stmts ':' simple_stmt
            | inline_stmts ':'
            ;


/* ======================================================================
 *  If
 * ====================================================================== */

if_stmt: single_line_if
       | block_if
       ;

single_line_if: IF expr THEN inline_stmts endl_list
              | IF expr THEN inline_stmts ELSE inline_stmts endl_list
              ;

block_if: IF expr THEN endlc_list block_e else_if_stmts else_clause_e END IF endlc_list
        ;

else_if_stmts: /* empty */
             | else_if_stmts else_if_clause
             ;

else_if_clause: ELSEIF expr THEN endlc_list block_e
              ;

else_clause_e: /* empty */
             | ELSE endlc_list block_e
             ;


/* ======================================================================
 *  Select Case
 * ====================================================================== */

select_stmt: select_subject endlc_list case_stmts END SELECT endlc_list
           ;

select_subject: SELECT expr
              | SELECT CASE expr
              ;

case_stmts: /* empty */
          | case_condition_branches
          | case_else_stmt
          | case_condition_branches case_else_stmt
          ;

case_condition_branches: case_condition_branch
                       | case_condition_branches case_condition_branch
                       ;

case_condition_branch: CASE case_clauses endlc_list block_e
                     ;

case_else_stmt: CASE ELSE endlc_list block_e
              ;

case_clauses: case_clause
            | case_clauses ',' endl_e case_clause
            ;

case_clause: expr
           | expr TO expr
           | case_comparison_op endl_e expr
           | IS endl_e case_comparison_op endl_e expr
           ;

case_comparison_op: '='
                  | NEQ
                  | '<'
                  | '>'
                  | LEQ
                  | GEQ
                  ;


/* ======================================================================
 *  Loops
 * ====================================================================== */

while_stmt: WHILE expr endlc_list block_e while_end endlc_list
          ;

while_end: END WHILE
         | WEND
         ;

for_stmt: for_header block_e NEXT endlc_list
        ;

for_header: FOR for_loop_variable '=' endl_e expr TO expr step_e endlc_list
          | FOR EACH for_loop_variable IN endl_e expr_or_initializer endlc_list
          ;

step_e: /* empty */
      | STEP expr
      ;

for_loop_variable: ID
                 | ID AS type_name
                 ;

do_stmt: DO endlc_list block_e LOOP endlc_list
       | DO endlc_list block_e LOOP loop_condition expr endlc_list
       | DO loop_condition expr endlc_list block_e LOOP endlc_list
       ;

loop_condition: WHILE
              | UNTIL
              ;


/* ======================================================================
 *  Variable declarations
 * ====================================================================== */

var_declaration: var_decl_kw var_declarator_list endlc_list
               ;

var_decl_kw: DIM
           | CONST
           ;

var_declarator_list: var_declarator
                   | variable_name
                   | var_names
                   | var_declarator ',' endl_e var_declarator_list
                   ;

var_declarator: variable_name AS type_name initializer_e
              | variable_name AS new_expr
              | variable_name initializer
              | var_names AS type_name
              | var_names AS new_expr
              ;

initializer: '=' endl_e expr_or_initializer
           ;

initializer_e: /* empty */
             | initializer
             ;

variable_name: ID
             | ID array_modifier
             ;

var_names: variable_name ',' endl_e variable_name
         | var_names ',' endl_e variable_name
         ;


/* ======================================================================
 *  Types
 * ====================================================================== */

type_name: simple_type_name
         | array_type
         ;

simple_type_name: ID
                | generic_type
                | primitive_type
                ;

generic_type: ID type_arguments
            ;

array_type: ID empty_parens
          | generic_type empty_parens
          | primitive_type empty_parens
          ;

type_arguments: '(' endl_e OF endl_e type_list endl_e ')'
              ;

type_list: simple_type_name
         | type_list ',' endl_e simple_type_name
         ;

primitive_type: BYTE
              | SBYTE
              | USHORT
              | SHORT
              | UINTEGER
              | INTEGER
              | ULONG
              | LONG
              | BOOLEAN
              | CHAR
              | STRING
              | DECIMAL
              | SINGLE
              | DOUBLE
              | OBJECT
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

field_declaration: member_modifiers_e var_decl_kw shared_e var_declarator_list endlc_list
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
             | AS type_name
             ;

parameter_clause_e: /* empty */
                  | parameter_clause
                  ;

parameter_clause: empty_parens
                | '(' endl_e parameter_list endl_e ')'
                ;

parameter_list: parameter
              | parameter_list ',' endl_e parameter
              ;

parameter: param_name AS type_name
         | param_name
         ;

param_name: ID
          | ID empty_parens
          ;

%%
