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
    std::string floatingDescription(const std::string& lexeme);
    std::string identifierDescription(const std::string& lexeme);
    long long toInteger(const std::string& lexeme);
    double toFloating(const std::string& lexeme);
    std::string toID(const std::string& lexeme);
%}

%x COMMENT
%x STR

%%

%{
    std::string commentValue;
    std::string stringValue;
%}

    /* Keywords */

AddHandler         { lexprint(yylineno, "KEYWORD AddHandler"); return ADD_HANDLER; }
AddressOf          { lexprint(yylineno, "KEYWORD AddressOf"); return ADDRESS_OF; }
Alias              { lexprint(yylineno, "KEYWORD Alias"); return ALIAS; }
And                { lexprint(yylineno, "KEYWORD And"); return AND; }
AndAlso            { lexprint(yylineno, "KEYWORD AndAlso"); return AND_ALSO; }
As                 { lexprint(yylineno, "KEYWORD As"); return AS; }
Assembly           { lexprint(yylineno, "KEYWORD Assembly"); return ASSEMBLY; }
Boolean            { lexprint(yylineno, "KEYWORD Boolean"); return BOOLEAN; }
ByRef              { lexprint(yylineno, "KEYWORD ByRef"); return BYREF; }
ByVal              { lexprint(yylineno, "KEYWORD ByVal"); return BYVAL; }
By                 { lexprint(yylineno, "KEYWORD By"); return BY; }
Byte               { lexprint(yylineno, "KEYWORD Byte"); return BYTE; }
Call               { lexprint(yylineno, "KEYWORD Call"); return CALL; }
Case               { lexprint(yylineno, "KEYWORD Case"); return CASE; }
Catch              { lexprint(yylineno, "KEYWORD Catch"); return CATCH; }
CBool              { lexprint(yylineno, "KEYWORD CBool"); return CBOOL; }
CByte              { lexprint(yylineno, "KEYWORD CByte"); return CBYTE; }
CChar              { lexprint(yylineno, "KEYWORD CChar"); return CCHAR; }
CDate              { lexprint(yylineno, "KEYWORD CDate"); return CDATE; }
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
Date               { lexprint(yylineno, "KEYWORD Date"); return DATE; }
Decimal            { lexprint(yylineno, "KEYWORD Decimal"); return DECIMAL; }
Declare            { lexprint(yylineno, "KEYWORD Declare"); return DECLARE; }
Default            { lexprint(yylineno, "KEYWORD Default"); return DEFAULT; }
Delegate           { lexprint(yylineno, "KEYWORD Delegate"); return DELEGATE; }
Dim                { lexprint(yylineno, "KEYWORD Dim"); return DIM; }
DirectCast         { lexprint(yylineno, "KEYWORD DirectCast"); return DIRECT_CAST; }
Do                 { lexprint(yylineno, "KEYWORD Do"); return DO; }
Double             { lexprint(yylineno, "KEYWORD Double"); return DOUBLE; }
Each               { lexprint(yylineno, "KEYWORD Each"); return EACH; }
Else               { lexprint(yylineno, "KEYWORD Else"); return ELSE; }
ElseIf             { lexprint(yylineno, "KEYWORD ElseIf"); return ELSEIF; }
End[ \t]+Class     { lexprint(yylineno, "KEYWORD End Class"); return END_CLASS; }
End[ \t]+Enum      { lexprint(yylineno, "KEYWORD End Enum"); return END_ENUM; }
End[ \t]+Function  { lexprint(yylineno, "KEYWORD End Function"); return END_FUNCTION; }
End[ \t]+Get       { lexprint(yylineno, "KEYWORD End Get"); return END_GET; }
End[ \t]+If        { lexprint(yylineno, "KEYWORD End If"); return END_IF; }
End[ \t]+Interface { lexprint(yylineno, "KEYWORD End Interface"); return END_INTERFACE; }
End[ \t]+Module    { lexprint(yylineno, "KEYWORD End Module"); return END_MODULE; }
End[ \t]+Namespace { lexprint(yylineno, "KEYWORD End Namespace"); return END_NAMESPACE; }
End[ \t]+Property  { lexprint(yylineno, "KEYWORD End Property"); return END_PROPERTY; }
End[ \t]+Select    { lexprint(yylineno, "KEYWORD End Select"); return END_SELECT; }
End[ \t]+Set       { lexprint(yylineno, "KEYWORD End Set"); return END_SET; }
End[ \t]+Structure { lexprint(yylineno, "KEYWORD End Structure"); return END_STRUCTURE; }
End[ \t]+Sub       { lexprint(yylineno, "KEYWORD End Sub"); return END_SUB; }
End[ \t]+SyncLock  { lexprint(yylineno, "KEYWORD End SyncLock"); return END_SYNC_LOCK; }
End[ \t]+Try       { lexprint(yylineno, "KEYWORD End Try"); return END_TRY; }
End[ \t]+While     { lexprint(yylineno, "KEYWORD End While"); return END_WHILE; }
End                { lexprint(yylineno, "KEYWORD End"); return END; }
Enum               { lexprint(yylineno, "KEYWORD Enum"); return ENUM; }
Erase              { lexprint(yylineno, "KEYWORD Erase"); return ERASE; }
Error              { lexprint(yylineno, "KEYWORD Error"); return ERROR; }
Event              { lexprint(yylineno, "KEYWORD Event"); return EVENT; }
Exit               { lexprint(yylineno, "KEYWORD Exit"); return EXIT; }
False              { lexprint(yylineno, "BOOLEAN False"); return BOOL_VAL; }
Finally            { lexprint(yylineno, "KEYWORD Finally"); return FINALLY; }
For                { lexprint(yylineno, "KEYWORD For"); return FOR; }
Friend             { lexprint(yylineno, "KEYWORD Friend"); return FRIEND; }
Function           { lexprint(yylineno, "KEYWORD Function"); return FUNCTION; }
Get                { lexprint(yylineno, "KEYWORD Get"); return GET; }
GetType            { lexprint(yylineno, "KEYWORD GetType"); return GET_TYPE; }
GetXMLNamespace    { lexprint(yylineno, "KEYWORD GetXMLNamespace"); return GET_XML_NAMESPACE; }
Global             { lexprint(yylineno, "KEYWORD Global"); return GLOBAL; }
GoSub              { lexprint(yylineno, "KEYWORD GoSub"); return GO_SUB; }
GoTo               { lexprint(yylineno, "KEYWORD GoTo"); return GOTO; }
Group              { lexprint(yylineno, "KEYWORD Group"); return GROUP; }
Handles            { lexprint(yylineno, "KEYWORD Handles"); return HANDLES; }
If                 { lexprint(yylineno, "KEYWORD If"); return IF; }
Implements         { lexprint(yylineno, "KEYWORD Implements"); return IMPLEMENTS; }
Imports            { lexprint(yylineno, "KEYWORD Imports"); return IMPORTS; }
In                 { lexprint(yylineno, "KEYWORD In"); return IN; }
Inherits           { lexprint(yylineno, "KEYWORD Inherits"); return INHERITS; }
Integer            { lexprint(yylineno, "KEYWORD Integer"); return INTEGER; }
Interface          { lexprint(yylineno, "KEYWORD Interface"); return INTERFACE; }
Into               { lexprint(yylineno, "KEYWORD Into"); return INTO; }
Is                 { lexprint(yylineno, "KEYWORD Is"); return IS; }
IsNot              { lexprint(yylineno, "KEYWORD IsNot"); return ISNOT; }
Iterator           { lexprint(yylineno, "KEYWORD Iterator"); return ITERATOR; }
Join               { lexprint(yylineno, "KEYWORD Join"); return JOIN; }
Lib                { lexprint(yylineno, "KEYWORD Lib"); return LIB; }
Like               { lexprint(yylineno, "KEYWORD Like"); return LIKE; }
Long               { lexprint(yylineno, "KEYWORD Long"); return LONG; }
Loop               { lexprint(yylineno, "KEYWORD Loop"); return LOOP; }
Me                 { lexprint(yylineno, "KEYWORD Me"); return ME; }
Mid                { lexprint(yylineno, "KEYWORD Mid"); return MID; }
Mod                { lexprint(yylineno, "KEYWORD Mod"); return MOD; }
Module             { lexprint(yylineno, "KEYWORD Module"); return MODULE; }
MustInherit        { lexprint(yylineno, "KEYWORD MustInherit"); return MUST_INHERIT; }
MustOverride       { lexprint(yylineno, "KEYWORD MustOverride"); return MUST_OVERRIDE; }
MyBase             { lexprint(yylineno, "KEYWORD MyBase"); return MYBASE; }
MyClass            { lexprint(yylineno, "KEYWORD MyClass"); return MYCLASS; }
NameOf             { lexprint(yylineno, "KEYWORD NameOf"); return NAME_OF; }
Namespace          { lexprint(yylineno, "KEYWORD Namespace"); return NAMESPACE; }
Narrowing          { lexprint(yylineno, "KEYWORD Narrowing"); return NARROWING; }
New                { lexprint(yylineno, "KEYWORD New"); return NEW; }
Next               { lexprint(yylineno, "KEYWORD Next"); return NEXT; }
Not                { lexprint(yylineno, "KEYWORD Not"); return NOT; }
Nothing            { lexprint(yylineno, "NOTHING Nothing"); return NOTHING_VAL; }
NotInheritable     { lexprint(yylineno, "KEYWORD NotInheritable"); return NOT_INHERITABLE; }
NotOverridable     { lexprint(yylineno, "KEYWORD NotOverridable"); return NOT_OVERRIDABLE; }
Object             { lexprint(yylineno, "KEYWORD Object"); return OBJECT; }
Of                 { lexprint(yylineno, "KEYWORD Of"); return OF; }
On                 { lexprint(yylineno, "KEYWORD On"); return ON; }
Operator           { lexprint(yylineno, "KEYWORD Operator"); return OPERATOR; }
Option             { lexprint(yylineno, "KEYWORD Option"); return OPTION; }
Optional           { lexprint(yylineno, "KEYWORD Optional"); return OPTIONAL; }
Or                 { lexprint(yylineno, "KEYWORD Or"); return OR; }
OrElse             { lexprint(yylineno, "KEYWORD OrElse"); return OR_ELSE; }
Order              { lexprint(yylineno, "KEYWORD Order"); return ORDER; }
Out                { lexprint(yylineno, "KEYWORD Out"); return OUT; }
Overloads          { lexprint(yylineno, "KEYWORD Overloads"); return OVERLOADS; }
Overridable        { lexprint(yylineno, "KEYWORD Overridable"); return OVERRIDABLE; }
Overrides          { lexprint(yylineno, "KEYWORD Overrides"); return OVERRIDES; }
ParamArray         { lexprint(yylineno, "KEYWORD ParamArray"); return PARAMARRAY; }
Partial            { lexprint(yylineno, "KEYWORD Partial"); return PARTIAL; }
Preserve           { lexprint(yylineno, "KEYWORD Preserve"); return PRESERVE; }
Private            { lexprint(yylineno, "KEYWORD Private"); return PRIVATE; }
Property           { lexprint(yylineno, "KEYWORD Property"); return PROPERTY; }
Protected          { lexprint(yylineno, "KEYWORD Protected"); return PROTECTED; }
Public             { lexprint(yylineno, "KEYWORD Public"); return PUBLIC; }
RaiseEvent         { lexprint(yylineno, "KEYWORD RaiseEvent"); return RAISE_EVENT; }
ReadOnly           { lexprint(yylineno, "KEYWORD ReadOnly"); return READONLY; }
ReDim              { lexprint(yylineno, "KEYWORD ReDim"); return REDIM; }
RemoveHandler      { lexprint(yylineno, "KEYWORD RemoveHandler"); return REMOVE_HANDLER; }
Resume             { lexprint(yylineno, "KEYWORD Resume"); return RESUME; }
Return             { lexprint(yylineno, "KEYWORD Return"); return RETURN; }
SByte              { lexprint(yylineno, "KEYWORD SByte"); return SBYTE; }
Select             { lexprint(yylineno, "KEYWORD Select"); return SELECT; }
Set                { lexprint(yylineno, "KEYWORD Set"); return SET; }
Shadows            { lexprint(yylineno, "KEYWORD Shadows"); return SHADOWS; }
Shared             { lexprint(yylineno, "KEYWORD Shared"); return SHARED; }
Short              { lexprint(yylineno, "KEYWORD Short"); return SHORT; }
Single             { lexprint(yylineno, "KEYWORD Single"); return SINGLE; }
Skip               { lexprint(yylineno, "KEYWORD Skip"); return SKIP; }
Static             { lexprint(yylineno, "KEYWORD Static"); return STATIC; }
Step               { lexprint(yylineno, "KEYWORD Step"); return STEP; }
Stop               { lexprint(yylineno, "KEYWORD Stop"); return STOP; }
String             { lexprint(yylineno, "KEYWORD String"); return STRING; }
Structure          { lexprint(yylineno, "KEYWORD Structure"); return STRUCT; }
Sub                { lexprint(yylineno, "KEYWORD Sub"); return SUB; }
SyncLock           { lexprint(yylineno, "KEYWORD SyncLock"); return SYNC_LOCK; }
Take               { lexprint(yylineno, "KEYWORD Take"); return TAKE; }
Then               { lexprint(yylineno, "KEYWORD Then"); return THEN; }
Throw              { lexprint(yylineno, "KEYWORD Throw"); return THROW; }
To                 { lexprint(yylineno, "KEYWORD To"); return TO; }
True               { lexprint(yylineno, "BOOLEAN True"); return BOOL_VAL; }
Try                { lexprint(yylineno, "KEYWORD Try"); return TRY; }
TryCast            { lexprint(yylineno, "KEYWORD TryCast"); return TRY_CAST; }
TypeOf             { lexprint(yylineno, "KEYWORD TypeOf"); return TYPE_OF; }
UInteger           { lexprint(yylineno, "KEYWORD UInteger"); return UINTEGER; }
ULong              { lexprint(yylineno, "KEYWORD ULong"); return ULONG; }
UShort             { lexprint(yylineno, "KEYWORD UShort"); return USHORT; }
Using              { lexprint(yylineno, "KEYWORD Using"); return USING; }
Until              { lexprint(yylineno, "KEYWORD Until"); return UNTIL; }
Variant            { lexprint(yylineno, "KEYWORD Variant"); return VARIANT; }
Wend               { lexprint(yylineno, "KEYWORD Wend"); return WEND; }
When               { lexprint(yylineno, "KEYWORD When"); return WHEN; }
While              { lexprint(yylineno, "KEYWORD While"); return WHILE; }
Widening           { lexprint(yylineno, "KEYWORD Widening"); return WIDENING; }
With               { lexprint(yylineno, "KEYWORD With"); return WITH; }
WithEvents         { lexprint(yylineno, "KEYWORD WithEvents"); return WITH_EVENTS; }
WriteOnly          { lexprint(yylineno, "KEYWORD WriteOnly"); return WRITE_ONLY; }
Xor                { lexprint(yylineno, "KEYWORD Xor"); return XOR; }

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

\>\>=   { lexprint(yylineno, "OPERATOR >>="); return RSHIFT_ASSIGN; }
\<\<=   { lexprint(yylineno, "OPERATOR <<="); return LSHIFT_ASSIGN; }
\>\>    { lexprint(yylineno, "OPERATOR >>"); return RSHIFT; }
\<\<    { lexprint(yylineno, "OPERATOR <<"); return LSHIFT; }

\\=     { lexprint(yylineno, "OPERATOR \\="); return FLOORDIV_ASSIGN; }
\/=     { lexprint(yylineno, "OPERATOR /="); return DIV_ASSIGN; }

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
    return ENDL;
}
<COMMENT><<EOF>> {
    lexprint(yylineno, "COMMENT %s", commentValue.c_str());
    BEGIN(INITIAL);
    return ENDL;
}

    /* Literals */

    /* String literals */

\" {
    BEGIN(STR);
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
    BEGIN(INITIAL);
}
<STR><<EOF>> {
    lexerror(yylineno, "String literal wasn't closed at last line");
    yyterminate();
}
<STR>\"[Cc] {
    BEGIN(INITIAL);
    
    if (stringValue.length() == 1) {
        lexprint(yylineno, "LITERAL CHAR %c", stringValue.at(0));
        return CHAR_VAL;
    } else {
        lexerror(yylineno, "Char literal has more than 1 symbol");
    }
}
<STR>\" {
    lexprint(yylineno, "LITERAL STRING \"%s\"", stringValue.c_str());
    BEGIN(INITIAL);
    return STR_VAL;
}

    /* Number literals */

    /* Integer literals */

\_+{NUMBER}\_*{INTEGER_SUFFIX}?|\_*{NUMBER}\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in number literal: %s", yytext);
}

{NUMBER}{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    return INT_VAL;
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in hex number literal: %s", yytext);
}

&H\_*{HEX_DIGIT}(\_*{HEX_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    return INT_VAL;
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in oct number literal: %s", yytext);
}

&O\_*{OCT_DIGIT}(\_*{OCT_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    return INT_VAL;
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*\_+{INTEGER_SUFFIX}? {
    lexerror(yylineno, "Invalid underscore character in bin number literal: %s", yytext);
}

&B\_*{BIN_DIGIT}(\_*{BIN_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%lld)", integerDescription(lexeme).c_str(), toInteger(lexeme));
    return INT_VAL;
}

    /* Floating-point literals */

{NUMBER}(\.{NUMBER})?{EXPONENT}|{NUMBER}?\.{NUMBER}{EXPONENT}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%g)", floatingDescription(lexeme).c_str(), toFloating(lexeme));
    return FLOAT_VAL;
}

({NUMBER}(\.{NUMBER})?{EXPONENT}?|{NUMBER}?\.{NUMBER}{EXPONENT}?){FLOATING_POINT_SUFFIX} {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%g)", floatingDescription(lexeme).c_str(), toFloating(lexeme));
    return FLOAT_VAL;
}

    /* Identifiers */

\[{ID}{TYPE_CHAR}\] {
    lexerror(yylineno, "Invalid type char in escaped identifier: %s", yytext);
    return ID;
}

\[{ID}\] {
    std::string lexeme(yytext);
    lexprint(yylineno, "ESCAPED IDENTIFIER %s (%s)", yytext, toID(lexeme).c_str());
    return ID;
}

{ID}{TYPE_CHAR}? {
    std::string lexeme(yytext);
    lexprint(yylineno, "%s (%s)", identifierDescription(lexeme).c_str(), toID(lexeme).c_str());
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
