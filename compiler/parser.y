%define parse.trace
%define parse.error detailed

%code requires { #include "compiler/node_factory.hpp" }

%{
    #include <stdio.h>
    #include <stdarg.h>
    #include <string>

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    ProgramNode* program_root = nullptr;

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

    ExprNode*                   expr;
    StmtNode*                   stmt;
    TypeNode*                   type;
    VariableNode*               variable;
    FieldNode*                  field;
    MethodNode*                 method;
    ClassNode*                  classNode;
    Node*                       member;
    CaseItem*                   caseItem;
    Block*                      block;
    AccessModifier              access;
    DataType                    dataType;
    MemberModifiers             modifiers;
    std::vector<ExprNode*>*     exprList;
    std::vector<VariableNode*>* variableList;
    std::vector<ClassNode*>*    classList;
    std::vector<Node*>*         memberList;
    std::vector<ElseifClause>*  elseifList;
    std::vector<CaseClause>*    caseList;
    std::vector<CaseItem>*      caseItemList;
    int                         arrayRank;
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
%token ME MYBASE MYCLASS NOTHING OPTIONAL AS
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

%type <classList>    members
%type <classNode>    class_declaration
%type <access>       access_modifier
%type <memberList>   class_body class_body_e
%type <member>       class_member
%type <field>        field_declaration
%type <modifiers>    member_modifiers
%type <method>       function_declaration sub_declaration
%type <id>           sub_name id_or_kw
%type <variableList> parameter_list parameter_list_e var_declaration
%type <variable>     parameter var_declarator
%type <block>        block block_e
%type <stmt>         stmt
%type <elseifList>   else_if_stmts
%type <caseList>     case_stmts
%type <caseItemList> case_exprs
%type <caseItem>     case_expr
%type <expr>         expr
%type <exprList>     expr_list expr_list_e
%type <dataType>     cast_operator
%type <type>         type simple_type
%type <arrayRank>    array_rank

%precedence NEW
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

program: ecle members ecle { program_root = create_program($2); }
       ;

members: class_declaration             { $$ = list_of($1); }
       | members ecl class_declaration { $$ = list_add($1, $3); }
       ;

/* Classes */

class_declaration: access_modifier CLASS ID ecl INHERITS ID class_body_e END CLASS { $$ = create_class($1, $3, $6, $7); }
                 | access_modifier CLASS ID class_body_e END CLASS                 { $$ = create_class($1, $3, nullptr, $4); }
                 | CLASS ID ecl INHERITS ID class_body_e END CLASS                 { $$ = create_class(AccessModifier::Public, $2, $5, $6); }
                 | CLASS ID class_body_e END CLASS                                 { $$ = create_class(AccessModifier::Public, $2, nullptr, $3); }
                 ;

access_modifier: PUBLIC    { $$ = AccessModifier::Public; }
               | PRIVATE   { $$ = AccessModifier::Private; }
               | PROTECTED { $$ = AccessModifier::Protected; }
               ;

class_body: class_member ecl            { $$ = list_of($1); }
          | class_body class_member ecl { $$ = list_add($1, $2); }
          ;

class_body_e: ecl            { $$ = list<Node*>(); }
            | ecl class_body { $$ = $2; }
            ;

class_member: field_declaration    { $$ = $1; }
            | function_declaration { $$ = $1; }
            | sub_declaration      { $$ = $1; }
            ;

/* Fields */

field_declaration: member_modifiers DIM SHARED var_declaration { $$ = create_field(VarKind::Dim, $1, true, $4); }
                 | member_modifiers DIM var_declaration        { $$ = create_field(VarKind::Dim, $1, false, $3); }
                 | access_modifier CONST var_declaration       { $$ = create_field(VarKind::Const, modifiers($1, false), false, $3); }
                 | DIM SHARED var_declaration                  { $$ = create_field(VarKind::Dim, modifiers(AccessModifier::Private, false), true, $3); }
                 | DIM var_declaration                         { $$ = create_field(VarKind::Dim, modifiers(AccessModifier::Private, false), false, $2); }
                 | CONST var_declaration                       { $$ = create_field(VarKind::Const, modifiers(AccessModifier::Private, false), false, $2); }
                 | member_modifiers var_declaration            { $$ = create_field(VarKind::Dim, $1, false, $2); }
                 ;

member_modifiers: access_modifier        { $$ = modifiers($1, false); }
                | SHARED                 { $$ = modifiers(AccessModifier::Public, true); }
                | access_modifier SHARED { $$ = modifiers($1, true); }
                | SHARED access_modifier { $$ = modifiers($2, true); }
                ;

/* Methods */

function_declaration: member_modifiers FUNCTION ID '(' parameter_list_e ')' AS type block_e END FUNCTION { $$ = create_function($1, $3, $5, $8, $9); }
                    | member_modifiers FUNCTION ID AS type block_e END FUNCTION                          { $$ = create_function($1, $3, nullptr, $5, $6); }
                    | FUNCTION ID '(' parameter_list_e ')' AS type block_e END FUNCTION                  { $$ = create_function(modifiers(AccessModifier::Public, false), $2, $4, $7, $8); }
                    | FUNCTION ID AS type block_e END FUNCTION                                           { $$ = create_function(modifiers(AccessModifier::Public, false), $2, nullptr, $4, $5); }
                    ;

sub_declaration: member_modifiers SUB sub_name '(' parameter_list_e ')' block_e END SUB { $$ = create_sub($1, $3, $5, $7); }
               | member_modifiers SUB sub_name block_e END SUB                          { $$ = create_sub($1, $3, nullptr, $4); }
               | SUB sub_name '(' parameter_list_e ')' block_e END SUB                  { $$ = create_sub(modifiers(AccessModifier::Public, false), $2, $4, $6); }
               | SUB sub_name block_e END SUB                                           { $$ = create_sub(modifiers(AccessModifier::Public, false), $2, nullptr, $3); }
               ;

sub_name: ID  { $$ = $1; }
        | NEW { $$ = new std::string("New"); }
        ;

parameter_list: parameter                       { $$ = list_of($1); }
              | parameter_list ',' ee parameter { $$ = list_add($1, $4); }
              ;

parameter_list_e: ee                { $$ = list<VariableNode*>(); }
                | parameter_list ee { $$ = $1; }
                ;

parameter: ID AS type                           { $$ = create_variable($1, $3, nullptr); }
         | ID '(' array_rank ')' AS simple_type { $$ = create_array_parameter($1, $6, $3); }
         | OPTIONAL ID AS type '=' ee expr      { $$ = create_optional_parameter($2, $4, $7); }
         ;

/* Statements */

block: stmt ecl       { $$ = list_of($1); }
     | block stmt ecl { $$ = list_add($1, $2); }
     ;

block_e: ecl       { $$ = list<StmtNode*>(); }
       | ecl block { $$ = $2; }
       ;

stmt: expr                                                             { $$ = create_assign_or_call_stmt($1); }
    | CALL expr                                                        { $$ = create_call_stmt($2); }
    | expr "+=" ee expr                                                { $$ = create_assignment($1, create_binary($1, $4, ExprType::AddOp)); }
    | expr "-=" ee expr                                                { $$ = create_assignment($1, create_binary($1, $4, ExprType::SubOp)); }
    | expr "*=" ee expr                                                { $$ = create_assignment($1, create_binary($1, $4, ExprType::MulOp)); }
    | expr "/=" ee expr                                                { $$ = create_assignment($1, create_binary($1, $4, ExprType::DivOp)); }
    | expr "\\=" ee expr                                               { $$ = create_assignment($1, create_binary($1, $4, ExprType::FloorDivOp)); }
    | expr "^=" ee expr                                                { $$ = create_assignment($1, create_binary($1, $4, ExprType::ExpOp)); }
    | expr "&=" ee expr                                                { $$ = create_assignment($1, create_binary($1, $4, ExprType::StrConcatOp)); }
    | RETURN                                                           { $$ = create_return(nullptr); }
    | RETURN expr                                                      { $$ = create_return($2); }
    | CONTINUE DO                                                      { $$ = create_simple_stmt(StmtType::ContinueDo); }
    | CONTINUE FOR                                                     { $$ = create_simple_stmt(StmtType::ContinueFor); }
    | CONTINUE WHILE                                                   { $$ = create_simple_stmt(StmtType::ContinueWhile); }
    | EXIT DO                                                          { $$ = create_simple_stmt(StmtType::ExitDo); }
    | EXIT FOR                                                         { $$ = create_simple_stmt(StmtType::ExitFor); }
    | EXIT WHILE                                                       { $$ = create_simple_stmt(StmtType::ExitWhile); }
    | EXIT SELECT                                                      { $$ = create_simple_stmt(StmtType::ExitSelect); }
    | EXIT FUNCTION                                                    { $$ = create_simple_stmt(StmtType::ExitFunction); }
    | EXIT SUB                                                         { $$ = create_simple_stmt(StmtType::ExitSub); }
    | IF expr THEN block_e else_if_stmts END IF                        { $$ = create_if($2, $4, $5, nullptr); }
    | IF expr THEN block_e else_if_stmts ELSE block_e END IF           { $$ = create_if($2, $4, $5, $7); }
    | SELECT CASE expr ecl case_stmts END SELECT                       { $$ = create_select($3, $5, nullptr); }
    | SELECT CASE expr ecl case_stmts CASE ELSE block_e END SELECT     { $$ = create_select($3, $5, $8); }
    | FOR ID AS simple_type '=' ee expr TO expr STEP expr block_e NEXT { $$ = create_for($2, $4, $7, $9, $11, $12); }
    | FOR ID AS simple_type '=' ee expr TO expr block_e NEXT           { $$ = create_for($2, $4, $7, $9, nullptr, $10); }
    | FOR ID '=' ee expr TO expr STEP expr block_e NEXT                { $$ = create_for($2, nullptr, $5, $7, $9, $10); }
    | FOR ID '=' ee expr TO expr block_e NEXT                          { $$ = create_for($2, nullptr, $5, $7, nullptr, $8); }
    | FOR EACH ID AS simple_type IN ee expr block_e NEXT               { $$ = create_for_each($3, $5, $8, $9); }
    | FOR EACH ID IN ee expr block_e NEXT                              { $$ = create_for_each($3, nullptr, $6, $7); }
    | WHILE expr block_e END WHILE                                     { $$ = create_while($2, $3); }
    | DO block_e LOOP                                                  { $$ = create_do($2, nullptr, false, false); }
    | DO block_e LOOP WHILE expr                                       { $$ = create_do($2, $5, true, false); }
    | DO block_e LOOP UNTIL expr                                       { $$ = create_do($2, $5, true, true); }
    | DO WHILE expr block_e LOOP                                       { $$ = create_do($4, $3, false, false); }
    | DO UNTIL expr block_e LOOP                                       { $$ = create_do($4, $3, false, true); }
    | DIM var_declaration                                              { $$ = create_var_decl(VarKind::Dim, $2); }
    | CONST var_declaration                                            { $$ = create_var_decl(VarKind::Const, $2); }
    ;

/* If */

else_if_stmts: %empty                                 { $$ = list<ElseifClause>(); }
             | else_if_stmts ELSEIF expr THEN block_e { $$ = elseifs_add($1, $3, $5); }
             ;

/* Select Case */

case_stmts: %empty                             { $$ = list<CaseClause>(); }
          | case_stmts CASE case_exprs block_e { $$ = cases_add($1, $3, $4); }
          ;

case_exprs: case_expr                   { $$ = case_items_new($1); }
          | case_exprs ',' ee case_expr { $$ = case_items_add($1, $4); }
          ;

case_expr: expr              { $$ = create_case_value($1); }
         | expr TO expr      { $$ = create_case_range($1, $3); }
         | is_e '=' ee expr  { $$ = create_case_compare(ExprType::EqOp, $4); }
         | is_e "<>" ee expr { $$ = create_case_compare(ExprType::NeqOp, $4); }
         | is_e '<' ee expr  { $$ = create_case_compare(ExprType::LtOp, $4); }
         | is_e '>' ee expr  { $$ = create_case_compare(ExprType::GtOp, $4); }
         | is_e "<=" ee expr { $$ = create_case_compare(ExprType::LteOp, $4); }
         | is_e ">=" ee expr { $$ = create_case_compare(ExprType::GteOp, $4); }
         ;

is_e: %empty
    | IS ee
    ;

/* Variable declarations */

var_declaration: var_declarator                        { $$ = list_of($1); }
               | var_declaration ',' ee var_declarator { $$ = list_add($1, $4); }
               ;

var_declarator: ID '=' ee expr                                    { $$ = create_variable($1, nullptr, $4); }
              | ID AS type                                        { $$ = create_variable($1, $3, nullptr); }
              | ID AS type '=' ee expr                            { $$ = create_variable($1, $3, $6); }
              | ID AS NEW simple_type                             { $$ = create_variable_new($1, $4, nullptr); }
              | ID AS NEW simple_type '(' expr_list_e ')'         { $$ = create_variable_new($1, $4, $6); }
              | ID '(' expr_list_e ')' AS simple_type             { $$ = create_array_variable($1, $6, $3, nullptr); }
              | ID '(' expr_list_e ')' AS simple_type '=' ee expr { $$ = create_array_variable($1, $6, $3, $9); }
              ;

/* Expressions */

expr: ID                                                      { $$ = create_id($1); }
    | INT_LIT                                                 { $$ = create_int($1); }
    | FLOAT_LIT                                               { $$ = create_float($1); }
    | STR_LIT                                                 { $$ = create_string($1); }
    | CHAR_LIT                                                { $$ = create_char($1); }
    | BOOL_LIT                                                { $$ = create_bool($1); }
    | NOTHING                                                 { $$ = create_simple_expr(ExprType::Nothing); }
    | ME                                                      { $$ = create_simple_expr(ExprType::Me); }
    | MYCLASS                                                 { $$ = create_simple_expr(ExprType::MyClass); }
    | MYBASE                                                  { $$ = create_simple_expr(ExprType::MyBase); }
    | INTEGER                                                 { $$ = create_id("integer"); }
    | BOOLEAN                                                 { $$ = create_id("boolean"); }
    | CHAR                                                    { $$ = create_id("char"); }
    | STRING                                                  { $$ = create_id("string"); }
    | SINGLE                                                  { $$ = create_id("single"); }
    | expr '+' ee expr                                        { $$ = create_binary($1, $4, ExprType::AddOp); }
    | expr '-' ee expr                                        { $$ = create_binary($1, $4, ExprType::SubOp); }
    | expr '*' ee expr                                        { $$ = create_binary($1, $4, ExprType::MulOp); }
    | expr '/' ee expr                                        { $$ = create_binary($1, $4, ExprType::DivOp); }
    | expr '\\' ee expr                                       { $$ = create_binary($1, $4, ExprType::FloorDivOp); }
    | expr '^' ee expr                                        { $$ = create_binary($1, $4, ExprType::ExpOp); }
    | expr '&' ee expr                                        { $$ = create_binary($1, $4, ExprType::StrConcatOp); }
    | expr '>' ee expr                                        { $$ = create_binary($1, $4, ExprType::GtOp); }
    | expr '<' ee expr                                        { $$ = create_binary($1, $4, ExprType::LtOp); }
    | expr '=' ee expr                                        { $$ = create_binary($1, $4, ExprType::EqOp); }
    | expr "<>" ee expr                                       { $$ = create_binary($1, $4, ExprType::NeqOp); }
    | expr "<=" ee expr                                       { $$ = create_binary($1, $4, ExprType::LteOp); }
    | expr ">=" ee expr                                       { $$ = create_binary($1, $4, ExprType::GteOp); }
    | expr AND ee expr                                        { $$ = create_binary($1, $4, ExprType::AndOp); }
    | expr AND_ALSO ee expr                                   { $$ = create_binary($1, $4, ExprType::AndAlsoOp); }
    | expr OR ee expr                                         { $$ = create_binary($1, $4, ExprType::OrOp); }
    | expr OR_ELSE ee expr                                    { $$ = create_binary($1, $4, ExprType::OrElseOp); }
    | expr MOD ee expr                                        { $$ = create_binary($1, $4, ExprType::ModOp); }
    | expr IS ee expr                                         { $$ = create_binary($1, $4, ExprType::IsOp); }
    | expr ISNOT ee expr                                      { $$ = create_binary($1, $4, ExprType::IsNotOp); }
    | NOT expr                                                { $$ = create_unary($2, ExprType::NotOp); }
    | '+' expr %prec UNPLUS                                   { $$ = create_unary($2, ExprType::UnaryPlusOp); }
    | '-' expr %prec UNMINUS                                  { $$ = create_unary($2, ExprType::UnaryMinusOp); }
    | '(' ee expr ee ')'                                      { $$ = $3; $$->parenthesized = true; }
    | expr '(' expr_list_e ')'                                { $$ = create_call_or_index($1, $3); }
    | expr '.' ee id_or_kw                                    { $$ = create_member_access($1, $4); }
    | expr '.' ee id_or_kw '(' expr_list_e ')'                { $$ = create_call_or_index(create_member_access($1, $4), $6); }
    | cast_operator '(' ee expr ee ')'                        { $$ = create_cast($4, create_type($1)); }
    | CTYPE '(' ee expr ',' ee type ee ')'                    { $$ = create_cast($4, $7); }
    | IF '(' ee expr ',' ee expr ',' ee expr ee ')'           { $$ = create_if_expr($4, $7, $10); }
    | IF '(' ee expr ',' ee expr ee ')'                       { $$ = create_coalesce($4, $7); }
    | NEW simple_type %prec NEW                               { $$ = create_new($2, nullptr, nullptr); }
    | NEW simple_type '(' expr_list_e ')'                     { $$ = create_new($2, $4, nullptr); }
    | NEW simple_type '(' expr_list_e ')' '{' expr_list_e '}' { $$ = create_new($2, $4, $7); }
    | '{' expr_list_e '}'                                     { $$ = create_collection($2); }
    ;

expr_list: ee expr               { $$ = list_of($2); }
         | expr_list ',' ee expr { $$ = list_add($1, $4); }
         ;

expr_list_e: ee           { $$ = list<ExprNode*>(); }
           | expr_list ee { $$ = $1; }
           ;

cast_operator: CBOOL { $$ = DataType::Boolean; }
             | CINT  { $$ = DataType::Integer; }
             | CCHAR { $$ = DataType::Char; }
             | CSTR  { $$ = DataType::String; }
             | CSNG  { $$ = DataType::Single; }
             ;

/* Types */

type: simple_type                    { $$ = $1; }
    | simple_type '(' array_rank ')' { $$ = create_array_type($1, $3); }
    ;

simple_type: ID      { $$ = create_user_type($1); }
           | INTEGER { $$ = create_type(DataType::Integer); }
           | BOOLEAN { $$ = create_type(DataType::Boolean); }
           | CHAR    { $$ = create_type(DataType::Char); }
           | STRING  { $$ = create_type(DataType::String); }
           | SINGLE  { $$ = create_type(DataType::Single); }
           ;

array_rank: ee                { $$ = 1; }
          | array_rank ',' ee { $$ = $1 + 1; }
          ;

/* Keywords */

id_or_kw: ID        { $$ = $1; }
        | IF        { $$ = new std::string("if"); }
        | THEN      { $$ = new std::string("then"); }
        | ELSE      { $$ = new std::string("else"); }
        | ELSEIF    { $$ = new std::string("elseif"); }
        | END       { $$ = new std::string("end"); }
        | SELECT    { $$ = new std::string("select"); }
        | CASE      { $$ = new std::string("case"); }
        | TO        { $$ = new std::string("to"); }
        | FOR       { $$ = new std::string("for"); }
        | EACH      { $$ = new std::string("each"); }
        | WHILE     { $$ = new std::string("while"); }
        | NEXT      { $$ = new std::string("next"); }
        | IN        { $$ = new std::string("in"); }
        | UNTIL     { $$ = new std::string("until"); }
        | LOOP      { $$ = new std::string("loop"); }
        | DO        { $$ = new std::string("do"); }
        | STEP      { $$ = new std::string("step"); }
        | ME        { $$ = new std::string("me"); }
        | MYBASE    { $$ = new std::string("mybase"); }
        | MYCLASS   { $$ = new std::string("myclass"); }
        | NEW       { $$ = new std::string("new"); }
        | AS        { $$ = new std::string("as"); }
        | OPTIONAL  { $$ = new std::string("optional"); }
        | DIM       { $$ = new std::string("dim"); }
        | CONST     { $$ = new std::string("const"); }
        | FUNCTION  { $$ = new std::string("function"); }
        | SUB       { $$ = new std::string("sub"); }
        | CLASS     { $$ = new std::string("class"); }
        | INHERITS  { $$ = new std::string("inherits"); }
        | CALL      { $$ = new std::string("call"); }
        | CONTINUE  { $$ = new std::string("continue"); }
        | EXIT      { $$ = new std::string("exit"); }
        | RETURN    { $$ = new std::string("return"); }
        | PUBLIC    { $$ = new std::string("public"); }
        | PRIVATE   { $$ = new std::string("private"); }
        | PROTECTED { $$ = new std::string("protected"); }
        | SHARED    { $$ = new std::string("shared"); }
        | INTEGER   { $$ = new std::string("integer"); }
        | BOOLEAN   { $$ = new std::string("boolean"); }
        | CHAR      { $$ = new std::string("char"); }
        | STRING    { $$ = new std::string("string"); }
        | SINGLE    { $$ = new std::string("single"); }
        | IS        { $$ = new std::string("is"); }
        | ISNOT     { $$ = new std::string("isnot"); }
        | NOT       { $$ = new std::string("not"); }
        | AND       { $$ = new std::string("and"); }
        | AND_ALSO  { $$ = new std::string("andalso"); }
        | OR        { $$ = new std::string("or"); }
        | OR_ELSE   { $$ = new std::string("orelse"); }
        | MOD       { $$ = new std::string("mod"); }
        | NOTHING   { $$ = new std::string("nothing"); }
        | CBOOL     { $$ = new std::string("cbool"); }
        | CINT      { $$ = new std::string("cint"); }
        | CCHAR     { $$ = new std::string("cchar"); }
        | CSTR      { $$ = new std::string("cstr"); }
        | CSNG      { $$ = new std::string("csng"); }
        | CTYPE     { $$ = new std::string("ctype"); }
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
