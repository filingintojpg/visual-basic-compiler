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

INTEGER_SUFFIX          (S|US|I|UI|L|UL)
FLOAT_SUFFIX   ([Ff]|[Dd]|[Rr])

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

    void lexprint(int line, const char *format, ...);
    void lexerror(int line, const char *format, ...);
    std::string toLower(const std::string& str);
    std::string integerDescription(const std::string& lexeme);
    std::string floatDescription(const std::string& lexeme);
    std::string identifierDescription(const std::string& lexeme);
    long long toInteger(const std::string& lexeme);
    double toFloat(const std::string& lexeme);
    std::string toID(const std::string& lexeme);
    bool isUnsignedInteger(const std::string& lexeme);
    IntType typeOfInteger(const std::string& lexeme);
    FloatType typeOfFloat(const std::string& lexeme);
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
    std::string istringValue;
%}

    /* Keywords */

And                { lexprint(yylineno, "KEYWORD And"); return AND; }
AndAlso            { lexprint(yylineno, "KEYWORD AndAlso"); return AND_ALSO; }
As                 { lexprint(yylineno, "KEYWORD As"); return AS; }
Boolean            { lexprint(yylineno, "KEYWORD Boolean"); return BOOLEAN; }
Byte               { lexprint(yylineno, "KEYWORD Byte"); return BYTE; }
Call               { lexprint(yylineno, "KEYWORD Call"); return CALL; }
Case               { lexprint(yylineno, "KEYWORD Case"); return CASE; }
CBool              { lexprint(yylineno, "KEYWORD CBool"); return CBOOL; }
CByte              { lexprint(yylineno, "KEYWORD CByte"); return CBYTE; }
CChar              { lexprint(yylineno, "KEYWORD CChar"); return CCHAR; }
CDbl               { lexprint(yylineno, "KEYWORD CDbl"); return CDBL; }
CDec               { lexprint(yylineno, "KEYWORD CDec"); return CDEC; }
Char               { lexprint(yylineno, "KEYWORD Char"); return CHAR; }
CInt               { lexprint(yylineno, "KEYWORD CInt"); return CINT; }
Class              { lexprint(yylineno, "KEYWORD Class"); return CLASS; }
CLng               { lexprint(yylineno, "KEYWORD CLng"); return CLNG; }
CObj               { lexprint(yylineno, "KEYWORD CObj"); return COBJ; }
Const              { lexprint(yylineno, "KEYWORD Const"); return CONST; }
Continue           { lexprint(yylineno, "KEYWORD Continue"); return CONTINUE; }
CSByte             { lexprint(yylineno, "KEYWORD CSByte"); return CSBYTE; }
CShort             { lexprint(yylineno, "KEYWORD CShort"); return CSHORT; }
CSng               { lexprint(yylineno, "KEYWORD CSng"); return CSNG; }
CStr               { lexprint(yylineno, "KEYWORD CStr"); return CSTR; }
CType              { lexprint(yylineno, "KEYWORD CType"); return CTYPE; }
CUInt              { lexprint(yylineno, "KEYWORD CUInt"); return CUINT; }
CULng              { lexprint(yylineno, "KEYWORD CULng"); return CULNG; }
CUShort            { lexprint(yylineno, "KEYWORD CUShort"); return CUSHORT; }
Decimal            { lexprint(yylineno, "KEYWORD Decimal"); return DECIMAL; }
Dim                { lexprint(yylineno, "KEYWORD Dim"); return DIM; }
Do                 { lexprint(yylineno, "KEYWORD Do"); return DO; }
Double             { lexprint(yylineno, "KEYWORD Double"); return DOUBLE; }
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
Long               { lexprint(yylineno, "KEYWORD Long"); return LONG; }
Loop               { lexprint(yylineno, "KEYWORD Loop"); return LOOP; }
Me                 { lexprint(yylineno, "KEYWORD Me"); return ME; }
Mod                { lexprint(yylineno, "KEYWORD Mod"); return MOD; }
MyBase             { lexprint(yylineno, "KEYWORD MyBase"); return MYBASE; }
MyClass            { lexprint(yylineno, "KEYWORD MyClass"); return MYCLASS; }
New                { lexprint(yylineno, "KEYWORD New"); return NEW; }
Next               { lexprint(yylineno, "KEYWORD Next"); return NEXT; }
Not                { lexprint(yylineno, "KEYWORD Not"); return NOT; }
Nothing            { lexprint(yylineno, "NOTHING Nothing"); return NOTHING; }
Object             { lexprint(yylineno, "KEYWORD Object"); return OBJECT; }
Optional           { lexprint(yylineno, "KEYWORD Optional"); return OPTIONAL; }
Or                 { lexprint(yylineno, "KEYWORD Or"); return OR; }
OrElse             { lexprint(yylineno, "KEYWORD OrElse"); return OR_ELSE; }
Private            { lexprint(yylineno, "KEYWORD Private"); return PRIVATE; }
Protected          { lexprint(yylineno, "KEYWORD Protected"); return PROTECTED; }
Public             { lexprint(yylineno, "KEYWORD Public"); return PUBLIC; }
Return             { lexprint(yylineno, "KEYWORD Return"); return RETURN; }
SByte              { lexprint(yylineno, "KEYWORD SByte"); return SBYTE; }
Select             { lexprint(yylineno, "KEYWORD Select"); return SELECT; }
Shared             { lexprint(yylineno, "KEYWORD Shared"); return SHARED; }
Short              { lexprint(yylineno, "KEYWORD Short"); return SHORT; }
Single             { lexprint(yylineno, "KEYWORD Single"); return SINGLE; }
Step               { lexprint(yylineno, "KEYWORD Step"); return STEP; }
String             { lexprint(yylineno, "KEYWORD String"); return STRING; }
Sub                { lexprint(yylineno, "KEYWORD Sub"); return SUB; }
Then               { lexprint(yylineno, "KEYWORD Then"); return THEN; }
To                 { lexprint(yylineno, "KEYWORD To"); return TO; }
True               { lexprint(yylineno, "BOOLEAN True"); yylval.boolLiteral = true; return BOOL_LIT; }
UInteger           { lexprint(yylineno, "KEYWORD UInteger"); return UINTEGER; }
ULong              { lexprint(yylineno, "KEYWORD ULong"); return ULONG; }
UShort             { lexprint(yylineno, "KEYWORD UShort"); return USHORT; }
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
    yy_push_state(ISTR);
    istringValue.clear();
    lexprint(yylineno, "ISTRING START");
    return ISTR_START;
}
<ISTR>[^\n"{}]+ {
    istringValue += yytext;
}
<ISTR>\{\{ {
    istringValue += "{";
}
<ISTR>\}\} {
    istringValue += "}";
}
<ISTR>\"\" {
    istringValue += "\"";
}
<ISTR>\{ {
    if (!istringValue.empty()) {
        lexprint(yylineno, "ISTRING PART \"%s\"", istringValue.c_str());
        istringValue.clear();
        yyless(0);
        return ISTR_PART;
    }
    yy_push_state(ISTR_EXPR);
    return ISTR_EXPR_START;
}
<ISTR>\} {
    lexerror(yylineno, "Single '}' in interpolated string");
}
<ISTR>\n {
    lexerror(yylineno - 1, "Interpolated string literal wasn't closed");
    yy_pop_state();
    return ISTR_END;
}
<ISTR><<EOF>> {
    lexerror(yylineno, "Interpolated string literal wasn't closed at last line");
    yyterminate();
}
<ISTR>\" {
    if (!istringValue.empty()) {
        lexprint(yylineno, "ISTRING PART \"%s\"", istringValue.c_str());
        istringValue.clear();
        yyless(0);
        return ISTR_PART;
    }
    lexprint(yylineno, "ISTRING END");
    yy_pop_state();
    return ISTR_END;
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
    return ISTR_EXPR_END;
}

    /* Number literals */

    /* Integer literals */

\_+{NUMBER}\_*{INTEGER_SUFFIX}?|\_*{NUMBER}\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in number literal: %s", yytext);
}

{NUMBER}{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    yylval.intLiteral = new IntLiteral(toInteger(lexeme), typeOfInteger(lexeme), isUnsignedInteger(lexeme));
    return INT_LIT;
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in hex number literal: %s", yytext);
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    yylval.intLiteral = new IntLiteral(toInteger(lexeme), typeOfInteger(lexeme), isUnsignedInteger(lexeme));
    return INT_LIT;
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in oct number literal: %s", yytext);
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    yylval.intLiteral = new IntLiteral(toInteger(lexeme), typeOfInteger(lexeme), isUnsignedInteger(lexeme));
    return INT_LIT;
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in bin number literal: %s", yytext);
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    yylval.intLiteral = new IntLiteral(toInteger(lexeme), typeOfInteger(lexeme), isUnsignedInteger(lexeme));
    return INT_LIT;
}

    /* Float literals */

{NUMBER}(\.{NUMBER})?{EXPONENT}|{NUMBER}?\.{NUMBER}{EXPONENT}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%g)", floatDescription(lexeme).c_str(), toFloat(lexeme));
    yylval.floatLiteral = new FloatLiteral(toFloat(lexeme), typeOfFloat(lexeme));
    return FLOAT_LIT;
}

({NUMBER}(\.{NUMBER})?{EXPONENT}?|{NUMBER}?\.{NUMBER}{EXPONENT}?){FLOAT_SUFFIX} {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%g)", floatDescription(lexeme).c_str(), toFloat(lexeme));
    yylval.floatLiteral = new FloatLiteral(toFloat(lexeme), typeOfFloat(lexeme));
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
\?  { lexprint(yylineno, "SEPARATOR ?"); return '?'; }
\.  { lexprint(yylineno, "SEPARATOR ."); return '.'; }
\!  { lexprint(yylineno, "SEPARATOR !"); return '!'; }
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
    printf("\nLEXER ERROR at line %d: ", line);

    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);

    printf("\n");
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

    if (lowerLexeme.ends_with("us") || 
        lowerLexeme.ends_with("ui") || 
        lowerLexeme.ends_with("ul")) {
        message += "UNSIGNED ";
    }
    
    if      (lowerLexeme.ends_with("s")) { message += "SHORT "; }
    else if (lowerLexeme.ends_with("l")) { message += "LONG "; }
    else if (lowerLexeme.ends_with("i")) { message += "INTEGER "; }
    else                                 { message += "INTEGER "; }

    return message + lexeme;
}

std::string floatDescription(const std::string& lexeme) {
    std::string message("LITERAL ");
    std::string lowerLexeme = toLower(lexeme);

    if      (lowerLexeme.ends_with("f")) { message += "SINGLE "; }
    else if (lowerLexeme.ends_with("d")) { message += "DECIMAL "; }
    else if (lowerLexeme.ends_with("r")) { message += "DOUBLE "; }

    return message + lexeme;
}

    /* Converting lexemes to values */

long long toInteger(const std::string& lexeme) {
    std::string number = lexeme;
    std::string lowerLexeme = toLower(lexeme);
    int base = 10;

    if (lowerLexeme.ends_with("us") || 
        lowerLexeme.ends_with("ui") || 
        lowerLexeme.ends_with("ul")) {
        number = number.substr(0, number.length() - 2);
    }
    else if (lowerLexeme.ends_with("s") || 
             lowerLexeme.ends_with("i") || 
             lowerLexeme.ends_with("l")) {
        number = number.substr(0, number.length() - 1);
    }

    if      (lowerLexeme.starts_with("&h")) { base = 16; number = number.substr(2); }
    else if (lowerLexeme.starts_with("&o")) { base = 8;  number = number.substr(2); }
    else if (lowerLexeme.starts_with("&b")) { base = 2;  number = number.substr(2); }

    number.erase(std::remove(number.begin(), number.end(), '_'), number.end());

    return std::stoll(number, nullptr, base);
}

double toFloat(const std::string& lexeme) {
    std::string number = lexeme;
    std::string lowerLexeme = toLower(lexeme);

    if (lowerLexeme.ends_with("f") || 
        lowerLexeme.ends_with("d") || 
        lowerLexeme.ends_with("r")) {
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

    /* Lexemes info getters */

bool isUnsignedInteger(const std::string& lexeme) {
    std::string lowerLexeme = toLower(lexeme);
    return lowerLexeme.ends_with("us") || 
            lowerLexeme.ends_with("ui") || 
            lowerLexeme.ends_with("ul");
}

IntType typeOfInteger(const std::string& lexeme) {
    std::string lowerLexeme = toLower(lexeme);
    if      (lowerLexeme.ends_with("s")) { return IntType::SHORT; }
    else if (lowerLexeme.ends_with("l")) { return IntType::LONG; }
    else if (lowerLexeme.ends_with("i")) { return IntType::INTEGER; }
    else                                 { return IntType::NONE; }
}

FloatType typeOfFloat(const std::string& lexeme) {
    std::string lowerLexeme = toLower(lexeme);
    if      (lowerLexeme.ends_with("f")) { return FloatType::SINGLE; }
    else if (lowerLexeme.ends_with("d")) { return FloatType::DECIMAL; }
    else if (lowerLexeme.ends_with("r")) { return FloatType::DOUBLE; }
    else                                 { return FloatType::NONE; }
}
