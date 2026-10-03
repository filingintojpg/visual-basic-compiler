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
program: endlc_list_e program_members
       ;

program_members: program_member
               | program_members program_member
               ;

program_member: class_declaration endlc_list_e
              ;

endl_list: ENDL
         | endl_list ENDL
         ;

endlc_list_e: /* empty */
            | endlc_list
            ;

endlc: ENDL
     | ':'
     ;

endlc_list: endlc
          | endlc_list endlc
          ;

endl_e: /* empty */
      | ENDL
      ;

kw: ME
  | IF
  | MYBASE
  | MYCLASS
  | NEW
  | REDIM
  | THEN
  | END
  | ELSE
  | ELSEIF
  | SELECT
  | CASE
  | TO
  | FOR
  | EACH
  | WHILE
  | NEXT
  | IN
  | UNTIL
  | LOOP
  | DO
  | STEP
  | AS
  | CALL
  | GOTO
  | CONTINUE
  | EXIT
  | STOP
  | RETURN
  | BYTE
  | SBYTE
  | USHORT
  | SHORT
  | UINTEGER
  | INTEGER
  | ULONG
  | LONG
  | BOOLEAN
  | DATE
  | CHAR
  | STRING
  | DECIMAL
  | SINGLE
  | DOUBLE
  | OBJECT
  | DIM
  | CONST
  | STATIC
  | OF
  | FUNCTION
  | SUB
  | BYREF
  | BYVAL
  | PARAMARRAY
  | OPTIONAL
  | PUBLIC
  | PRIVATE
  | PROTECTED
  | SHARED
  | CLASS
  | STRUCT
  | INHERITS
  | READONLY
  | ERASE
  | CBOOL
  | CBYTE
  | CSBYTE
  | CUSHORT
  | CSHORT
  | CINT
  | CUINT
  | CLNG
  | CULNG
  | CDATE
  | CCHAR
  | CSTR
  | CDEC
  | CSNG
  | CDBL
  | COBJ
  | CTYPE
  ;

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
    | '+' expr %prec UNPLUS
    | '-' expr %prec UNMINUS
    | NOT expr
    | expr IS endl_e expr
    | expr ISNOT endl_e expr
    ;

postfix_expr: primary_expr
            | suffixed_expr
            ;

suffixed_expr: postfix_expr '(' endl_e expr_list endl_e ')'
             | postfix_expr '(' endl_e ')'
             | postfix_expr '.' endl_e member_access_member
             ;

primary_expr: INT_LIT
            | STR_LIT
            | ID
            | FLOAT_LIT
            | BOOL_LIT
            | CHAR_LIT
            | NOTHING
            | ME
            | BYTE
            | SBYTE
            | USHORT
            | SHORT
            | UINTEGER
            | INTEGER
            | ULONG
            | LONG
            | BOOLEAN
            | DATE
            | CHAR
            | STRING
            | DECIMAL
            | SINGLE
            | DOUBLE
            | OBJECT
            | '(' endl_e expr endl_e ')'
            | cast_target '(' endl_e expr endl_e ')'
            | CTYPE '(' endl_e expr ',' endl_e type_name endl_e ')'
            | IF '(' endl_e expr ',' endl_e expr ',' endl_e expr endl_e ')'
            | IF '(' endl_e expr ',' endl_e expr endl_e ')'
            | MYBASE '.' endl_e member_access_member
            | MYCLASS '.' endl_e member_access_member
            | new_expr
            | collection_initializer
            ;

new_expr: NEW ID %prec NEW
        | NEW ID '(' endl_e ')' %prec NEW
        | NEW ID '(' endl_e expr_list endl_e ')' %prec NEW
        | NEW ID '(' endl_e ')' collection_initializer %prec NEW
        | NEW ID '(' endl_e expr_list endl_e ')' collection_initializer %prec NEW
        | NEW ID '(' endl_e OF endl_e type_list endl_e ')' %prec NEW
        | NEW ID '(' endl_e OF endl_e type_list endl_e ')' '(' endl_e ')' %prec NEW
        | NEW ID '(' endl_e OF endl_e type_list endl_e ')' '(' endl_e expr_list endl_e ')' %prec NEW
        | NEW ID '(' endl_e OF endl_e type_list endl_e ')' '(' endl_e ')' collection_initializer %prec NEW
        | NEW ID '(' endl_e OF endl_e type_list endl_e ')' '(' endl_e expr_list endl_e ')' collection_initializer %prec NEW
        | NEW primitive_type %prec NEW
        | NEW primitive_type '(' endl_e ')' %prec NEW
        | NEW primitive_type '(' endl_e expr_list endl_e ')' %prec NEW
        | NEW primitive_type '(' endl_e ')' collection_initializer %prec NEW
        | NEW primitive_type '(' endl_e expr_list endl_e ')' collection_initializer %prec NEW
        ;

cast_target: CBOOL
           | CBYTE
           | CSBYTE
           | CUSHORT
           | CSHORT
           | CINT
           | CUINT
           | CLNG
           | CULNG
           | CDATE
           | CCHAR
           | CSTR
           | CDEC
           | CSNG
           | CDBL
           | COBJ
           ;

collection_initializer: '{' endl_e expr_list endl_e '}'
                      | '{' endl_e '}'
                      ;

member_access_member: ID
                    | kw
                    ;

expr_list: expr
         | expr_list ',' endl_e expr
         ;

lvalue: ID
      | suffixed_expr
      | MYBASE '.' endl_e member_access_member
      | MYCLASS '.' endl_e member_access_member
      ;

simple_stmt: CALL expr
           | ID
           | suffixed_expr
           | REDIM redim_clause_list
           | REDIM PRESERVE redim_clause_list
           | ERASE expr_list
           | lvalue '=' endl_e expr
           | lvalue ADD_ASSIGN endl_e expr
           | lvalue SUB_ASSIGN endl_e expr
           | lvalue MUL_ASSIGN endl_e expr
           | lvalue DIV_ASSIGN endl_e expr
           | lvalue FLOORDIV_ASSIGN endl_e expr
           | lvalue EXP_ASSIGN endl_e expr
           | lvalue STRCAT_ASSIGN endl_e expr
           | lvalue LSHIFT_ASSIGN endl_e expr
           | lvalue RSHIFT_ASSIGN endl_e expr
           | RETURN
           | RETURN expr
           | CONTINUE DO
           | CONTINUE FOR
           | CONTINUE WHILE
           | EXIT DO
           | EXIT FOR
           | EXIT WHILE
           | EXIT SELECT
           | EXIT SUB
           | EXIT FUNCTION
           ;

stmt: simple_stmt endlc_list
    | if_stmt
    | select_stmt
    | for_stmt
    | DO endlc_list block_e LOOP endlc_list
    | do_while_stmt
    | do_until_stmt
    | while_stmt
    | var_declaration
    ;

inline_stmts: simple_stmt
            | inline_stmts ':' simple_stmt
            | inline_stmts ':'
            ;

redim_clause: postfix_expr '(' endl_e expr_list endl_e ')'
            ;

redim_clause_list: redim_clause
                 | redim_clause_list ',' endl_e redim_clause
                 ;

if_stmt: IF expr THEN inline_stmts endl_list
       | IF expr THEN inline_stmts ELSE inline_stmts endl_list
       | IF expr THEN endlc_list block else_if_stmts ELSE endlc_list block END IF endlc_list
       | IF expr THEN endlc_list else_if_stmts ELSE endlc_list block END IF endlc_list
       | IF expr THEN endlc_list block else_if_stmts ELSE endlc_list END IF endlc_list
       | IF expr THEN endlc_list else_if_stmts ELSE endlc_list END IF endlc_list
       | IF expr THEN endlc_list block else_if_stmts END IF endlc_list
       | IF expr THEN endlc_list else_if_stmts END IF endlc_list
       ;

else_if_stmts: /* empty */
             | else_if_stmts ELSEIF expr THEN endlc_list block
             | else_if_stmts ELSEIF expr THEN endlc_list
             ;

select_stmt: SELECT expr endlc_list case_stmts END SELECT endlc_list
           | SELECT CASE expr endlc_list case_stmts END SELECT endlc_list
           ;

case_condition_branch: CASE case_clauses endlc_list block
                     | CASE case_clauses endlc_list
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

case_condition_branches: case_condition_branch
                       | case_condition_branches case_condition_branch
                       ;

case_else_stmt: CASE ELSE endlc_list block_e
              ;

case_stmts: /* empty */
          | case_condition_branches
          | case_else_stmt
          | case_condition_branches case_else_stmt
          ;

while_stmt: WHILE expr endlc_list block while_end endlc_list
          | WHILE expr endlc_list while_end endlc_list
          ;

while_end: END WHILE
         | WEND
         ;

for_head: FOR for_loop_variable '=' endl_e expr TO expr endlc_list
        | FOR for_loop_variable '=' endl_e expr TO expr STEP expr endlc_list
        | FOR EACH for_loop_variable IN endl_e expr endlc_list
        ;

for_stmt: for_chain endlc_list
        | for_head NEXT endlc_list
        | for_head block NEXT endlc_list
        ;

for_chain: for_head NEXT ID
         | for_head block NEXT ID
         | for_head for_chain ',' endl_e ID
         | for_head block for_chain ',' endl_e ID
         ;

for_loop_variable: ID
                 | ID AS type_name
                 ;

do_while_stmt: DO endlc_list block_e LOOP WHILE expr endlc_list
             | DO WHILE expr endlc_list block_e LOOP endlc_list
             ;

do_until_stmt: DO endlc_list block_e LOOP UNTIL expr endlc_list
             | DO UNTIL expr endlc_list block_e LOOP endlc_list
             ;

block_e: /* empty */
       | block
       ;

block: stmt
     | block stmt
     ;

variable_name: ID
             | ID array_modifier
             ;

array_modifier: '(' endl_e expr endl_e ')'
              | '(' ')'
              ;

var_names: variable_name ',' endl_e variable_name
         | var_names ',' endl_e variable_name
         ;

var_declarator: variable_name AS type_name
              | var_names AS type_name
              | variable_name '=' endl_e expr
              | variable_name AS type_name '=' endl_e expr
              | variable_name AS new_expr
              | var_names AS new_expr
              ;

var_declarator_list: var_declarator
                   | variable_name
                   | var_names
                   | var_declarator ',' endl_e var_declarator_list
                   ;

var_declaration: DIM var_declarator_list endlc_list
               | CONST var_declarator_list endlc_list
               ;

type_name: ID
         | ID '(' endl_e OF endl_e type_list endl_e ')'
         | primitive_type
         | ID '(' endl_e ')'
         | ID '(' endl_e OF endl_e type_list endl_e ')' '(' endl_e ')'
         | primitive_type '(' endl_e ')'
         ;

simple_type_name: ID
                | ID '(' endl_e OF endl_e type_list endl_e ')'
                | primitive_type
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
              | DATE
              | CHAR
              | STRING
              | DECIMAL
              | SINGLE
              | DOUBLE
              | OBJECT
              ;

type_list: simple_type_name
         | type_list ',' endl_e simple_type_name
         ;

id_list: ID
       | id_list ',' endl_e ID
       ;

function_signature: FUNCTION ID '(' endl_e function_parameters endl_e ')' AS type_name
                  | FUNCTION ID '(' endl_e function_parameters endl_e ')'
                  | FUNCTION ID '(' endl_e ')' AS type_name
                  | FUNCTION ID '(' endl_e ')'
                  | FUNCTION ID AS type_name
                  | FUNCTION ID
                  ;

sub_name: ID
        | NEW
        ;

sub_signature: SUB sub_name '(' endl_e function_parameters endl_e ')'
             | SUB sub_name '(' endl_e ')'
             | SUB sub_name
             ;

function_declaration: member_modifiers_e function_signature endl_list block END FUNCTION endlc_list
                    | member_modifiers_e function_signature endl_list END FUNCTION endlc_list
                    ;

sub_declaration: member_modifiers_e sub_signature endl_list block END SUB endlc_list
               | member_modifiers_e sub_signature endl_list END SUB endlc_list
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

function_parameters: function_parameter
                   | function_parameters ',' endl_e function_parameter
                   ;

param_name: ID
          | ID '(' ')'
          ;

function_parameter: param_name AS type_name
                  | param_name
                  ;

class_declaration: class_modifiers_e CLASS ID endlc_list INHERITS ID endlc_list structure_body_e END CLASS
                 | class_modifiers_e CLASS ID endlc_list structure_body_e END CLASS
                 | class_modifiers_e CLASS ID generic_param_list endlc_list INHERITS ID endlc_list structure_body_e END CLASS
                 | class_modifiers_e CLASS ID generic_param_list endlc_list structure_body_e END CLASS
                 ;

generic_param_list: '(' endl_e OF endl_e id_list endl_e ')'
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


field_declaration: member_modifiers_e DIM var_declarator_list endlc_list
                 | member_modifiers_e DIM SHARED var_declarator_list endlc_list
                 | member_modifiers_e CONST var_declarator_list endlc_list
                 | member_modifiers_e CONST SHARED var_declarator_list endlc_list
                 | member_modifiers var_declarator_list endlc_list
                 ;

%%
