%{
	int counter=1;
%}
%x comment
%%
[ ]+ ;
"main" return MAIN;
"boolean" return BOOL;
"char" return CHAR;
"integer" return INT;
"string" return STRING;
"intptr" return INTPTR;
"charptr" return CHARPTR;
"if" return IF;
"else" return ELSE;
"while" return WHILE;
"var" return VAR;
"procedure" return PROCEDURE;
"return" return RETURN;
"true" return BOOLTRUE;
"false" return BOOLFALSE;
"null" return NULLL;
"=" return ASSIGN;
"&&" return AND;
\/ return DIVISION;
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
"|" return ABSUOLUT;
";" return SEMICOLON;
":" return COLUMS;
"," return COMMA;
"{" return LEFTBRACE;
"}" return RIGHTBRACE;
"(" return LEFTPAREN;
")" return RIGHTPAREN;
"[" return LEFTBRACKET;
"]" return RIGHTBRACKET;
"%" return PRESENT;
"[\40\]" ;
 /*\/%(\n|\r|\t)*[^%]*(\n\r\t)*\%\/ counter++;return COOMMENT*/
"/%" BEGIN comment;
<comment>[^\n] ;
<comment>\n counter++;
<comment>"%/" BEGIN 0;
[a-zA-Z][a-zA-Z0-9_]* return ID;
[1-9][0-9]*|-?0 return INTEGER_CONST;
\-[1-9]+ return NEGATIVE_NUM;
[\'].[\'] return CHAR_CONST;
[\"][^\"]*[\"] return STRING_CONST;
0x[0-9A-Fa-f]+|0Xx[0-9A-Fa-f]+ return HEX_CONST;
0[0-7]+ return OCTAL_CONST;
([01][01][01][01])+b return BINARY_CONST;
\n counter++;
[ \t] ;
. ;
%%
