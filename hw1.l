%{
    #include <stdio.h>
    #include "y.tab.h"
    int counter=1;
%}
%x comment
%%
"bool" return BOOL;
"char" return CHAR;
"int" return INT;
"real" return REAL;
"string" return STRING;
"intptr" return INTPTR;
"charptr" return CHARPTR;
"realptr" return REALPTR;
"if" return IF;
"else" return ELSE;
"while" return WHILE;
"for" return FOR;
"var" return VAR;
"func" return FUNC;
"proc" return PROC;
"return" return RETURN;
"null" return NULLL;

"&&" return AND;
"/" return DIVISION;
"=" return ASSIGN;
"==" return EQUAL;
">" return GREATER;
">=" return GREATEREQUAL;
"<" return LESS;
"<=" return LESSEQUAL;
"-" return MINUS;
"!" return NOT;
"!=" return NOTEQUAL;
"||" return OR;
"+" return PLUS;
"*" return MULTI;
"&" return ADDRESS;
"^" return DEREFERENCE;
"true" return BOOLTRUE;
"false" return BOOLFALSE;

";" return SEMICOLON;
":" return COLUMS;
"," return COMMA;
"|" return ABSUOLUT;
"{" return LEFTBRACE;
"}" return RIGHTBRACE;
"(" return LEFTPAREN;
")" return RIGHTPAREN;
"[" return LEFTBRACKET;
"]" return RIGHTBRACKET;
"%" return PRESENT;

"[\40\]" ;
"/%" BEGIN comment;
<comment>[^\n] ;
<comment>\n counter++;
<comment>"%/" BEGIN 0;
"Main" return MAIN;

[1-9][0-9]*|-?0 return INTEGER_CONST;
\-[1-9]+ return NEGATIVE_NUM;
[\'].[\'] return CHAR_CONST;
[\"].[\"] return STRING_CONST;
0x[0-9A-Fa-f]+|0Xx[0-9A-Fa-f]+ return HEX_CONST;
[1-9][0-9]*\.?[0-9]*([Ee][+-]?[0-9]+)? return REAL_CONST;
[a-zA-Z][a-zA-Z0-9_]* return ID;
\n counter++;
[ \t] ;
. ;
%%

