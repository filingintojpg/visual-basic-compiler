%option noyywrap
%option never-interactive
%option yylineno
%option case-insensitive

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
    bool DEBUG_LEXER_EOL = false;

    bool LEXER_ERROR = false;

    std::string stringValue;
    std::string commentValue;

    void lexprint(const char *format, ...);
    void lexerror(const char *format, ...);
    std::string toLower(const std::string& str);
    std::string integerDescription(const std::string& lexeme);
    std::string floatingDescription(const std::string& lexeme);
    long long toInteger(const std::string& lexeme);
    double toFloating(const std::string& lexeme);
%}

%x STRING
%x COMMENT

%%

    /* Keywords */

And              { lexprint("KEYWORD And\n"); }
AndAlso          { lexprint("KEYWORD AndAlso\n"); }
As               { lexprint("KEYWORD As\n"); }
ByRef            { lexprint("KEYWORD ByRef\n"); }
ByVal            { lexprint("KEYWORD ByVal\n"); }
Call             { lexprint("KEYWORD Call\n"); }
Case             { lexprint("KEYWORD Case\n"); }
Catch            { lexprint("KEYWORD Catch\n"); }
CByte            { lexprint("KEYWORD CByte\n"); }
CChar            { lexprint("KEYWORD CChar\n"); }
CDate            { lexprint("KEYWORD CDate\n"); }
CDbl             { lexprint("KEYWORD CDbl\n"); }
CDec             { lexprint("KEYWORD CDec\n"); }
Char             { lexprint("KEYWORD Char\n"); }
CInt             { lexprint("KEYWORD CInt\n"); }
Class            { lexprint("KEYWORD Class\n"); }
CLng             { lexprint("KEYWORD CLng\n"); }
CObj             { lexprint("KEYWORD CObj\n"); }
Const            { lexprint("KEYWORD Const\n"); }
Continue         { lexprint("KEYWORD Continue\n"); }
CSByte           { lexprint("KEYWORD CSByte\n"); }
CShort           { lexprint("KEYWORD CShort\n"); }
CSng             { lexprint("KEYWORD CSng\n"); }
CStr             { lexprint("KEYWORD CStr\n"); }
CType            { lexprint("KEYWORD CType\n"); }
CUInt            { lexprint("KEYWORD CUInt\n"); }
CULng            { lexprint("KEYWORD CULng\n"); }
CUShort          { lexprint("KEYWORD CUShort\n"); }
Date             { lexprint("KEYWORD Date\n"); }
Decimal          { lexprint("KEYWORD Decimal\n"); }
Declare          { lexprint("KEYWORD Declare\n"); }
Default          { lexprint("KEYWORD Default\n"); }
Delegate         { lexprint("KEYWORD Delegate\n"); }
Dim              { lexprint("KEYWORD Dim\n"); }
DirectCast       { lexprint("KEYWORD DirectCast\n"); }
Do               { lexprint("KEYWORD Do\n"); }
Double           { lexprint("KEYWORD Double\n"); }
Each             { lexprint("KEYWORD Each\n"); }
Else             { lexprint("KEYWORD Else\n"); }
ElseIf           { lexprint("KEYWORD ElseIf\n"); }
End[ ]+Class     { lexprint("KEYWORD End Class\n"); }
End[ ]+Enum      { lexprint("KEYWORD End Enum\n"); }
End[ ]+Function  { lexprint("KEYWORD End Function\n"); }
End[ ]+Get       { lexprint("KEYWORD End Get\n"); }
End[ ]+If        { lexprint("KEYWORD End If\n"); }
End[ ]+Interface { lexprint("KEYWORD End Interface\n"); }
End[ ]+Module    { lexprint("KEYWORD End Module\n"); }
End[ ]+Namespace { lexprint("KEYWORD End Namespace\n"); }
End[ ]+Property  { lexprint("KEYWORD End Property\n"); }
End[ ]+Select    { lexprint("KEYWORD End Select\n"); }
End[ ]+Set       { lexprint("KEYWORD End Set\n"); }
End[ ]+Structure { lexprint("KEYWORD End Structure\n"); }
End[ ]+Sub       { lexprint("KEYWORD End Sub\n"); }
End[ ]+SyncLock  { lexprint("KEYWORD End SyncLock\n"); }
End[ ]+Try       { lexprint("KEYWORD End Try\n"); }
End[ ]+While     { lexprint("KEYWORD End While\n"); }
End              { lexprint("KEYWORD End\n"); }
Erase            { lexprint("KEYWORD Erase\n"); }
Error            { lexprint("KEYWORD Error\n"); }
Event            { lexprint("KEYWORD Event\n"); }
Exit             { lexprint("KEYWORD Exit\n"); }
False            { lexprint("BOOLEAN False\n"); }
Finally          { lexprint("KEYWORD Finally\n"); }
For              { lexprint("KEYWORD For\n"); }
Friend           { lexprint("KEYWORD Friend\n"); }
Function         { lexprint("KEYWORD Function\n"); }
Get              { lexprint("KEYWORD Get\n"); }
GetType          { lexprint("KEYWORD GetType\n"); }
Global           { lexprint("KEYWORD Global\n"); }
GoSub            { lexprint("KEYWORD GoSub\n"); }
GoTo             { lexprint("KEYWORD GoTo\n"); }
Handles          { lexprint("KEYWORD Handles\n"); }
If               { lexprint("KEYWORD If\n"); }
Implements       { lexprint("KEYWORD Implements\n"); }
Imports          { lexprint("KEYWORD Imports\n"); }
In               { lexprint("KEYWORD In\n"); }
Inherits         { lexprint("KEYWORD Inherits\n"); }
Integer          { lexprint("KEYWORD Integer\n"); }
Interface        { lexprint("KEYWORD Interface\n"); }
Is               { lexprint("KEYWORD Is\n"); }
IsNot            { lexprint("KEYWORD IsNot\n"); }
Let              { lexprint("KEYWORD Let\n"); }
Like             { lexprint("KEYWORD Like\n"); }
Long             { lexprint("KEYWORD Long\n"); }
Loop             { lexprint("KEYWORD Loop\n"); }
Me               { lexprint("KEYWORD Me\n"); }
Mod              { lexprint("KEYWORD Mod\n"); }
Module           { lexprint("KEYWORD Module\n"); }
MustInherit      { lexprint("KEYWORD MustInherit\n"); }
MustOverride     { lexprint("KEYWORD MustOverride\n"); }
MyBase           { lexprint("KEYWORD MyBase\n"); }
MyClass          { lexprint("KEYWORD MyClass\n"); }
NameOf           { lexprint("KEYWORD NameOf\n"); }
Namespace        { lexprint("KEYWORD Namespace\n"); }
Narrowing        { lexprint("KEYWORD Narrowing\n"); }
New              { lexprint("KEYWORD New\n"); }
Next             { lexprint("KEYWORD Next\n"); }
Not              { lexprint("KEYWORD Not\n"); }
Nothing          { lexprint("NOTHING Nothing\n"); }
NotInheritable   { lexprint("KEYWORD NotInheritable\n"); }
NotOverridable   { lexprint("KEYWORD NotOverridable\n"); }
Object           { lexprint("KEYWORD Object\n"); }
Of               { lexprint("KEYWORD Of\n"); }
On               { lexprint("KEYWORD On\n"); }
Operator         { lexprint("KEYWORD Operator\n"); }
Option           { lexprint("KEYWORD Option\n"); }
Optional         { lexprint("KEYWORD Optional\n"); }
Or               { lexprint("KEYWORD Or\n"); }
OrElse           { lexprint("KEYWORD OrElse\n"); }
Overloads        { lexprint("KEYWORD Overloads\n"); }
Overrides        { lexprint("KEYWORD Overrides\n"); }
ParamArray       { lexprint("KEYWORD ParamArray\n"); }
Partial          { lexprint("KEYWORD Partial\n"); }
Private          { lexprint("KEYWORD Private\n"); }
Property         { lexprint("KEYWORD Property\n"); }
Protected        { lexprint("KEYWORD Protected\n"); }
Public           { lexprint("KEYWORD Public\n"); }
RaiseEvent       { lexprint("KEYWORD RaiseEvent\n"); }
ReadOnly         { lexprint("KEYWORD ReadOnly\n"); }
ReDim            { lexprint("KEYWORD ReDim\n"); }
RemoveHandler    { lexprint("KEYWORD RemoveHandler\n"); }
Resume           { lexprint("KEYWORD Resume\n"); }
Return           { lexprint("KEYWORD Return\n"); }
Select           { lexprint("KEYWORD Select\n"); }
Set              { lexprint("KEYWORD Set\n"); }
Shadows          { lexprint("KEYWORD Shadows\n"); }
Shared           { lexprint("KEYWORD Shared\n"); }
Short            { lexprint("KEYWORD Short\n"); }
Single           { lexprint("KEYWORD Single\n"); }
Static           { lexprint("KEYWORD Static\n"); }
Step             { lexprint("KEYWORD Step\n"); }
Stop             { lexprint("KEYWORD Stop\n"); }
String           { lexprint("KEYWORD String\n"); }
Structure        { lexprint("KEYWORD Structure\n"); }
Sub              { lexprint("KEYWORD Sub\n"); }
SyncLock         { lexprint("KEYWORD SyncLock\n"); }
Then             { lexprint("KEYWORD Then\n"); }
Throw            { lexprint("KEYWORD Throw\n"); }
To               { lexprint("KEYWORD To\n"); }
True             { lexprint("BOOLEAN True\n"); }
Try              { lexprint("KEYWORD Try\n"); }
TryCast          { lexprint("KEYWORD TryCast\n"); }
TypeOf           { lexprint("KEYWORD TypeOf\n"); }
UInteger         { lexprint("KEYWORD UInteger\n"); }
ULong            { lexprint("KEYWORD ULong\n"); }
UShort           { lexprint("KEYWORD UShort\n"); }
Using            { lexprint("KEYWORD Using\n"); }
When             { lexprint("KEYWORD When\n"); }
While            { lexprint("KEYWORD While\n"); }
Widening         { lexprint("KEYWORD Widening\n"); }
With             { lexprint("KEYWORD With\n"); }
WithEvents       { lexprint("KEYWORD WithEvents\n"); }
WriteOnly        { lexprint("KEYWORD WriteOnly\n"); }
Xor              { lexprint("KEYWORD Xor\n"); }

    /* Operators */

\^      { lexprint("OPERATOR ^\n"); }
\*      { lexprint("OPERATOR *\n"); }
\\      { lexprint("OPERATOR \\\n"); }
\/      { lexprint("OPERATOR /\n"); }
\+      { lexprint("OPERATOR +\n"); }
\-      { lexprint("OPERATOR -\n"); }

\^=     { lexprint("OPERATOR ^=\n"); }
\*=     { lexprint("OPERATOR *=\n"); }
\+=     { lexprint("OPERATOR +=\n"); }
\-=     { lexprint("OPERATOR -=\n"); }

\<=     { lexprint("OPERATOR <=\n"); }
\<      { lexprint("OPERATOR <\n"); }
\>=     { lexprint("OPERATOR >=\n"); }
\>      { lexprint("OPERATOR >\n"); }
\=      { lexprint("OPERATOR =\n"); }
\<\>    { lexprint("OPERATOR <>\n"); }

\&=     { lexprint("OPERATOR &=\n"); }
\&      { lexprint("OPERATOR &\n"); }

\>\>=   { lexprint("OPERATOR >>=\n"); }
\<\<=   { lexprint("OPERATOR <<=\n"); }
\>\>    { lexprint("OPERATOR >>\n"); }
\<\<    { lexprint("OPERATOR <<\n"); }

\\=     { lexprint("OPERATOR \\=\n"); }
\/=     { lexprint("OPERATOR /=\n"); }

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
    lexprint("COMMENT %s\n", commentValue.c_str());
    BEGIN(INITIAL);
}
<COMMENT><<EOF>> {
    lexprint("COMMENT %s\n", commentValue.c_str());
    BEGIN(INITIAL);
}

    /* Literals */

    /* String literals */

\" {
    BEGIN(STRING);
    stringValue.clear();
}
<STRING>[^\n"]+ {
    stringValue += yytext;
}
<STRING>\"\" {
    stringValue += "\"";
}
<STRING>\n {
    lexerror("String literal wasn't closed at line %d\n", yylineno - 1);
    BEGIN(INITIAL);
}
<STRING><<EOF>> {
    lexerror("String literal wasn't closed at last line\n");
}
<STRING>\"[Cc] {
    if (stringValue.length() == 1) {
        lexprint("LITERAL CHAR %c\n", stringValue.at(0));
    } else {
        lexerror("Char literal has more than 1 symbol at line %d\n", yylineno);
    }
    BEGIN(INITIAL);
}
<STRING>\" {
    lexprint("LITERAL STRING \"%s\"\n", stringValue.c_str());
    BEGIN(INITIAL);
}

    /* Number literals */

    /* Integer literals */

\_+{NUMBER}\_*{INTEGER_SUFFIX}?|\_*{NUMBER}\_+{INTEGER_SUFFIX}? {
    lexerror("Invalid underscore character in number literal at line %d: %s\n", yylineno, yytext);
}

{NUMBER}{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint("%s (%lld)\n", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror("Invalid underscore character in hex number literal at line %d: %s\n", yylineno, yytext);
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint("%s (%lld)\n", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror("Invalid underscore character in oct number literal at line %d: %s\n", yylineno, yytext);
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint("%s (%lld)\n", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror("Invalid underscore character in bin number literal at line %d: %s\n", yylineno, yytext);
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint("%s (%lld)\n", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

    /* Floating-point literals */

{NUMBER}(\.{NUMBER})?{EXPONENT}|{NUMBER}?\.{NUMBER}{EXPONENT}? {
    std::string lexeme(yytext);
    lexprint("%s (%g)\n", floatingDescription(lexeme).c_str(), toFloating(lexeme));
}

({NUMBER}(\.{NUMBER})?{EXPONENT}?|{NUMBER}?\.{NUMBER}{EXPONENT}?){FLOATING_POINT_SUFFIX} {
    std::string lexeme(yytext);
    lexprint("%s (%g)\n", floatingDescription(lexeme).c_str(), toFloating(lexeme));
}

    /* Identifiers */

\[{ID}{TYPE_CHAR}\] {
    lexerror("Invalid type char in escaped identifier at line %d: %s\n", yylineno, yytext);
}

\[{ID}\] {
    std::string lexeme(yytext);
    std::string id = lexeme.substr(1, lexeme.length() - 2);
    lexprint("ESCAPED IDENTIFIER %s\n", id.c_str());
}

{ID}{TYPE_CHAR}? {
    std::string message("IDENTIFIER ");
    std::string lexeme(yytext);

    if      (lexeme.ends_with("%")) { message += "INTEGER "; }
    else if (lexeme.ends_with("&")) { message += "LONG "; }
    else if (lexeme.ends_with("@")) { message += "DECIMAL "; }
    else if (lexeme.ends_with("!")) { message += "SINGLE "; }
    else if (lexeme.ends_with("#")) { message += "DOUBLE "; }
    else if (lexeme.ends_with("$")) { message += "STRING "; }

    lexprint("%s%s\n", message.c_str(), lexeme.c_str());
}

    /* Separators */

\(  { lexprint("SEPARATOR (\n"); }
\)  { lexprint("SEPARATOR )\n"); }
\{  { lexprint("SEPARATOR {\n"); }
\}  { lexprint("SEPARATOR }\n"); }
\?  { lexprint("SEPARATOR ?\n"); }
\.  { lexprint("SEPARATOR .\n"); }
\!  { lexprint("SEPARATOR !\n"); }
\,  { lexprint("SEPARATOR ,\n"); }
\:  { lexprint("SEPARATOR :\n"); }

    /* Whitespaces */

[\r\t ]+            { }
[\r\t ]_[\r\t ]*\n+ { lexprint("LINE CONTINUATION _\n"); }
\n+                 { if (DEBUG_LEXER_EOL) lexprint("END OF LINE %d\n", yylineno - 1); }

    /* Other */

.       { lexerror("Unexpected character at line %d: %s\n", yylineno, yytext); }
<<EOF>> { yyterminate(); }

%%

    /* Functions */

    /* Debugging */

void lexprint(const char *format, ...) {
    if (DEBUG_LEXER) {
        va_list args;
        va_start(args, format);
        vprintf(format, args);
        va_end(args);
    }
}

void lexerror(const char *format, ...) {
    LEXER_ERROR = true;
    printf("LEXER ERROR: ");

    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
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

    if      (lowerLexeme.starts_with("&H")) { message += "HEX "; }
    else if (lowerLexeme.starts_with("&O")) { message += "OCT "; }
    else if (lowerLexeme.starts_with("&B")) { message += "BIN "; }
    else                                    { message += "DEC "; }

    if (lowerLexeme.ends_with("US") || 
        lowerLexeme.ends_with("UI") || 
        lowerLexeme.ends_with("UL")) {
        message += "UNSIGNED ";
    }
    
    if      (lowerLexeme.ends_with("S")) { message += "SHORT "; }
    else if (lowerLexeme.ends_with("L")) { message += "LONG "; }
    else if (lowerLexeme.ends_with("I")) { message += "INTEGER "; }
    else                                 { message += "INTEGER "; }

    return message + lexeme;
}

std::string floatingDescription(const std::string& lexeme) {
    std::string message("LITERAL ");
    std::string lowerLexeme = toLower(lexeme);

    if      (lowerLexeme.ends_with("F")) { message += "SINGLE "; }
    else if (lowerLexeme.ends_with("D")) { message += "DECIMAL "; }
    else if (lowerLexeme.ends_with("R")) { message += "DOUBLE "; }

    return message + lexeme;
}

    /* Converting lexemes to values */

long long toInteger(const std::string& lexeme) {
    std::string number = lexeme;
    std::string lowerLexeme = toLower(lexeme);
    int base = 10;

    if (lowerLexeme.ends_with("US") || 
        lowerLexeme.ends_with("UI") || 
        lowerLexeme.ends_with("UL")) {
        number = number.substr(0, number.length() - 2);
    }
    else if (lowerLexeme.ends_with("S") || 
             lowerLexeme.ends_with("I") || 
             lowerLexeme.ends_with("L")) {
        number = number.substr(0, number.length() - 1);
    }

    if      (lowerLexeme.starts_with("&H")) { base = 16; number = number.substr(2); }
    else if (lowerLexeme.starts_with("&O")) { base = 8;  number = number.substr(2); }
    else if (lowerLexeme.starts_with("&B")) { base = 2;  number = number.substr(2); }

    number.erase(std::remove(number.begin(), number.end(), '_'), number.end());

    return std::stoll(number, nullptr, base);
}

double toFloating(const std::string& lexeme) {
    std::string number = lexeme;
    std::string lowerLexeme = toLower(lexeme);

    if (lowerLexeme.ends_with("F") || 
        lowerLexeme.ends_with("D") || 
        lowerLexeme.ends_with("R")) {
        number.pop_back();
    }

    number.erase(std::remove(number.begin(), number.end(), '_'), number.end());

    return std::stod(number);
}
