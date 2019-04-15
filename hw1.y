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

    typedef struct Body {
        char* Things;
        struct Block* insiders;
        struct Argument* var_exp;
        struct Body* next;
    }Body; 

    typedef struct Block {
        float Num;
        struct TypeOfBlock *type;
        int WhoIsYourFather;
        struct Body* BlockBody;
        struct Block* next;
    }Block;

    typedef struct Program {
        struct Block* block;
        struct Program* next;
        int numOfProgram;
    }Program;

    typedef struct SymbolTable {
        char* name;
        char* kind;
        char* type;
    }SymbolTable;

    typedef struct TypeOfBlock {
        struct SymbolTable* SymbolTable;
        struct Argument* ArgumentOrCondition;
    }TypeOfBlock;

    typedef struct Argument {
        char* name;
        struct SymbolTable* Table;
        struct Argument* Next;
    }Argument;

    node *mknode(char *token,node *left,node *middle,node *right);

    void printtree(node *tree);

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
    start: Main                {printtree($1);};

    Main: proc Main            {$$=mknode("CODE\n",$1,$2,NULL);}  
         |empty                {$$=mknode("",$1,NULL,NULL);};

   // comment: DIVISION PRESENT ID ;
    
    exp: exp PLUS exp          {$$=mknode("+",$1,NULL,$3);}
        |exp MINUS exp         {$$=mknode("-",$1,NULL,$3);}
        |exp MULTI exp         {$$=mknode("*",$1,NULL,$3);}
        |exp DIVISION exp      {$$=mknode("/",$1,NULL,$3);}
        |exp AND exp           {$$=mknode("&&",$1,NULL,$3);}	
        |exp EQUAL exp         {$$=mknode("==",$1,NULL,$3);}	
        |exp GREATER exp       {$$=mknode(">",$1,NULL,$3);}	
        |exp GREATEREQUAL exp  {$$=mknode(">=",$1,NULL,$3);}	
        |exp LESS exp          {$$=mknode("<",$1,NULL,$3);}	
        |exp LESSEQUAL exp     {$$=mknode("<=",$1,NULL,$3);}	
        |exp NOTEQUAL exp      {$$=mknode("!=",$1,NULL,$3);}	
        |exp OR exp            {$$=mknode("||",$1,NULL,$3);}
        |exp ASSIGN exp        {$$=mknode("=",$1,NULL,$3);} 
        |abs exp abs           {$$=mknode($2->token,$1,NULL,$3);}
        |NOT AttrType          {$$=mknode("!",$2,NULL,NULL);}
        |AttrType
        |FuncActivation;

    exp2: exp PLUS exp           {$$=mknode("+",$1,NULL,$3);}
        |exp MINUS exp         {$$=mknode("-",$1,NULL,$3);}
        |exp MULTI exp         {$$=mknode("*",$1,NULL,$3);}
        |exp DIVISION exp      {$$=mknode("/",$1,NULL,$3);}
        |exp AND exp           {$$=mknode("&&",$1,NULL,$3);}	
        |exp EQUAL exp         {$$=mknode("==",$1,NULL,$3);}	
        |exp GREATER exp       {$$=mknode(">",$1,NULL,$3);}	
        |exp GREATEREQUAL exp  {$$=mknode(">=",$1,NULL,$3);}	
        |exp LESS exp          {$$=mknode("<",$1,NULL,$3);}	
        |exp LESSEQUAL exp     {$$=mknode("<=",$1,NULL,$3);}	
        |exp NOTEQUAL exp      {$$=mknode("!=",$1,NULL,$3);}	
        |exp OR exp            {$$=mknode("||",$1,NULL,$3);}
        |exp ASSIGN exp        {$$=mknode("=",$1,NULL,$3);} 
        |abs exp abs           {$$=mknode($2->token,$1,NULL,$3);}
        |NOT AttrType2          {$$=mknode("!",$2,NULL,NULL);}
        |AttrType2;

    AttrType2: INTEGER_CONST                                    {$$=mknode(yytext,NULL,NULL,NULL);}
             |CHAR_CONST                                        {$$=mknode(yytext,NULL,NULL,NULL);}
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

    structOfCond:  While 
 	  	 		 |for
	 	         |if;
  
    if: IF condition block else                                {$$=mknode("IF",$2,$3,$4);};

    AttrType: INTEGER_CONST                                    {$$=mknode(yytext,NULL,NULL,NULL);}
            |CHAR_CONST                                        {$$=mknode(yytext,NULL,NULL,NULL);}
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

    block: leftBrace BlockBody rightBrace                      {$$=mknode("\nBLOCK\n",$1,$2,$3);};

    for: FOR forCondition block           ;                      

    inits: varType ID EQUAL ID  ;

    updates: ID PLUS ID 
            |ID MINUS ID    ;

    forCondition: leftParen inits SEMICOLON exp SEMICOLON updates rightParen ;

    abs: ABSUOLUT                                              {$$=mknode("|",NULL,NULL,NULL);};

    LeftBracket: LEFTBRACKET                                   {$$=mknode("[",NULL,NULL,NULL);};

    RightBracket: RIGHTBRACKET                                 {$$=mknode("]",NULL,NULL,NULL);};

    leftParen: LEFTPAREN                                       {$$=mknode("(",NULL,NULL,NULL);};

    rightParen: RIGHTPAREN                                     {$$=mknode(")",NULL,NULL,NULL);};

    leftBrace: LEFTBRACE                                       {$$=mknode("\n",NULL,NULL,NULL);};

    rightBrace: RIGHTBRACE                                     {$$=mknode("}\n",NULL,NULL,NULL);};

    Declaration: VAR startparamsList arrstring SEMICOLON       {$$=mknode("var",$2,$3,NULL);};

    arrstring: LeftBracket exp RightBracket                    {$$=mknode("",$1,$2,$3);}
                |empty;

    arrNotEmptystring: LeftBracket exp RightBracket            {$$=mknode("",$1,$2,$3);};

    id: ID                                               {$$=mknode(strcat(yytext,"\n"),NULL,NULL,NULL);};

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
//            |id input                                  {$$=mknode($1->token,$2,NULL,NULL);}
            |empty                                       {$$=mknode($1->token,NULL,NULL,NULL);};

    input: COMMA exp2 input                              {$$=mknode(",",$2,$3,NULL);}
  ///         |COMMA id input                            {$$=mknode(",",$2,$3,NULL);}
           |empty;

    empty:                                               {$$=mknode("",NULL,NULL,NULL);};

    return: returnBranch PossibleReturnValues SEMICOLON  {$$=mknode($1->token,$2,NULL,NULL);} ;

    returnInsideFuncDeclaration: returnBranch FuncType   {$$=mknode($1->token,$2,NULL,NULL);};

    returnBranch: RETURN                                 {$$=mknode("RET",NULL,NULL,NULL);};

    Intval: INTEGER_CONST                                {$$=mknode(yytext,NULL,NULL,NULL);};

    Charval: CHAR_CONST                                  {$$=mknode(yytext,NULL,NULL,NULL);};

    PossibleReturnValues: Intval
                          |Charval
                          |id
                          |True
                          |False;

    proc: PROC id leftParen paramsList rightParen Problock {$$=mknode("PROC\n",mknode($2->token,$3,$4,$5),NULL,$6);}
         |FUNC id leftParen paramsList rightParen returnInsideFuncDeclaration Problock {$$=mknode("FUNC\n",mknode($2->token,$3,$4,$5),$6,$7);};

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

    startparamsList: id next_param_in_proc               {$$=mknode("ARGS ",$1,$2,NULL);};

    next_param_in_proc: COMMA id next_param_in_proc      {$$=mknode(",",$2,$3,NULL);}
                        |COLUMS varType                  {$$=mknode(":",$2,NULL,NULL);};
    
    Problock: leftBrace Procbody rightBrace              {$$=mknode("",$1,$2,$3);};

    Procbody: BlockBody                                  {$$=mknode("BODY\n",$1,NULL,NULL);}
              |BlockBody return                          {$$=mknode("BODY\n",$1,$2,NULL);} ; 

    HelpToStatement: ProcStatement HelpToStatement       {$$=mknode("",$1,$2,NULL);}
                     |empty  		            	     {$$=mknode("",$1,NULL,NULL);};

    HelpToTheProcedure: proc HelpToTheProcedure          {$$=mknode("",$1,$2,NULL);}
                        |empty	        			     {$$=mknode("",$1,NULL,NULL);};

    HelpDeclare: Declaration HelpDeclare                 {$$=mknode("",$1,$2,NULL);}
                 |empty                                  {$$=mknode("",$1,NULL,NULL);};

    BlockBody: HelpToTheProcedure HelpDeclare HelpToStatement   {$$=mknode("",$1,$2,$3);};   
   
    ProcStatement:   exp SEMICOLON 
                     |structOfCond
                     |block;
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

void printtree(node *tree)
{
    if(tree->token == " ") {
        return ;
    }
    // if i am { than \n
    // if i am ( then 
    // if i am } than 
    // if i am ) than 
    // if i am  '' than 
    //printf("(");

	printf("%s",tree->token);
	if(tree->left)
	    printtree(tree->left);
	if(tree->middle)
	    printtree(tree->middle);
	if(tree->right)
		printtree(tree->right);

    //printf(")");    
}

void yyerror(const char *str)
{
	printf("%s - %s in line:%d \n",str,yytext,counter);
}
//int yywrap() {return(1);}
