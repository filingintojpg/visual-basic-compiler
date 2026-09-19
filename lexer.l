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

%x STRING
%x COMMENT

%%

    /* Keywords */

And              { lexprint(yylineno, "KEYWORD And\n"); }
AndAlso          { lexprint(yylineno, "KEYWORD AndAlso\n"); }
As               { lexprint(yylineno, "KEYWORD As\n"); }
ByRef            { lexprint(yylineno, "KEYWORD ByRef\n"); }
ByVal            { lexprint(yylineno, "KEYWORD ByVal\n"); }
Call             { lexprint(yylineno, "KEYWORD Call\n"); }
Case             { lexprint(yylineno, "KEYWORD Case\n"); }
Catch            { lexprint(yylineno, "KEYWORD Catch\n"); }
CByte            { lexprint(yylineno, "KEYWORD CByte\n"); }
CChar            { lexprint(yylineno, "KEYWORD CChar\n"); }
CDate            { lexprint(yylineno, "KEYWORD CDate\n"); }
CDbl             { lexprint(yylineno, "KEYWORD CDbl\n"); }
CDec             { lexprint(yylineno, "KEYWORD CDec\n"); }
Char             { lexprint(yylineno, "KEYWORD Char\n"); }
CInt             { lexprint(yylineno, "KEYWORD CInt\n"); }
Class            { lexprint(yylineno, "KEYWORD Class\n"); }
CLng             { lexprint(yylineno, "KEYWORD CLng\n"); }
CObj             { lexprint(yylineno, "KEYWORD CObj\n"); }
Const            { lexprint(yylineno, "KEYWORD Const\n"); }
Continue         { lexprint(yylineno, "KEYWORD Continue\n"); }
CSByte           { lexprint(yylineno, "KEYWORD CSByte\n"); }
CShort           { lexprint(yylineno, "KEYWORD CShort\n"); }
CSng             { lexprint(yylineno, "KEYWORD CSng\n"); }
CStr             { lexprint(yylineno, "KEYWORD CStr\n"); }
CType            { lexprint(yylineno, "KEYWORD CType\n"); }
CUInt            { lexprint(yylineno, "KEYWORD CUInt\n"); }
CULng            { lexprint(yylineno, "KEYWORD CULng\n"); }
CUShort          { lexprint(yylineno, "KEYWORD CUShort\n"); }
Date             { lexprint(yylineno, "KEYWORD Date\n"); }
Decimal          { lexprint(yylineno, "KEYWORD Decimal\n"); }
Declare          { lexprint(yylineno, "KEYWORD Declare\n"); }
Default          { lexprint(yylineno, "KEYWORD Default\n"); }
Delegate         { lexprint(yylineno, "KEYWORD Delegate\n"); }
Dim              { lexprint(yylineno, "KEYWORD Dim\n"); }
DirectCast       { lexprint(yylineno, "KEYWORD DirectCast\n"); }
Do               { lexprint(yylineno, "KEYWORD Do\n"); }
Double           { lexprint(yylineno, "KEYWORD Double\n"); }
Each             { lexprint(yylineno, "KEYWORD Each\n"); }
Else             { lexprint(yylineno, "KEYWORD Else\n"); }
ElseIf           { lexprint(yylineno, "KEYWORD ElseIf\n"); }
End[ ]+Class     { lexprint(yylineno, "KEYWORD End Class\n"); }
End[ ]+Enum      { lexprint(yylineno, "KEYWORD End Enum\n"); }
End[ ]+Function  { lexprint(yylineno, "KEYWORD End Function\n"); }
End[ ]+Get       { lexprint(yylineno, "KEYWORD End Get\n"); }
End[ ]+If        { lexprint(yylineno, "KEYWORD End If\n"); }
End[ ]+Interface { lexprint(yylineno, "KEYWORD End Interface\n"); }
End[ ]+Module    { lexprint(yylineno, "KEYWORD End Module\n"); }
End[ ]+Namespace { lexprint(yylineno, "KEYWORD End Namespace\n"); }
End[ ]+Property  { lexprint(yylineno, "KEYWORD End Property\n"); }
End[ ]+Select    { lexprint(yylineno, "KEYWORD End Select\n"); }
End[ ]+Set       { lexprint(yylineno, "KEYWORD End Set\n"); }
End[ ]+Structure { lexprint(yylineno, "KEYWORD End Structure\n"); }
End[ ]+Sub       { lexprint(yylineno, "KEYWORD End Sub\n"); }
End[ ]+SyncLock  { lexprint(yylineno, "KEYWORD End SyncLock\n"); }
End[ ]+Try       { lexprint(yylineno, "KEYWORD End Try\n"); }
End[ ]+While     { lexprint(yylineno, "KEYWORD End While\n"); }
End              { lexprint(yylineno, "KEYWORD End\n"); }
Erase            { lexprint(yylineno, "KEYWORD Erase\n"); }
Error            { lexprint(yylineno, "KEYWORD Error\n"); }
Event            { lexprint(yylineno, "KEYWORD Event\n"); }
Exit             { lexprint(yylineno, "KEYWORD Exit\n"); }
False            { lexprint(yylineno, "BOOLEAN False\n"); }
Finally          { lexprint(yylineno, "KEYWORD Finally\n"); }
For              { lexprint(yylineno, "KEYWORD For\n"); }
Friend           { lexprint(yylineno, "KEYWORD Friend\n"); }
From             { lexprint(yylineno, "KEYWORD From\n"); }
Function         { lexprint(yylineno, "KEYWORD Function\n"); }
Get              { lexprint(yylineno, "KEYWORD Get\n"); }
GetType          { lexprint(yylineno, "KEYWORD GetType\n"); }
Global           { lexprint(yylineno, "KEYWORD Global\n"); }
GoSub            { lexprint(yylineno, "KEYWORD GoSub\n"); }
GoTo             { lexprint(yylineno, "KEYWORD GoTo\n"); }
Handles          { lexprint(yylineno, "KEYWORD Handles\n"); }
If               { lexprint(yylineno, "KEYWORD If\n"); }
Implements       { lexprint(yylineno, "KEYWORD Implements\n"); }
Imports          { lexprint(yylineno, "KEYWORD Imports\n"); }
In               { lexprint(yylineno, "KEYWORD In\n"); }
Inherits         { lexprint(yylineno, "KEYWORD Inherits\n"); }
Integer          { lexprint(yylineno, "KEYWORD Integer\n"); }
Interface        { lexprint(yylineno, "KEYWORD Interface\n"); }
Is               { lexprint(yylineno, "KEYWORD Is\n"); }
IsNot            { lexprint(yylineno, "KEYWORD IsNot\n"); }
Let              { lexprint(yylineno, "KEYWORD Let\n"); }
Like             { lexprint(yylineno, "KEYWORD Like\n"); }
Long             { lexprint(yylineno, "KEYWORD Long\n"); }
Loop             { lexprint(yylineno, "KEYWORD Loop\n"); }
Me               { lexprint(yylineno, "KEYWORD Me\n"); }
Mod              { lexprint(yylineno, "KEYWORD Mod\n"); }
Module           { lexprint(yylineno, "KEYWORD Module\n"); }
MustInherit      { lexprint(yylineno, "KEYWORD MustInherit\n"); }
MustOverride     { lexprint(yylineno, "KEYWORD MustOverride\n"); }
MyBase           { lexprint(yylineno, "KEYWORD MyBase\n"); }
MyClass          { lexprint(yylineno, "KEYWORD MyClass\n"); }
NameOf           { lexprint(yylineno, "KEYWORD NameOf\n"); }
Namespace        { lexprint(yylineno, "KEYWORD Namespace\n"); }
Narrowing        { lexprint(yylineno, "KEYWORD Narrowing\n"); }
New              { lexprint(yylineno, "KEYWORD New\n"); }
Next             { lexprint(yylineno, "KEYWORD Next\n"); }
Not              { lexprint(yylineno, "KEYWORD Not\n"); }
Nothing          { lexprint(yylineno, "NOTHING Nothing\n"); }
NotInheritable   { lexprint(yylineno, "KEYWORD NotInheritable\n"); }
NotOverridable   { lexprint(yylineno, "KEYWORD NotOverridable\n"); }
Object           { lexprint(yylineno, "KEYWORD Object\n"); }
Of               { lexprint(yylineno, "KEYWORD Of\n"); }
On               { lexprint(yylineno, "KEYWORD On\n"); }
Operator         { lexprint(yylineno, "KEYWORD Operator\n"); }
Option           { lexprint(yylineno, "KEYWORD Option\n"); }
Optional         { lexprint(yylineno, "KEYWORD Optional\n"); }
Or               { lexprint(yylineno, "KEYWORD Or\n"); }
OrElse           { lexprint(yylineno, "KEYWORD OrElse\n"); }
Overloads        { lexprint(yylineno, "KEYWORD Overloads\n"); }
Overrides        { lexprint(yylineno, "KEYWORD Overrides\n"); }
ParamArray       { lexprint(yylineno, "KEYWORD ParamArray\n"); }
Partial          { lexprint(yylineno, "KEYWORD Partial\n"); }
Private          { lexprint(yylineno, "KEYWORD Private\n"); }
Property         { lexprint(yylineno, "KEYWORD Property\n"); }
Protected        { lexprint(yylineno, "KEYWORD Protected\n"); }
Public           { lexprint(yylineno, "KEYWORD Public\n"); }
RaiseEvent       { lexprint(yylineno, "KEYWORD RaiseEvent\n"); }
ReadOnly         { lexprint(yylineno, "KEYWORD ReadOnly\n"); }
ReDim            { lexprint(yylineno, "KEYWORD ReDim\n"); }
RemoveHandler    { lexprint(yylineno, "KEYWORD RemoveHandler\n"); }
Resume           { lexprint(yylineno, "KEYWORD Resume\n"); }
Return           { lexprint(yylineno, "KEYWORD Return\n"); }
Select           { lexprint(yylineno, "KEYWORD Select\n"); }
Set              { lexprint(yylineno, "KEYWORD Set\n"); }
Shadows          { lexprint(yylineno, "KEYWORD Shadows\n"); }
Shared           { lexprint(yylineno, "KEYWORD Shared\n"); }
Short            { lexprint(yylineno, "KEYWORD Short\n"); }
Single           { lexprint(yylineno, "KEYWORD Single\n"); }
Static           { lexprint(yylineno, "KEYWORD Static\n"); }
Step             { lexprint(yylineno, "KEYWORD Step\n"); }
Stop             { lexprint(yylineno, "KEYWORD Stop\n"); }
String           { lexprint(yylineno, "KEYWORD String\n"); }
Structure        { lexprint(yylineno, "KEYWORD Structure\n"); }
Sub              { lexprint(yylineno, "KEYWORD Sub\n"); }
SyncLock         { lexprint(yylineno, "KEYWORD SyncLock\n"); }
Then             { lexprint(yylineno, "KEYWORD Then\n"); }
Throw            { lexprint(yylineno, "KEYWORD Throw\n"); }
To               { lexprint(yylineno, "KEYWORD To\n"); }
True             { lexprint(yylineno, "BOOLEAN True\n"); }
Try              { lexprint(yylineno, "KEYWORD Try\n"); }
TryCast          { lexprint(yylineno, "KEYWORD TryCast\n"); }
TypeOf           { lexprint(yylineno, "KEYWORD TypeOf\n"); }
UInteger         { lexprint(yylineno, "KEYWORD UInteger\n"); }
ULong            { lexprint(yylineno, "KEYWORD ULong\n"); }
UShort           { lexprint(yylineno, "KEYWORD UShort\n"); }
Using            { lexprint(yylineno, "KEYWORD Using\n"); }
Until            { lexprint(yylineno, "KEYWORD Until\n"); }
When             { lexprint(yylineno, "KEYWORD When\n"); }
Where            { lexprint(yylineno, "KEYWORD Where\n"); }
While            { lexprint(yylineno, "KEYWORD While\n"); }
Widening         { lexprint(yylineno, "KEYWORD Widening\n"); }
With             { lexprint(yylineno, "KEYWORD With\n"); }
WithEvents       { lexprint(yylineno, "KEYWORD WithEvents\n"); }
WriteOnly        { lexprint(yylineno, "KEYWORD WriteOnly\n"); }
Xor              { lexprint(yylineno, "KEYWORD Xor\n"); }

    /* Operators */

\^      { lexprint(yylineno, "OPERATOR ^\n"); }
\*      { lexprint(yylineno, "OPERATOR *\n"); }
\\      { lexprint(yylineno, "OPERATOR \\\n"); }
\/      { lexprint(yylineno, "OPERATOR /\n"); }
\+      { lexprint(yylineno, "OPERATOR +\n"); }
\-      { lexprint(yylineno, "OPERATOR -\n"); }

\^=     { lexprint(yylineno, "OPERATOR ^=\n"); }
\*=     { lexprint(yylineno, "OPERATOR *=\n"); }
\+=     { lexprint(yylineno, "OPERATOR +=\n"); }
\-=     { lexprint(yylineno, "OPERATOR -=\n"); }

\<=     { lexprint(yylineno, "OPERATOR <=\n"); }
\<      { lexprint(yylineno, "OPERATOR <\n"); }
\>=     { lexprint(yylineno, "OPERATOR >=\n"); }
\>      { lexprint(yylineno, "OPERATOR >\n"); }
\<\>    { lexprint(yylineno, "OPERATOR <>\n"); }
\=      { lexprint(yylineno, "OPERATOR =\n"); }

\&=     { lexprint(yylineno, "OPERATOR &=\n"); }
\&      { lexprint(yylineno, "OPERATOR &\n"); }

\>\>=   { lexprint(yylineno, "OPERATOR >>=\n"); }
\<\<=   { lexprint(yylineno, "OPERATOR <<=\n"); }
\>\>    { lexprint(yylineno, "OPERATOR >>\n"); }
\<\<    { lexprint(yylineno, "OPERATOR <<\n"); }

\\=     { lexprint(yylineno, "OPERATOR \\=\n"); }
\/=     { lexprint(yylineno, "OPERATOR /=\n"); }

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
    lexprint(yylineno, "COMMENT %s\n", commentValue.c_str());
    BEGIN(INITIAL);
}
<COMMENT><<EOF>> {
    lexprint(yylineno, "COMMENT %s\n", commentValue.c_str());
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
    lexerror(yylineno - 1, "String literal wasn't closed\n");
    BEGIN(INITIAL);
}
<STRING><<EOF>> {
    lexerror(yylineno, "String literal wasn't closed at last line\n");
}
<STRING>\"[Cc] {
    if (stringValue.length() == 1) {
        lexprint(yylineno, "LITERAL CHAR %c\n", stringValue.at(0));
    } else {
        lexerror(yylineno, "Char literal has more than 1 symbol\n");
    }
    BEGIN(INITIAL);
}
<STRING>\" {
    lexprint(yylineno, "LITERAL STRING \"%s\"\n", stringValue.c_str());
    BEGIN(INITIAL);
}

    /* Number literals */

    /* Integer literals */

\_+{NUMBER}\_*{INTEGER_SUFFIX}?|\_*{NUMBER}\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in number literal: %s\n", yytext);
}

{NUMBER}{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)\n", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in hex number literal: %s\n", yytext);
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)\n", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in oct number literal: %s\n", yytext);
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)\n", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in bin number literal: %s\n", yytext);
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)\n", integerDescription(lexeme).c_str(), toInteger(lexeme));
}

    /* Floating-point literals */

{NUMBER}(\.{NUMBER})?{EXPONENT}|{NUMBER}?\.{NUMBER}{EXPONENT}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%g)\n", floatingDescription(lexeme).c_str(), toFloating(lexeme));
}

({NUMBER}(\.{NUMBER})?{EXPONENT}?|{NUMBER}?\.{NUMBER}{EXPONENT}?){FLOATING_POINT_SUFFIX} {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%g)\n", floatingDescription(lexeme).c_str(), toFloating(lexeme));
}

    /* Identifiers */

\[{ID}{TYPE_CHAR}\] {
    lexerror(yylineno, "Invalid type char in escaped identifier: %s\n", yytext);
}

\[{ID}\] {
    std::string lexeme(yytext);
    lexprint(yylineno, "ESCAPED IDENTIFIER %s (%s)\n", yytext, toID(lexeme).c_str());
}

{ID}{TYPE_CHAR}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%s)\n", identifierDescription(lexeme).c_str(), toID(lexeme).c_str());
}

    /* Separators */

\(  { lexprint(yylineno, "SEPARATOR (\n"); }
\)  { lexprint(yylineno, "SEPARATOR )\n"); }
\{  { lexprint(yylineno, "SEPARATOR {\n"); }
\}  { lexprint(yylineno, "SEPARATOR }\n"); }
\?  { lexprint(yylineno, "SEPARATOR ?\n"); }
\.  { lexprint(yylineno, "SEPARATOR .\n"); }
\!  { lexprint(yylineno, "SEPARATOR !\n"); }
\,  { lexprint(yylineno, "SEPARATOR ,\n"); }
\:  { lexprint(yylineno, "SEPARATOR :\n"); }

    /* Whitespaces */

[\r\t ]+            { }
[\r\t ]+_[\r\t ]*\n { lexprint(yylineno, "LINE CONTINUATION _\n"); }
\n+                 { if (DEBUG_LEXER_EOL) lexprint(yylineno, "END OF LINE %d\n", yylineno - 1); }

    /* Other */

.       { lexerror(yylineno, "Unexpected character: %s\n", yytext); }
<<EOF>> { yyterminate(); }

%%

    /* Functions */

    /* Debugging */

void lexprint(int line, const char *format, ...) {
    if (DEBUG_LEXER && std::string(format).find("=") != std::string::npos) {
        printf("%d. ", line);

        va_list args;
        va_start(args, format);
        vprintf(format, args);
        va_end(args);
    }
}

void lexerror(int line, const char *format, ...) {
    LEXER_ERROR = true;
    printf("LEXER ERROR at line %d: ", line);

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
