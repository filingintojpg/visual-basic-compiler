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
FLOATING_POINT_SUFFIX   ([Ff]|[Dd]|[Rr])

TYPE_CHAR   [%&@!#$]
ID          ({LETTER}|_[a-zA-Z0-9_])[a-zA-Z0-9_]*

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    #include <string>
    #include <algorithm>

    bool DEBUG_LEXER = true;
    bool DEBUG_LEXER_BY_LINE = false;
    bool DEBUG_LEXER_EOL = false;

    void lexprint(int line, const char *format, ...);
    void lexerror(int line, const char *format, ...);
    std::string toLower(const std::string& str);
    std::string integerDescription(const std::string& lexeme);
    std::string floatingDescription(const std::string& lexeme);
    std::string identifierDescription(const std::string& lexeme);
    long long toInteger(const std::string& lexeme);
    double toFloating(const std::string& lexeme);
    std::string toID(const std::string& lexeme);
%}

%x COMMENT
%x STRING
%x ISTRING
%s ISTRING_EXPR

%%

%{
    std::string commentValue;
    std::string stringValue;
    std::string istringValue;
    int istringBraceDepth = 0;
%}

    /* Keywords */

AddHandler         { lexprint(yylineno, "KEYWORD AddHandler"); }
AddressOf          { lexprint(yylineno, "KEYWORD AddressOf"); }
Alias              { lexprint(yylineno, "KEYWORD Alias"); }
And                { lexprint(yylineno, "KEYWORD And"); }
AndAlso            { lexprint(yylineno, "KEYWORD AndAlso"); }
As                 { lexprint(yylineno, "KEYWORD As"); }
Assembly           { lexprint(yylineno, "KEYWORD Assembly"); }
Boolean            { lexprint(yylineno, "KEYWORD Boolean"); }
ByRef              { lexprint(yylineno, "KEYWORD ByRef"); }
ByVal              { lexprint(yylineno, "KEYWORD ByVal"); }
By                 { lexprint(yylineno, "KEYWORD By"); }
Byte               { lexprint(yylineno, "KEYWORD Byte"); }
Call               { lexprint(yylineno, "KEYWORD Call"); }
Case               { lexprint(yylineno, "KEYWORD Case"); }
Catch              { lexprint(yylineno, "KEYWORD Catch"); }
CByte              { lexprint(yylineno, "KEYWORD CByte"); }
CChar              { lexprint(yylineno, "KEYWORD CChar"); }
CDate              { lexprint(yylineno, "KEYWORD CDate"); }
CDbl               { lexprint(yylineno, "KEYWORD CDbl"); }
CDec               { lexprint(yylineno, "KEYWORD CDec"); }
Char               { lexprint(yylineno, "KEYWORD Char"); }
CInt               { lexprint(yylineno, "KEYWORD CInt"); }
Class              { lexprint(yylineno, "KEYWORD Class"); }
CLng               { lexprint(yylineno, "KEYWORD CLng"); }
CObj               { lexprint(yylineno, "KEYWORD CObj"); }
Const              { lexprint(yylineno, "KEYWORD Const"); }
Continue           { lexprint(yylineno, "KEYWORD Continue"); }
CSByte             { lexprint(yylineno, "KEYWORD CSByte"); }
CShort             { lexprint(yylineno, "KEYWORD CShort"); }
CSng               { lexprint(yylineno, "KEYWORD CSng"); }
CStr               { lexprint(yylineno, "KEYWORD CStr"); }
CType              { lexprint(yylineno, "KEYWORD CType"); }
CUInt              { lexprint(yylineno, "KEYWORD CUInt"); }
CULng              { lexprint(yylineno, "KEYWORD CULng"); }
CUShort            { lexprint(yylineno, "KEYWORD CUShort"); }
Date               { lexprint(yylineno, "KEYWORD Date"); }
Decimal            { lexprint(yylineno, "KEYWORD Decimal"); }
Declare            { lexprint(yylineno, "KEYWORD Declare"); }
Default            { lexprint(yylineno, "KEYWORD Default"); }
Delegate           { lexprint(yylineno, "KEYWORD Delegate"); }
Dim                { lexprint(yylineno, "KEYWORD Dim"); }
DirectCast         { lexprint(yylineno, "KEYWORD DirectCast"); }
Do                 { lexprint(yylineno, "KEYWORD Do"); }
Double             { lexprint(yylineno, "KEYWORD Double"); }
Each               { lexprint(yylineno, "KEYWORD Each"); }
Else               { lexprint(yylineno, "KEYWORD Else"); }
ElseIf             { lexprint(yylineno, "KEYWORD ElseIf"); }
End[ ]+Class       { lexprint(yylineno, "KEYWORD End Class"); }
End[ ]+Enum        { lexprint(yylineno, "KEYWORD End Enum"); }
End[ ]+Function    { lexprint(yylineno, "KEYWORD End Function"); }
End[ ]+Get         { lexprint(yylineno, "KEYWORD End Get"); }
End[ ]+If          { lexprint(yylineno, "KEYWORD End If"); }
End[ ]+Interface   { lexprint(yylineno, "KEYWORD End Interface"); }
End[ ]+Module      { lexprint(yylineno, "KEYWORD End Module"); }
End[ ]+Namespace   { lexprint(yylineno, "KEYWORD End Namespace"); }
End[ ]+Property    { lexprint(yylineno, "KEYWORD End Property"); }
End[ ]+Select      { lexprint(yylineno, "KEYWORD End Select"); }
End[ ]+Set         { lexprint(yylineno, "KEYWORD End Set"); }
End[ ]+Structure   { lexprint(yylineno, "KEYWORD End Structure"); }
End[ ]+Sub         { lexprint(yylineno, "KEYWORD End Sub"); }
End[ ]+SyncLock    { lexprint(yylineno, "KEYWORD End SyncLock"); }
End[ ]+Try         { lexprint(yylineno, "KEYWORD End Try"); }
End[ ]+While       { lexprint(yylineno, "KEYWORD End While"); }
End                { lexprint(yylineno, "KEYWORD End"); }
EndIf              { lexprint(yylineno, "KEYWORD EndIf"); }
Enum               { lexprint(yylineno, "KEYWORD Enum"); }
Erase              { lexprint(yylineno, "KEYWORD Erase"); }
Error              { lexprint(yylineno, "KEYWORD Error"); }
Event              { lexprint(yylineno, "KEYWORD Event"); }
Exit               { lexprint(yylineno, "KEYWORD Exit"); }
False              { lexprint(yylineno, "BOOLEAN False"); }
Finally            { lexprint(yylineno, "KEYWORD Finally"); }
For                { lexprint(yylineno, "KEYWORD For"); }
Friend             { lexprint(yylineno, "KEYWORD Friend"); }
Function           { lexprint(yylineno, "KEYWORD Function"); }
Get                { lexprint(yylineno, "KEYWORD Get"); }
GetType            { lexprint(yylineno, "KEYWORD GetType"); }
GetXMLNamespace    { lexprint(yylineno, "KEYWORD GetXMLNamespace"); }
Global             { lexprint(yylineno, "KEYWORD Global"); }
GoSub              { lexprint(yylineno, "KEYWORD GoSub"); }
GoTo               { lexprint(yylineno, "KEYWORD GoTo"); }
Group              { lexprint(yylineno, "KEYWORD Group"); }
Handles            { lexprint(yylineno, "KEYWORD Handles"); }
If                 { lexprint(yylineno, "KEYWORD If"); }
Implements         { lexprint(yylineno, "KEYWORD Implements"); }
Imports            { lexprint(yylineno, "KEYWORD Imports"); }
In                 { lexprint(yylineno, "KEYWORD In"); }
Inherits           { lexprint(yylineno, "KEYWORD Inherits"); }
Integer            { lexprint(yylineno, "KEYWORD Integer"); }
Interface          { lexprint(yylineno, "KEYWORD Interface"); }
Into               { lexprint(yylineno, "KEYWORD Into"); }
Is                 { lexprint(yylineno, "KEYWORD Is"); }
IsNot              { lexprint(yylineno, "KEYWORD IsNot"); }
Iterator           { lexprint(yylineno, "KEYWORD Iterator"); }
Join               { lexprint(yylineno, "KEYWORD Join"); }
Lib                { lexprint(yylineno, "KEYWORD Lib"); }
Like               { lexprint(yylineno, "KEYWORD Like"); }
Long               { lexprint(yylineno, "KEYWORD Long"); }
Loop               { lexprint(yylineno, "KEYWORD Loop"); }
Me                 { lexprint(yylineno, "KEYWORD Me"); }
Mid                { lexprint(yylineno, "KEYWORD Mid"); }
Mod                { lexprint(yylineno, "KEYWORD Mod"); }
Module             { lexprint(yylineno, "KEYWORD Module"); }
MustInherit        { lexprint(yylineno, "KEYWORD MustInherit"); }
MustOverride       { lexprint(yylineno, "KEYWORD MustOverride"); }
MyBase             { lexprint(yylineno, "KEYWORD MyBase"); }
MyClass            { lexprint(yylineno, "KEYWORD MyClass"); }
NameOf             { lexprint(yylineno, "KEYWORD NameOf"); }
Namespace          { lexprint(yylineno, "KEYWORD Namespace"); }
Narrowing          { lexprint(yylineno, "KEYWORD Narrowing"); }
New                { lexprint(yylineno, "KEYWORD New"); }
Next               { lexprint(yylineno, "KEYWORD Next"); }
Not                { lexprint(yylineno, "KEYWORD Not"); }
Nothing            { lexprint(yylineno, "NOTHING Nothing"); }
NotInheritable     { lexprint(yylineno, "KEYWORD NotInheritable"); }
NotOverridable     { lexprint(yylineno, "KEYWORD NotOverridable"); }
Object             { lexprint(yylineno, "KEYWORD Object"); }
Of                 { lexprint(yylineno, "KEYWORD Of"); }
On                 { lexprint(yylineno, "KEYWORD On"); }
Operator           { lexprint(yylineno, "KEYWORD Operator"); }
Option             { lexprint(yylineno, "KEYWORD Option"); }
Optional           { lexprint(yylineno, "KEYWORD Optional"); }
Or                 { lexprint(yylineno, "KEYWORD Or"); }
OrElse             { lexprint(yylineno, "KEYWORD OrElse"); }
Order              { lexprint(yylineno, "KEYWORD Order"); }
Out                { lexprint(yylineno, "KEYWORD Out"); }
Overloads          { lexprint(yylineno, "KEYWORD Overloads"); }
Overridable        { lexprint(yylineno, "KEYWORD Overridable"); }
Overrides          { lexprint(yylineno, "KEYWORD Overrides"); }
ParamArray         { lexprint(yylineno, "KEYWORD ParamArray"); }
Partial            { lexprint(yylineno, "KEYWORD Partial"); }
Preserve           { lexprint(yylineno, "KEYWORD Preserve"); }
Private            { lexprint(yylineno, "KEYWORD Private"); }
Property           { lexprint(yylineno, "KEYWORD Property"); }
Protected          { lexprint(yylineno, "KEYWORD Protected"); }
Public             { lexprint(yylineno, "KEYWORD Public"); }
RaiseEvent         { lexprint(yylineno, "KEYWORD RaiseEvent"); }
ReadOnly           { lexprint(yylineno, "KEYWORD ReadOnly"); }
ReDim              { lexprint(yylineno, "KEYWORD ReDim"); }
RemoveHandler      { lexprint(yylineno, "KEYWORD RemoveHandler"); }
Resume             { lexprint(yylineno, "KEYWORD Resume"); }
Return             { lexprint(yylineno, "KEYWORD Return"); }
SByte              { lexprint(yylineno, "KEYWORD SByte"); }
Select             { lexprint(yylineno, "KEYWORD Select"); }
Set                { lexprint(yylineno, "KEYWORD Set"); }
Shadows            { lexprint(yylineno, "KEYWORD Shadows"); }
Shared             { lexprint(yylineno, "KEYWORD Shared"); }
Short              { lexprint(yylineno, "KEYWORD Short"); }
Single             { lexprint(yylineno, "KEYWORD Single"); }
Skip               { lexprint(yylineno, "KEYWORD Skip"); }
Static             { lexprint(yylineno, "KEYWORD Static"); }
Step               { lexprint(yylineno, "KEYWORD Step"); }
Stop               { lexprint(yylineno, "KEYWORD Stop"); }
String             { lexprint(yylineno, "KEYWORD String"); }
Structure          { lexprint(yylineno, "KEYWORD Structure"); }
Sub                { lexprint(yylineno, "KEYWORD Sub"); }
SyncLock           { lexprint(yylineno, "KEYWORD SyncLock"); }
Take               { lexprint(yylineno, "KEYWORD Take"); }
Then               { lexprint(yylineno, "KEYWORD Then"); }
Throw              { lexprint(yylineno, "KEYWORD Throw"); }
To                 { lexprint(yylineno, "KEYWORD To"); }
True               { lexprint(yylineno, "BOOLEAN True"); }
Try                { lexprint(yylineno, "KEYWORD Try"); }
TryCast            { lexprint(yylineno, "KEYWORD TryCast"); }
TypeOf             { lexprint(yylineno, "KEYWORD TypeOf"); }
UInteger           { lexprint(yylineno, "KEYWORD UInteger"); }
ULong              { lexprint(yylineno, "KEYWORD ULong"); }
UShort             { lexprint(yylineno, "KEYWORD UShort"); }
Using              { lexprint(yylineno, "KEYWORD Using"); }
Until              { lexprint(yylineno, "KEYWORD Until"); }
Variant            { lexprint(yylineno, "KEYWORD Variant"); }
Wend               { lexprint(yylineno, "KEYWORD Wend"); }
When               { lexprint(yylineno, "KEYWORD When"); }
While              { lexprint(yylineno, "KEYWORD While"); }
Widening           { lexprint(yylineno, "KEYWORD Widening"); }
With               { lexprint(yylineno, "KEYWORD With"); }
WithEvents         { lexprint(yylineno, "KEYWORD WithEvents"); }
WriteOnly          { lexprint(yylineno, "KEYWORD WriteOnly"); }
Xor                { lexprint(yylineno, "KEYWORD Xor"); }

    /* Operators */

\^      { lexprint(yylineno, "OPERATOR ^"); }
\*      { lexprint(yylineno, "OPERATOR *"); }
\\      { lexprint(yylineno, "OPERATOR \\"); }
\/      { lexprint(yylineno, "OPERATOR /"); }
\+      { lexprint(yylineno, "OPERATOR +"); }
\-      { lexprint(yylineno, "OPERATOR -"); }

\^=     { lexprint(yylineno, "OPERATOR ^="); }
\*=     { lexprint(yylineno, "OPERATOR *="); }
\+=     { lexprint(yylineno, "OPERATOR +="); }
\-=     { lexprint(yylineno, "OPERATOR -="); }

\<=     { lexprint(yylineno, "OPERATOR <="); }
\<      { lexprint(yylineno, "OPERATOR <"); }
\>=     { lexprint(yylineno, "OPERATOR >="); }
\>      { lexprint(yylineno, "OPERATOR >"); }
\<\>    { lexprint(yylineno, "OPERATOR <>"); }
\=      { lexprint(yylineno, "OPERATOR ="); }

\&=     { lexprint(yylineno, "OPERATOR &="); }
\&      { lexprint(yylineno, "OPERATOR &"); }

\>\>=   { lexprint(yylineno, "OPERATOR >>="); }
\<\<=   { lexprint(yylineno, "OPERATOR <<="); }
\>\>    { lexprint(yylineno, "OPERATOR >>"); }
\<\<    { lexprint(yylineno, "OPERATOR <<"); }

\\=     { lexprint(yylineno, "OPERATOR \\="); }
\/=     { lexprint(yylineno, "OPERATOR /="); }

    /* Comments */

\'|REM {
    BEGIN(COMMENT);
    commentValue.clear();
    commentValue += yytext;
}
<COMMENT>[^\n]+ {
    commentValue += yytext;
}
<COMMENT>\n {
    lexprint(yylineno - 1, "COMMENT %s", commentValue.c_str());
    BEGIN(INITIAL);
}
<COMMENT><<EOF>> {
    lexprint(yylineno, "COMMENT %s", commentValue.c_str());
    BEGIN(INITIAL);
}

    /* Literals */

    /* String literals */

\" {
    yy_push_state(STRING);
    stringValue.clear();
}
<STRING>[^\n"]+ {
    stringValue += yytext;
}
<STRING>\"\" {
    stringValue += "\"";
}
<STRING>\n {
    lexerror(yylineno - 1, "String literal wasn't closed");
    yy_pop_state();
}
<STRING><<EOF>> {
    lexerror(yylineno, "String literal wasn't closed at last line");
}
<STRING>\"[Cc] {
    if (stringValue.length() == 1) {
        lexprint(yylineno, "LITERAL CHAR %c", stringValue.at(0));
    } else {
        lexerror(yylineno, "Char literal has more than 1 symbol");
    }
    yy_pop_state();
}
<STRING>\" {
    lexprint(yylineno, "LITERAL STRING \"%s\"", stringValue.c_str());
    yy_pop_state();
}

    /* Interpolated string literals */

\$\" {
    yy_push_state(ISTRING);
    istringValue.clear();
    lexprint(yylineno, "ISTRING START");
}
<ISTRING>[^\n"{}]+ {
    istringValue += yytext;
}
<ISTRING>\{\{ {
    istringValue += "{";
}
<ISTRING>\}\} {
    istringValue += "}";
}
<ISTRING>\"\" {
    istringValue += "\"";
}
<ISTRING>\{ {
    lexprint(yylineno, "ISTRING PART \"%s\"", istringValue.c_str());
    istringValue.clear();
    lexprint(yylineno, "SEPARATOR {");
    yy_push_state(ISTRING_EXPR);
}
<ISTRING>\n {
    lexerror(yylineno - 1, "Interpolated string literal wasn't closed");
    yy_pop_state();
}
<ISTRING><<EOF>> {
    lexerror(yylineno, "Interpolated string literal wasn't closed at last line");
}
<ISTRING>\" {
    lexprint(yylineno, "ISTRING PART \"%s\"", istringValue.c_str());
    lexprint(yylineno, "ISTRING END");
    yy_pop_state();
}

<ISTRING_EXPR>\{ {
    istringBraceDepth++;
    lexprint(yylineno, "SEPARATOR {");
}
<ISTRING_EXPR>\} {
    if (istringBraceDepth == 0) {
        yy_pop_state();
    } else {
        istringBraceDepth--;
    }
    lexprint(yylineno, "SEPARATOR }");
}

    /* Number literals */

    /* Integer literals */

\_+{NUMBER}\_*{INTEGER_SUFFIX}?|\_*{NUMBER}\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in number literal: %s", yytext);
}

{NUMBER}{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in hex number literal: %s", yytext);
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in oct number literal: %s", yytext);
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in bin number literal: %s", yytext);
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

    /* Floating-point literals */

{NUMBER}(\.{NUMBER})?{EXPONENT}|{NUMBER}?\.{NUMBER}{EXPONENT}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%g)", floatingDescription(lexeme).c_str(), toFloating(lexeme));
}

({NUMBER}(\.{NUMBER})?{EXPONENT}?|{NUMBER}?\.{NUMBER}{EXPONENT}?){FLOATING_POINT_SUFFIX} {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%g)", floatingDescription(lexeme).c_str(), toFloating(lexeme));
}

    /* Identifiers */

\[{ID}{TYPE_CHAR}\] {
    lexerror(yylineno, "Invalid type char in escaped identifier: %s", yytext);
}

\[{ID}\] {
    std::string lexeme(yytext);
    lexprint(yylineno, "ESCAPED IDENTIFIER %s (%s)", yytext, toID(lexeme).c_str());
}

{ID}{TYPE_CHAR}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%s)", identifierDescription(lexeme).c_str(), toID(lexeme).c_str());
}

    /* Separators */

\(  { lexprint(yylineno, "SEPARATOR ("); }
\)  { lexprint(yylineno, "SEPARATOR )"); }
\{  { lexprint(yylineno, "SEPARATOR {"); }
\}  { lexprint(yylineno, "SEPARATOR }"); }
\?  { lexprint(yylineno, "SEPARATOR ?"); }
\.  { lexprint(yylineno, "SEPARATOR ."); }
\!  { lexprint(yylineno, "SEPARATOR !"); }
\,  { lexprint(yylineno, "SEPARATOR ,"); }
\:  { lexprint(yylineno, "SEPARATOR :"); }

    /* Whitespaces */

[\r\t ]+            { }
[\r\t ]+_[\r\t ]*\n { lexprint(yylineno, "LINE CONTINUATION _"); }
\n+                 { if (DEBUG_LEXER_EOL) lexprint(yylineno - 1, "END OF LINE %d", yylineno - 1); }

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

std::string floatingDescription(const std::string& lexeme) {
    std::string message("LITERAL ");
    std::string lowerLexeme = toLower(lexeme);

    if      (lowerLexeme.ends_with("f")) { message += "SINGLE "; }
    else if (lowerLexeme.ends_with("d")) { message += "DECIMAL "; }
    else if (lowerLexeme.ends_with("r")) { message += "DOUBLE "; }

    return message + lexeme;
}

std::string identifierDescription(const std::string& lexeme) {
    std::string message("IDENTIFIER ");

    if      (lexeme.ends_with("%")) { message += "INTEGER "; }
    else if (lexeme.ends_with("&")) { message += "LONG "; }
    else if (lexeme.ends_with("@")) { message += "DECIMAL "; }
    else if (lexeme.ends_with("!")) { message += "SINGLE "; }
    else if (lexeme.ends_with("#")) { message += "DOUBLE "; }
    else if (lexeme.ends_with("$")) { message += "STRING "; }

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

double toFloating(const std::string& lexeme) {
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

    if (id.ends_with("%") || id.ends_with("&") || id.ends_with("@") || 
        id.ends_with("!") || id.ends_with("#") || id.ends_with("$")) {
        id.pop_back();
    }

    return toLower(id);
}
