%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <limits.h>

    #define N 100

    typedef struct node {
        char* token;
        struct node *left;
        struct node *middle; 
        struct node *right;
    }node;

    typedef struct SymbolTable {
        char* name;
        char* kind;
        char* type;
        int count;
        int arr;
    }SymbolTable;

    typedef struct StackNode { 
        node* data;
        char* type; 
        struct StackNode* next; 
    }StackNode; 

    struct StackNode* newNode(node* data);
  
    int isEmpty(struct StackNode *root);
  
    void push(struct StackNode** root, node* data);
  
    node* pop(struct StackNode** root);
  
    node* peek(struct StackNode* root);

    //void checkScope2(node* scope, int mode);

    //void checkScope(node* scope, int mode);

    int checkType(char* token);

    char* getType(int index);

    int CheckCode(node *tree); 

    void printError(const char* err);

    SymbolTable *mksymboltable(char* name, char* kind, char* type);

    node *mknode(char *token,node *left,node *middle,node *right);

    SymbolTable mkidST(char *token);

    void printtree(node *tree, int i);

    void yyerror(const char *s);

    int yylex();

    int flag=0, mainFlag=0, sti=0, found=0, dupcheck=0, argscheck=0;

    SymbolTable* symbolTableArr[N];

    int* argsTypes;

    static int counterForBuilding=0;

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
    start: Main                                                 {flag=CheckCode($1); if(flag!=0) printtree($1,0); };

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
        |abs exp abs                                            {$$=mknode($2->token,$1,mknode("ABS",$2,NULL,NULL),$3);}
        |NOT AttrType                                           {$$=mknode("!",$2,NULL,NULL);}
        |AttrType                                               {$$=mknode("ATYPE",$1,$1,$1);}
        |FuncActivation                                         {$$=mknode("CALL",$1,NULL,NULL);};

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
        |abs exp abs                                            {$$=mknode($2->token,$1,mknode("ABS",$2,NULL,NULL),$3);}
        |NOT AttrType2                                          {$$=mknode("!",$2,NULL,NULL);}
        |AttrType2                                              {$$=mknode("ATYPE",$1,mknode($1->token,NULL,NULL,NULL),$1);};

    exp3: exp PLUS exp                                          {$$=mknode("+",$1,NULL,$3);}
        |exp MINUS exp                                          {$$=mknode("-",$1,NULL,$3);}
        |exp MULTI exp                                          {$$=mknode("*",$1,NULL,$3);}
        |exp DIVISION exp                                       {$$=mknode("/",$1,NULL,$3);}
        |NOT AttrType3                                          {$$=mknode("!",$2,NULL,NULL);}
        |AttrType3                                              {$$=mknode("ATYPE",$1,mknode($1->token,NULL,NULL,NULL),$1);};


    AttrType3: id arrNotEmptystring                              {$$=mknode($1->token,$2->left,$2->middle,$2->right);}
             |DEREFERENCE PossibleForDereference                {$$=mknode("^",$2,NULL,NULL);}
             |ADDRESS id                                        {$$=mknode("&",$2,NULL,NULL);}
             |NULLL                                             {$$=mknode(yytext,NULL,NULL,mknode("null",NULL,NULL,NULL));}
             |NEGATIVE_NUM                                      {$$=mknode(yytext,NULL,NULL,NULL);};


    AttrType2: INTEGER_CONST                                    {$$=mknode(yytext,NULL,mknode(yytext,NULL,NULL,NULL),mknode("int",NULL,NULL,NULL));}
             |CHAR_CONST                                        {$$=mknode(yytext,NULL,mknode(yytext,NULL,NULL,NULL),mknode("char",NULL,NULL,NULL));}
             |REAL_CONST                                        {$$=mknode(yytext,NULL,mknode(yytext,NULL,NULL,NULL),mknode("real",NULL,NULL,NULL));}
             |STRING_CONST                                      {$$=mknode("yytext",NULL,mknode(yytext,NULL,NULL,NULL),mknode("string",NULL,NULL,NULL));}
             |HEX_CONST                                         {$$=mknode(yytext,NULL,NULL,mknode("hex",NULL,NULL,NULL));}
             |id arrNotEmptystring                              {$$=mknode($1->token,$2->left,$2->middle,$2->right);}
             |DEREFERENCE PossibleForDereference                {$$=mknode("^",$2,NULL,NULL);}
             |ADDRESS id                                        {$$=mknode("&",$2,NULL,NULL);}
             |NULLL                                             {$$=mknode(yytext,NULL,NULL,mknode("null",NULL,NULL,NULL));}
             |True	
             |False
             |NEGATIVE_NUM                                      {$$=mknode(yytext,NULL,NULL,NULL);}
             |id                                                {$$=mknode("USEID",$1,mknode("",NULL,NULL,NULL),NULL);}; 

    structOfCond:  For 
 	  	 	      |While    
	 	          |if       ;
  
    if: IF condition block else                                {$$=mknode("IF",$2,$3,$4);};

    AttrType: INTEGER_CONST                                    {$$=mknode(yytext,NULL,mknode(yytext,NULL,NULL,NULL),mknode("int",NULL,NULL,NULL));}
            |CHAR_CONST                                        {$$=mknode(yytext,NULL,mknode(yytext,NULL,NULL,NULL),mknode("char",NULL,NULL,NULL));}
            |REAL_CONST                                        {$$=mknode(yytext,NULL,mknode(yytext,NULL,NULL,NULL),mknode("real",NULL,NULL,NULL));}
            |STRING_CONST                                      {$$=mknode("yytext",NULL,mknode(yytext,NULL,NULL,NULL),mknode("string",NULL,NULL,NULL));}
            |HEX_CONST                                         {$$=mknode(yytext,NULL,NULL,mknode("hex",NULL,NULL,NULL));}
            |id arrNotEmptystring                              {$$=mknode($1->token,$2->left,$2->middle,$2->right);}
            |DEREFERENCE PossibleForDereference                {$$=mknode("^",$2,NULL,NULL);}
            |ADDRESS PossibleForDereference                    {$$=mknode("&",$2,NULL,NULL);}
            |NULLL                                             {$$=mknode(yytext,NULL,NULL,mknode("null",NULL,NULL,NULL));}
            |True	
            |False
            |condition
            |NEGATIVE_NUM                                      {$$=mknode(yytext,NULL,NULL,NULL);}
            |id                                                {$$=mknode("USEID",$1,mknode("",NULL,NULL,NULL),NULL);}; 


    else: ELSE block                                           {$$=mknode("ELSE",NULL,$2,NULL);}
	    |empty;

    PossibleForDereference: condition
			                |id arrstring;

    While: WHILE condition block                               {$$=mknode("WHILE",$2,$3,$3);};

    condition: leftParen exp rightParen                        {$$=mknode("COND",$1,$2,$3);};

    conditionFor: exp                                          {$$=mknode("COND",NULL,$1,NULL);};

    block: leftBrace BlockBody rightBrace                      {$$=mknode("BLOCK",$1,$2,$3);};

    For: FOR forCondition block                                {$$=mknode("FOR", $2, NULL, $3);};                      

    forCondition: leftParen inits SEMICOLON conditionFor SEMICOLON update rightParen  {$$=mknode("", $2, $4, $6);};

    update:  exp ASSIGN exp                                         {$$=mknode("=",$1,NULL,$3);} 
            |exp PLUS exp                                      {$$=mknode("+",$1,NULL,$3);}
            |exp MULTI exp                                          {$$=mknode("*",$1,NULL,$3);}
            |exp DIVISION exp                                       {$$=mknode("/",$1,NULL,$3);}
            |exp MINUS exp                                     {$$=mknode("-",$1,NULL,$3);};

    inits: id ASSIGN INTEGER_CONST                     {$$=mknode("", $1, mknode(" = ", $1, $2, mknode(yytext,NULL,NULL,NULL) ) ,$3);};

    abs: ABSUOLUT                                              {$$=mknode("|",NULL,NULL,NULL);};

    LeftBracket: LEFTBRACKET                                   {$$=mknode("[",NULL,NULL,NULL);};

    RightBracket: RIGHTBRACKET                                 {$$=mknode("]",NULL,NULL,NULL);};

    leftParen: LEFTPAREN                                       {$$=mknode("(",NULL,NULL,NULL);};

    rightParen: RIGHTPAREN                                     {$$=mknode(")",NULL,NULL,NULL);};

    leftBrace: LEFTBRACE                                       {$$=mknode("{",NULL,NULL,NULL);};

    rightBrace: RIGHTBRACE                                     {$$=mknode("}",NULL,NULL,NULL);};

    Declaration: VAR HelpDeclareMany arrstring SEMICOLON       {$$=mknode("DEC",$2,NULL,NULL);};

    HelpDeclareMany: id arrstring next_param_in_proc           {$$=mknode("VAR",$1,$3,$2);};

    arrstring: LeftBracket exp RightBracket                    {$$=mknode("[]",$1,$2,$3);}
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

    FuncActivation: id leftParen args rightParen         {$$=mknode($1->token,$2,$3,$3);};

    args:   PossibleReturnValues input                   {$$=mknode("ARG",$2,NULL,$1);}
            |empty                                       {$$=mknode($1->token,NULL,NULL,NULL);};

    input: COMMA exp2 input                               {$$=mknode(",",$3,$3,$2);}
           |empty                                         {$$=NULL;};

    empty:                                               {$$=mknode("",NULL,NULL,NULL);};

    return: returnBranch PossibleReturnValues SEMICOLON  {$$=mknode($1->token,$2,NULL,NULL);} ;

    returnInsideFuncDeclaration: returnBranch FuncType   {$$=mknode($1->token,$2,NULL,NULL);};

    returnBranch: RETURN                                 {$$=mknode("RET ",NULL,NULL,NULL);};

    Intval: INTEGER_CONST                                {$$=mknode(yytext,NULL,NULL,mknode("int",NULL,NULL,NULL));};

    Charval: CHAR_CONST                                  {$$=mknode(yytext,NULL,NULL,mknode("char",NULL,NULL,NULL));};

    Realval: REAL_CONST                                  {$$=mknode(yytext,NULL,NULL,mknode("real",NULL,NULL,NULL));};

    PossibleReturnValues: Intval
                          |Charval
                          |Realval
                          |id
                          |True
                          |False
                          |exp3 ;

    proc: PROC id leftParen paramsList rightParen Problock {$$=mknode("PROC",mknode($2->token,$3,$4,$5),$6,$6);}
         |FUNC id leftParen paramsList rightParen returnInsideFuncDeclaration funcblock {$$=mknode("FUNC",mknode($2->token,$3,$4,$5),$6,$7);};


    FuncType: INT                                        {$$=mknode(yytext,NULL,NULL,NULL);}
              |BOOL                                      {$$=mknode(yytext,NULL,NULL,NULL);}
              |CHAR                                      {$$=mknode(yytext,NULL,NULL,NULL);}
              |REAL                                      {$$=mknode(yytext,NULL,NULL,NULL);}
              |REALPTR                                   {$$=mknode(yytext,NULL,NULL,NULL);}
              |INTPTR                                    {$$=mknode(yytext,NULL,NULL,NULL);}
              |CHARPTR                                   {$$=mknode(yytext,NULL,NULL,NULL);}
              |True
              |False;

    True: BOOLTRUE                                       {$$=mknode(yytext,$1,NULL,mknode("bool",NULL,NULL,NULL));};

    False: BOOLFALSE                                     {$$=mknode(yytext,$1,NULL,mknode("bool",NULL,NULL,NULL));};

    paramsList: startparamsList SEMICOLON paramsList     {$$=mknode("STARGS",$1,mknode(";",NULL,NULL,NULL),$3);}
	            |startparamsList			             {$$=mknode("STARGS",$1,NULL,NULL);}
	            |empty			            		     {$$=mknode("ARGS NONE",$1,NULL,NULL);};	

    startparamsList: id next_param_in_proc               {$$=mknode("ARGS",$1,$2,NULL);};

    next_param_in_proc: COMMA id next_param_in_proc      {$$=mknode("NEXTP",$2,$3,NULL);}
                        |COLUMS varType                  {$$=mknode(":",$2,NULL,NULL);};
    

    Problock: leftBrace Procbody rightBrace              {$$=mknode("{{",$1,$2,$3);};

    funcblock: leftBrace funcbody rightBrace              {$$=mknode("{{",$1,$2,$3);};

    Procbody: BlockBody                                  {$$=mknode("BODY",$1,NULL,NULL);};

    funcbody: BlockBody return                          {$$=mknode("BODY",$1,$2,NULL);};

    HelpToStatement: ProcStatement HelpToStatement       {$$=mknode("  ",$1,$2,NULL);}
                     |empty  		            	     {$$=mknode("",$1,NULL,NULL);};

    HelpToTheProcedure: proc HelpToTheProcedure          {$$=mknode("",$1,$2,NULL);}
                        |empty	        			     {$$=mknode("",$1,NULL,NULL);};

    HelpDeclare: Declaration HelpDeclare                 {$$=mknode("",$1,$2,NULL);}
                 |empty                                  {$$=mknode("",$1,NULL,NULL);};

    BlockBody: HelpToTheProcedure HelpDeclare HelpToStatement   {$$=mknode("",$1,$2,$3);};
   
    ProcStatement:   exp SEMICOLON                       {$$=mknode("EXPR", $1, NULL, NULL);}                       
                    |structOfCond                        {$$=mknode("SOCD", $1, NULL, NULL);}
                    |proc SEMICOLON
                    |block    ;

%%
#include "lex.yy.c"

int main()
{
	return yyparse();
}
 
struct StackNode* newNode(node* data) 
{ 
    struct StackNode* stackNode = (struct StackNode*) malloc(sizeof(struct StackNode)); 
    stackNode->data = data; 
    stackNode->next = NULL;
    stackNode->type = NULL; 
    return stackNode; 
} 
  
int isEmpty(struct StackNode *root) 
{ 
    return !root; 
} 
  
void push(struct StackNode** root, node* data) 
{ 
    struct StackNode* stackNode = newNode(data); 
    stackNode->next = *root; 
    *root = stackNode; 
    //printf(" pushed to stack\n"); 
} 
  
node* pop(struct StackNode** root) 
{ 
    if (isEmpty(*root)) 
        return NULL; 
    struct StackNode* temp = *root; 
    *root = (*root)->next; 
    node* popped = temp->data; 
    free(temp); 
  
    return popped; 
} 
  
node* peek(struct StackNode* root) 
{ 
    if (isEmpty(root)) 
        return NULL; 
    return root->data; 
}

int checkType(char* token) {
    if (!strcmp(token, "bool"))
        return 0;
    else if (!strcmp(token, "char"))
        return 1;
    else if (!strcmp(token, "int"))
        return 2;
    else if (!strcmp(token, "real"))
        return 3;
    else if (!strcmp(token, "string"))
        return 4;
    else if (!strcmp(token, "char*"))
        return 5;
    else if (!strcmp(token, "int*"))
        return 6;
    else if (!strcmp(token, "real*"))
        return 7;
    else return -1;
}

char* getType(int index) {
    char* typ;
    switch (index) {
        case 0:
            typ = "bool";
            return typ;
            break;
        case 1:
            typ = "char";
            return typ;
            break;
        case 2:
            typ = "int";
            return typ;
            break;
        case 3:
            typ = "real";
            return typ;
            break;
        case 4:
            typ = "string";
            return typ;
            break;  
        case 5:
            typ = "char*";
            return typ;
            break;
        case 6:
            typ = "int*";
            return typ;
            break;  
        case 7:
            typ = "real*";
            return typ;
            break;
        default :
            printError("Error! no such type!\n");
            exit(1);
            break;
    }
}

void iterativePreorder(node* root) 
{ 
    if (root == NULL) 
       return; 
  
    StackNode* nodeStack = NULL;
    push(&nodeStack, root); 
  
    while (1) 
    { 
        struct node* node = peek(nodeStack); 
        //printf ("%s\n ", node->token);
        if (!strcmp(node->token, "Main")){
            mainFlag++;
            if (strcmp(node->middle->token, "ARGS NONE")){
                mainFlag=-1;
                break;
            }
        }

    //     if (!strcmp(node->token, "BODY")){
    //         struct node* scope = node->left;
    //         checkScope(scope, 1);
    //         checkScope(scope, 2);
    //         checkScope(scope, 3);
    //         checkScope(scope, 4);
    //    //     checkScope(scope, 5);
    //         checkScope2(scope, 8);
    //         checkScope2(scope, 9);
    //         checkScope2(scope, 10);
    //         checkScope2(scope, 11);
    //         checkScope2(scope, 12);
    //         checkScope2(scope, 13);
    //         checkScope2(scope, 16);
    //         checkScope2(scope, 17);
    //         checkScope2(scope, 18);
    //         checkScope2(scope, 19);
    //         checkScope2(scope, 20);
    //         checkScope2(scope, 21);
    //         checkScope2(scope, 22);
    //         checkScope2(scope, 23);
    //     }
        
    //     if (!strcmp(node->token, "CODE")){
    //         struct node* scope = node->middle;
    //         checkScope(scope, 1);
    //         checkScope(scope, 2);
    //         checkScope(scope, 3);
    //         checkScope(scope, 4);
    //      //   checkScope(scope, 5);
    //         checkScope2(scope, 8);
    //         checkScope2(scope, 9);
    //         checkScope2(scope, 10);
    //         checkScope2(scope, 11);
    //         checkScope2(scope, 12);
    //         checkScope2(scope, 13);
    //         checkScope2(scope, 16);
    //         checkScope2(scope, 17);
    //         checkScope2(scope, 18);
    //         checkScope2(scope, 19);
    //         checkScope2(scope, 20);
    //         checkScope2(scope, 21);
    //         checkScope2(scope, 22);
    //         checkScope2(scope, 23);
    //     }

        pop(&nodeStack); 
  
        if (node->right) 
            push(&nodeStack, node->right);
        if (node->middle) 
            push(&nodeStack, node->middle);     
        if (node->left) 
            push(&nodeStack, node->left); 
        if (nodeStack==NULL)
            break; 
    }
 
} 

int CheckCode(node* tree)
{
    node* tmp;  
    tmp = tree;

    iterativePreorder(tree);
    
    free(*symbolTableArr);
    free(argsTypes);

    if (mainFlag>1) {
        printError("Error!, No more then 1 procedure of 'Main' is allowed!");
        return 0;
    }
    if (mainFlag==0){
        printError("Error!, must be at least 1 procedure of 'Main' in the code!");
        return 0;
    }
    if (mainFlag==-1){
        printError("Error!, No arguments to 'Main' is allowed!");
        return 0;
    }
    

    return 1;  
}

void printError(const char* err) {
    printf("%s", err);
    printf("\n");
}

SymbolTable *mksymboltable(char* name, char* kind, char* type)
{
	SymbolTable* newST = (SymbolTable*)malloc(sizeof(SymbolTable));
	char *newname = (char*)malloc(sizeof(name)+1);
	strcpy(newname,name);
	newST->name = newname;
    char *newkind = (char*)malloc(sizeof(kind)+1);
	strcpy(newkind,kind);
	newST->kind = newkind;
    char *newtype = (char*)malloc(sizeof(type)+1);
	strcpy(newtype,type);
	newST->type = newtype;
    newST->count=0;
    newST->arr=0;

	return newST;
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
    struct node* tmpn1, *tmpn2, *tmpn3, *tmpn0, *tmpn4, *tmpn5, *tmpn6, *tmpargs, *tmpelse, *tmpop, *tmpn7, *tmpn8, *tmpreturn, *retex1, *retex2, *tmpnB;
    char* tmp = "       ", *tmp2 = "   ";
    int tcount, funcFlag=0, degel=0, coolflag=0;
    if (!strcmp(tree->token, "PROC") || !strcmp(tree->token, "FUNC")) {
        if (!strcmp(tree->token, "FUNC")) {
            funcFlag=1;
            tmpreturn = tree->right->middle->middle->left;
            //printf("%s %s \n", tree->token, tmpreturn->token);
        }
        tcount=0;
        printf("%s:\n", tree->left->token);
        printf("%s BeginFunc\n", tmp);
        tmpnB = tree->right;
        
        tmpn1 = tmpnB->middle->left->right;
        
        while (!strcmp(tmpn1->token, "  ")) {
        //    funcFlag=0;
            tmpn2 = tmpn1->left;
            if (!strcmp(tmpn2->token, "EXPR")) {
                tmpn2 = tmpn2->left;
                if (!strcmp(tmpn2->token, "=")) {        
                    tmpn3 = tmpn2->left;
                    tmpn2 = tmpn2->right;
                    if (!strcmp(tmpn2->token, "ATYPE")) {
                        tmpn2 = tmpn2->left;
                        if (!strcmp(tmpn2->right->token, "int") || !strcmp(tmpn2->right->token, "real") || !strcmp(tmpn2->right->token, "char") || !strcmp(tmpn2->right->token, "string") || !strcmp(tmpn2->right->token, "bool")) {
                            printf("%s t%d = %s\n", tmp, tcount, tmpn2->token);        
                        }
                    }
                    //printf("%s \n",tmpn3->token);
                    if (!strcmp(tmpn3->token, "ATYPE")) {
                        tmpn3 = tmpn3->left;
                        if (!strcmp(tmpn3->token, "USEID")) {
                            tmpn3 = tmpn3->left;
                            printf("%s %s = t%d\n", tmp, tmpn3->token, tcount++);        
                        }
                    }
                }
            }//tmpn2 = tmpn1->left;
            else if (!strcmp(tmpn2->token, "SOCD")) { 
                tmpn2 = tmpn2->left;
                if (!strcmp(tmpn2->token, "IF")) {
                    tmpelse = tmpn2->right;
                    tmpn4 = tmpn2->middle->middle->right;
                    tmpn2 = tmpn2->left->middle;
                    
                    if (!strcmp(tmpn2->token, "==") || !strcmp(tmpn2->token, ">") || !strcmp(tmpn2->token, ">=") || !strcmp(tmpn2->token, "<") || !strcmp(tmpn2->token, "<=") || !strcmp(tmpn2->token, "!=")) {        
                        tmpn3 = tmpn2->left;
                        tmpn2 = tmpn2->right;
                        
                        if (!strcmp(tmpn2->token, "ATYPE")) {
                            tmpn2 = tmpn2->left;
                            if (!strcmp(tmpn2->right->token, "int") || !strcmp(tmpn2->right->token, "real") || !strcmp(tmpn2->right->token, "char") || !strcmp(tmpn2->right->token, "string") || !strcmp(tmpn2->right->token, "bool")) {
                                printf("%s t%d = %s\n", tmp, tcount++, tmpn2->token);        
                            }
                        }
                        //printf("%s \n",tmpn3->token);
                        if (!strcmp(tmpn3->token, "ATYPE")) {
                            tmpn3 = tmpn3->left;
                            if (!strcmp(tmpn3->token, "USEID")) {
                                tmpn3 = tmpn3->left;
                                printf("%s t%d = %s == t%d\n", tmp, tcount++, tmpn3->token, tcount-1);        
                                printf("%s ifz t%d Goto L%d\n", tmp, tcount-1, ++counterForBuilding);
                            }
                        }
                    }
                    tmpn0 = tmpn4;
                    while (!strcmp(tmpn0->token, "  ")) {
                        tmpn4 = tmpn0->left;
                        if (!strcmp(tmpn4->token, "EXPR")) {
                            tmpn4 = tmpn4->left;
                            if (!strcmp(tmpn4->token, "=")) {        
                                tmpn5 = tmpn4->left;
                                tmpn4 = tmpn4->right;
                                tmpn6 = tmpn4;
                                tmpn7 = tmpn4;
                                if (!strcmp(tmpn4->token, "ATYPE")) {
                                    tmpn4 = tmpn4->left;
                                    if (!strcmp(tmpn4->right->token, "int") || !strcmp(tmpn4->right->token, "real") || !strcmp(tmpn4->right->token, "char") || !strcmp(tmpn4->right->token, "string") || !strcmp(tmpn4->right->token, "bool")) {
                                        printf("%s t%d = %s\n", tmp, tcount, tmpn4->token);        
                                    }
                                }

                                if (!strcmp(tmpn6->token, "CALL")) {
                                    tmpn6 = tmpn6->left;
                                    tmpargs = tmpn6;
                                    tmpn6 = tmpn6->middle;
                                    while (!strcmp(tmpn6->token, "ARG")) {
                                        //printf("%s       \n", tmpn6->token);
                                        printf("%s t%d = %s\n", tmp, tcount++, tmpn6->right->token);
                                        printf("%s PushParam t%d\n", tmp, tcount-1);        
                                        if (tmpn6->left==NULL) {
                                            break;
                                        }
                                        tmpn6 = tmpn6->left;
                                    }
                                    printf("%s t%d = LCall %s\n", tmp, tcount, tmpargs->token);
                                    printf("%s PopParams %d\n", tmp, tcount);        
                                }
                                
                                if (!strcmp(tmpn7->token, "+") || !strcmp(tmpn7->token, "-") || !strcmp(tmpn7->token, "*") || !strcmp(tmpn7->token, "/")) {
                                    tmpop = tmpn7;
                                    tmpn7 = tmpop->left;
                                    tmpn8 = tmpop->right;
                                    if (!strcmp(tmpn7->token, "ATYPE")) {
                                        tmpn7 = tmpn7->left;
                                        if (!strcmp(tmpn7->token, "USEID")) {
                                            tmpn7 = tmpn7->left;
                                        }    
                                    }
                                    if (!strcmp(tmpn8->token, "ATYPE")) {
                                        tmpn8 = tmpn8->left;
                                        if (!strcmp(tmpn8->token, "USEID")) {
                                            tmpn8 = tmpn8->left;
                                        }    
                                    }
                                    printf("%s t%d = %s %s %s\n", tmp, tcount, tmpn7->token, tmpop->token, tmpn8->token);
                                }
                                
                                if (!strcmp(tmpn5->token, "ATYPE")) {
                                    tmpn5 = tmpn5->left;
                                    if (!strcmp(tmpn5->token, "USEID")) {
                                        tmpn5 = tmpn5->left;
                                        printf("%s %s = t%d\n", tmp, tmpn5->token, tcount++);        
                                    }
                                }
                            }
                        }
                        tmpn0 = tmpn0->middle;
                    }
                    printf("%s Goto L%d\n", tmp, counterForBuilding+1);
                    if (!strcmp(tmpelse->token, "ELSE")) {
                        tmpelse = tmpelse->middle->middle->right;
                        tmpn0 = tmpelse;
                        while (!strcmp(tmpn0->token, "  ")) {
                            tmpn4 = tmpn0->left;
                            if (!strcmp(tmpn4->token, "EXPR")) {
                                tmpn4 = tmpn4->left;
                                if (!strcmp(tmpn4->token, "=")) {        
                                    tmpn5 = tmpn4->left;
                                    tmpn4 = tmpn4->right;
                                    if (!strcmp(tmpn4->token, "ATYPE")) {
                                        tmpn4 = tmpn4->left;
                                        if (!strcmp(tmpn4->right->token, "int") || !strcmp(tmpn4->right->token, "real") || !strcmp(tmpn4->right->token, "char") || !strcmp(tmpn4->right->token, "string") || !strcmp(tmpn4->right->token, "bool")) {
                                            printf("%s L%d: t%d = %s\n", tmp2, counterForBuilding, tcount, tmpn4->token);        
                                        }
                                    }
                                    //printf("%s \n",tmpn3->token);
                                    if (!strcmp(tmpn5->token, "ATYPE")) {
                                        tmpn5 = tmpn5->left;
                                        if (!strcmp(tmpn5->token, "USEID")) {
                                            tmpn5 = tmpn5->left;
                                            printf("%s %s = t%d\n", tmp, tmpn5->token, tcount++);        
                                        }
                                    }
                                }
                            }
                            tmpn0 = tmpn0->middle;
                        }
                    }
                }
                else if (!strcmp(tmpn2->token, "WHILE")) {
                    tmpn4 = tmpn2->middle->middle->right;
                    tmpn2 = tmpn2->left->middle;
                    degel=0;
                    if (!strcmp(tmpn2->token, "==") || !strcmp(tmpn2->token, ">") || !strcmp(tmpn2->token, ">=") || !strcmp(tmpn2->token, "<") || !strcmp(tmpn2->token, "<=") || !strcmp(tmpn2->token, "!=")) {        
                        tmpelse = tmpn2;
                        tmpn3 = tmpn2->left;
                        tmpn2 = tmpn2->right;
                        
                        if (!strcmp(tmpn2->token, "ATYPE")) {
                            tmpn2 = tmpn2->left;
                            if (tmpn2->right!=NULL) {
                                if (!strcmp(tmpn2->right->token, "int") || !strcmp(tmpn2->right->token, "real") || !strcmp(tmpn2->right->token, "char") || !strcmp(tmpn2->right->token, "string") || !strcmp(tmpn2->right->token, "bool")) {
                                    //printf("%s t%d = %s\n", tmp, tcount++, tmpn2->token);
                                    counterForBuilding++;
                                    printf("%s L%d: t%d = %s\n", tmp2, ++counterForBuilding, tcount++, tmpn2->token);                
                                
                                } 
                            } else if (!strcmp(tmpn2->token, "USEID")) {
                                    tmpn2 = tmpn2->left;
                                    degel=1;
                            }
                            
                        }
                        if (!strcmp(tmpn3->token, "ATYPE")) {
                            tmpn3 = tmpn3->left;
                            if (tmpn2->right!=NULL) {
                                if (!strcmp(tmpn2->right->token, "int") || !strcmp(tmpn2->right->token, "real") || !strcmp(tmpn2->right->token, "char") || !strcmp(tmpn2->right->token, "string") || !strcmp(tmpn2->right->token, "bool")) {
                                    //printf("%s t%d = %s\n", tmp, tcount++, tmpn2->token);
                                    counterForBuilding++;
                                    printf("%s L%d: t%d = %s\n", tmp2, ++counterForBuilding, tcount++, tmpn2->token);                
                                
                                } 
                            } else if (!strcmp(tmpn3->token, "USEID")) {
                                tmpn3 = tmpn3->left;
                                if (degel==0) {
                                    printf("%s t%d = %s %s t%d\n", tmp, tcount++, tmpn3->token, tmpelse->token, tcount-1);        
                                } else printf("%s t%d = %s %s %s\n", tmp, tcount++, tmpn3->token, tmpelse->token, tmpn2->token);        
                                
                                printf("%s ifz t%d Goto L%d\n", tmp, tcount-1, ++counterForBuilding);
                            }
                        }
                    }
                    tmpn0 = tmpn4;
                    while (!strcmp(tmpn0->token, "  ")) {
                        tmpn4 = tmpn0->left;
                        if (!strcmp(tmpn4->token, "EXPR")) {
                            tmpn4 = tmpn4->left;
                            if (!strcmp(tmpn4->token, "=")) {        
                                tmpn5 = tmpn4->left;
                                tmpn4 = tmpn4->right;
                                tmpn6 = tmpn4;
                                tmpn7 = tmpn4;
                                if (!strcmp(tmpn4->token, "ATYPE")) {
                                    tmpn4 = tmpn4->left;
                                    if (!strcmp(tmpn4->right->token, "int") || !strcmp(tmpn4->right->token, "real") || !strcmp(tmpn4->right->token, "char") || !strcmp(tmpn4->right->token, "string") || !strcmp(tmpn4->right->token, "bool")) {
                                        printf("%s t%d = %s\n", tmp, tcount, tmpn4->token);        
                                    }
                                }
                                //printf("%s \n",tmpn6->token);
                                if (!strcmp(tmpn6->token, "CALL")) {
                                    tmpn6 = tmpn6->left;
                                    tmpargs = tmpn6;
                                    tmpn6 = tmpn6->middle;
                                    while (!strcmp(tmpn6->token, "ARG")) {
                                        //printf("%s       \n", tmpn6->token);
                                        printf("%s t%d = %s\n", tmp, tcount++, tmpn6->right->token);
                                        printf("%s PushParam t%d\n", tmp, tcount-1);        
                                        if (tmpn6->left==NULL) {
                                            break;
                                        }
                                        tmpn6 = tmpn6->left;
                                    }
                                    printf("%s t%d = LCall %s\n", tmp, tcount, tmpargs->token);
                                    printf("%s PopParams %d\n", tmp, tcount);        
                                }
                                
                                if (!strcmp(tmpn7->token, "+") || !strcmp(tmpn7->token, "-") || !strcmp(tmpn7->token, "*") || !strcmp(tmpn7->token, "/")) {
                                    tmpop = tmpn7;
                                    tmpn7 = tmpop->left;
                                    tmpn8 = tmpop->right;
                                    if (!strcmp(tmpn7->token, "ATYPE")) {
                                        tmpn7 = tmpn7->left;
                                        if (!strcmp(tmpn7->token, "USEID")) {
                                            tmpn7 = tmpn7->left;
                                        }    
                                    }
                                    if (!strcmp(tmpn8->token, "ATYPE")) {
                                        tmpn8 = tmpn8->left;
                                        if (!strcmp(tmpn8->token, "USEID")) {
                                            tmpn8 = tmpn8->left;
                                        }    
                                    }
                                    printf("%s t%d = %s %s %s\n", tmp, tcount, tmpn7->token, tmpop->token, tmpn8->token);
                                }
                                if (!strcmp(tmpn5->token, "ATYPE")) {
                                    tmpn5 = tmpn5->left;
                                    if (!strcmp(tmpn5->token, "USEID")) {
                                        tmpn5 = tmpn5->left;
                                        printf("%s %s = t%d\n", tmp, tmpn5->token, tcount);
                                        tcount++;
                                    }
                                }
                            }
                        }
                        tmpn0 = tmpn0->middle;
                    }
                    printf("%s Goto L%d\n", tmp, counterForBuilding-1);    
                    printf("%s L%d: ", tmp2, counterForBuilding);      
                }
                else if (!strcmp(tmpn2->token, "FOR")) {
                    
                    tmpn4 = tmpn2;
                    tmpn2 = tmpn2->left->left->middle;
                    degel=0;
                    if (!strcmp(tmpn2->token, " = ") ) {
                        tmpn3 = tmpn2->right;
                        tmpn2 = tmpn2->left;
                        printf("%s t%d = %s\n", tmp, tcount, tmpn3->token);
                        printf("%s %s = t%d\n", tmp, tmpn2->token, tcount++);
                    }
                    tmpn2 = tmpn4->left->middle->middle;

                    if (!strcmp(tmpn2->token, "==") || !strcmp(tmpn2->token, ">") || !strcmp(tmpn2->token, ">=") || !strcmp(tmpn2->token, "<") || !strcmp(tmpn2->token, "<=") || !strcmp(tmpn2->token, "!=")) {        
                        tmpelse = tmpn2;
                        tmpn3 = tmpn2->left;
                        tmpn2 = tmpn2->right;
                        
                        if (!strcmp(tmpn2->token, "ATYPE")) {
                            tmpn2 = tmpn2->left;
                            if (tmpn2->right!=NULL) {
                                if (!strcmp(tmpn2->right->token, "int") || !strcmp(tmpn2->right->token, "real") || !strcmp(tmpn2->right->token, "char") || !strcmp(tmpn2->right->token, "string") || !strcmp(tmpn2->right->token, "bool")) {
                                    //printf("%s t%d = %s\n", tmp, tcount++, tmpn2->token);
                                    counterForBuilding++;
                                    printf("%s t%d = %s\n", tmp, tcount, tmpn2->token);                
                                
                                } 
                            } else if (!strcmp(tmpn2->token, "USEID")) {
                                    tmpn2 = tmpn2->left;
                                    degel=1;
                            }
                            
                        }
                        if (!strcmp(tmpn3->token, "ATYPE")) {
                            tmpn3 = tmpn3->left;
                          
                            if (!strcmp(tmpn3->token, "USEID")) {
                                tmpn3 = tmpn3->left;
                                if (degel==0) {
                                    printf("%s L%d: t%d = %s %s t%d\n", tmp2, ++counterForBuilding, tcount-1, tmpn3->token, tmpelse->token, tcount);        
                                } else printf("%s L%d: t%d = %s %s %s\n", tmp2, ++counterForBuilding, tcount++, tmpn3->token, tmpelse->token, tmpn2->token);        
                                
                                printf("%s ifz t%d Goto L%d\n", tmp, tcount-1, ++counterForBuilding);
                            }
                        }

                    }
                    tmpn2 = tmpn4->left->right;
                    
                    if (!strcmp(tmpn2->token, "=") ) {
                        printf("%s t%d = %s\n", tmp, ++tcount, tmpn2->left->left->left->token );        
                        tmpn2 = tmpn2->right;
                    }
                    if (!strcmp(tmpn2->token, "+") || !strcmp(tmpn2->token, "-") || !strcmp(tmpn2->token, "*") || !strcmp(tmpn2->token, "/")) {
                            tmpop = tmpn2;
                            tmpn7 = tmpop->left;
                            tmpn8 = tmpop->right;
                            if (!strcmp(tmpn7->token, "ATYPE")) {
                                tmpn7 = tmpn7->left;
                                if (!strcmp(tmpn7->token, "USEID")) {
                                    tmpn7 = tmpn7->left;
                                }    
                            }
                            if (!strcmp(tmpn8->token, "ATYPE")) {
                                tmpn8 = tmpn8->left;
                                if (!strcmp(tmpn8->token, "USEID")) {
                                    tmpn8 = tmpn8->left;
                                }   
                            }
                        printf("%s %s = t%d = %s %s %s\n", tmp, tmpn7->token, tcount++, tmpn7->token, tmpop->token, tmpn8->token);
                    }

                    tmpn0 = tmpn4->right->middle->right;
                    while (!strcmp(tmpn0->token, "  ")) {
                        coolflag=0;
                        tmpn4 = tmpn0->left;
                        if (!strcmp(tmpn4->token, "EXPR")) {
                            tmpn4 = tmpn4->left;
                            if (!strcmp(tmpn4->token, "=")) {        
                                tmpn5 = tmpn4->left;
                                tmpn4 = tmpn4->right;
                                tmpn6 = tmpn4;
                                tmpn7 = tmpn4;
                                if (!strcmp(tmpn4->token, "ATYPE")) {
                                    tmpn4 = tmpn4->left;
                                    if (!strcmp(tmpn4->right->token, "int") || !strcmp(tmpn4->right->token, "real") || !strcmp(tmpn4->right->token, "char") || !strcmp(tmpn4->right->token, "string") || !strcmp(tmpn4->right->token, "bool")) {
                                        printf("%s t%d = %s\n", tmp, tcount, tmpn4->token);        
                                    }
                                }
                                //printf("%s \n",tmpn6->token);
                                if (!strcmp(tmpn6->token, "CALL")) {
                                    coolflag=1;
                                    tmpn6 = tmpn6->left;
                                    tmpargs = tmpn6;
                                    tmpn6 = tmpn6->middle;
                                    while (!strcmp(tmpn6->token, "ARG")) {                                        
                                        printf("%s t%d = %s\n", tmp, tcount++, tmpn6->right->token);
                                        printf("%s PushParam t%d\n", tmp, tcount-1);        
                                        if (tmpn6->left==NULL) {
                                            break;
                                        }
                                        tmpn6 = tmpn6->left;
                                    }
                                    printf("%s t%d = LCall %s\n", tmp, tcount, tmpargs->token);
                                    printf("%s PopParams %d\n", tmp, tcount--);        
                                }
                                
                                if (!strcmp(tmpn7->token, "+") || !strcmp(tmpn7->token, "-") || !strcmp(tmpn7->token, "*") || !strcmp(tmpn7->token, "/")) {
                                    tmpop = tmpn7;
                                    tmpn7 = tmpop->left;
                                    tmpn8 = tmpop->right;
                                    if (!strcmp(tmpn7->token, "ATYPE")) {
                                        tmpn7 = tmpn7->left;
                                        if (!strcmp(tmpn7->token, "USEID")) {
                                            tmpn7 = tmpn7->left;
                                        }    
                                    }
                                    if (!strcmp(tmpn8->token, "ATYPE")) {
                                        tmpn8 = tmpn8->left;
                                        if (!strcmp(tmpn8->token, "USEID")) {
                                            tmpn8 = tmpn8->left;
                                        }    
                                    }
                                    if (!strcmp(tmpn8->token, "CALL")) {
                                        coolflag=1;
                                        tmpn6 = tmpn6->left;
                                        tmpargs = tmpn6;
                                        tmpn6 = tmpn6->middle;
                                        //printf("%s %s = t%d \n", tmp, tmpargs->left->left->token, tcount);
                                        while (!strcmp(tmpn6->token, "ARG")) {                                        
                                            printf("%s t%d = %s\n", tmp, ++tcount, tmpn6->right->token);
                                            printf("%s PushParam t%d\n", tmp, tcount-1);        
                                            if (tmpn6->left==NULL) {
                                                break;
                                            }
                                            tmpn6 = tmpn6->left;
                                        }
                                        printf("%s t%d = LCall %s\n", tmp, tcount++, tmpn8->left->token);
                                        printf("%s PopParams %d \n", tmp, 2);
                                        printf("%s t%d = %s %s t%d\n", tmp, tcount, tmpn7->token, tmpop->token, tcount-1);
                                        coolflag=1;
                                        tcount--;       
                                    }
                                    else printf("%s t%d = %s %s %s\n", tmp, ++tcount, tmpn7->token, tmpop->token, tmpn8->token);
                                }
                                if (!strcmp(tmpn5->token, "ATYPE")) {
                                    tmpn5 = tmpn5->left;
                                    if (!strcmp(tmpn5->token, "USEID")) {
                                        tmpn5 = tmpn5->left;
                                        if (coolflag == 1) {
                                            printf("%s %s = t%d\n", tmp, tmpn5->token, ++tcount);
                                            }
                                        else  {
                                            
                                            printf("%s %s = t%d\n", tmp, tmpn5->token, tcount);
                                        }
                                            
                                    }
                                }
                            }
                        }
                        tmpn0 = tmpn0->middle;
                    }
                    printf("%s Goto L%d\n", tmp, counterForBuilding-1);    
                    printf("%s L%d: ", tmp2, counterForBuilding);      
                }
            }
            tmpn1 = tmpn1->middle;
        }
        if (funcFlag==1) {
            if (!strcmp(tmpreturn->token, "+") || !strcmp(tmpreturn->token, "-") || !strcmp(tmpreturn->token, "*") || !strcmp(tmpreturn->token, "/") ) {
                retex1 = tmpreturn->left;
                retex2 = tmpreturn->right;
                if (!strcmp(retex1->token, "ATYPE")) {
                    retex1 = retex1->left;
                    if (!strcmp(retex1->token, "USEID")) {
                       retex1 = retex1->left;
                    }
                }
                if (!strcmp(retex2->token, "ATYPE")) {
                    retex2 = retex2->left;
                    if (!strcmp(retex2->token, "USEID")) {
                       retex2 = retex2->left;
                    }
                }
                printf("%s Return  %s %s %s\n", tmp2, retex1->token, tmpreturn->token, retex2->token);
            } else 
                printf("%s L%d: Return %s\n", tmp2, counterForBuilding+1, tmpreturn->token);        
        }
        printf("%s EndFunc\n", tmp);
    }
    int iden;
    iden = i;
   
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

char* GetToken(node* s)
{
	return s->token;
}
