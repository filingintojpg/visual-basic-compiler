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
%token END_CLASS
%token END_ENUM
%token END_FUNCTION
%token END_GET
%token END_IF
%token END_INTERFACE
%token END_MODULE
%token END_NAMESPACE
%token END_PROPERTY
%token END_SELECT
%token END_SET
%token END_STRUCTURE
%token END_SUB
%token END_SYNC_LOCK
%token END_TRY
%token END_WHILE
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
%token NEW
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

%token ID

%token INT_VAL
%token FLOAT_VAL
%token STR_VAL
%token CHAR_VAL
%token BOOL_VAL
%token NOTHING_VAL

%token ISTR_START
%token ISTR_PART
%token ISTR_END
%token ISTR_EXPR_START
%token ISTR_EXPR_END

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

%left  XOR
%left  OR OR_ELSE
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
