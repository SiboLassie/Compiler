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
        int count;
        int arr;
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

    typedef struct StackNode 
    { 
        node* data; 
        struct StackNode* next; 
    }StackNode; 

    struct StackNode* newNode(node* data);
  
    int isEmpty(struct StackNode *root);
  
    void push(struct StackNode** root, node* data);
  
    node* pop(struct StackNode** root);
  
    node* peek(struct StackNode* root);

    void checkScope2(node* scope, int mode);

    void checkScope(node* scope, int mode);

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

    static float counterForBuilding=0.0;

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
    start: Main                                                 {flag=CheckCode($1); if(flag==1) printtree($1,0);};

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
        |AttrType                                               {$$=mknode("ATYPE",$1,NULL,NULL);}
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
        |AttrType2                                              {$$=mknode("ATYPE",$1,$1,NULL);};


    AttrType2: INTEGER_CONST                                    {$$=mknode(yytext,NULL,NULL,mknode("int",NULL,NULL,NULL));}
             |CHAR_CONST                                        {$$=mknode(yytext,NULL,NULL,mknode("char",NULL,NULL,NULL));}
             |REAL_CONST                                        {$$=mknode(yytext,NULL,NULL,mknode("real",NULL,NULL,NULL));}
             |STRING_CONST                                      {$$=mknode("yytext",NULL,NULL,mknode("string",NULL,NULL,NULL));}
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

    AttrType: INTEGER_CONST                                    {$$=mknode(yytext,NULL,NULL,mknode("int",NULL,NULL,NULL));}
            |CHAR_CONST                                        {$$=mknode(yytext,NULL,NULL,mknode("char",NULL,NULL,NULL));}
            |REAL_CONST                                        {$$=mknode(yytext,NULL,NULL,mknode("real",NULL,NULL,NULL));}
            |STRING_CONST                                      {$$=mknode("yytext",NULL,NULL,mknode("string",NULL,NULL,NULL));}
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

    While: WHILE condition block                               {$$=mknode("WHILE",$2,NULL,$3);};

    condition: leftParen exp rightParen                        {$$=mknode("COND",$1,$2,$3);};

    conditionFor: exp                                          {$$=mknode("COND",NULL,$1,NULL);};

    block: leftBrace BlockBody rightBrace                      {$$=mknode("BLOCK",$1,$2,$3);};

    For: FOR forCondition block                                {$$=mknode("FOR", $2, NULL, $3);};                      

    forCondition: leftParen inits SEMICOLON conditionFor SEMICOLON update rightParen  {$$=mknode("", $2, $4, $6);};

    update:  exp PLUS exp                                      {$$=mknode("+",$1,NULL,$3);}
            |exp MINUS exp                                     {$$=mknode("-",$1,NULL,$3);};

    inits: varType id ASSIGN INTEGER_CONST                     {$$=mknode("", $1, mknode(" = ", $2, $3, $4) ,NULL);};

    abs: ABSUOLUT                                              {$$=mknode("|",NULL,NULL,NULL);};

    LeftBracket: LEFTBRACKET                                   {$$=mknode("[",NULL,NULL,NULL);};

    RightBracket: RIGHTBRACKET                                 {$$=mknode("]",NULL,NULL,NULL);};

    leftParen: LEFTPAREN                                       {$$=mknode("(",NULL,NULL,NULL);};

    rightParen: RIGHTPAREN                                     {$$=mknode(")",NULL,NULL,NULL);};

    leftBrace: LEFTBRACE                                       {$$=mknode("{",NULL,NULL,NULL);};

    rightBrace: RIGHTBRACE                                     {$$=mknode("}",NULL,NULL,NULL);};

    Declaration: VAR HelpDeclareMany SEMICOLON                 {$$=mknode("DEC",$2,NULL,NULL);};

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

    FuncActivation: id leftParen args rightParen         {$$=mknode($1->token,$2,$3,$4);};

    args:   exp2 input                                   {$$=mknode($1->token,$2,NULL,$1);}
            |empty                                       {$$=mknode($1->token,NULL,NULL,NULL);};


    input: COMMA exp2 input                              {$$=mknode(",",$2,$3,NULL);}
           |empty                                        {$$=NULL;};


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
                          |False;

    proc: PROC id leftParen paramsList rightParen Problock {$$=mknode("PROC",mknode($2->token,$3,$4,$5),NULL,$6);}
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
    

    Problock: leftBrace Procbody rightBrace              {$$=mknode("",$1,$2,$3);};

    funcblock: leftBrace funcbody rightBrace              {$$=mknode("",$1,$2,$3);};

    Procbody: BlockBody                                  {$$=mknode("BODY",$1,NULL,NULL);};

    funcbody: BlockBody return                          {$$=mknode(" ",$1,$2,NULL);};

    HelpToStatement: ProcStatement HelpToStatement       {$$=mknode("",$1,$2,NULL);}
                     |empty  		            	     {$$=mknode("",$1,NULL,NULL);};

    HelpToTheProcedure: proc HelpToTheProcedure          {$$=mknode("",$1,$2,NULL);}
                        |empty	        			     {$$=mknode("",$1,NULL,NULL);};

    HelpDeclare: Declaration HelpDeclare                 {$$=mknode("",$1,$2,NULL);}
                 |empty                                  {$$=mknode("",$1,NULL,NULL);};

    BlockBody: HelpToTheProcedure HelpDeclare HelpToStatement   {$$=mknode("",$1,$2,$3);};
   
    ProcStatement:   exp SEMICOLON                       {$$=mknode("EXPR", $1, NULL, NULL);}                       
                    |structOfCond
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

void checkScope2(node* scope, int mode) {
    
    if (scope == NULL) 
       return; 
  
    StackNode* scopeStack = NULL;
    push(&scopeStack, scope); 
    int indexer=0, indexer2=0, indexer3=0, tmpcount=0, isBool=0, cheker=0;
    struct node* funcTyp, *retVal, *varVal, *condVal, *lexp, *rexp;
    switch(mode) {    
            case 8:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    struct node* tempn, *tempn2, *tempn3;
                    indexer=0, indexer2=0;
                    if (!strcmp(node->token, "PROC")){
                        for (int j=0; j<sti; j++) {
                            if (!strcmp(node->left->token, symbolTableArr[j]->name) && !strcmp("Procedure", symbolTableArr[j]->kind) ) {
                                tmpcount=symbolTableArr[j]->count;
                            }
                        }
                        argsTypes =  malloc(tmpcount*sizeof(int));
                        for (int j=0; j<tmpcount; j++) {
                            argsTypes[j]=0;
                        }
                        if (!strcmp(node->left->middle->token, "STARGS")){
                            tempn = node->left->middle;
                            tempn2 = tempn;
                            while (!strcmp(tempn->token, "STARGS")) {
                                tempn2 = tempn;
                                tempn = tempn->left;
                                if (!strcmp(tempn->token, "ARGS")){
                                    tempn = tempn->middle;
                                    tempn3 = tempn;
                                    if (!strcmp(tempn3->token, "NEXTP")) {
                                        while (strcmp(tempn3->token, ":")) {                                            
                                                tempn3 = tempn3->middle;
                                        }
                                    }
                                    argsTypes[indexer2] = checkType(tempn3->left->token);
                                    indexer2++;                              
                                    if (!strcmp(tempn->token, "NEXTP")){
                                        indexer++;
                                        while (strcmp(tempn->token, ":")) {
                                            tempn = tempn->middle;
                                            if (checkType(tempn->left->token) == -1) {
                                                argsTypes[indexer2] = checkType(tempn3->left->token);    
                                            } 
                                            else 
                                                argsTypes[indexer2] = checkType(tempn->left->token);
                                            indexer++;
                                            indexer2++;
                                        }
                                    } else indexer++;
                                }
                                if (tempn2->middle != NULL) {
                                    tempn = tempn2->right;
                                    indexer =0;   
                                }
                            }
                        }
                    }
                    else if (!strcmp(node->token, "FUNC")){
                        for (int j=0; j<sti; j++) {
                            if (!strcmp(node->left->token, symbolTableArr[j]->name) && !strcmp("Function", symbolTableArr[j]->kind) ) {
                                tmpcount=symbolTableArr[j]->count;
                            }
                        }
                        argsTypes =  malloc(tmpcount*sizeof(int));
                        for (int j=0; j<tmpcount; j++) {
                            argsTypes[j]=0;
                        }
                        if (!strcmp(node->left->middle->token, "STARGS")){
                            tempn = node->left->middle;
                            tempn2 = tempn;
                            while (!strcmp(tempn->token, "STARGS")) {
                                tempn2 = tempn;
                                tempn = tempn->left;
                                if (!strcmp(tempn->token, "ARGS")){
                                    tempn = tempn->middle;
                                    tempn3 = tempn;
                                    if (!strcmp(tempn3->token, "NEXTP")) {
                                        while (strcmp(tempn3->token, ":")) {                                            
                                                tempn3 = tempn3->middle;
                                        }
                                    }
                                    argsTypes[indexer2] = checkType(tempn3->left->token);
                                    indexer2++;                              
                                    if (!strcmp(tempn->token, "NEXTP")){
                                        indexer++;
                                        while (strcmp(tempn->token, ":")) {
                                            tempn = tempn->middle;
                                            if (checkType(tempn->left->token) == -1) {
                                                argsTypes[indexer2] = checkType(tempn3->left->token);    
                                            } 
                                            else 
                                                argsTypes[indexer2] = checkType(tempn->left->token);
                                            indexer++;
                                            indexer2++;
                                        }
                                    } else indexer++;
                                }
                                if (tempn2->middle != NULL) {
                                    tempn = tempn2->right;
                                    indexer =0;   
                                }
                            }
                        }

                    }
                    else if (!strcmp(node->token, "CALL")){
                        indexer=0;
                        if (tmpcount == 0) {
                            break;
                        } else if (tmpcount == 1 ) {
                            tempn = node->left->middle->right->left->right;
                            if (checkType(tempn->token) != argsTypes[0]) {
                                printf("Error! %s expect argument of type %s but argument has type %s\n" , node->left->token, getType(argsTypes[0]), tempn->token);
                                printError("\n");
                                exit(1);
                            }
                        } else if (tmpcount > 1 ) {
                            tempn = node->left->middle->right->left->right;
                            if (checkType(tempn->token) != argsTypes[0]) {
                                printf("Error! %s expect argument of type %s but argument has type %s\n" , node->left->token, getType(argsTypes[0]), tempn->token);
                                printError("\n");
                                exit(1);
                            }
                            tempn2 = node->left->middle->left;
                            tempn=tempn2;
                            while (!strcmp(tempn2->token, ",")) {
                                
                                tempn = tempn2->left->left->right;
                                if (checkType(tempn->token) != argsTypes[++indexer]) {
                                    printf("Error! %s expect argument of type %s but given argument has type of %s\n" , node->left->token, getType(argsTypes[indexer]), tempn->token);
                                    printError("\n");
                                    exit(1);
                                }
                                if (tempn2->middle == NULL) {
                                    break;
                                }
                                else tempn2 = tempn2->middle;
                            }
                        }
                    
                    }
                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                return;
                break;       

            case 9:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    
                    indexer=0;
                    if (!strcmp(node->token, "FUNC")){
                        retVal = node->right->middle->middle->left->right;
                        
                        funcTyp = node->middle->left;
                        // printf("type: %s  \n", funcTyp->token);
                        // printf("retVal: %s \n", retVal->token);
                        if (strcmp(retVal->token, funcTyp->token)) {
                            printf("Error! The Function %s return type is %s but the return value has type of %s\n" , node->left->token, funcTyp->token, retVal->token);
                            printError("\n");
                            exit(1);
                        }
                    }
                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;

            case 10:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer=0, indexer2=0;
                    if (!strcmp(node->token, "=")){
                        varVal = node->left;
                        if (!strcmp(varVal->token, "ATYPE")){
                            varVal = varVal->left;
                            if (!strcmp(varVal->token, "USEID")){
                                varVal = varVal->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                            indexer=j;
                                        }
                                    }
                                }  
                            }   
                        }
                        funcTyp = node->right;
                        if (!strcmp(funcTyp->token, "CALL")){
                            funcTyp = funcTyp->left;
                            for(int j=0; j<sti; j++) {
                                if ( !strcmp(symbolTableArr[j]->kind, "Function")) {
                                    if (!strcmp(funcTyp->token, symbolTableArr[j]->name)) {
                                        indexer2=j;
                                    }
                                }
                            }  
                        } else break;
                        if (strcmp(symbolTableArr[indexer]->type, symbolTableArr[indexer2]->type)) {
                            printf("Error! Function %s type is '%s' but '%s' has type of '%s'\n" , symbolTableArr[indexer2]->name, symbolTableArr[indexer2]->type, symbolTableArr[indexer]->name, symbolTableArr[indexer]->type);
                            printError("\n");
                            exit(1);
                        }
                    }
                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;
            case 11:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer=0, indexer2=0, isBool=0;

                    if (node->left != NULL){
                        if (!strcmp(node->left->token, "COND")){
                            funcTyp = node; 
                        }
                    }
                    if (!strcmp(node->token, "FOR")){
                        funcTyp = node; 
                        node = node->left->middle;            
                    }
                    if (!strcmp(node->token, "COND")){
                        condVal = node->middle;

                        if (!strcmp(condVal->token, "==") || !strcmp(condVal->token, ">") || !strcmp(condVal->token, ">=") || !strcmp(condVal->token, "<") || !strcmp(condVal->token, "<=") || !strcmp(condVal->token, "!=")){
                            isBool=1;
                        }
                        if (!strcmp(condVal->token, "ATYPE")){
                            condVal = condVal->left;
                            if (condVal->right != NULL){
                                if (!strcmp(condVal->right->token, "int")){
                                    isBool=1;
                                }
                            }
                            if ( !strcmp(condVal->token, "true") || !strcmp(condVal->token, "false") ){
                                isBool=1;    
                            }                         
                            if (!strcmp(condVal->token, "USEID")){
                                varVal = condVal->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                            if (!strcmp(symbolTableArr[j]->type, "bool")) {
                                                isBool=1;  
                                            }
                                        }
                                    }
                                }  
                            }   
                        }
                        
                        if (isBool==0) {
                            printf("Error! The Condition in '%s' statment must be of boolean type \n", funcTyp->token );
                            printError("\n");
                            exit(1);
                        }
                    }
                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;    
            case 12:
                 while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer=0, indexer2=0, isBool=0;

                    if (node->left != NULL){
                        if (!strcmp(node->left->token, "[")){
                            varVal = node->middle; 
                            indexer=0;
                            if (!strcmp(varVal->token, "ATYPE")){
                                varVal = varVal->left;
                                if (varVal->right != NULL){
                                    if (!strcmp(varVal->right->token, "int")){                                
                                        indexer=1;
                                    }
                                    if (!strcmp(varVal->token, "USEID")){
                                        varVal = varVal->left;
                                        for(int j=0; j<sti; j++) {
                                            if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                                if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                                    if (!strcmp(symbolTableArr[j]->type, "int")) {
                                                        indexer=1;
                                                    }
                                                }
                                            }
                                        }  
                                    }   
                                }
                            }
                            if (indexer==0) {
                                printf("Error! The index parameter inside '[]' place must be of type 'int' \n");
                                printError("\n");
                                exit(1);
                            }
                        }
                    }

                    node = peek(scopeStack); 
                    if (node != NULL) {
                        if (!strcmp(node->token, "VAR")){
                            if (node->right != NULL) {
                                if (!strcmp(node->right->token, "[]")){
                                    indexer2=0;                    
                                    varVal = node->middle;
                                    while (strcmp(varVal->token, ":")){
                                        if (varVal->middle != NULL) {
                                            varVal = varVal->middle;
                                            if (!strcmp(varVal->token, ":")){ 
                                                break;
                                            }
                                        }
                                    }
                                    varVal = varVal->left;
                                    if (!strcmp(varVal->token, "string")){
                                        indexer2=1;
                                    }
                                    if (indexer2==0) {
                                        printf("Error! The '[]' operator is available only for 'string' type \n");
                                        printError("\n");
                                        exit(1);
                                    }   
                                    
                                }
                            }   
                        }
                    }
                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;    
            case 13:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer=0, indexer2=0;
                    if (!strcmp(node->token, "=")){
                        varVal = node->left;
                        if (!strcmp(varVal->token, "ATYPE")){
                            varVal = varVal->left;
                            if (!strcmp(varVal->token, "USEID")){
                                varVal = varVal->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                            indexer=j;
                                        }
                                    }
                                }  
                            }   
                        }
                        if (!strcmp("string", symbolTableArr[indexer]->type)){
                            if (symbolTableArr[indexer]->arr==1) {
                                symbolTableArr[indexer]->type = "char";
                            }
                        }

                        condVal = node->right;
                        if (!strcmp(condVal->token, "ATYPE")){
                            condVal = condVal->left;
                            if (condVal->right != NULL) {
                                condVal = condVal->right;
                            }
                        } else break;
                        indexer2=0;
                        if (!strcmp("int*", symbolTableArr[indexer]->type) || !strcmp("char*", symbolTableArr[indexer]->type) || !strcmp("real*", symbolTableArr[indexer]->type)) {
                            if (!strcmp("null", condVal->token)){
                                condVal->token = symbolTableArr[indexer]->type;
                            }
                            if (!strcmp(condVal->token, "&") || !strcmp(condVal->token, "^")) {
                                cheker=1;
                            }
                        }
                                               
                        if (!strcmp(symbolTableArr[indexer]->type, "int")) {
                            cheker=0;
                            if (!strcmp(condVal->token, "|")) {
                                cheker=1;
                            }
                        }
                        if (!strcmp(condVal->token, "&")) {
                            cheker=1;
                            if (strcmp(symbolTableArr[indexer]->type, "int*") && strcmp(symbolTableArr[indexer]->type, "real*") && strcmp(symbolTableArr[indexer]->type, "char*")) {
                                printf("Error! Variable '%s' define type is '%s' but assign value has address for pointers only!\n" , symbolTableArr[indexer]->name, symbolTableArr[indexer]->type);
                                printError("\n");
                                exit(1);
                            }
                        } 
                        if (!strcmp(condVal->token, "^")) {
                            cheker=1;
                            if (strcmp(symbolTableArr[indexer]->type, "int") && strcmp(symbolTableArr[indexer]->type, "real") && strcmp(symbolTableArr[indexer]->type, "char")) {
                                printf("Error! Variable '%s' define type is '%s' but assign value of pointers to variable only!\n" , symbolTableArr[indexer]->name, symbolTableArr[indexer]->type);
                                printError("\n");
                                exit(1);
                            }
                        }
                        if (cheker==0) {
                            if (strcmp(symbolTableArr[indexer]->type, condVal->token)) {
                                printf("Error! Variable '%s' define type is '%s' but assign value has type of '%s'\n" , symbolTableArr[indexer]->name, symbolTableArr[indexer]->type, condVal->token);
                                printError("\n");
                                exit(1);
                            }
                        }
                    }
                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;
            
            case 16:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer2=0;
                    if (!strcmp(node->token, "=")){
                        varVal = node->left;
                        if (!strcmp(varVal->token, "ATYPE")){
                            varVal = varVal->left;
                            if (!strcmp(varVal->token, "USEID")){
                                varVal = varVal->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                            indexer=j;
                                        }
                                    }
                                }  
                            }   
                        }
                    }
                    node = peek(scopeStack);
                    if (!strcmp(node->token, "+") || !strcmp(node->token, "-") || !strcmp(node->token, "*") || !strcmp(node->token, "/")){
                        lexp = node->left;
                        rexp = node->right;
                        cheker=0;
                        if (!strcmp(lexp->token, "ATYPE")){
                            lexp = lexp->left;
                           if (lexp->right!=NULL) {
                               
                               if (!strcmp(lexp->right->token, "int") || !strcmp(lexp->right->token, "real")) {
                                   lexp = lexp->right;
                               }
                               else {
                                   cheker=1;
                                   lexp = lexp->right;
                               }
                           }
                        }
                        if (!strcmp(rexp->token, "ATYPE")){
                            rexp = rexp->left;
                           if (rexp->right!=NULL) {
                               if (!strcmp(rexp->right->token, "int") || !strcmp(rexp->right->token, "real")) {
                                   rexp = rexp->right;
                               } 
                               else {
                                   cheker=2;
                                   rexp = rexp->right;
                               }
                           }
                        }
                        if (cheker == 1) {
                            printf("Error!  '%s' operator is available for type of int or real not '%s' \n" ,node->token, lexp->token);
                            printError("\n");
                            exit(1);
                        }
                        if (cheker == 2) {
                            printf("Error!  '%s' operator is available for type of int or real not '%s' \n" ,node->token, rexp->token);
                            printError("\n");
                            exit(1);
                        }
                        if (!strcmp(lexp->token, rexp->token)) {
                            if (!strcmp(lexp->token, "int")) {
                                cheker=3;
                            } else cheker=5;
                        } else cheker = 6;                        
                        if (cheker==3) {
                            if (strcmp(symbolTableArr[indexer]->type, "int")) {
                                cheker=4;
                            }
                        } 
                        if (cheker == 4 ) {
                            printf("Error! Variable '%s' type is '%s' and the result of '%s' oprerator is of type 'int'\n" ,symbolTableArr[indexer]->name,symbolTableArr[indexer]->type, node->token);
                            printError("\n");
                            exit(1);
                        }
                        if (!strcmp(symbolTableArr[indexer]->type, "int") && cheker>=5) {
                            printf("Error! Variable %s type is '%s' but assign value has type of 'real'\n" , symbolTableArr[indexer]->name, symbolTableArr[indexer]->type);
                            printError("\n");
                             exit(1);
                        }
                        if (strcmp(symbolTableArr[indexer]->type, "real") && strcmp(symbolTableArr[indexer]->type, "int")) {
                            printf("Error! Variable %s type is '%s' but assign value has type of 'real'\n" , symbolTableArr[indexer]->name, symbolTableArr[indexer]->type);
                            printError("\n");
                             exit(1);
                        }
                    }
                    


                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;
            case 17:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer2=0;
                    if (!strcmp(node->token, "=")){
                        varVal = node->left;
                        if (!strcmp(varVal->token, "ATYPE")){
                            varVal = varVal->left;
                            if (!strcmp(varVal->token, "USEID")){
                                varVal = varVal->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                            indexer=j;
                                        }
                                    }
                                }  
                            }   
                        }
                    }
                    node = peek(scopeStack);
                    if (!strcmp(node->token, "&&") || !strcmp(node->token, "||") ){
                        lexp = node->left;
                        rexp = node->right;
                        cheker=0;
                        if (!strcmp(lexp->token, "ATYPE")){
                            lexp = lexp->left;
                           if (lexp->right!=NULL) {
                               
                               if (!strcmp(lexp->right->token, "bool") ) {
                                   lexp = lexp->right;
                               }
                               else {
                                   cheker=1;
                                   lexp = lexp->right;
                               }
                           }
                        }
                        if (!strcmp(rexp->token, "ATYPE")){
                            rexp = rexp->left;
                           if (rexp->right!=NULL) {
                               if (!strcmp(rexp->right->token, "bool")) {
                                   rexp = rexp->right;
                               } 
                               else {
                                   cheker=2;
                                   rexp = rexp->right;
                               }
                           }
                        }
                        if (cheker == 1) {
                            printf("Error!  '%s' operator is available for type 'bool' only! not '%s' \n" ,node->token, lexp->token);
                            printError("\n");
                            exit(1);
                        }
                        if (cheker == 2) {
                            printf("Error!  '%s' operator is available for type 'bool' only! not '%s' \n" ,node->token, rexp->token);
                            printError("\n");
                            exit(1);
                        }
                        if (strcmp(symbolTableArr[indexer]->type, "bool")) {
                            printf("Error! Variable %s type is '%s' but assign value has type of 'bool'\n" , symbolTableArr[indexer]->name, symbolTableArr[indexer]->type);
                            printError("\n");
                             exit(1);
                        }
                    }
                    


                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;
            case 18:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer2=0;
                    if (!strcmp(node->token, "=")){
                        varVal = node->left;
                        if (!strcmp(varVal->token, "ATYPE")){
                            varVal = varVal->left;
                            if (!strcmp(varVal->token, "USEID")){
                                varVal = varVal->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                            indexer=j;
                                        }
                                    }
                                }  
                            }   
                        }
                    }
                    node = peek(scopeStack);
                    if (!strcmp(node->token, ">") || !strcmp(node->token, ">=") || !strcmp(node->token, "<") || !strcmp(node->token, "<=") ){
                        lexp = node->left;
                        rexp = node->right;
                        cheker=0;
                        if (!strcmp(lexp->token, "ATYPE")){
                            lexp = lexp->left;
                           if (lexp->right!=NULL) {
                               
                               if (!strcmp(lexp->right->token, "int") || !strcmp(lexp->right->token, "real") ) {
                                   lexp = lexp->right;
                               }
                               else {
                                   cheker=1;
                                   lexp = lexp->right;
                               }
                           }
                        }
                        if (!strcmp(rexp->token, "ATYPE")){
                            rexp = rexp->left;
                           if (rexp->right!=NULL) {
                               if (!strcmp(rexp->right->token, "real") || !strcmp(rexp->right->token, "int")) {
                                   rexp = rexp->right;
                               } 
                               else {
                                   cheker=2;
                                   rexp = rexp->right;
                               }
                           }
                        }

                        if (strcmp(rexp->token, lexp->token)) {
                            printf("Error!  '%s' operator is available only for same type 'int' or 'real' \n" ,node->token);
                            printError("\n");
                            exit(1);
                        }
                        if (cheker == 1) {
                            printf("Error!  '%s' operator is available for type 'int' or 'real' only! not '%s' \n" ,node->token, lexp->token);
                            printError("\n");
                            exit(1);
                        }
                        if (cheker == 2) {
                            printf("Error!  '%s' operator is available for type 'int' or 'real' only! not '%s' \n" ,node->token, rexp->token);
                            printError("\n");
                            exit(1);
                        }

                        if (!strcmp(lexp->token, "USEID")){
                            cheker=1;
                            lexp = lexp->left;
                            for(int j=0; j<sti; j++) {
                                if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                    if (!strcmp(lexp->token, symbolTableArr[j]->name)) {
                                        if (strcmp("int", symbolTableArr[j]->type) && strcmp("real", symbolTableArr[j]->type)){
                                            cheker=4;
                                            indexer2=j;
                                        }
                                    }
                                    
                                }
                            }  
                        }  
                        if (!strcmp(rexp->token, "USEID")){
                            cheker=1;
                            rexp = rexp->left;
                            for(int j=0; j<sti; j++) {
                                if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                    if (!strcmp(rexp->token, symbolTableArr[j]->name)) {
                                        if (strcmp("int", symbolTableArr[j]->type) && strcmp("real", symbolTableArr[j]->type)){
                                            cheker=4;
                                            indexer2=j;
                                        }
                                    }
                                    
                                }
                            }  
                        }  
                        if (cheker == 4) {
                            printf("Error!  '%s' operator is available for type 'int' or 'real' only! not '%s' \n" ,node->token, symbolTableArr[indexer2]->type);
                            printError("\n");
                            exit(1);
                        }
                        for(int j=0; j<sti; j++) {
                            if (!strcmp(symbolTableArr[j]->kind, "Veriable") ){
                                if (!strcmp(lexp->token, symbolTableArr[j]->name)) {
                                    cheker=0;
                                    break;
                                }
                            }
                        }       
                        for(int j=0; j<sti; j++) {
                            if (!strcmp(symbolTableArr[j]->kind, "Veriable") ){
                                if (!strcmp(rexp->token, symbolTableArr[j]->name)) {
                                    cheker=0;
                                    break;
                                }
                            }
                        }

                        if (cheker != 0) {
                            printf("Error! %s is not define before use! \n" ,lexp->token);
                            printError("\n");
                            exit(1);
                        }
                        if (strcmp(symbolTableArr[indexer]->type, "bool")) {
                            printf("Error! Variable %s type is '%s' but assign value has type of 'bool'\n" , symbolTableArr[indexer]->name, symbolTableArr[indexer]->type);
                            printError("\n");
                            exit(1);
                        }
                    }

                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;
            case 19:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer2=0;
                    if (!strcmp(node->token, "=")){
                        varVal = node->left;
                        if (!strcmp(varVal->token, "ATYPE")){
                            varVal = varVal->left;
                            if (!strcmp(varVal->token, "USEID")){
                                varVal = varVal->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                            indexer=j;
                                        }
                                    }
                                }  
                            }   
                        }
                    }
                    node = peek(scopeStack);
                    if (!strcmp(node->token, "==") || !strcmp(node->token, "!=")){
                        lexp = node->left;
                        rexp = node->right;
                        cheker=0;
                        if (!strcmp(lexp->token, "ATYPE")){
                            lexp = lexp->left;
                           if (lexp->right!=NULL) {
                               if (!strcmp(lexp->right->token, "int") || !strcmp(lexp->right->token, "real") || !strcmp(lexp->right->token, "char") || !strcmp(lexp->right->token, "bool") || !strcmp(lexp->right->token, "int*") || !strcmp(lexp->right->token, "real*") || !strcmp(lexp->right->token, "char*")) {
                                   lexp = lexp->right;
                                   varVal = lexp;
                               }
                               else {
                                   cheker=1;
                                   lexp = lexp->right;
                                   varVal = lexp;
                               }
                           }
                        }
                        if (!strcmp(rexp->token, "ATYPE")){
                            rexp = rexp->left;
                           if (rexp->right!=NULL) {
                               if (!strcmp(rexp->right->token, "int") || !strcmp(rexp->right->token, "real") || !strcmp(rexp->right->token, "char") || !strcmp(rexp->right->token, "bool") || !strcmp(rexp->right->token, "int*") || !strcmp(rexp->right->token, "real*") || !strcmp(rexp->right->token, "char*")) {
                                   rexp = rexp->right;
                                   condVal = rexp;
                               } 
                               else {
                                   cheker=2;
                                   rexp = rexp->right;
                                   condVal = rexp;
                               }
                           }
                        }
                        if (strcmp(rexp->token, lexp->token)) {
                            printf("Error!  '%s' operator is available only for same types \n" ,node->token);
                            printError("\n");
                            exit(1);
                        }
                        if (cheker == 1) {
                            printf("Error!  '%s' operator is available for type only! not '%s' \n" ,node->token, lexp->token);
                            printError("\n");
                            exit(1);
                        }
                        if (cheker == 2) {
                            printf("Error!  '%s' operator is available for type only! not '%s' \n" ,node->token, rexp->token);
                            printError("\n");
                            exit(1);
                        }
                        tmpcount=0;
                        if (!strcmp(lexp->token, "USEID")){
                            cheker=1;
                            tmpcount=1;
                            lexp = lexp->left;
                            for(int j=0; j<sti; j++) {
                                if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                    if (!strcmp(lexp->token, symbolTableArr[j]->name)) {
                                        if (strcmp("int", symbolTableArr[j]->type) && strcmp("real", symbolTableArr[j]->type) && strcmp("char", symbolTableArr[j]->type) && strcmp("bool", symbolTableArr[j]->type) && strcmp("int*", symbolTableArr[j]->type) && strcmp("real*", symbolTableArr[j]->type) && strcmp("char*", symbolTableArr[j]->type)){
                                            cheker=4;
                                            indexer2=j;
                                        }
                                    }
                                    
                                }
                            }  
                        }  
                        if (!strcmp(rexp->token, "USEID")){
                            cheker=1;
                            if (tmpcount>0) {
                                tmpcount=3;
                            }else tmpcount=2;
                            
                            rexp = rexp->left;
                            for(int j=0; j<sti; j++) {
                                if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                    if (!strcmp(rexp->token, symbolTableArr[j]->name)) {
                                        if (strcmp("int", symbolTableArr[j]->type) && strcmp("real", symbolTableArr[j]->type) && strcmp("char", symbolTableArr[j]->type) && strcmp("bool", symbolTableArr[j]->type) && strcmp("int*", symbolTableArr[j]->type) && strcmp("real*", symbolTableArr[j]->type) && strcmp("char*", symbolTableArr[j]->type)){
                                            cheker=4;
                                            indexer3=j;
                                        }
                                    }
                                    
                                }
                            }  
                        }
                        if (tmpcount==1) {
                            if (!strcmp(symbolTableArr[indexer2]->type, varVal->token)) {
                                printf("Error!  '%s' operator is available for same types only! \n" ,node->token);
                                printError("\n");
                                exit(1);
                            }
                        }
                        if (tmpcount==2) {
                            if (!strcmp(symbolTableArr[indexer3]->type, condVal->token)) {
                                printf("Error!  '%s' operator is available for same types only! \n" ,node->token);
                                printError("\n");
                                exit(1);
                            }
                        }
                        if (tmpcount==3) {
                            if (!strcmp(symbolTableArr[indexer2]->type, symbolTableArr[indexer3]->type)) {
                                printf("Error!  '%s' operator is available for same types only! \n" ,node->token);
                                printError("\n");
                                exit(1);
                            }
                        }
                          
                        if (cheker == 4) {
                            printf("Error!  '%s' operator is available for types only! not '%s' \n" ,node->token, symbolTableArr[indexer2]->type);
                            printError("\n");
                            exit(1);
                        }
                        for(int j=0; j<sti; j++) {
                            if (!strcmp(symbolTableArr[j]->kind, "Veriable") ){
                                if (!strcmp(lexp->token, symbolTableArr[j]->name)) {
                                    cheker=0;
                                    break;
                                }
                            }
                        }       
                        for(int j=0; j<sti; j++) {
                            if (!strcmp(symbolTableArr[j]->kind, "Veriable") ){
                                if (!strcmp(rexp->token, symbolTableArr[j]->name)) {
                                    cheker=0;
                                    break;
                                }
                            }
                        }
                        if (cheker != 0) {
                            printf("Error! %s is not define before use! \n" ,lexp->token);
                            printError("\n");
                            exit(1);
                        }

                        if (strcmp(symbolTableArr[indexer]->type, "bool")) {
                            printf("Error! Variable %s type is '%s' but assign value has type of 'bool'\n" , symbolTableArr[indexer]->name, symbolTableArr[indexer]->type);
                            printError("\n");
                            exit(1);
                        }
                    }

                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;
            case 20:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer2=0;
                    if (!strcmp(node->token, "=")){
                        varVal = node->left;
                        if (!strcmp(varVal->token, "ATYPE")){
                            varVal = varVal->left;
                            if (!strcmp(varVal->token, "USEID")){
                                varVal = varVal->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                            indexer=j;
                                        }
                                    }
                                }  
                            }   
                        }
                    }
                    node = peek(scopeStack);
                    if (node->middle != NULL) {
                        if (!strcmp(node->middle->token, "ABS")){
                            funcTyp = node->middle->left;
                            cheker=0;
                            if (!strcmp(funcTyp->token, "ATYPE")){
                                funcTyp = funcTyp->left;
                                if (funcTyp->right!=NULL) {
                                    if (!strcmp(funcTyp->right->token, "string")) {
                                        funcTyp = funcTyp->right;
                                        cheker=1;
                                    }
                                    else {
                                        funcTyp = funcTyp->right;
                                        cheker=2;
                                    }
                                }
                            }
                            if (cheker == 2) {
                                printf("Error! '%s' operator is available for string type only! not '%s' \n" ,node->middle->token, funcTyp->token);
                                printError("\n");
                                exit(1);
                            }
                            if (!strcmp(funcTyp->token, "USEID")){
                                cheker=0;
                                funcTyp = funcTyp->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(funcTyp->token, symbolTableArr[j]->name)) {
                                            if (strcmp("string", symbolTableArr[j]->type)){
                                                cheker=3;
                                                indexer2=j;
                                            }
                                        }
                                        
                                    }
                                }  
                            }  
                            if (cheker==3) {
                                printf("Error! '%s' operator is available for string type only! \n" ,node->middle->token);
                                printError("\n");
                                exit(1);
                            
                            }
                            for(int j=0; j<sti; j++) {
                                if (!strcmp(symbolTableArr[j]->kind, "Veriable") ){
                                    if (!strcmp(funcTyp->token, symbolTableArr[j]->name)) {
                                        cheker=0;
                                        break;
                                    }
                                }
                            }       
                            if (cheker != 0) {
                                printf("Error! %s is not define before use! \n" ,funcTyp->token);
                                printError("\n");
                                exit(1);
                            }
                            if (strcmp(symbolTableArr[indexer]->type, "int")) {
                                printf("Error! Variable %s type is '%s' but assign value has type of 'int'\n" , symbolTableArr[indexer]->name, symbolTableArr[indexer]->type);
                                printError("\n");
                                exit(1);
                            }
                        }
                    }

                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;

            case 21:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    if (!strcmp(node->token, "=")){
                        isBool=0;
                        rexp = node->right;
                        if (!strcmp(rexp->token, "!")) {
                            varVal = node->left;
                            if (!strcmp(varVal->token, "ATYPE")){
                                varVal = varVal->left;
                                if (!strcmp(varVal->token, "USEID")){
                                    isBool=0;
                                    varVal = varVal->left;
                                    for(int j=0; j<sti; j++) {
                                        if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                            if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                                if (!strcmp(symbolTableArr[j]->type, "bool")) {
                                                    isBool=1;
                                                }
                                                indexer=j;                                            
                                            }
                                        }
                                    }
                                    if (isBool==0) {
                                        printf("Error! Variable %s type is '%s' but assign value has type of 'bool'\n" , symbolTableArr[indexer]->name, symbolTableArr[indexer]->type);
                                        printError("\n");
                                        exit(1);
                                    }  
                                }
                            }
                        }
                    }
                    node = peek(scopeStack);
                    if (!strcmp(node->token, "!") ){
                        lexp = node->left;
                        cheker=0;
                        if (lexp->right!=NULL) {
                            if (!strcmp(lexp->right->token, "bool") ) {
                                lexp = lexp->right;
                            }
                            else {
                                cheker=1;
                                lexp = lexp->right;
                            }
                        }
                        funcTyp = node->left;
                        if (!strcmp(funcTyp->token, "USEID")){
                            cheker=0;
                            funcTyp = funcTyp->left;
                            for(int j=0; j<sti; j++) {
                                if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                    if (!strcmp(funcTyp->token, symbolTableArr[j]->name)) {
                                        if (strcmp("bool", symbolTableArr[j]->type)){
                                            cheker=3;
                                            indexer2=j;
                                        }
                                    }
                                    
                                }
                            }
                            if (cheker == 3) {
                            printf("Error!  '%s' operator is available for type 'bool' only! not '%s' \n" ,node->token, symbolTableArr[indexer2]->type);
                            printError("\n");
                            exit(1);
                            }  
                        }  

                        if (cheker == 1) {
                            printf("Error!  '%s' operator is available for type 'bool' only! not '%s' \n" ,node->token, lexp->token);
                            printError("\n");
                            exit(1);
                        }
                    }
                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;
            case 22:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer2=0;
                    if (!strcmp(node->token, "=")){
                        varVal = node->left;
                        if (!strcmp(varVal->token, "ATYPE")){
                            varVal = varVal->left;
                            if (!strcmp(varVal->token, "USEID")){
                                varVal = varVal->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                            indexer=j;
                                        }
                                    }
                                }  
                            }   
                        }
                    }
                    node = peek(scopeStack);
                    if (!strcmp(node->token, "&")){
                        cheker=0;
                        lexp = node->left;
                        printf("%s \n", lexp->token);
                        for(int j=0; j<sti; j++) {
                            if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                if (!strcmp(lexp->token, symbolTableArr[j]->name)) {
                                    indexer=j;
                                    if (!strcmp("int", symbolTableArr[j]->type) || !strcmp("real", symbolTableArr[j]->type) || !strcmp("char", symbolTableArr[j]->type) || !strcmp("string", symbolTableArr[j]->type) ) {
                                        cheker=1;
                                    }
                                }
                            }
                        }
                        if (cheker == 0) {
                            printf("Error!  '%s' operator is available for types only!\n" ,node->token);
                            printError("\n");
                            exit(1);
                        } 
                    }

                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;
            case 23:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    indexer2=0;
                    if (!strcmp(node->token, "=")){
                        varVal = node->left;
                        if (!strcmp(varVal->token, "ATYPE")){
                            varVal = varVal->left;
                            if (!strcmp(varVal->token, "USEID")){
                                varVal = varVal->left;
                                for(int j=0; j<sti; j++) {
                                    if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        if (!strcmp(varVal->token, symbolTableArr[j]->name)) {
                                            indexer=j;
                                        }
                                    }
                                }  
                            }   
                        }
                    }
                    node = peek(scopeStack);
                    if (!strcmp(node->token, "^")){
                        cheker=0;
                        lexp = node->left;
                        for(int j=0; j<sti; j++) {
                            if ( !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                if (!strcmp(lexp->token, symbolTableArr[j]->name)) {
                                    indexer=j;
                                    if (!strcmp("int*", symbolTableArr[j]->type) || !strcmp("real*", symbolTableArr[j]->type) || !strcmp("char*", symbolTableArr[j]->type)) {
                                        cheker=1;
                                    }
                                }
                            }
                        }
                        if (cheker == 0) {
                            printf("Error!  '%s' operator is available for pointers only!\n" ,node->token);
                            printError("\n");
                            exit(1);
                        } 
                    }

                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;

            default:
                printError("Error!, WTF man damn code bro");
                break;
    }
    
}

void checkScope(node* scope, int mode) {
    
    char* dupType;
    if (scope == NULL) 
       return; 
  
    StackNode* scopeStack = NULL, *idStack = NULL, *tmpStack=NULL; 
    push(&scopeStack, scope); 
   
    switch(mode) {    
            case 1:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    if (!strcmp(node->token, "PROC")){
                        dupType = "Procedure";
                        push(&idStack, node->left);
                    }
                    else if (!strcmp(node->token, "FUNC")){
                        dupType = "Function";
                        push(&idStack, node->left);
                        //printf("%s ", peek(idStack)->token); 
                    }

                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;
            case 2:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    if (!strcmp(node->token, "VAR")){
                        dupType = "Variable";
                        push(&idStack, node->left);
                        //printf("%s ", peek(idStack)->token); 
                    }
                    pop(&scopeStack); 
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                break;
            case 3:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    struct node* tempn, *tempn2;
                    if (!strcmp(node->token, "PROC")){
                        symbolTableArr[sti++] = mksymboltable(node->left->token, "Procedure", "proc");
                        if (!strcmp(node->left->middle->token, "STARGS")){
                            tempn = node->left->middle;
                            tempn2 = tempn;
                            while (!strcmp(tempn->token, "STARGS")) {
                                
                                tempn2 = tempn;
                                tempn = tempn->left;
                                if (!strcmp(tempn->token, "ARGS")){
                                    symbolTableArr[sti-1]->count++;
                                    tempn = tempn->middle;
                                    if (!strcmp(tempn->token, "NEXTP")){
                                        while (strcmp(tempn->token, ":")) {
                                            symbolTableArr[sti-1]->count++;
                                            tempn = tempn->middle;
                                        }
                                    }
                                }
                                if (tempn2->middle != NULL) {
                                    tempn = tempn2->right;   
                                }
                            }
                        }
                    }
                    else if (!strcmp(node->token, "FUNC")){
                        symbolTableArr[sti++] = mksymboltable(node->left->token, "Function", node->middle->left->token);
                        if (!strcmp(node->left->middle->token, "STARGS")){
                            tempn = node->left->middle;
                            tempn2 = tempn;
                            while (!strcmp(tempn->token, "STARGS")) {
                                
                                tempn2 = tempn;
                                tempn = tempn->left;
                                if (!strcmp(tempn->token, "ARGS")){
                                    symbolTableArr[sti-1]->count++;
                                    tempn = tempn->middle;
                                    if (!strcmp(tempn->token, "NEXTP")){
                                        while (strcmp(tempn->token, ":")) {
                                            symbolTableArr[sti-1]->count++;
                                            tempn = tempn->middle;
                                        }
                                    }
                                }
                                if (tempn2->middle != NULL) {
                                    tempn = tempn2->right;   
                                }
                            }
                        }                    
                    }
                    else if (!strcmp(node->token, "CALL")){
                        found=0;
                        argscheck=0;
                        tempn = node->left->middle;                       
                        if (tempn->left!= NULL) {
                            
                            argscheck++;
                            tempn = tempn->left;
                            while(tempn!=NULL) {
                                argscheck++;
                                tempn = tempn->middle;
                            }
                        }else argscheck++;
                       // printf("%s \n\n", node->left->token);
                        for(int j=0; j<sti; j++) {
                            if (!strcmp(symbolTableArr[j]->name, node->left->token) ) {
                                found=1;
                                if (symbolTableArr[j]->count==0)
                                    break;
                                if (symbolTableArr[j]->count == argscheck) {
                                    found=2;
                                }else found = -1;
                            }   
                        }
                        if(found==0) {
                            printf("Error! %s is not define before use!", node->left->token);
                            printError("\n");
                            exit(1);
                        }
                        else if(found==-1) {
                            printf("Error! The number of arguments passed to '%s' is not as define!", node->left->token);
                            printError("\n");
                            exit(1);
                        }
                    }
                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                }
                // for(int j=0; j<sti; j++) {
                //     if( !strcmp(symbolTableArr[j]->kind, "Procedure") || !strcmp(symbolTableArr[j]->kind, "Function") ){
                //         printf("%d \n", symbolTableArr[j]->count);
                //     }
                // } 
                return;
                break;       


            case 4:
                while (1) 
                { 
                    struct node* node = peek(scopeStack); 
                    struct node* tmpn, *typen, *tmpn2;
                    int arrflag=0; 
                    if (!strcmp(node->token, "DEC")){
                        tmpn=node->left->middle;
                        tmpn2=node->left;
                        if (tmpn2->right->middle!=NULL) {
                            arrflag=1;
                        }
                        while (strcmp(tmpn->token, ":")!=0) {
                            tmpn=tmpn->middle;
                            if(!strcmp(tmpn->token, ":")) {
                                typen = tmpn->left;
                                break;                    
                            }
                        }
                        tmpn=node->left->middle;
                        while (strcmp(tmpn->token, ":")!=0) {
                            if(!strcmp(tmpn->token, "NEXTP")) {
                                dupcheck=0;
                                for(int j=0; j<sti; j++) {
                                    if (!strcmp(symbolTableArr[j]->name, node->left->left->token) && !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        dupcheck=1;
                                    }    
                                }
                                if (dupcheck==0){
                                    symbolTableArr[sti++] = mksymboltable(tmpn->left->token, "Veriable", typen->token);
                                    if (arrflag==1) {
                                        symbolTableArr[sti-1]->arr=1;
                                    }
                                }
                            }
                            tmpn=tmpn->middle;
                            if(!strcmp(tmpn->token, ":")) {
                                dupcheck=0;
                                for(int j=0; j<sti; j++) {
                                    if (!strcmp(symbolTableArr[j]->name, node->left->left->token) && !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        dupcheck=1;
                                    }    
                                }
                                if (dupcheck==0){
                                    symbolTableArr[sti++] = mksymboltable(node->left->left->token, "Veriable", tmpn->left->token);                                
                                    if (arrflag==1) {
                                        symbolTableArr[sti-1]->arr=1;
                                    }
                                }
                                break;                    
                            }
                        }
                        if(!strcmp(tmpn->token, ":")) {
                            dupcheck=0;
                            for(int j=0; j<sti; j++) {
                                if (!strcmp(symbolTableArr[j]->name, node->left->left->token) && !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                    dupcheck=1;
                                }    
                            }
                            if (dupcheck==0){
                                symbolTableArr[sti++] = mksymboltable(node->left->left->token, "Veriable", tmpn->left->token);                                                   
                                if (arrflag==1) {
                                    symbolTableArr[sti-1]->arr=1;
                                }
                            }
                        }
                        //printf("%s %s ", node->left->left->token, tmpn->left->token);
                    }

                    if (!strcmp(node->token, "EXPR")) {
                        found=0;
                        tmpn = node->left->left;
                        if (node->left->right != NULL) {
                            tmpn2 = node->left->right;    
                        }
                        if (!strcmp(tmpn->token, "+") || !strcmp(tmpn->token, "-") || !strcmp(tmpn->token, "*") || !strcmp(tmpn->token, "/") || !strcmp(tmpn->token, "&&") || !strcmp(tmpn->token, "||") || !strcmp(tmpn->token, ">") || !strcmp(tmpn->token, ">=") || !strcmp(tmpn->token, "<") || !strcmp(tmpn->token, "<=") || !strcmp(tmpn->token, "==") || !strcmp(tmpn->token, "!=")) {
                            found=1;
                        }
                        if (!strcmp(tmpn->token, "ATYPE")) {
                            tmpn = tmpn->left;
                            if (!strcmp(tmpn->token, "USEID")) {
                                tmpn = tmpn->left;
                                for(int j=0; j<sti; j++) {
                                    if (!strcmp(symbolTableArr[j]->name, tmpn->token) && !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                        found=1;
                                    }  
                                }
                                if(found==0) {
                                    printf("Error! %s is not define before use!", tmpn->token);
                                    printError("\n");
                                    exit(1);
                                }
                            }
                        }
                        found = 0;
                        if (tmpn2!=NULL) {
                            if (!strcmp(tmpn2->token, "+") || !strcmp(tmpn2->token, "-") || !strcmp(tmpn2->token, "*") || !strcmp(tmpn2->token, "/") || !strcmp(tmpn2->token, "&&") || !strcmp(tmpn2->token, "||") || !strcmp(tmpn2->token, ">") || !strcmp(tmpn2->token, ">=") || !strcmp(tmpn2->token, "<") || !strcmp(tmpn2->token, "<=") || !strcmp(tmpn2->token, "==") || !strcmp(tmpn2->token, "!=")) {
                                found=1;
                            }
                            if (!strcmp(tmpn2->token, "ATYPE")) {
                                tmpn2 = tmpn2->left;
                                if (!strcmp(tmpn2->token, "USEID")) {
                                    tmpn2 = tmpn2->left;
                                    for(int j=0; j<sti; j++) {
                                        if (!strcmp(symbolTableArr[j]->name, tmpn2->token) && !strcmp(symbolTableArr[j]->kind, "Veriable")) {
                                            found=1;
                                        }
                                    }
                                    if(found==0) {
                                        printf("Error! %s is not define before use!", tmpn2->token);
                                        printError("\n");
                                        exit(1);
                                    }
                                }
                            }
                        }
                   }

                    pop(&scopeStack); 
            
                    if (node->right) 
                        push(&scopeStack, node->right);
                    if (node->middle) 
                        push(&scopeStack, node->middle);     
                    if (node->left) 
                        push(&scopeStack, node->left); 
                    if (!scopeStack)
                        break;
                } 
                return;
                break;    
            
            default:
                printError("Error!, WTF man damn code bro");
                break;
    }
    struct node* tmp1 = pop(&idStack), *tmp2;
    while(idStack!=NULL) {
        tmp2=pop(&idStack);
        
        if (!strcmp(tmp1->token, tmp2->token)){
            printf("Error!, illegal %s! %s is already used, there are no two functions or procedures or veriables with the same name in the same scope", dupType, tmp1->token);
            exit(1);
        }
        push(&tmpStack, tmp2);
        if (idStack==NULL) {
            while(tmpStack!=NULL) {
                push(&idStack, pop(&tmpStack));
            }
            tmp1 = pop(&idStack);
        }
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

        if (!strcmp(node->token, "BODY")){
            struct node* scope = node->left;
            checkScope(scope, 1);
            checkScope(scope, 2);
            checkScope(scope, 3);
            checkScope(scope, 4);
            checkScope2(scope, 8);
            checkScope2(scope, 9);
            checkScope2(scope, 10);
            checkScope2(scope, 11);
            checkScope2(scope, 12);
            checkScope2(scope, 13);
            checkScope2(scope, 16);
            checkScope2(scope, 17);
            checkScope2(scope, 18);
            checkScope2(scope, 19);
            checkScope2(scope, 20);
            checkScope2(scope, 21);
            checkScope2(scope, 22);
            checkScope2(scope, 23);
        }
        if (!strcmp(node->token, "CODE")){
            struct node* scope = node->middle;
            checkScope(scope, 1);
            checkScope(scope, 2);
            checkScope(scope, 3);
            checkScope(scope, 4);
            checkScope2(scope, 8);
            checkScope2(scope, 9);
            checkScope2(scope, 10);
            checkScope2(scope, 11);
            checkScope2(scope, 12);
            checkScope2(scope, 13);
            checkScope2(scope, 16);
            checkScope2(scope, 17);
            checkScope2(scope, 18);
            checkScope2(scope, 19);
            checkScope2(scope, 20);
            checkScope2(scope, 21);
            checkScope2(scope, 22);
            checkScope2(scope, 23);
        }

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

char* GetToken(node* s)
{
	return s->token;
}
