%option noyywrap
%option never-interactive
%option yylineno
%option case-insensitive

LETTER      [a-zA-Z]
DIGIT       [0-9]
BIN_DIGIT   [0-1]
OCT_DIGIT   [0-7]
HEX_DIGIT   [a-fA-F0-9]

NUMBER      {DIGIT}(\_*{DIGIT}*)*
EXPONENT    [Ee][+-]?{NUMBER}

INTEGER_SUFFIX          (S|US|I|UI|L|UL)
FLOATING_POINT_SUFFIX   ([Ff]|[Dd]|[Rr])

TYPE_CHAR   [%&@!#$]
ID          ({LETTER}|_[a-zA-Z0-9_])[a-zA-Z0-9_]*

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string>
%}

%x STRING
%x COMMENT

%%

%{
    std::string stringValue;
    std::string commentValue;
%}

/* Keywords */

And             { printf("KEYWORD And\n"); }
AndAlso         { printf("KEYWORD AndAlso\n"); }
As              { printf("KEYWORD As\n"); }
ByRef           { printf("KEYWORD ByRef\n"); }
ByVal           { printf("KEYWORD ByVal\n"); }
Call            { printf("KEYWORD Call\n"); }
Case            { printf("KEYWORD Case\n"); }
Catch           { printf("KEYWORD Catch\n"); }
CByte           { printf("KEYWORD CByte\n"); }
CChar           { printf("KEYWORD CChar\n"); }
CDate           { printf("KEYWORD CDate\n"); }
CDbl            { printf("KEYWORD CDbl\n"); }
CDec            { printf("KEYWORD CDec\n"); }
Char            { printf("KEYWORD Char\n"); }
CInt            { printf("KEYWORD CInt\n"); }
Class           { printf("KEYWORD Class\n"); }
CLng            { printf("KEYWORD CLng\n"); }
CObj            { printf("KEYWORD CObj\n"); }
Const           { printf("KEYWORD Const\n"); }
Continue        { printf("KEYWORD Continue\n"); }
CSByte          { printf("KEYWORD CSByte\n"); }
CShort          { printf("KEYWORD CShort\n"); }
CSng            { printf("KEYWORD CSng\n"); }
CStr            { printf("KEYWORD CStr\n"); }
CType           { printf("KEYWORD CType\n"); }
CUInt           { printf("KEYWORD CUInt\n"); }
CULng           { printf("KEYWORD CULng\n"); }
CUShort         { printf("KEYWORD CUShort\n"); }
Date            { printf("KEYWORD Date\n"); }
Decimal         { printf("KEYWORD Decimal\n"); }
Declare         { printf("KEYWORD Declare\n"); }
Default         { printf("KEYWORD Default\n"); }
Delegate        { printf("KEYWORD Delegate\n"); }
Dim             { printf("KEYWORD Dim\n"); }
DirectCast      { printf("KEYWORD DirectCast\n"); }
Do              { printf("KEYWORD Do\n"); }
Double          { printf("KEYWORD Double\n"); }
Each            { printf("KEYWORD Each\n"); }
Else            { printf("KEYWORD Else\n"); }
ElseIf          { printf("KEYWORD ElseIf\n"); }
End[ ]+Class    { printf("KEYWORD End Class\n"); }
End[ ]+Enum     { printf("KEYWORD End Enum\n"); }
End[ ]+Function { printf("KEYWORD End Function\n"); }
End[ ]+Get      { printf("KEYWORD End Get\n"); }
End[ ]+If       { printf("KEYWORD End If\n"); }
End[ ]+Interface{ printf("KEYWORD End Interface\n"); }
End[ ]+Module   { printf("KEYWORD End Module\n"); }
End[ ]+Namespace{ printf("KEYWORD End Namespace\n"); }
End[ ]+Property { printf("KEYWORD End Property\n"); }
End[ ]+Select   { printf("KEYWORD End Select\n"); }
End[ ]+Set      { printf("KEYWORD End Set\n"); }
End[ ]+Structure{ printf("KEYWORD End Structure\n"); }
End[ ]+Sub      { printf("KEYWORD End Sub\n"); }
End[ ]+SyncLock { printf("KEYWORD End SyncLock\n"); }
End[ ]+Try      { printf("KEYWORD End Try\n"); }
End[ ]+While    { printf("KEYWORD End While\n"); }
End             { printf("KEYWORD End\n"); }
Erase           { printf("KEYWORD Erase\n"); }
Error           { printf("KEYWORD Error\n"); }
Event           { printf("KEYWORD Event\n"); }
Exit            { printf("KEYWORD Exit\n"); }
False           { printf("BOOLEAN False\n"); }
Finally         { printf("KEYWORD Finally\n"); }
For             { printf("KEYWORD For\n"); }
Friend          { printf("KEYWORD Friend\n"); }
Function        { printf("KEYWORD Function\n"); }
Get             { printf("KEYWORD Get\n"); }
GetType         { printf("KEYWORD GetType\n"); }
Global          { printf("KEYWORD Global\n"); }
GoSub           { printf("KEYWORD GoSub\n"); }
GoTo            { printf("KEYWORD GoTo\n"); }
Handles         { printf("KEYWORD Handles\n"); }
If              { printf("KEYWORD If\n"); }
Implements      { printf("KEYWORD Implements\n"); }
Imports         { printf("KEYWORD Imports\n"); }
In              { printf("KEYWORD In\n"); }
Inherits        { printf("KEYWORD Inherits\n"); }
Integer         { printf("KEYWORD Integer\n"); }
Interface       { printf("KEYWORD Interface\n"); }
Is              { printf("KEYWORD Is\n"); }
IsNot           { printf("KEYWORD IsNot\n"); }
Let             { printf("KEYWORD Let\n"); }
Like            { printf("KEYWORD Like\n"); }
Long            { printf("KEYWORD Long\n"); }
Loop            { printf("KEYWORD Loop\n"); }
Me              { printf("KEYWORD Me\n"); }
Mod             { printf("KEYWORD Mod\n"); }
Module          { printf("KEYWORD Module\n"); }
MustInherit     { printf("KEYWORD MustInherit\n"); }
MustOverride    { printf("KEYWORD MustOverride\n"); }
MyBase          { printf("KEYWORD MyBase\n"); }
MyClass         { printf("KEYWORD MyClass\n"); }
NameOf          { printf("KEYWORD NameOf\n"); }
Namespace       { printf("KEYWORD Namespace\n"); }
Narrowing       { printf("KEYWORD Narrowing\n"); }
New             { printf("KEYWORD New\n"); }
Next            { printf("KEYWORD Next\n"); }
Not             { printf("KEYWORD Not\n"); }
Nothing         { printf("NOTHING Nothing\n"); }
NotInheritable  { printf("KEYWORD NotInheritable\n"); }
NotOverridable  { printf("KEYWORD NotOverridable\n"); }
Object          { printf("KEYWORD Object\n"); }
Of              { printf("KEYWORD Of\n"); }
On              { printf("KEYWORD On\n"); }
Operator        { printf("KEYWORD Operator\n"); }
Option          { printf("KEYWORD Option\n"); }
Optional        { printf("KEYWORD Optional\n"); }
Or              { printf("KEYWORD Or\n"); }
OrElse          { printf("KEYWORD OrElse\n"); }
Overloads       { printf("KEYWORD Overloads\n"); }
Overrides       { printf("KEYWORD Overrides\n"); }
ParamArray      { printf("KEYWORD ParamArray\n"); }
Partial         { printf("KEYWORD Partial\n"); }
Private         { printf("KEYWORD Private\n"); }
Property        { printf("KEYWORD Property\n"); }
Protected       { printf("KEYWORD Protected\n"); }
Public          { printf("KEYWORD Public\n"); }
RaiseEvent      { printf("KEYWORD RaiseEvent\n"); }
ReadOnly        { printf("KEYWORD ReadOnly\n"); }
ReDim           { printf("KEYWORD ReDim\n"); }
RemoveHandler   { printf("KEYWORD RemoveHandler\n"); }
Resume          { printf("KEYWORD Resume\n"); }
Return          { printf("KEYWORD Return\n"); }
Select          { printf("KEYWORD Select\n"); }
Set             { printf("KEYWORD Set\n"); }
Shadows         { printf("KEYWORD Shadows\n"); }
Shared          { printf("KEYWORD Shared\n"); }
Short           { printf("KEYWORD Short\n"); }
Single          { printf("KEYWORD Single\n"); }
Static          { printf("KEYWORD Static\n"); }
Step            { printf("KEYWORD Step\n"); }
Stop            { printf("KEYWORD Stop\n"); }
String          { printf("KEYWORD String\n"); }
Structure       { printf("KEYWORD Structure\n"); }
Sub             { printf("KEYWORD Sub\n"); }
SyncLock        { printf("KEYWORD SyncLock\n"); }
Then            { printf("KEYWORD Then\n"); }
Throw           { printf("KEYWORD Throw\n"); }
To              { printf("KEYWORD To\n"); }
True            { printf("BOOLEAN True\n"); }
Try             { printf("KEYWORD Try\n"); }
TryCast         { printf("KEYWORD TryCast\n"); }
TypeOf          { printf("KEYWORD TypeOf\n"); }
UInteger        { printf("KEYWORD UInteger\n"); }
ULong           { printf("KEYWORD ULong\n"); }
UShort          { printf("KEYWORD UShort\n"); }
Using           { printf("KEYWORD Using\n"); }
When            { printf("KEYWORD When\n"); }
While           { printf("KEYWORD While\n"); }
Widening        { printf("KEYWORD Widening\n"); }
With            { printf("KEYWORD With\n"); }
WithEvents      { printf("KEYWORD WithEvents\n"); }
WriteOnly       { printf("KEYWORD WriteOnly\n"); }
Xor             { printf("KEYWORD Xor\n"); }

/* Operators */

\^      { printf("OPERATOR ^\n"); }
\*      { printf("OPERATOR *\n"); }
\\      { printf("OPERATOR \\\n"); }
\/      { printf("OPERATOR /\n"); }
\+      { printf("OPERATOR +\n"); }
\-      { printf("OPERATOR -\n"); }

\^=     { printf("OPERATOR ^=\n"); }
\*=     { printf("OPERATOR *=\n"); }
\+=     { printf("OPERATOR +=\n"); }
\-=     { printf("OPERATOR -=\n"); }

\<=     { printf("OPERATOR <=\n"); }
\<      { printf("OPERATOR <\n"); }
\>=     { printf("OPERATOR >=\n"); }
\>      { printf("OPERATOR >\n"); }
\=      { printf("OPERATOR =\n"); }
\<\>    { printf("OPERATOR <>\n"); }

\&=     { printf("OPERATOR &=\n"); }
\&      { printf("OPERATOR &\n"); }

\>\>=   { printf("OPERATOR >>=\n"); }
\<\<=   { printf("OPERATOR <<=\n"); }
\>\>    { printf("OPERATOR >>\n"); }
\<\<    { printf("OPERATOR <<\n"); }

\\=     { printf("OPERATOR \\\=\n"); }
\/=     { printf("OPERATOR /=\n"); }

/* Comments */

\'|REM {
    BEGIN(COMMENT);
    commentValue.clear();
}
<COMMENT>[^\n]+ {
    commentValue += yytext;
}
<COMMENT>\n {
    printf("COMMENT %s\n", commentValue.c_str());
    BEGIN(INITIAL);
}
<COMMENT><<EOF>> {
    printf("COMMENT %s\n", commentValue.c_str());
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
    printf("ERROR: String literal wasn't closed at line %d\n", yylineno - 1);
    BEGIN(INITIAL);
}
<STRING><<EOF>> {
    printf("ERROR: String literal wasn't closed at last line\n");
    yyterminate();
}
<STRING>\"[Cc] {
    if (stringValue.length() == 1) {
        printf("LITERAL CHAR %c\n", stringValue.at(0));
    } else {
        printf("ERROR: Char literal has more than 1 symbol at line %d\n", yylineno);
    }
    BEGIN(INITIAL);
}
<STRING>\" {
    printf("LITERAL STRING \"%s\"\n", stringValue.c_str());
    BEGIN(INITIAL);
}

/* Number literals */

{NUMBER}{INTEGER_SUFFIX}? {
    std::string message("LITERAL ");
    std::string lexeme(yytext);

    if (lexeme.ends_with("US") || lexeme.ends_with("UI") || lexeme.ends_with("UL")) {
        message += "UNSIGNED ";
    }
    
    if      (lexeme.ends_with("S")) { message += "SHORT "; }
    else if (lexeme.ends_with("L")) { message += "LONG "; }
    else if (lexeme.ends_with("I")) { message += "INTEGER "; }
    else                            { message += "INTEGER "; }

    printf("%s%s\n", message.c_str(), yytext);
}

&H{HEX_DIGIT}(\_*{HEX_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string message("LITERAL HEX ");
    std::string lexeme(yytext);

    if (lexeme.ends_with("US") || lexeme.ends_with("UI") || lexeme.ends_with("UL")) {
        message += "UNSIGNED ";
    }
    
    if      (lexeme.ends_with("S")) { message += "SHORT "; }
    else if (lexeme.ends_with("L")) { message += "LONG "; }
    else if (lexeme.ends_with("I")) { message += "INTEGER "; }
    else                            { message += "INTEGER "; }

    printf("%s%s\n", message.c_str(), yytext);
}

&O{OCT_DIGIT}(\_*{OCT_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string message("LITERAL OCT ");
    std::string lexeme(yytext);

    if (lexeme.ends_with("US") || lexeme.ends_with("UI") || lexeme.ends_with("UL")) {
        message += "UNSIGNED ";
    }

    if      (lexeme.ends_with("S")) { message += "SHORT "; }
    else if (lexeme.ends_with("L")) { message += "LONG "; }
    else if (lexeme.ends_with("I")) { message += "INTEGER "; }
    else                            { message += "INTEGER "; }

    printf("%s%s\n", message.c_str(), yytext);
}

&B{BIN_DIGIT}(\_*{BIN_DIGIT}*)*{INTEGER_SUFFIX}? {
    std::string message("LITERAL BIN ");
    std::string lexeme(yytext);

    if (lexeme.ends_with("US") || lexeme.ends_with("UI") || lexeme.ends_with("UL")) {
        message += "UNSIGNED ";
    }
    
    if      (lexeme.ends_with("S")) { message += "SHORT "; }
    else if (lexeme.ends_with("L")) { message += "LONG "; }
    else if (lexeme.ends_with("I")) { message += "INTEGER "; }
    else                            { message += "INTEGER "; }

    printf("%s%s\n", message.c_str(), yytext);
}

{NUMBER}(\.{NUMBER})?{EXPONENT}|{NUMBER}?\.{NUMBER}{EXPONENT}? {
    printf("LITERAL FLOATING POINT %s\n", yytext);
}

({NUMBER}(\.{NUMBER})?{EXPONENT}?|{NUMBER}?\.{NUMBER}{EXPONENT}?){FLOATING_POINT_SUFFIX} {
    std::string message("LITERAL ");
    std::string lexeme(yytext);
    
    if      (lexeme.ends_with("F") || lexeme.ends_with("f")) { message += "SINGLE "; }
    else if (lexeme.ends_with("D") || lexeme.ends_with("d")) { message += "DECIMAL "; }
    else if (lexeme.ends_with("R") || lexeme.ends_with("r")) { message += "DOUBLE "; }

    printf("%s%s\n", message.c_str(), yytext);
}

/* Identifiers */

\[{ID}\] {
    std::string lexeme(yytext);
    std::string id = lexeme.substr(1, lexeme.length() - 2);
    printf("ESCAPED IDENTIFIER %s\n", id.c_str());
}

{ID}{TYPE_CHAR}? {
    std::string message("IDENTIFIER ");
    std::string lexeme(yytext);
    std::string id(yytext);

    if      (lexeme.ends_with("%")) { message += "INTEGER "; }
    else if (lexeme.ends_with("&")) { message += "LONG "; }
    else if (lexeme.ends_with("@")) { message += "DECIMAL "; }
    else if (lexeme.ends_with("!")) { message += "SINGLE "; }
    else if (lexeme.ends_with("#")) { message += "DOUBLE "; }
    else if (lexeme.ends_with("$")) { message += "STRING "; }

    if (lexeme.ends_with("%") || lexeme.ends_with("&") || lexeme.ends_with("@") ||
            lexeme.ends_with("!") || lexeme.ends_with("#") || lexeme.ends_with("$")) {
        id = lexeme.substr(0, lexeme.length - 1);
    }

    printf("%s%s\n", message.c_str(), id.c_str());
}

/* Separators */

\(  { printf("SEPARATOR (\n"); }
\)  { printf("SEPARATOR )\n"); }
\{  { printf("SEPARATOR {\n"); }
\}  { printf("SEPARATOR }\n"); }
\?  { printf("SEPARATOR ?\n"); }
\.  { printf("SEPARATOR .\n"); }
\!  { printf("SEPARATOR !\n"); }
\,  { printf("SEPARATOR ,\n"); }
\:  { printf("SEPARATOR :\n"); }

/* Whitespaces */

[\r\t ]+            { }
[\r\t ]_[\r\t ]+\n+ { printf("LINE CONTINUATION _\n"); }
\n+                 { printf("END OF LINE %d\n", yylineno - 1); }

/* Other */

.       { printf("ERROR at line %d: %s\n", yylineno, yytext); }
<<EOF>> { yyterminate(); }

%%
