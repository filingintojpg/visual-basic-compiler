%option noyywrap
%option never-interactive
%option yylineno
%option case-insensitive
%option stack

LETTER      [a-zA-Z]
DIGIT       [0-9]
BIN_DIGIT   [0-1]
OCT_DIGIT   [0-7]
HEX_DIGIT   [a-fA-F0-9]

NUMBER      {DIGIT}(\_*{DIGIT})*
EXPONENT    [Ee][+-]?{NUMBER}

ID          ({LETTER}|_[a-zA-Z0-9_])[a-zA-Z0-9_]*

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    #include <string>
    #include <vector>
    #include <algorithm>
    #include "parser.hpp"

    bool DEBUG_LEXER;
    bool DEBUG_LEXER_BY_LINE;
    bool DEBUG_LEXER_EOL;

    int lexerErrors = 0;

    void lexprint(int line, const char *format, ...);
    void lexerror(int line, const char *format, ...);
    std::string toLower(const std::string& str);
    std::string integerDescription(const std::string& lexeme);
    std::string floatDescription(const std::string& lexeme);
    int toInteger(const std::string& lexeme);
    float toFloat(const std::string& lexeme);
    std::string toID(const std::string& lexeme);
%}

%x COMMENT
%x STR
%x ISTR
%s ISTR_EXPR
%s ISTR_BRACE

%%

%{
    std::string commentValue;
    std::string stringValue;

    static int pendingToken = 0;
    if (pendingToken) {
        int returningToken = pendingToken;
        pendingToken = 0;
        return returningToken;
    }
%}

    /* Keywords */

And                { lexprint(yylineno, "KEYWORD And"); return AND; }
AndAlso            { lexprint(yylineno, "KEYWORD AndAlso"); return AND_ALSO; }
As                 { lexprint(yylineno, "KEYWORD As"); return AS; }
Boolean            { lexprint(yylineno, "KEYWORD Boolean"); return BOOLEAN; }
Call               { lexprint(yylineno, "KEYWORD Call"); return CALL; }
Case               { lexprint(yylineno, "KEYWORD Case"); return CASE; }
CBool              { lexprint(yylineno, "KEYWORD CBool"); return CBOOL; }
CChar              { lexprint(yylineno, "KEYWORD CChar"); return CCHAR; }
Char               { lexprint(yylineno, "KEYWORD Char"); return CHAR; }
CInt               { lexprint(yylineno, "KEYWORD CInt"); return CINT; }
Class              { lexprint(yylineno, "KEYWORD Class"); return CLASS; }
Const              { lexprint(yylineno, "KEYWORD Const"); return CONST; }
Continue           { lexprint(yylineno, "KEYWORD Continue"); return CONTINUE; }
CSng               { lexprint(yylineno, "KEYWORD CSng"); return CSNG; }
CStr               { lexprint(yylineno, "KEYWORD CStr"); return CSTR; }
CType              { lexprint(yylineno, "KEYWORD CType"); return CTYPE; }
Dim                { lexprint(yylineno, "KEYWORD Dim"); return DIM; }
Do                 { lexprint(yylineno, "KEYWORD Do"); return DO; }
Each               { lexprint(yylineno, "KEYWORD Each"); return EACH; }
Else               { lexprint(yylineno, "KEYWORD Else"); return ELSE; }
ElseIf             { lexprint(yylineno, "KEYWORD ElseIf"); return ELSEIF; }
End                { lexprint(yylineno, "KEYWORD End"); return END; }
Exit               { lexprint(yylineno, "KEYWORD Exit"); return EXIT; }
False              { lexprint(yylineno, "BOOLEAN False"); yylval.boolLiteral = false; return BOOL_LIT; }
For                { lexprint(yylineno, "KEYWORD For"); return FOR; }
Function           { lexprint(yylineno, "KEYWORD Function"); return FUNCTION; }
If                 { lexprint(yylineno, "KEYWORD If"); return IF; }
In                 { lexprint(yylineno, "KEYWORD In"); return IN; }
Inherits           { lexprint(yylineno, "KEYWORD Inherits"); return INHERITS; }
Integer            { lexprint(yylineno, "KEYWORD Integer"); return INTEGER; }
Is                 { lexprint(yylineno, "KEYWORD Is"); return IS; }
IsNot              { lexprint(yylineno, "KEYWORD IsNot"); return ISNOT; }
Loop               { lexprint(yylineno, "KEYWORD Loop"); return LOOP; }
Me                 { lexprint(yylineno, "KEYWORD Me"); return ME; }
Mod                { lexprint(yylineno, "KEYWORD Mod"); return MOD; }
MyBase             { lexprint(yylineno, "KEYWORD MyBase"); return MYBASE; }
MyClass            { lexprint(yylineno, "KEYWORD MyClass"); return MYCLASS; }
New                { lexprint(yylineno, "KEYWORD New"); return NEW; }
Next               { lexprint(yylineno, "KEYWORD Next"); return NEXT; }
Not                { lexprint(yylineno, "KEYWORD Not"); return NOT; }
Nothing            { lexprint(yylineno, "NOTHING Nothing"); return NOTHING; }
Optional           { lexprint(yylineno, "KEYWORD Optional"); return OPTIONAL; }
Or                 { lexprint(yylineno, "KEYWORD Or"); return OR; }
OrElse             { lexprint(yylineno, "KEYWORD OrElse"); return OR_ELSE; }
Private            { lexprint(yylineno, "KEYWORD Private"); return PRIVATE; }
Protected          { lexprint(yylineno, "KEYWORD Protected"); return PROTECTED; }
Public             { lexprint(yylineno, "KEYWORD Public"); return PUBLIC; }
Return             { lexprint(yylineno, "KEYWORD Return"); return RETURN; }
Select             { lexprint(yylineno, "KEYWORD Select"); return SELECT; }
Shared             { lexprint(yylineno, "KEYWORD Shared"); return SHARED; }
Single             { lexprint(yylineno, "KEYWORD Single"); return SINGLE; }
Step               { lexprint(yylineno, "KEYWORD Step"); return STEP; }
String             { lexprint(yylineno, "KEYWORD String"); return STRING; }
Sub                { lexprint(yylineno, "KEYWORD Sub"); return SUB; }
Then               { lexprint(yylineno, "KEYWORD Then"); return THEN; }
To                 { lexprint(yylineno, "KEYWORD To"); return TO; }
True               { lexprint(yylineno, "BOOLEAN True"); yylval.boolLiteral = true; return BOOL_LIT; }
Until              { lexprint(yylineno, "KEYWORD Until"); return UNTIL; }
While              { lexprint(yylineno, "KEYWORD While"); return WHILE; }

    /* Operators */

\^      { lexprint(yylineno, "OPERATOR ^"); return '^'; }
\*      { lexprint(yylineno, "OPERATOR *"); return '*'; }
\\      { lexprint(yylineno, "OPERATOR \\"); return '\\'; }
\/      { lexprint(yylineno, "OPERATOR /"); return '/'; }
\+      { lexprint(yylineno, "OPERATOR +"); return '+'; }
\-      { lexprint(yylineno, "OPERATOR -"); return '-'; }

\^=     { lexprint(yylineno, "OPERATOR ^="); return EXP_ASSIGN; }
\*=     { lexprint(yylineno, "OPERATOR *="); return MUL_ASSIGN; }
\+=     { lexprint(yylineno, "OPERATOR +="); return ADD_ASSIGN; }
\-=     { lexprint(yylineno, "OPERATOR -="); return SUB_ASSIGN; }

\<=     { lexprint(yylineno, "OPERATOR <="); return LEQ; }
\<      { lexprint(yylineno, "OPERATOR <"); return '<'; }
\>=     { lexprint(yylineno, "OPERATOR >="); return GEQ; }
\>      { lexprint(yylineno, "OPERATOR >"); return '>'; }
\<\>    { lexprint(yylineno, "OPERATOR <>"); return NEQ; }
\=      { lexprint(yylineno, "OPERATOR ="); return '='; }

\&=     { lexprint(yylineno, "OPERATOR &="); return STRCAT_ASSIGN; }
\&      { lexprint(yylineno, "OPERATOR &"); return '&'; }

\\=     { lexprint(yylineno, "OPERATOR \\="); return FLOORDIV_ASSIGN; }
\/=     { lexprint(yylineno, "OPERATOR /="); return DIV_ASSIGN; }

    /* Comments */

\'|REM {
    yy_push_state(COMMENT);
    commentValue.clear();
    commentValue += yytext;
}
<COMMENT>[^\n]+ {
    commentValue += yytext;
}
<COMMENT>\n {
    lexprint(yylineno - 1, "COMMENT %s", commentValue.c_str());
    yy_pop_state();
    return ENDL;
}
<COMMENT><<EOF>> {
    lexprint(yylineno, "COMMENT %s", commentValue.c_str());
    yy_pop_state();
    return ENDL;
}

    /* Literals */

    /* String literals */

\" {
    yy_push_state(STR);
    stringValue.clear();
}
<STR>[^\n"]+ {
    stringValue += yytext;
}
<STR>\"\" {
    stringValue += "\"";
}
<STR>\n {
    lexerror(yylineno - 1, "String literal wasn't closed");
    yy_pop_state();
}
<STR><<EOF>> {
    lexerror(yylineno, "String literal wasn't closed at last line");
    yyterminate();
}
<STR>\"[Cc] {
    yy_pop_state();
    
    if (stringValue.length() == 1) {
        lexprint(yylineno, "LITERAL CHAR %c", stringValue.at(0));
        yylval.charLiteral = stringValue.at(0);
        return CHAR_LIT;
    } else {
        lexerror(yylineno, "Char literal has more than 1 symbol");
    }
}
<STR>\" {
    lexprint(yylineno, "LITERAL STRING \"%s\"", stringValue.c_str());
    yy_pop_state();
    yylval.stringLiteral = new std::string(stringValue);
    return STR_LIT;
}

    /* Interpolated string literals */

\$\" {
    lexprint(yylineno, "ISTRING START");
    yy_push_state(ISTR);
    return '(';
}
<ISTR>[^\n"{}]+ {
    lexprint(yylineno, "ISTRING PART \"%s\"", yytext);
    yylval.stringLiteral = new std::string(yytext);
    pendingToken = '&';
    return STR_LIT;
}
<ISTR>\{\{|\}\}|\"\" {
    lexprint(yylineno, "ISTRING PART \"%c\"", yytext[0]);
    yylval.stringLiteral = new std::string(1, yytext[0]);
    pendingToken = '&';
    return STR_LIT;
}
<ISTR>\{ {
    lexprint(yylineno, "ISTRING CSTR(");
    yy_push_state(ISTR_EXPR);
    pendingToken = '(';
    return CSTR;
}
<ISTR>\} {
    lexerror(yylineno, "Single '}' in interpolated string");
}
<ISTR>\n {
    lexerror(yylineno - 1, "Interpolated string literal wasn't closed");
    yy_pop_state();
    return ')';
}
<ISTR><<EOF>> {
    lexerror(yylineno, "Interpolated string literal wasn't closed at last line");
    yyterminate();
}
<ISTR>\" {
    lexprint(yylineno, "ISTRING END");
    yy_pop_state();
    yylval.stringLiteral = new std::string();
    pendingToken = ')';
    return STR_LIT;
}

<ISTR_EXPR,ISTR_BRACE>\{ {
    lexprint(yylineno, "SEPARATOR {");
    yy_push_state(ISTR_BRACE);
    return '{';
}
<ISTR_BRACE>\} {
    lexprint(yylineno, "SEPARATOR }");
    yy_pop_state();
    return '}';
}
<ISTR_EXPR>\} {
    lexprint(yylineno, "SEPARATOR }");
    yy_pop_state();
    pendingToken = '&';
    return ')';
}

    /* Number literals */

    /* Integer literals */

\_+{NUMBER}\_*I?|\_*{NUMBER}\_+I? {
    lexerror(yylineno, "Invalid underscore character in number literal: %s", yytext);
}

{NUMBER}I? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%d)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    yylval.intLiteral = toInteger(lexeme);
    return INT_LIT;
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*\_+I? {
    lexerror(yylineno, "Invalid underscore character in hex number literal: %s", yytext);
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*I? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%d)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    yylval.intLiteral = toInteger(lexeme);
    return INT_LIT;
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*\_+I? {
    lexerror(yylineno, "Invalid underscore character in oct number literal: %s", yytext);
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*I? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%d)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    yylval.intLiteral = toInteger(lexeme);
    return INT_LIT;
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*\_+I? {
    lexerror(yylineno, "Invalid underscore character in bin number literal: %s", yytext);
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*I? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%d)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    yylval.intLiteral = toInteger(lexeme);
    return INT_LIT;
}

    /* Float literals */

{NUMBER}(\.{NUMBER})?{EXPONENT}|{NUMBER}?\.{NUMBER}{EXPONENT}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%f)", floatDescription(lexeme).c_str(), toFloat(lexeme));
    yylval.floatLiteral = toFloat(lexeme);
    return FLOAT_LIT;
}

({NUMBER}(\.{NUMBER})?{EXPONENT}?|{NUMBER}?\.{NUMBER}{EXPONENT}?)F {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%f)", floatDescription(lexeme).c_str(), toFloat(lexeme));
    yylval.floatLiteral = toFloat(lexeme);
    return FLOAT_LIT;
}

    /* Identifiers */

\[{ID}\] {
    std::string lexeme(yytext);
    std::string id = toID(lexeme);
    lexprint(yylineno, "IDENTIFIER %s (%s)", yytext, id.c_str());
    yylval.id = new std::string(id);
    return ID;
}

{ID} {
    std::string lexeme(yytext);
    std::string id = toID(lexeme);
    lexprint(yylineno, "IDENTIFIER %s (%s)", yytext, id.c_str());
    yylval.id = new std::string(id);
    return ID;
}

    /* Separators */

\(  { lexprint(yylineno, "SEPARATOR ("); return '('; }
\)  { lexprint(yylineno, "SEPARATOR )"); return ')'; }
\{  { lexprint(yylineno, "SEPARATOR {"); return '{'; }
\}  { lexprint(yylineno, "SEPARATOR }"); return '}'; }
\.  { lexprint(yylineno, "SEPARATOR ."); return '.'; }
\,  { lexprint(yylineno, "SEPARATOR ,"); return ','; }
\:  { lexprint(yylineno, "SEPARATOR :"); return ':'; }

    /* Whitespaces */

[\r\t ]+            { }
[\r\t ]+_[\r\t ]*\n { lexprint(yylineno, "LINE CONTINUATION _"); }
\n+                 {
if (DEBUG_LEXER_EOL)
    lexprint(yylineno - 1, "END OF LINE %d", yylineno - 1);
    return ENDL;
}

    /* Other */

.       { lexerror(yylineno, "Unexpected character: %s", yytext); }
<<EOF>> { yyterminate(); }

%%

    /* Functions */

    /* Debugging */

void lexprint(int line, const char *format, ...) {
    if (!DEBUG_LEXER) return;

    static int lastLine = 0;

    if (DEBUG_LEXER_BY_LINE || line != lastLine) {
        printf("\n Line %d: ", line);
        lastLine = line;
    }

    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);

    printf(" ");
}

void lexerror(int line, const char *format, ...) {
    lexerErrors++;

    fprintf(stderr, "\nLEXER ERROR at line %d: ", line);

    va_list args;
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);

    fprintf(stderr, "\n");
}

    /* Generating descriptions while debugging */

std::string toLower(const std::string& str) {
    std::string lowerStr = str;

    std::transform(lowerStr.begin(), lowerStr.end(), lowerStr.begin(),
        [](unsigned char c) { return std::tolower(c); }
    );
    return lowerStr;
}

std::string integerDescription(const std::string& lexeme) {
    std::string message("LITERAL ");
    std::string lowerLexeme = toLower(lexeme);

    if      (lowerLexeme.starts_with("&h")) { message += "HEX "; }
    else if (lowerLexeme.starts_with("&o")) { message += "OCT "; }
    else if (lowerLexeme.starts_with("&b")) { message += "BIN "; }
    else                                    { message += "DEC "; }

    return message + "INTEGER " + lexeme;
}

std::string floatDescription(const std::string& lexeme) {
    return "LITERAL SINGLE " + lexeme;
}

    /* Converting lexemes to values */

int toInteger(const std::string& lexeme) {
    std::string number = lexeme;
    std::string lowerLexeme = toLower(lexeme);
    int base = 10;

    if (lowerLexeme.ends_with("i")) {
        number = number.substr(0, number.length() - 1);
    }

    if      (lowerLexeme.starts_with("&h")) { base = 16; number = number.substr(2); }
    else if (lowerLexeme.starts_with("&o")) { base = 8;  number = number.substr(2); }
    else if (lowerLexeme.starts_with("&b")) { base = 2;  number = number.substr(2); }

    number.erase(std::remove(number.begin(), number.end(), '_'), number.end());

    return std::stoll(number, nullptr, base);
}

float toFloat(const std::string& lexeme) {
    std::string number = lexeme;
    std::string lowerLexeme = toLower(lexeme);

    if (lowerLexeme.ends_with("f")) {
        number.pop_back();
    }

    number.erase(std::remove(number.begin(), number.end(), '_'), number.end());

    return std::stod(number);
}

std::string toID(const std::string& lexeme) {
    std::string id = lexeme;

    if (id.starts_with("[") && id.ends_with("]")) {
        id = id.substr(1, id.length() - 2);
    }

    return toLower(id);
}
