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

%precedence NEW
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
program: endlc_list_e program_members { parsprint("endlc_list_e program_members -> program"); }
       ;

program_members: program_member                 { parsprint("program_member -> program_members"); }
               | program_members program_member { parsprint("program_members program_member -> program_members"); }
       ;

program_member: class_declaration endlc_list_e { parsprint("class_declaration endlc_list_e -> program_member"); }
              ;

endl_list: ENDL           { parsprint("ENDL -> endl_list"); }
         | endl_list ENDL { parsprint("endl_list ENDL -> endl_list"); }
         ;

endlc_list_e: /* empty */ { parsprint("empty -> endlc_list_e"); }
            | endlc_list  { parsprint("endlc_list -> endlc_list_e"); }
            ;

endlc: ENDL { parsprint("ENDL -> endlc"); }
     | ':'  { parsprint("':' -> endlc"); }
     ;

endlc_list: endlc            { parsprint("endlc -> endlc_list"); }
          | endlc_list endlc { parsprint("endlc_list endlc -> endlc_list"); }
          ;

endl_e: ENDL        { parsprint("ENDL -> endl_e"); }
      | /* empty */ { parsprint("empty -> endl_e"); }
      ;

kw: ME         { parsprint("ME -> kw"); }
  | IF         { parsprint("IF -> kw"); }
  | MYBASE     { parsprint("MYBASE -> kw"); }
  | MYCLASS    { parsprint("MYCLASS -> kw"); }
  | NEW        { parsprint("NEW -> kw"); }
  | REDIM      { parsprint("REDIM -> kw"); }
  | THEN       { parsprint("THEN -> kw"); }
  | END        { parsprint("END -> kw"); }
  | ELSE       { parsprint("ELSE -> kw"); }
  | ELSEIF     { parsprint("ELSEIF -> kw"); }
  | SELECT     { parsprint("SELECT -> kw"); }
  | CASE       { parsprint("CASE -> kw"); }
  | TO         { parsprint("TO -> kw"); }
  | FOR        { parsprint("FOR -> kw"); }
  | EACH       { parsprint("EACH -> kw"); }
  | WHILE      { parsprint("WHILE -> kw"); }
  | NEXT       { parsprint("NEXT -> kw"); }
  | IN         { parsprint("IN -> kw"); }
  | UNTIL      { parsprint("UNTIL -> kw"); }
  | LOOP       { parsprint("LOOP -> kw"); }
  | DO         { parsprint("DO -> kw"); }
  | STEP       { parsprint("STEP -> kw"); }
  | AS         { parsprint("AS -> kw"); }
  | CALL       { parsprint("CALL -> kw"); }
  | GOTO       { parsprint("GOTO -> kw"); }
  | CONTINUE   { parsprint("CONTINUE -> kw"); }
  | EXIT       { parsprint("EXIT -> kw"); }
  | STOP       { parsprint("STOP -> kw"); }
  | RETURN     { parsprint("RETURN -> kw"); }
  | BYTE       { parsprint("BYTE -> kw"); }
  | SBYTE      { parsprint("SBYTE -> kw"); }
  | USHORT     { parsprint("USHORT -> kw"); }
  | SHORT      { parsprint("SHORT -> kw"); }
  | UINTEGER   { parsprint("UINTEGER -> kw"); }
  | INTEGER    { parsprint("INTEGER -> kw"); }
  | ULONG      { parsprint("ULONG -> kw"); }
  | LONG       { parsprint("LONG -> kw"); }
  | BOOLEAN    { parsprint("BOOLEAN -> kw"); }
  | DATE       { parsprint("DATE -> kw"); }
  | CHAR       { parsprint("CHAR -> kw"); }
  | STRING     { parsprint("STRING -> kw"); }
  | DECIMAL    { parsprint("DECIMAL -> kw"); }
  | SINGLE     { parsprint("SINGLE -> kw"); }
  | DOUBLE     { parsprint("DOUBLE -> kw"); }
  | OBJECT     { parsprint("OBJECT -> kw"); }
  | DIM        { parsprint("DIM -> kw"); }
  | CONST      { parsprint("CONST -> kw"); }
  | STATIC     { parsprint("STATIC -> kw"); }
  | OF         { parsprint("OF -> kw"); }
  | FUNCTION   { parsprint("FUNCTION -> kw"); }
  | SUB        { parsprint("SUB -> kw"); }
  | BYREF      { parsprint("BYREF -> kw"); }
  | BYVAL      { parsprint("BYVAL -> kw"); }
  | PARAMARRAY { parsprint("PARAMARRAY -> kw"); }
  | OPTIONAL   { parsprint("OPTIONAL -> kw"); }
  | PUBLIC     { parsprint("PUBLIC -> kw"); }
  | PRIVATE    { parsprint("PRIVATE -> kw"); }
  | PROTECTED  { parsprint("PROTECTED -> kw"); }
  | SHARED     { parsprint("SHARED -> kw"); }
  | CLASS      { parsprint("CLASS -> kw"); }
  | STRUCT     { parsprint("STRUCT -> kw"); }
  | INHERITS   { parsprint("INHERITS -> kw"); }
  | READONLY   { parsprint("READONLY -> kw"); }
  | ERASE      { parsprint("ERASE -> kw"); }
  | CBOOL      { parsprint("CBOOL -> kw"); }
  | CBYTE      { parsprint("CBYTE -> kw"); }
  | CSBYTE     { parsprint("CSBYTE -> kw"); }
  | CUSHORT    { parsprint("CUSHORT -> kw"); }
  | CSHORT     { parsprint("CSHORT -> kw"); }
  | CINT       { parsprint("CINT -> kw"); }
  | CUINT      { parsprint("CUINT -> kw"); }
  | CLNG       { parsprint("CLNG -> kw"); }
  | CULNG      { parsprint("CULNG -> kw"); }
  | CDATE      { parsprint("CDATE -> kw"); }
  | CCHAR      { parsprint("CCHAR -> kw"); }
  | CSTR       { parsprint("CSTR -> kw"); }
  | CDEC       { parsprint("CDEC -> kw"); }
  | CSNG       { parsprint("CSNG -> kw"); }
  | CDBL       { parsprint("CDBL -> kw"); }
  | COBJ       { parsprint("COBJ -> kw"); }
  | CTYPE      { parsprint("CTYPE -> kw"); }
  ;

expr: postfix_expr              { parsprint("postfix_expr -> expr"); }
    | expr '+' endl_e expr      { parsprint("expr + expr -> expr"); }
    | expr '-' endl_e expr      { parsprint("expr - expr -> expr"); }
    | expr '*' endl_e expr      { parsprint("expr * expr -> expr"); }
    | expr '/' endl_e expr      { parsprint("expr / expr -> expr"); }
    | expr '\\' endl_e expr     { parsprint("expr \\ expr -> expr"); }
    | expr '^' endl_e expr      { parsprint("expr ^ expr -> expr"); }
    | expr '&' endl_e expr      { parsprint("expr & expr -> expr"); }
    | expr '>' endl_e expr      { parsprint("expr > expr -> expr"); }
    | expr '<' endl_e expr      { parsprint("expr < expr -> expr"); }
    | expr '=' endl_e expr      { parsprint("expr = expr -> expr"); }
    | expr NEQ endl_e expr      { parsprint("expr NEQ expr -> expr"); }
    | expr LEQ endl_e expr      { parsprint("expr LEQ expr -> expr"); }
    | expr GEQ endl_e expr      { parsprint("expr GEQ expr -> expr"); }
    | expr AND endl_e expr      { parsprint("expr AND expr -> expr"); }
    | expr AND_ALSO endl_e expr { parsprint("expr AND_ALSO expr -> expr"); }
    | expr OR_ELSE endl_e expr  { parsprint("expr OR_ELSE expr -> expr"); }
    | expr OR endl_e expr       { parsprint("expr OR expr -> expr"); }
    | expr XOR endl_e expr      { parsprint("expr XOR expr -> expr"); }
    | expr MOD endl_e expr      { parsprint("expr MOD expr -> expr"); }
    | expr LSHIFT endl_e expr   { parsprint("expr LSHIFT expr -> expr"); }
    | expr RSHIFT endl_e expr   { parsprint("expr RSHIFT expr -> expr"); }
    | '+' expr %prec UNPLUS     { parsprint("+ expr -> expr"); }
    | '-' expr %prec UNMINUS    { parsprint("- expr -> expr"); }
    | NOT expr                  { parsprint("NOT expr -> expr"); }
    | expr IS endl_e expr       { parsprint("expr IS expr -> expr"); }
    | expr ISNOT endl_e expr    { parsprint("expr ISNOT expr -> expr"); }
    ;

postfix_expr: primary_expr                                 { parsprint("primary_expr -> postfix_expr"); }
            | postfix_expr '(' endl_e expr_list endl_e ')' { parsprint("expr ( expr_list ) -> expr"); }
            | postfix_expr '(' endl_e ')'                  { parsprint("expr () -> expr"); }
            | postfix_expr '.' endl_e member_access_member { parsprint("expr . member_access_member -> expr"); }
            ;

primary_expr: INT_VAL                                                                                                           { parsprint("INT_VAL -> expr"); }
            | STR_VAL                                                                                                           { parsprint("STR_VAL -> expr"); }
            | ID                                                                                                                { parsprint("ID -> expr"); }
            | FLOAT_VAL                                                                                                         { parsprint("FLOAT_VAL -> expr"); }
            | BOOL_VAL                                                                                                          { parsprint("BOOL_VAL -> expr"); }
            | CHAR_VAL                                                                                                          { parsprint("CHAR_VAL -> expr"); }
            | NOTHING_VAL                                                                                                       { parsprint("NOTHING_VAL -> expr"); }
            | ME                                                                                                                { parsprint("ME -> expr"); }
            | BYTE                                                                                                              { parsprint("BYTE -> expr"); }
            | SBYTE                                                                                                             { parsprint("SBYTE -> expr"); }
            | USHORT                                                                                                            { parsprint("USHORT -> expr"); }
            | SHORT                                                                                                             { parsprint("SHORT -> expr"); }
            | UINTEGER                                                                                                          { parsprint("UINTEGER -> expr"); }
            | INTEGER                                                                                                           { parsprint("INTEGER -> expr"); }
            | ULONG                                                                                                             { parsprint("ULONG -> expr"); }
            | LONG                                                                                                              { parsprint("LONG -> expr"); }
            | BOOLEAN                                                                                                           { parsprint("BOOLEAN -> expr"); }
            | DATE                                                                                                              { parsprint("DATE -> expr"); }
            | CHAR                                                                                                              { parsprint("CHAR -> expr"); }
            | STRING                                                                                                            { parsprint("STRING -> expr"); }
            | DECIMAL                                                                                                           { parsprint("DECIMAL -> expr"); }
            | SINGLE                                                                                                            { parsprint("SINGLE -> expr"); }
            | DOUBLE                                                                                                            { parsprint("DOUBLE -> expr"); }
            | OBJECT                                                                                                            { parsprint("OBJECT -> expr"); }
            | '(' endl_e expr endl_e ')'                                                                                        { parsprint("( expr ) -> expr"); }
            | cast_target '(' endl_e expr endl_e ')'                                                                            { parsprint("cast_target ( expr ) -> expr"); }
            | CTYPE '(' endl_e expr ',' endl_e type_name endl_e ')'                                                             { parsprint("CTYPE ( expr , type_name ) -> expr"); }
            | IF '(' endl_e expr ',' endl_e expr ',' endl_e expr endl_e ')'                                                     { parsprint("IF ( expr , expr , expr ) -> expr"); }
            | IF '(' endl_e expr ',' endl_e expr endl_e ')'                                                                     { parsprint("IF ( expr , expr ) -> expr"); }
            | MYBASE '.' endl_e member_access_member                                                                            { parsprint("MYBASE . member_access_member -> expr"); }
            | MYCLASS '.' endl_e member_access_member                                                                           { parsprint("MYCLASS . member_access_member -> expr"); }
            | NEW ID %prec NEW                                                                                                  { parsprint("NEW ID -> expr"); }
            | NEW ID '(' endl_e ')' %prec NEW                                                                                   { parsprint("NEW ID () -> expr"); }
            | NEW ID '(' endl_e expr_list endl_e ')' %prec NEW                                                                  { parsprint("NEW ID ( expr_list ) -> expr"); }
            | NEW ID '(' endl_e ')' collection_initializer %prec NEW                                                            { parsprint("NEW ID () collection_initializer -> expr"); }
            | NEW ID '(' endl_e expr_list endl_e ')' collection_initializer %prec NEW                                           { parsprint("NEW ID ( expr_list ) collection_initializer -> expr"); }
            | NEW ID '(' endl_e OF endl_e type_list endl_e ')' %prec NEW                                                        { parsprint("NEW ID ( OF type_list ) -> expr"); }
            | NEW ID '(' endl_e OF endl_e type_list endl_e ')' '(' endl_e ')' %prec NEW                                         { parsprint("NEW ID ( OF type_list ) () -> expr"); }
            | NEW ID '(' endl_e OF endl_e type_list endl_e ')' '(' endl_e expr_list endl_e ')' %prec NEW                        { parsprint("NEW ID ( OF type_list ) ( expr_list ) -> expr"); }
            | NEW ID '(' endl_e OF endl_e type_list endl_e ')' '(' endl_e ')' collection_initializer %prec NEW                  { parsprint("NEW ID ( OF type_list ) () collection_initializer -> expr"); }
            | NEW ID '(' endl_e OF endl_e type_list endl_e ')' '(' endl_e expr_list endl_e ')' collection_initializer %prec NEW { parsprint("NEW ID ( OF type_list ) ( expr_list ) collection_initializer -> expr"); }
            | NEW primitive_type %prec NEW                                                                                      { parsprint("NEW primitive_type -> expr"); }
            | NEW primitive_type '(' endl_e ')' %prec NEW                                                                       { parsprint("NEW primitive_type () -> expr"); }
            | NEW primitive_type '(' endl_e expr_list endl_e ')' %prec NEW                                                      { parsprint("NEW primitive_type ( expr_list ) -> expr"); }
            | NEW primitive_type '(' endl_e ')' collection_initializer %prec NEW                                                { parsprint("NEW primitive_type () collection_initializer -> expr"); }
            | NEW primitive_type '(' endl_e expr_list endl_e ')' collection_initializer %prec NEW                               { parsprint("NEW primitive_type ( expr_list ) collection_initializer -> expr"); }
            | collection_initializer                                                                                            { parsprint("collection_initializer -> expr"); }
            ;

cast_target: CBOOL   { parsprint("CBOOL -> cast_target"); }
           | CBYTE   { parsprint("CBYTE -> cast_target"); }
           | CSBYTE  { parsprint("CSBYTE -> cast_target"); }
           | CUSHORT { parsprint("CUSHORT -> cast_target"); }
           | CSHORT  { parsprint("CSHORT -> cast_target"); }
           | CINT    { parsprint("CINT -> cast_target"); }
           | CUINT   { parsprint("CUINT -> cast_target"); }
           | CLNG    { parsprint("CLNG -> cast_target"); }
           | CULNG   { parsprint("CULNG -> cast_target"); }
           | CDATE   { parsprint("CDATE -> cast_target"); }
           | CCHAR   { parsprint("CCHAR -> cast_target"); }
           | CSTR    { parsprint("CSTR -> cast_target"); }
           | CDEC    { parsprint("CDEC -> cast_target"); }
           | CSNG    { parsprint("CSNG -> cast_target"); }
           | CDBL    { parsprint("CDBL -> cast_target"); }
           | COBJ    { parsprint("COBJ -> cast_target"); }
           ;

collection_initializer: '{' endl_e expr_list endl_e '}' { parsprint("{ expr_list } -> collection_initializer"); }
                      | '{' endl_e '}'                  { parsprint("{ } -> collection_initializer"); }
                      ;

member_access_member: ID { parsprint("ID -> member_access_member"); }
                    | kw { parsprint("kw -> member_access_member"); }
                    ;

expr_list: expr                      { parsprint("expr -> expr_list"); }
         | expr_list ',' endl_e expr { parsprint("expr_list , expr -> expr_list"); }
         ;

simple_stmt: CALL expr                                    { parsprint("CALL expr -> simple_stmt"); }
           | postfix_expr '(' endl_e expr_list endl_e ')' { parsprint("expr ( expr_list ) -> simple_stmt"); }
           | postfix_expr '(' endl_e ')'                  { parsprint("expr () -> simple_stmt"); }
           | REDIM redim_clause_list                      { parsprint("REDIM redim_clause_list -> simple_stmt"); }
           | REDIM PRESERVE redim_clause_list             { parsprint("REDIM PRESERVE redim_clause_list -> simple_stmt"); }
           | ERASE expr_list                              { parsprint("ERASE expr_list -> simple_stmt"); }
           | postfix_expr '=' endl_e expr                 { parsprint("expr = expr -> simple_stmt"); }
           | postfix_expr ADD_ASSIGN endl_e expr          { parsprint("expr += expr -> simple_stmt"); }
           | postfix_expr SUB_ASSIGN endl_e expr          { parsprint("expr -= expr -> simple_stmt"); }
           | postfix_expr MUL_ASSIGN endl_e expr          { parsprint("expr *= expr -> simple_stmt"); }
           | postfix_expr DIV_ASSIGN endl_e expr          { parsprint("expr /= expr -> simple_stmt"); }
           | postfix_expr FLOORDIV_ASSIGN endl_e expr     { parsprint("expr \\= expr -> simple_stmt"); }
           | postfix_expr EXP_ASSIGN endl_e expr          { parsprint("expr ^= expr -> simple_stmt"); }
           | postfix_expr STRCAT_ASSIGN endl_e expr       { parsprint("expr &= expr -> simple_stmt"); }
           | postfix_expr LSHIFT_ASSIGN endl_e expr       { parsprint("expr <<= expr -> simple_stmt"); }
           | postfix_expr RSHIFT_ASSIGN endl_e expr       { parsprint("expr >>= expr -> simple_stmt"); }
           | RETURN                                       { parsprint("RETURN -> simple_stmt"); }
           | RETURN expr                                  { parsprint("RETURN expr -> simple_stmt"); }
           | CONTINUE DO                                  { parsprint("CONTINUE DO -> simple_stmt"); }
           | CONTINUE FOR                                 { parsprint("CONTINUE FOR -> simple_stmt"); }
           | CONTINUE WHILE                               { parsprint("CONTINUE WHILE -> simple_stmt"); }
           | EXIT DO                                      { parsprint("EXIT DO -> simple_stmt"); }
           | EXIT FOR                                     { parsprint("EXIT FOR -> simple_stmt"); }
           | EXIT WHILE                                   { parsprint("EXIT WHILE -> simple_stmt"); }
           | EXIT SELECT                                  { parsprint("EXIT SELECT -> simple_stmt"); }
           ;

stmt: simple_stmt endlc_list                { parsprint("simple_stmt endlc_list -> stmt"); }
    | if_stmt                               { parsprint("if_stmt -> stmt"); }
    | select_stmt                           { parsprint("select_stmt -> stmt"); }
    | for_stmt                              { parsprint("for_stmt -> stmt"); }
    | foreach_stmt                          { parsprint("foreach_stmt -> stmt"); }
    | DO endlc_list block_e LOOP endlc_list { parsprint("DO endlc_list block_e LOOP endlc_list -> stmt"); }
    | do_while_stmt                         { parsprint("do_while_stmt -> stmt"); }
    | do_until_stmt                         { parsprint("do_until_stmt -> stmt"); }
    | while_stmt                            { parsprint("while_stmt -> stmt"); }
    | var_declaration                       { parsprint("var_declaration -> stmt"); }
    ;

inline_stmts: simple_stmt                  { parsprint("simple_stmt -> inline_stmts"); }
            | inline_stmts ':' simple_stmt { parsprint("inline_stmts : simple_stmt -> inline_stmts"); }
            | inline_stmts ':'             { parsprint("inline_stmts : -> inline_stmts"); }
            ;

redim_clause: postfix_expr '(' endl_e expr_list endl_e ')' { parsprint("expr ( expr_list ) -> redim_clause"); }
            ;

redim_clause_list: redim_clause                              { parsprint("redim_clause -> redim_clause_list"); }
                 | redim_clause_list ',' endl_e redim_clause { parsprint("redim_clause_list , redim_clause -> redim_clause_list"); }
                 ;

if_stmt: IF expr THEN inline_stmts endl_list                                                 { parsprint("IF expr THEN inline_stmts -> if_stmt"); }
       | IF expr THEN inline_stmts ELSE inline_stmts endl_list                               { parsprint("IF expr THEN inline_stmts ELSE inline_stmts -> if_stmt"); }
       | IF expr THEN endlc_list block else_if_stmts ELSE endlc_list block END_IF endlc_list { parsprint("IF expr THEN block else_if_stmts ELSE block END_IF -> if_stmt"); }
       | IF expr THEN endlc_list else_if_stmts ELSE endlc_list block END_IF endlc_list       { parsprint("IF expr THEN else_if_stmts ELSE block END_IF -> if_stmt"); }
       | IF expr THEN endlc_list block else_if_stmts ELSE endlc_list END_IF endlc_list       { parsprint("IF expr THEN block else_if_stmts ELSE END_IF -> if_stmt"); }
       | IF expr THEN endlc_list else_if_stmts ELSE endlc_list END_IF endlc_list             { parsprint("IF expr THEN else_if_stmts ELSE END_IF -> if_stmt"); }
       | IF expr THEN endlc_list block else_if_stmts END_IF endlc_list                       { parsprint("IF expr THEN block else_if_stmts END_IF -> if_stmt"); }
       | IF expr THEN endlc_list else_if_stmts END_IF endlc_list                             { parsprint("IF expr THEN else_if_stmts END_IF -> if_stmt"); }
       ;

else_if_stmts: /* empty */                                     { parsprint("empty -> else_if_stmts"); }
             | else_if_stmts ELSEIF expr THEN endlc_list block { parsprint("else_if_stmts ELSEIF expr THEN block -> else_if_stmts"); }
             | else_if_stmts ELSEIF expr THEN endlc_list       { parsprint("else_if_stmts ELSEIF expr THEN -> else_if_stmts"); }
             ;

select_stmt: SELECT expr endlc_list case_stmts END_SELECT endlc_list      { parsprint("SELECT expr case_stmts END_SELECT -> select_stmt"); }
           | SELECT CASE expr endlc_list case_stmts END_SELECT endlc_list { parsprint("SELECT CASE expr case_stmts END_SELECT -> select_stmt"); }
           ;

case_condition_branch: CASE expr endlc_list block         { parsprint("CASE expr block -> case_condition_branch"); }
                     | CASE expr endlc_list               { parsprint("CASE expr -> case_condition_branch"); }
                     | CASE expr TO expr endlc_list block { parsprint("CASE expr TO expr block -> case_condition_branch"); }
                     | CASE expr TO expr endlc_list       { parsprint("CASE expr TO expr -> case_condition_branch"); }
                     ;

case_condition_branches: case_condition_branch                         { parsprint("case_condition_branch -> case_condition_branches"); }
                       | case_condition_branches case_condition_branch { parsprint("case_condition_branches case_condition_branch -> case_condition_branches"); }
                       ;

case_else_stmt: CASE ELSE endlc_list block_e { parsprint("CASE ELSE block_e -> case_else_stmt"); }
              ;

case_stmts: case_condition_branches                { parsprint("case_condition_branches -> case_stmts"); }
          | case_else_stmt                         { parsprint("case_else_stmt -> case_stmts"); }
          | case_condition_branches case_else_stmt { parsprint("case_condition_branches case_else_stmt -> case_stmts"); }
          | /* empty */                            { parsprint("empty -> case_stmts"); }
          ;

while_stmt: WHILE expr endlc_list block END_WHILE endlc_list { parsprint("WHILE expr block END_WHILE -> while_stmt"); }
          | WHILE expr endlc_list END_WHILE endlc_list       { parsprint("WHILE expr END_WHILE -> while_stmt"); }
          ;

for_stmt: FOR for_loop_variable '=' endl_e expr TO expr endlc_list block NEXT endlc_list           { parsprint("FOR var = expr TO expr block NEXT -> for_stmt"); }
        | FOR for_loop_variable '=' endl_e expr TO expr endlc_list NEXT endlc_list                 { parsprint("FOR var = expr TO expr NEXT -> for_stmt"); }
        | FOR for_loop_variable '=' endl_e expr TO expr STEP expr endlc_list block NEXT endlc_list { parsprint("FOR var = expr TO expr STEP expr block NEXT -> for_stmt"); }
        | FOR for_loop_variable '=' endl_e expr TO expr STEP expr endlc_list NEXT endlc_list       { parsprint("FOR var = expr TO expr STEP expr NEXT -> for_stmt"); }
        ;

for_loop_variable: ID              { parsprint("ID -> for_loop_variable"); }
                 | ID AS type_name { parsprint("ID AS type_name -> for_loop_variable"); }
                 ;

foreach_stmt: FOR EACH for_loop_variable IN endl_e expr endlc_list block_e NEXT endlc_list { parsprint("FOR EACH var IN expr block_e NEXT -> foreach_stmt"); }
            ;

do_while_stmt: DO endlc_list block_e LOOP WHILE expr endlc_list { parsprint("DO block_e LOOP WHILE expr -> do_while_stmt"); }
             | DO WHILE expr endlc_list block_e LOOP endlc_list { parsprint("DO WHILE expr block_e LOOP -> do_while_stmt"); }
             ;

do_until_stmt: DO endlc_list block_e LOOP UNTIL expr endlc_list { parsprint("DO block_e LOOP UNTIL expr -> do_until_stmt"); }
             | DO UNTIL expr endlc_list block_e LOOP endlc_list { parsprint("DO UNTIL expr block_e LOOP -> do_until_stmt"); }
             ;

block_e: /* empty */ { parsprint("empty -> block_e"); }
       | block       { parsprint("block -> block_e"); }
       ;

block: stmt       { parsprint("stmt -> block"); }
     | block stmt { parsprint("block stmt -> block"); }
     ;

variable_name: ID                { parsprint("ID -> variable_name"); }
             | ID array_modifier { parsprint("ID array_modifier -> variable_name"); }
             ;

array_modifier: '(' endl_e expr endl_e ')' { parsprint("( expr ) -> array_modifier"); }
              | '(' ')'                    { parsprint("() -> array_modifier"); }
              ;

var_declarator: variable_name                              { parsprint("variable_name -> var_declarator"); }
              | variable_name AS type_name                 { parsprint("variable_name AS type_name -> var_declarator"); }
              | variable_name '=' endl_e expr              { parsprint("variable_name = expr -> var_declarator"); }
              | variable_name AS type_name '=' endl_e expr { parsprint("variable_name AS type_name = expr -> var_declarator"); }
              ;

var_declaration: DIM var_declarator endlc_list   { parsprint("DIM var_declarator endlc_list -> var_declaration"); }
               | CONST var_declarator endlc_list { parsprint("CONST var_declarator endlc_list -> var_declaration"); }
               ;

type_name: ID                                                          { parsprint("ID -> type_name"); }
         | ID '(' endl_e OF endl_e type_list endl_e ')'                { parsprint("ID ( OF type_list ) -> type_name"); }
         | primitive_type                                              { parsprint("primitive_type -> type_name"); }
         | ID '(' endl_e ')'                                           { parsprint("ID () -> type_name"); }
         | ID '(' endl_e OF endl_e type_list endl_e ')' '(' endl_e ')' { parsprint("ID ( OF type_list ) () -> type_name"); }
         | primitive_type '(' endl_e ')'                               { parsprint("primitive_type () -> type_name"); }
         ;

simple_type_name: ID                                           { parsprint("ID -> simple_type_name"); }
                | ID '(' endl_e OF endl_e type_list endl_e ')' { parsprint("ID ( OF type_list ) -> simple_type_name"); }
                | primitive_type                               { parsprint("primitive_type -> simple_type_name"); }
                ;

primitive_type: BYTE     { parsprint("BYTE -> primitive_type"); }
              | SBYTE    { parsprint("SBYTE -> primitive_type"); }
              | USHORT   { parsprint("USHORT -> primitive_type"); }
              | SHORT    { parsprint("SHORT -> primitive_type"); }
              | UINTEGER { parsprint("UINTEGER -> primitive_type"); }
              | INTEGER  { parsprint("INTEGER -> primitive_type"); }
              | ULONG    { parsprint("ULONG -> primitive_type"); }
              | LONG     { parsprint("LONG -> primitive_type"); }
              | BOOLEAN  { parsprint("BOOLEAN -> primitive_type"); }
              | DATE     { parsprint("DATE -> primitive_type"); }
              | CHAR     { parsprint("CHAR -> primitive_type"); }
              | STRING   { parsprint("STRING -> primitive_type"); }
              | DECIMAL  { parsprint("DECIMAL -> primitive_type"); }
              | SINGLE   { parsprint("SINGLE -> primitive_type"); }
              | DOUBLE   { parsprint("DOUBLE -> primitive_type"); }
              | OBJECT   { parsprint("OBJECT -> primitive_type"); }
              ;

type_list: simple_type_name                      { parsprint("simple_type_name -> type_list"); }
         | type_list ',' endl_e simple_type_name { parsprint("type_list , simple_type_name -> type_list"); }
         ;

id_list: ID                    { parsprint("ID -> id_list"); }
       | id_list ',' endl_e ID { parsprint("id_list , ID -> id_list"); }
       ;

function_signature: FUNCTION ID '(' endl_e function_parameters endl_e ')' AS type_name { parsprint("FUNCTION ID ( params ) AS type_name -> function_signature"); }
                  | FUNCTION ID '(' endl_e function_parameters endl_e ')'              { parsprint("FUNCTION ID ( params ) -> function_signature"); }
                  | FUNCTION ID '(' endl_e ')' AS type_name                            { parsprint("FUNCTION ID () AS type_name -> function_signature"); }
                  | FUNCTION ID '(' endl_e ')'                                         { parsprint("FUNCTION ID () -> function_signature"); }
                  | FUNCTION ID AS type_name                                           { parsprint("FUNCTION ID AS type_name -> function_signature"); }
                  | FUNCTION ID                                                        { parsprint("FUNCTION ID -> function_signature"); }
                  ;

sub_signature: SUB ID '(' endl_e function_parameters endl_e ')' { parsprint("SUB ID ( params ) -> sub_signature"); }
             | SUB ID '(' endl_e ')'                            { parsprint("SUB ID () -> sub_signature"); }
             | SUB ID                                           { parsprint("SUB ID -> sub_signature"); }
             ;

function_declaration: procedure_modifiers_e function_signature endl_list block END_FUNCTION endlc_list { parsprint("procedure_modifiers_e function_signature block END_FUNCTION -> function_declaration"); }
                    | procedure_modifiers_e function_signature endl_list END_FUNCTION endlc_list { parsprint("procedure_modifiers_e function_signature END_FUNCTION -> function_declaration"); }
                    ;

sub_declaration: procedure_modifiers_e sub_signature endl_list block END_SUB endlc_list { parsprint("procedure_modifiers_e sub_signature block END_SUB -> sub_declaration"); }
               | procedure_modifiers_e sub_signature endl_list END_SUB endlc_list       { parsprint("procedure_modifiers_e sub_signature END_SUB -> sub_declaration"); }
               ;

procedure_modifiers_e: SHARED      { parsprint("SHARED -> procedure_modifiers_e"); }
                     | /* empty */ { parsprint("empty -> procedure_modifiers_e"); }
                     ;

function_parameters: function_parameter                                { parsprint("function_parameter -> function_parameters"); }
                   | function_parameters ',' endl_e function_parameter { parsprint("function_parameters , function_parameter -> function_parameters"); }
                   ;

function_parameter: variable_name AS type_name { parsprint("variable_name AS type_name -> function_parameter"); }
                  | variable_name              { parsprint("variable_name -> function_parameter"); }
                  ;

class_declaration: CLASS ID endlc_list INHERITS ID endlc_list structure_body_e END_CLASS { parsprint("CLASS ID INHERITS ID structure_body_e END_CLASS -> class_declaration"); }
                 | CLASS ID endlc_list structure_body_e END_CLASS                        { parsprint("CLASS ID structure_body_e END_CLASS -> class_declaration"); }
                 | CLASS ID generic_param_list endlc_list INHERITS ID endlc_list structure_body_e END_CLASS { parsprint("CLASS ID generic_param_list INHERITS ID structure_body_e END_CLASS -> class_declaration"); }
                 | CLASS ID generic_param_list endlc_list structure_body_e END_CLASS { parsprint("CLASS ID generic_param_list structure_body_e END_CLASS -> class_declaration"); }
                 ;

generic_param_list: '(' endl_e OF endl_e id_list endl_e ')' { parsprint("( OF id_list ) -> generic_param_list"); }
                  ;

structure_body_e: /* empty */    { parsprint("empty -> structure_body_e"); }
                | structure_body { parsprint("structure_body -> structure_body_e"); }
                ;

structure_body: structure_member                { parsprint("structure_member -> structure_body"); }
              | structure_body structure_member { parsprint("structure_body structure_member -> structure_body"); }
              ;

structure_member: function_declaration { parsprint("function_declaration -> structure_member"); }
                | sub_declaration      { parsprint("sub_declaration -> structure_member"); }
                | field_declaration    { parsprint("field_declaration -> structure_member"); }
                ;

field_declaration: SHARED DIM var_declarator endlc_list   { parsprint("SHARED DIM var_declarator -> field_declaration"); }
                 | DIM SHARED var_declarator endlc_list   { parsprint("DIM SHARED var_declarator -> field_declaration"); }
                 | DIM var_declarator endlc_list          { parsprint("DIM var_declarator -> field_declaration"); }
                 | SHARED CONST var_declarator endlc_list { parsprint("SHARED CONST var_declarator -> field_declaration"); }
                 | CONST SHARED var_declarator endlc_list { parsprint("CONST SHARED var_declarator -> field_declaration"); }
                 | CONST var_declarator endlc_list        { parsprint("CONST var_declarator -> field_declaration"); }
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
    fprintf(stderr, "\nPARSER ERROR at line %d: %s - %s\n", yylineno, yytext, s);
}
