/* **********************************************
 * Duale Hochschule Baden-Württemberg Karlsruhe
 * Prof. Dr. Jörn Eisenbiegler
 * 
 * Vorlesung Übersetzerbau
 * Praxis X-Scanner mit JFlex
 * - Scanner-Definition
 * 
 * **********************************************
 */


package de.dhbw.compiler.jflexxscanner;

%%

%class JFlexXScanner
%type Token
%function nextToken


%unicode
%line
%column

%public
%final

%xstate INT, STR, FLOAT, FLOATCONST, INTCONST, STRINGCONST

%{
    StringBuffer textValue;
    int intValue;
    StringBuffer strValue;
    float floatValue;
%}

%eofval{
    return new Token(Token.EOF, "", yyline+1, yycolumn+1);
%eofval}

LETTER = [a-zA-Z]
DIGIT = [0-9]
NUMBER = 0 | [1-9] {DIGIT}*
ID = {LETTER} ({LETTER} | {DIGIT})*
FLOATCONST = \-? {NUMBER} \. {DIGIT}* ((e|E) -? {NUMBER})?
INTCONST = \-? {NUMBER}+
STRINGCONST = \" ({LETTER} | {DIGIT} | {OTHER})* \"
INT = int
STRING = string
FLOAT = float
OTHER = \ | \. | \: | \\ | \" \\
LSBR = \[
RSBR = \]
COMMA = \,
WS = [\ \t\b\f\r\n]+
DOT = \.
COLON = \:
SEMICOLON = \;
PLUS = \+
MINUS = \-
DIV = \/
MULT = \*
LESS = \<
EQUALS = \=
MORE = \>

%%

{WS}                    { /* eat whitespace */ }
\(                      { return new Token(Token.LBR, yytext(), yyline+1, yycolumn+1); }
\)                      { return new Token(Token.RBR, yytext(), yyline+1, yycolumn+1); }
\.                      { return new Token(Token.DOT, yytext(), yyline+1, yycolumn+1); }
\:                      { return new Token(Token.COLON, yytext(), yyline+1, yycolumn+1); }
\;                      { return new Token(Token.SEMICOLON, yytext(), yyline+1, yycolumn+1); }
\+                      { return new Token(Token.PLUS, yytext(), yyline+1, yycolumn+1); }
\-                      { return new Token(Token.MINUS, yytext(), yyline+1, yycolumn+1); }
\*                      { return new Token(Token.MULT, yytext(), yyline+1, yycolumn+1); }
\/                      { return new Token(Token.DIV, yytext(), yyline+1, yycolumn+1); }
\<                      { return new Token(Token.LESS, yytext(), yyline+1, yycolumn+1); }
\>                      { return new Token(Token.MORE, yytext(), yyline+1, yycolumn+1); }
\=                      { return new Token(Token.EQUALS, yytext(), yyline+1, yycolumn+1); }
\:\=                    { return new Token(Token.ASSIGN, yytext(), yyline+1, yycolumn+1); }
begin                   { return new Token(Token.BEGIN, yytext(), yyline+1, yycolumn+1); }
else                    { return new Token(Token.ELSE, yytext(), yyline+1, yycolumn+1); }
end                     { return new Token(Token.END, yytext(), yyline+1, yycolumn+1); }
for                     { return new Token(Token.FOR, yytext(), yyline+1, yycolumn+1); }
if                      { return new Token(Token.IF, yytext(), yyline+1, yycolumn+1); }
print                   { return new Token(Token.PRINT, yytext(), yyline+1, yycolumn+1); }
read                    { return new Token(Token.READ, yytext(), yyline+1, yycolumn+1); }
then                    { return new Token(Token.THEN, yytext(), yyline+1, yycolumn+1); }
while                   { return new Token(Token.WHILE, yytext(), yyline+1, yycolumn+1); }
program                 { return new Token(Token.PROGRAM, yytext(), yyline+1, yycolumn+1); }
{INT}                   { return new Token(Token.INT, yytext(), yyline+1, yycolumn+1); }
{STRING}                { return new Token(Token.STRING, yytext(), yyline+1, yycolumn+1); }
{FLOAT}                 { return new Token(Token.FLOAT, yytext(), yyline+1, yycolumn+1); }
{INTCONST}              { return new IntConstToken(Token.INTCONST, yytext(), yyline+1, yycolumn+1); }
{STRINGCONST}           { return new StringConstToken(Token.STRINGCONST, yytext(), yyline+1, yycolumn+1); }
{FLOATCONST}            { return new FloatConstToken(Token.FLOATCONST, yytext(), yyline+1, yycolumn+1); }
{ID}                    { return new Token(Token.ID, yytext(), yyline+1, yycolumn+1); }
{WS}                    { /* eat whitespace */ }
[^]						{ return new Token(Token.INVALID,  yytext(), yyline+1, yycolumn+1); }


/* Block für INTCONST-Token mit Typumwandlung */

[0-9]               { yybegin(INTCONST); numValue = yycharat(0)-'0';
                  textValue = new StringBuffer(); textValue.append(yytext()); }

<INTCONST>  {

    0/0             { yybegin(INTCONST); return new IntConstToken(Token.INTCONST, yytext(), yyline, yycolumn+1); }
}

[0-9]/\.            {yybegin(FLOATCONST); numvalue = yycharat(0)-'0';
                        textValue = new StringBuffer(); textValue.append(yytext()); }

{MINUS}      { yybegin(YYINITIAL); return new Token(Token.MINUS, yytext(), yyline+1, yycolumn+1); }

{DIGIT}/{LETTER}    { yybegin(YYINITIAL); return new Token(Token.INTCONST, yytext(), yyline+1, yycolumn+1); }



