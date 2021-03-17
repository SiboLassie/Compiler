%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
     
    typedef struct node {
        char* token;
        struct node *left;
        struct node *middle; 
        struct node *right;
    }node;

    node *mknode(char *token,node *left,node *middle,node *right);

    void printtree(node *tree, int i);

    void yyerror(const char *s);

    int yylex();

    #define YYSTYPE struct node*
    extern char *yytext;

%}
%start start
%token MULTI DIVISION BOOL CHAR INT REAL STRING INTPTR CHARPTR REALPTR IF ELSE WHILE FOR VAR FUNC PROC RETURN ASSIGN AND EQUAL GREATER GREATEREQUAL LESS LESSEQUAL MINUS NOT NOTEQUAL OR PLUS ADDRESS DEREFERENCE ABSUOLUT NULLL SEMICOLON COLUMS COMMA NEGATIVE_NUM LEFTBRACE RIGHTBRACE LEFTBRACKET RIGHTBRACKET COOMMENT PRESENT MAIN BOOLTRUE LEFTPAREN RIGHTPAREN BOOLFALSE INTEGER_CONST CHAR_CONST REAL_CONST ID STRING_CONST HEX_CONST 
%right ASSIGN ELSE DIVISION
%left LEFTBRACE RIGHTBRACE LEFTPAREN RIGHTPAREN
%left EQUAL GREATER GREATEREQUAL LESSEQUAL LESS NOTEQUAL
%left PLUS MINUS AND OR 
%left MULTI 

%%
    start: Main                {printtree($1, 0);};

    Main: proc Main                                             {$$=mknode("CODE",$1,$2,NULL);}  
         |empty                                                 {$$=mknode("",$1,NULL,NULL);};
    
    exp: exp PLUS exp                                           {$$=mknode("+",$1,NULL,$3);}
        |exp MINUS exp                                          {$$=mknode("-",$1,NULL,$3);}
        |exp MULTI exp                                          {$$=mknode("*",$1,NULL,$3);}
        |exp DIVISION exp                                       {$$=mknode("/",$1,NULL,$3);}
        |exp AND exp                                            {$$=mknode("&&",$1,NULL,$3);}	
        |exp EQUAL exp                                          {$$=mknode("==",$1,NULL,$3);}	
        |exp GREATER exp                                        {$$=mknode(">",$1,NULL,$3);}	
        |exp GREATEREQUAL exp                                   {$$=mknode(">=",$1,NULL,$3);}	
        |exp LESS exp                                           {$$=mknode("<",$1,NULL,$3);}	
        |exp LESSEQUAL exp                                      {$$=mknode("<=",$1,NULL,$3);}	
        |exp NOTEQUAL exp                                       {$$=mknode("!=",$1,NULL,$3);}	
        |exp OR exp                                             {$$=mknode("||",$1,NULL,$3);}
        |exp ASSIGN exp                                         {$$=mknode("=",$1,NULL,$3);} 
        |abs exp abs                                            {$$=mknode($2->token,$1,NULL,$3);}
        |NOT AttrType                                           {$$=mknode("!",$2,NULL,NULL);}
        |AttrType
        |FuncActivation;

    exp2: exp PLUS exp                                          {$$=mknode("+",$1,NULL,$3);}
        |exp MINUS exp                                          {$$=mknode("-",$1,NULL,$3);}
        |exp MULTI exp                                          {$$=mknode("*",$1,NULL,$3);}
        |exp DIVISION exp                                       {$$=mknode("/",$1,NULL,$3);}
        |exp AND exp                                            {$$=mknode("&&",$1,NULL,$3);}	
        |exp EQUAL exp                                          {$$=mknode("==",$1,NULL,$3);}	
        |exp GREATER exp                                        {$$=mknode(">",$1,NULL,$3);}	
        |exp GREATEREQUAL exp                                   {$$=mknode(">=",$1,NULL,$3);}	
        |exp LESS exp                                           {$$=mknode("<",$1,NULL,$3);}	
        |exp LESSEQUAL exp                                      {$$=mknode("<=",$1,NULL,$3);}	
        |exp NOTEQUAL exp                                       {$$=mknode("!=",$1,NULL,$3);}	
        |exp OR exp                                             {$$=mknode("||",$1,NULL,$3);}
        |exp ASSIGN exp                                         {$$=mknode("=",$1,NULL,$3);} 
        |abs exp abs                                            {$$=mknode($2->token,$1,NULL,$3);}
        |NOT AttrType2                                          {$$=mknode("!",$2,NULL,NULL);}
        |AttrType2;


    AttrType2: INTEGER_CONST                                    {$$=mknode(yytext,NULL,NULL,NULL);}
             |CHAR_CONST                                        {$$=mknode(yytext,NULL,NULL,NULL);}
             |REAL_CONST                                        {$$=mknode(yytext,NULL,NULL,NULL);}
             |STRING_CONST                                      {$$=mknode(yytext,NULL,NULL,NULL);}
             |HEX_CONST                                         {$$=mknode(yytext,NULL,NULL,NULL);}
             |id arrNotEmptystring                              {$$=mknode($1->token,$2->left,$2->middle,$2->right);}
             |DEREFERENCE PossibleForDereference                {$$=mknode("^",$2,NULL,NULL);}
             |ADDRESS id                                        {$$=mknode("&",$2,NULL,NULL);}
             |NULLL                                             {$$=mknode(yytext,NULL,NULL,NULL);}
             |True	
             |False
             |NEGATIVE_NUM                                      {$$=mknode(yytext,NULL,NULL,NULL);}
             |id; 

    structOfCond:  For 
 	  	 	      |While    
	 	          |if       ;
  
    if: IF condition block else                                {$$=mknode("IF",$2,$3,$4);};

    AttrType: INTEGER_CONST                                    {$$=mknode(yytext,NULL,NULL,NULL);}
            |CHAR_CONST                                        {$$=mknode(yytext,NULL,NULL,NULL);}
            |REAL_CONST                                        {$$=mknode(yytext,NULL,NULL,NULL);}
            |STRING_CONST                                      {$$=mknode(yytext,NULL,NULL,NULL);}
            |HEX_CONST                                         {$$=mknode(yytext,NULL,NULL,NULL);}
            |id arrNotEmptystring                              {$$=mknode($1->token,$2->left,$2->middle,$2->right);}
            |DEREFERENCE PossibleForDereference                {$$=mknode("^",$2,NULL,NULL);}
            |ADDRESS PossibleForDereference                    {$$=mknode("&",$2,NULL,NULL);}
            |NULLL                                             {$$=mknode(yytext,NULL,NULL,NULL);}
            |True	
            |False
            |condition
            |NEGATIVE_NUM                                      {$$=mknode(yytext,NULL,NULL,NULL);}
            |id; 


    else: ELSE block                                           {$$=mknode("ELSE",NULL,$2,NULL);}
	    |empty;

    PossibleForDereference: condition
			                |id arrstring;

    While: WHILE condition block                               {$$=mknode("WHILE",$2,NULL,$3);};

    condition: leftParen exp rightParen                        {$$=mknode("",$1,$2,$3);};

    block: leftBrace BlockBody rightBrace                      {$$=mknode("BLOCK",$1,$2,$3);};

    For: FOR forCondition block                                {$$=mknode("FOR", $2, NULL, $3);};                      

    forCondition: leftParen inits SEMICOLON exp SEMICOLON update rightParen  {$$=mknode("", $2, $4, $6);};

    update:  exp PLUS exp                                      {$$=mknode("+",$1,NULL,$3);}
            |exp MINUS exp                                     {$$=mknode("-",$1,NULL,$3);};

    inits: varType id ASSIGN INTEGER_CONST                     {$$=mknode("", $1, mknode("=", $2, $3, $4) ,NULL);};

    abs: ABSUOLUT                                              {$$=mknode("|",NULL,NULL,NULL);};

    LeftBracket: LEFTBRACKET                                   {$$=mknode("[",NULL,NULL,NULL);};

    RightBracket: RIGHTBRACKET                                 {$$=mknode("]",NULL,NULL,NULL);};

    leftParen: LEFTPAREN                                       {$$=mknode("(",NULL,NULL,NULL);};

    rightParen: RIGHTPAREN                                     {$$=mknode(")",NULL,NULL,NULL);};

    leftBrace: LEFTBRACE                                       {$$=mknode("{",NULL,NULL,NULL);};

    rightBrace: RIGHTBRACE                                     {$$=mknode("}",NULL,NULL,NULL);};

    Declaration: VAR HelpDeclareMany arrstring SEMICOLON       {$$=mknode("",$2,$3,NULL);};

    HelpDeclareMany: id next_param_in_proc                     {$$=mknode("VAR",$1,$2,NULL);};

    arrstring: LeftBracket exp RightBracket                    {$$=mknode("",$1,$2,$3);}
                |empty;

    arrNotEmptystring: LeftBracket exp RightBracket            {$$=mknode("",$1,$2,$3);};

    id: ID                                               {$$=mknode(yytext,NULL,NULL,NULL);};

    varType: INT                                         {$$=mknode(yytext,NULL,NULL,NULL);}
            |BOOL                                        {$$=mknode(yytext,NULL,NULL,NULL);}
            |CHAR                                        {$$=mknode(yytext,NULL,NULL,NULL);}
            |STRING                                      {$$=mknode(yytext,NULL,NULL,NULL);}
            |REAL                                        {$$=mknode(yytext,NULL,NULL,NULL);}
            |REALPTR                                     {$$=mknode(yytext,NULL,NULL,NULL);}
            |INTPTR                                      {$$=mknode(yytext,NULL,NULL,NULL);}
            |CHARPTR                                     {$$=mknode(yytext,NULL,NULL,NULL);};

    FuncActivation: id leftParen args rightParen         {$$=mknode($1->token,$2,$3,$4);};

    args:   exp2 input                                   {$$=mknode($1->token,$2,NULL,NULL);}
            |empty                                       {$$=mknode($1->token,NULL,NULL,NULL);};


    input: COMMA exp2 input                              {$$=mknode(",",$2,$3,NULL);}
           |empty;


    empty:                                               {$$=mknode("",NULL,NULL,NULL);};

    return: returnBranch PossibleReturnValues SEMICOLON  {$$=mknode($1->token,$2,NULL,NULL);} ;

    returnInsideFuncDeclaration: returnBranch FuncType   {$$=mknode($1->token,$2,NULL,NULL);};

    returnBranch: RETURN                                 {$$=mknode("RET ",NULL,NULL,NULL);};

    Intval: INTEGER_CONST                                {$$=mknode(yytext,NULL,NULL,NULL);};

    Charval: CHAR_CONST                                  {$$=mknode(yytext,NULL,NULL,NULL);};

    Realval: REAL_CONST                                  {$$=mknode(yytext,NULL,NULL,NULL);};

    PossibleReturnValues: Intval
                          |Charval
                          |Realval
                          |id
                          |True
                          |False;

    proc: PROC id leftParen paramsList rightParen Problock {$$=mknode("PROC",mknode($2->token,$3,$4,$5),NULL,$6);}
         |FUNC id leftParen paramsList rightParen returnInsideFuncDeclaration Problock {$$=mknode("FUNC",mknode($2->token,$3,$4,$5),$6,$7);};


    FuncType: INT                                        {$$=mknode(yytext,NULL,NULL,NULL);}
              |BOOL                                      {$$=mknode(yytext,NULL,NULL,NULL);}
              |CHAR                                      {$$=mknode(yytext,NULL,NULL,NULL);}
              |REAL                                      {$$=mknode(yytext,NULL,NULL,NULL);}
              |REALPTR                                   {$$=mknode(yytext,NULL,NULL,NULL);}
              |INTPTR                                    {$$=mknode(yytext,NULL,NULL,NULL);}
              |CHARPTR                                   {$$=mknode(yytext,NULL,NULL,NULL);}
              |True
              |False;

    True: BOOLTRUE                                       {$$=mknode(yytext,NULL,NULL,NULL);};

    False: BOOLFALSE                                     {$$=mknode(yytext,NULL,NULL,NULL);};

    paramsList: startparamsList SEMICOLON paramsList     {$$=mknode("",$1,mknode(";",NULL,NULL,NULL),$3);}
	            |startparamsList			             {$$=mknode("",$1,NULL,NULL);}
	            |empty			            		     {$$=mknode("ARGS NONE",$1,NULL,NULL);};	

    startparamsList: id next_param_in_proc               {$$=mknode("ARGS",$1,$2,NULL);};

    next_param_in_proc: COMMA id next_param_in_proc      {$$=mknode(",",$2,$3,NULL);}
                        |COLUMS varType                  {$$=mknode(":",$2,NULL,NULL);};
    

    Problock: leftBrace Procbody rightBrace              {$$=mknode("",$1,$2,$3);};

    Procbody: BlockBody                                  {$$=mknode("BODY",$1,NULL,NULL);}
              |BlockBody return                          {$$=mknode(" ",$1,$2,NULL);};

    HelpToStatement: ProcStatement HelpToStatement       {$$=mknode("",$1,$2,NULL);}
                     |empty  		            	     {$$=mknode("",$1,NULL,NULL);};

    HelpToTheProcedure: proc HelpToTheProcedure          {$$=mknode("",$1,$2,NULL);}
                        |empty	        			     {$$=mknode("",$1,NULL,NULL);};

    HelpDeclare: Declaration HelpDeclare                 {$$=mknode("",$1,$2,NULL);}
                 |empty                                  {$$=mknode("",$1,NULL,NULL);};

    BlockBody: HelpToTheProcedure HelpDeclare HelpToStatement   {$$=mknode("",$1,$2,$3);};
   
    ProcStatement:   exp SEMICOLON                       {$$=mknode(";;", $1, NULL, NULL);}                       
                    |structOfCond
                    |proc SEMICOLON
                    |block    ;

%%
#include "lex.yy.c"

int main()
{
	return yyparse();
}

node *mknode(char *token, node *left, node *middle, node *right)
{
	node *newnode = (node*)malloc(sizeof(node));
	char *newstr = (char*)malloc(sizeof(token)+1);
	strcpy(newstr,token);
	newnode->left = left;
	newnode->middle = middle;
	newnode->right = right;
	newnode->token = newstr;
	return newnode;
}
void printtree(node *tree, int i)
{
    int iden;
    iden = i;
    if (!strcmp(tree->token, "CODE")) {
        iden = 1;
    }
    char *tmp = (char*)malloc(i+5);
    strcpy(tmp, "");
    for (int j=0; j<iden*4; j++) {
        strcat(tmp, " ");
    }
    if (!strcmp(tree->token, "CODE") || !strcmp(tree->token, "BODY")) {
        printf("%s%s", tree->token, tmp);
    } else if (!strcmp(tree->token, "VAR")) {
        strcat(tmp, "    ");
        printf("\n%s", tmp);
    } else if (!strcmp(tree->token, "PROC") || !strcmp(tree->token, "FUNC") ||!strcmp(tree->token, "ARGS") || !strcmp(tree->token, "FOR") || !strcmp(tree->token, "ARGS NONE")  || !strcmp(tree->token, "RET ")) {
        iden++;
        printf("\n%s%s\n", tmp, tree->token);
        strcat(tmp, "    ");
        printf("%s", tmp);
    } else if(!strcmp(tree->token, "IF")) { 
        iden++;
        printf("%s", tree->token);
        strcat(tmp, "    ");
        printf("\n%s", tmp);
    } else if (!strcmp(tree->token, "{")) {
        printf("\n%s", tmp);
    } else if (!strcmp(tree->token, ";;")) {
        strcat(tmp, "    ");
        printf("\n%s", tmp);
    } else if (!strcmp(tree->token, ")") || !strcmp(tree->token, "}") || !strcmp(tree->token, "BLOCK")) {
        for (int j=0; j<sizeof(tmp)/5; j++) {
            strcat(tmp, " ");
        }
        printf("\n%s", tmp);
        if (!strcmp(tree->token, "BLOCK")) {
            printf("%s", tree->token);
        }
    } else if (strcmp(tree->token, "CODE") && strcmp(tree->token, "("))
    	printf("%s ", tree->token);
	if(tree->left)
	    printtree(tree->left, iden);
	if(tree->middle)
	    printtree(tree->middle, iden);
	if(tree->right)
		printtree(tree->right, iden);
}

void yyerror(const char *str)
{
	printf("%s - %s in line:%d \n",str,yytext,counter);
}
//int yywrap() {return(1);}
