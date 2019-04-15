%{
 #include<stdio.h>

 #include<stdlib.h>

 #include<string.h>

 typedef struct node
 {
 char* token;

 struct node *left;

 struct node *middle; 

 struct node *right;

 }node;

 typedef struct Body
 {
 char* Things;

 struct Block* insiders;
 
 struct Argument* var_exp;

 struct Body* next;

 }Body; 

 typedef struct Block
 {
 float Num;

 struct TypeOfBlock *type;

 int WhoIsYourFather;

 struct Body* BlockBody;

 struct Block* next;

 }Block;

 typedef struct Program
 {
  struct Block* block;

  struct Program* next;

  int numOfProgram;

 }Program;

 typedef struct SymbolTable
 {
  char* name;

  char* kind;

  char* type;

 }SymbolTable;

typedef struct TypeOfBlock
{
 struct SymbolTable* SymbolTable;

 struct Argument* ArgumentOrCondition;

}TypeOfBlock;

typedef struct Argument
{
 char* name;

 struct SymbolTable* Table;

 struct Argument* Next;

}Argument;

 Program* BuildProgram(node* tree);

 Program* GetNextProgram(node* tree);

 Block* BuildBlock(node *tree);

 int CheckCode(Program* Program); 

 node *mknode(char *token,node *left,node *middle,node *right);

 void printtree(node *tree);

 void yyerror(const char *s);

 int yylex();

 int flag=0;

 static float counterForBuilding=0.0;

#define YYSTYPE struct node*

 extern char *yytext;

%}

%start start
%token MULTI DIVISION BOOL CHAR INT STRING INTPTR CHARPTR IF ELSE WHILE VAR PROCEDURE RETURN ASSIGN AND EQUAL GREATER GREATEREQUAL LESS LESSEQUAL MINUS NOT NOTEQUAL OR PLUS ADDRESS DEREFERENCE ABSUOLUT NULLL SEMICOLON COLUMS COMMA NEGATIVE_NUM LEFTBRACE RIGHTBRACE LEFTBRACKET RIGHTBRACKET /*COOMMENT*/PRESENT MAIN BOOLTRUE LEFTPAREN RIGHTPAREN BOOLFALSE INTEGER_CONST CHAR_CONST ID STRING_CONST HEX_CONST OCTAL_CONST BINARY_CONST
%right ASSIGN ELSE DIVISION
%left LEFTBRACE RIGHTBRACE LEFTPAREN RIGHTPAREN
%left EQUAL GREATER GREATEREQUAL LESSEQUAL LESS NOTEQUAL
%left PLUS MINUS AND OR 
%left MULTI 
%%
start: main                    {/*flag=CheckCode(BuildProgram($1));
				if(flag==1)*/printtree($1);};

main: procedure main   {$$=mknode("Program",$1,$2,NULL);}
      | empty              {$$=mknode("Program",$1,NULL,NULL);};

//comment: DIVISION PRESENT ID 

exp: 	exp PLUS exp           {$$=mknode("+",$1,NULL,$3);}
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

exp2: 	exp PLUS exp           {$$=mknode("+",$1,NULL,$3);}
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
	|OCTAL_CONST                                       {$$=mknode(yytext,NULL,NULL,NULL);}
	|BINARY_CONST                                      {$$=mknode(yytext,NULL,NULL,NULL);}
	|id arrNotEmptystring                              {$$=mknode($1->token,$2->left,$2->middle,$2->right);}
	|DEREFERENCE PossibleForDereference                {$$=mknode("^",$2,NULL,NULL);}
	|ADDRESS id                                        {$$=mknode("&",$2,NULL,NULL);}
	|NULLL                                             {$$=mknode(yytext,NULL,NULL,NULL);}
	|True	
	|False
	|NEGATIVE_NUM                                      {$$=mknode(yytext,NULL,NULL,NULL);}
	|id; 

structOfCond:   While 
	       |if;

if: IF condition block else                                {$$=mknode("IF",$2,$3,$4);};

AttrType: INTEGER_CONST                                    {$$=mknode(yytext,NULL,NULL,NULL);}
	|CHAR_CONST                                        {$$=mknode(yytext,NULL,NULL,NULL);}
	|STRING_CONST                                      {$$=mknode(yytext,NULL,NULL,NULL);}
	|HEX_CONST                                         {$$=mknode(yytext,NULL,NULL,NULL);}
	|OCTAL_CONST                                       {$$=mknode(yytext,NULL,NULL,NULL);}
	|BINARY_CONST                                      {$$=mknode(yytext,NULL,NULL,NULL);}
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

PossibleForDereference:condition
			|id arrstring;

While: WHILE condition block                               {$$=mknode("WHILE",$2,NULL,$3);};

condition: leftParen exp rightParen                        {$$=mknode("start_condition",$1,$2,$3);};

block: leftBrace BlockBody rightBrace                      {$$=mknode("start_block",$1,$2,$3);};

abs: ABSUOLUT                         {$$=mknode("|",NULL,NULL,NULL);};

LeftBracket: LEFTBRACKET              {$$=mknode("[",NULL,NULL,NULL);};

RightBracket: RIGHTBRACKET            {$$=mknode("]",NULL,NULL,NULL);};

leftParen: LEFTPAREN                  {$$=mknode("(",NULL,NULL,NULL);};

rightParen: RIGHTPAREN                {$$=mknode(")",NULL,NULL,NULL);};

leftBrace: LEFTBRACE                  {$$=mknode("{",NULL,NULL,NULL);};

rightBrace: RIGHTBRACE                {$$=mknode("}",NULL,NULL,NULL);};

Declaration: VAR startparamsList arrstring SEMICOLON {$$=mknode("var",$2,$3,NULL);};

arrstring: LeftBracket exp RightBracket              {$$=mknode("",$1,$2,$3);}
		|empty;

arrNotEmptystring: LeftBracket exp RightBracket      {$$=mknode("",$1,$2,$3);};

id: ID                                               {$$=mknode(yytext,NULL,NULL,NULL);};

varType: INT                                        {$$=mknode(yytext,NULL,NULL,NULL);}
	|BOOL                                        {$$=mknode(yytext,NULL,NULL,NULL);}
	|CHAR                                       {$$=mknode(yytext,NULL,NULL,NULL);}
	|STRING                                      {$$=mknode(yytext,NULL,NULL,NULL);}
	|INTPTR                                      {$$=mknode(yytext,NULL,NULL,NULL);}
	|CHARPTR                                     {$$=mknode(yytext,NULL,NULL,NULL);};

FuncActivation: id leftParen args rightParen         {$$=mknode($1->token,$2,$3,$4);};


args:  //id input                                      {$$=mknode($1->token,$2,NULL,NULL);}
	exp2 input                                  {$$=mknode($1->token,$2,NULL,NULL);}
	|empty                                       {$$=mknode($1->token,NULL,NULL,NULL);};

input:  //COMMA id input                               {$$=mknode(",",$2,$3,NULL);}
	COMMA exp2 input                    {$$=mknode(",",$2,$3,NULL);}
	|empty;

empty:                                               {$$=mknode("",NULL,NULL,NULL);};

return: returnBranch PossibleReturnValues SEMICOLON  {$$=mknode($1->token,$2,NULL,NULL);} ;

returnInsideProcDeclaration: returnBranch ProcType   {$$=mknode($1->token,$2,NULL,NULL);};

returnBranch: RETURN                                 {$$=mknode(yytext,NULL,NULL,NULL);};

Intval: INTEGER_CONST                                {$$=mknode(yytext,NULL,NULL,NULL);};

PossibleReturnValues: Intval
			|id
			|True
			|False;

procedure: PROCEDURE id leftParen paramsList rightParen returnInsideProcDeclaration Problock {$$=mknode("PROCEDURE",mknode($2->token,$3,$4,$5),$6,$7);};

ProcType: INT                                        {$$=mknode(yytext,NULL,NULL,NULL);}
	|BOOL                                        {$$=mknode(yytext,NULL,NULL,NULL);}
	|CHAR                                        {$$=mknode(yytext,NULL,NULL,NULL);}
	|INTPTR                                      {$$=mknode(yytext,NULL,NULL,NULL);}
	|CHARPTR                                     {$$=mknode(yytext,NULL,NULL,NULL);}
	|True
	|False;

True: BOOLTRUE                                       {$$=mknode(yytext,NULL,NULL,NULL);};

False: BOOLFALSE                                     {$$=mknode(yytext,NULL,NULL,NULL);};

paramsList: startparamsList SEMICOLON paramsList     {$$=mknode("start_params",$1,mknode(";",NULL,NULL,NULL),$3);}
	|startparamsList			     {$$=mknode("start_params",$1,NULL,NULL);}
	|empty					     {$$=mknode("start_params",$1,NULL,NULL);};	

startparamsList: id next_param_in_proc               {$$=mknode("start_params",$1,$2,NULL);};

next_param_in_proc: COMMA id next_param_in_proc      {$$=mknode(",",$2,$3,NULL);}
	|COLUMS varType                              {$$=mknode(":",$2,NULL,NULL);};

Problock: leftBrace Procbody rightBrace              {$$=mknode("start_Procedure_block",$1,$2,$3);};

Procbody: BlockBody return                           {$$=mknode("start_body",$1,$2,NULL);} ; 

HelpToStatement: ProcStatement HelpToStatement       {$$=mknode("help to statment",$1,$2,NULL);}
		|empty  			     {$$=mknode("help to statment",$1,NULL,NULL);};

HelpToTheProcedure: procedure HelpToTheProcedure     {$$=mknode("help proc",$1,$2,NULL);}
		|empty				     {$$=mknode("help proc",$1,NULL,NULL);};

HelpDeclare: Declaration HelpDeclare                 {$$=mknode("declartion",$1,$2,NULL);}
		|empty                               {$$=mknode("declartion",$1,NULL,NULL);};

BlockBody: HelpToTheProcedure HelpDeclare HelpToStatement   {$$=mknode("Body",$1,$2,$3);};


ProcStatement:   exp SEMICOLON 
		|structOfCond
		|block;

%%
#include "lex.yy.c"
int main()
{
	return yyparse();
}

Block* BuildBlock(node *tree)
{
		
	int i=counterForBuilding;

	//Build the block cube and the type cube

	Block* TheBlockOfTheProcedure=(Block*)malloc(sizeof(Block));

	//Alway Null- only one block to procedure

	TheBlockOfTheProcedure->next=NULL;

	TheBlockOfTheProcedure->Num=i;

	//if this is the first block

	if(counterForBuilding==0.0)
	{
		TheBlockOfTheProcedure->WhoIsYourFather=0.0;
	}

	//initialize sade type
	
	TheBlockOfTheProcedure->type=(TypeOfBlock*)malloc(sizeof(TypeOfBlock));
	
	TheBlockOfTheProcedure->type->SymbolTable=(SymbolTable*)malloc(sizeof(SymbolTable));

	//initialize sade type->symbol table
	
	TheBlockOfTheProcedure->type->SymbolTable->name=tree->left->token;

	TheBlockOfTheProcedure->type->SymbolTable->kind="PROCEDURE";

	TheBlockOfTheProcedure->type->SymbolTable->type= tree->middle->left->token;

	//allocate sade type->argument or condition
		
	TheBlockOfTheProcedure->type->ArgumentOrCondition=(Argument*)malloc(sizeof(Argument));

	TheBlockOfTheProcedure->type->ArgumentOrCondition->Next=NULL;

	//initialize sade type->argument or condition -in this part of the tree its only arguments
		printf("333\n");
	Argument* head =TheBlockOfTheProcedure->type->ArgumentOrCondition;
printf("335\n");
	if(strcmp(tree->left->middle->left->token,"")!=0)
	{
	printf("%s\n",tree->left->middle->token);
		node* TypeOfVar=(node*)malloc(sizeof(node));

		TypeOfVar=tree->left->middle->left->middle;

		node* tipus =(node*)malloc(sizeof(node));

		tipus = tree->left->middle->left->left;
	
		//initialize sade type->argument or condition->symbole table

		//initialize the first in the left branch -cant do it with the rest of the arguments because they have ->next in a loop.
		printf("343\n");
		TheBlockOfTheProcedure->type->ArgumentOrCondition=(Argument*)malloc(sizeof(Argument));
		printf("345\n");
		TheBlockOfTheProcedure->type->ArgumentOrCondition->Table=(SymbolTable*)malloc(sizeof(SymbolTable));
		printf("347\n");
	
		TheBlockOfTheProcedure->type->ArgumentOrCondition->Table->name=tipus->token;

		printf("349\n");
		TheBlockOfTheProcedure->type->ArgumentOrCondition->Table->kind="var";
		printf("351\n");
		while(strcmp(TypeOfVar->token,":")!=0)
		{
			TypeOfVar=TypeOfVar->middle;
		}
		printf("358\n");	
		//get the type of the arguments

		if(strcmp(TypeOfVar->token,":")==0)
		{
			TypeOfVar=TypeOfVar->left;	
		}	
	
		TheBlockOfTheProcedure->type->ArgumentOrCondition->Table->type=TypeOfVar->token;

		printf("365\n");	
		Argument* temp=TheBlockOfTheProcedure->type->ArgumentOrCondition;

		printf("372\n");	
	
		//rest of the arguments in left branch

		node* Layla=(node*)malloc(sizeof(node));

		Layla=tree->left->middle->left->middle; 
		printf("386\n");
	
		while(strcmp(Layla->token,":")!=0)
		{

			temp->Next=(Argument*)malloc(sizeof(Argument));
			printf("393\n");
			temp->Next->Table=(SymbolTable*)malloc(sizeof(SymbolTable));
			temp->Next->Table->name=Layla->left->token;
			temp->Next->Table->kind="var";
			temp->Next->Table->type=TypeOfVar->token;

			Layla=Layla->middle;
			temp=temp->Next;
			temp->Next=NULL;
		}
	printf("401\n");
		// first of right branch
	
		if(tree->left->middle->right!=NULL)
		{
			node* Layla2=(node*)malloc(sizeof(node));

			Layla2=tree->left->middle->right->left; 

			node* TypeOfVar2 = (node*)malloc(sizeof(node));

			TypeOfVar2 = tree->left->middle->right->left->middle;
			printf("%s\n",TypeOfVar2->token);
			if(tree->left->middle->right->left!=NULL)
			{			printf("410\n");
				while(strcmp(TypeOfVar2->token,":")!=0)
				{printf("412\n");
					TypeOfVar2=TypeOfVar2->middle;
				}
			
				if(strcmp(TypeOfVar2->token,":")==0)
				{
					TypeOfVar2=TypeOfVar2->left;	
				}
				printf("418\n");
				temp->Next=(Argument*)malloc(sizeof(Argument));
printf("420\n");
				temp->Next->Table=(SymbolTable*)malloc(sizeof(SymbolTable));
printf("422\n");
				temp->Next->Table->name=Layla2->left->token;

				temp->Next->Table->kind="var";
printf("426\n");
				temp->Next->Table->type=TypeOfVar2->token;

				temp=temp->Next;

				//rest arguments in right branch
printf("432\n");	
				Layla2=tree->left->middle->right->left->middle;
printf("434\n");
	   	 		while(strcmp(Layla2->token,":")!=0)
				{
printf("439\n");
					temp->Next=(Argument*)malloc(sizeof(Argument));

					temp->Next->Table=(SymbolTable*)malloc(sizeof(SymbolTable));

					temp->Next->Table->name=Layla2->left->token;

					temp->Next->Table->kind="var";

					temp->Next->Table->type=TypeOfVar2->token;

					Layla2=Layla2->middle;

					temp=temp->Next;

					temp->Next=NULL;
	     			}//end while.
			}//end if.
		}//end if.
	}//end if.
	printf("456\n");
	head =TheBlockOfTheProcedure->type->ArgumentOrCondition;
	
	// for check

	/*do{

		printf("%s\n",head->Table->name);
		printf("%s\n",head->Table->type);
		head=head->Next;

	}while(head!=NULL);*/

		printf("467\n");
	
		
	//allocating sade BlockBody

	TheBlockOfTheProcedure->BlockBody=(Body*)malloc(sizeof(Body));

	TheBlockOfTheProcedure->BlockBody->next=(Body*)malloc(sizeof(Body));

	TheBlockOfTheProcedure->BlockBody->next->next=(Body*)malloc(sizeof(Body));

	TheBlockOfTheProcedure->BlockBody->next->next->next=NULL;

	//initialize things in body

	TheBlockOfTheProcedure->BlockBody->Things="PROCEDURE";

	TheBlockOfTheProcedure->BlockBody->next->Things="var";

	TheBlockOfTheProcedure->BlockBody->next->next->Things="statment";

	if(strcmp(tree->right->middle->left->left->left->left->token,"")!=0)
	{

	}
	
	TheBlockOfTheProcedure->BlockBody->insiders=NULL;

	if(strcmp(tree->right->middle->left->middle->left->token,"")!=0)
	{
	
	}

	if(strcmp(tree->right->middle->left->right->left->token,"")!=0)
	{
	
	}

	if((strcmp(tree->right->middle->left->right->left->token,tree->right->middle->left->middle->left->token)==0) && (strcmp(tree->right->middle->left->right->left->token,"")))
	{
		TheBlockOfTheProcedure->BlockBody->var_exp=NULL;
	}	
			
	printf("519\n");
	return TheBlockOfTheProcedure; 		
}





	//return ListOfBlocks;
/*
	//build list with three arg and table cube in every arg 
	Argument* ListOfArguments=(Argument*)malloc(sizeof (Argument));
	ListOfArguments->Next=(Argument*)malloc(sizeof (Argument));
	ListOfArguments->Next->Next=(Argument*)malloc(sizeof (Argument));
	ListOfArguments->Next->Next->Next=NULL;
	ListOfArguments->Table=(SymbolTable*)malloc(sizeof(SymbolTable));
	ListOfArguments->Next->Table=(SymbolTable*)malloc(sizeof(SymbolTable));
	ListOfArguments->Next->Next->Table=(SymbolTable*)malloc(sizeof(SymbolTable));

	//initialize the first arg and the cube
	ListOfArguments->name=tree->left->token;
	ListOfArguments->Table->name= tree->left->token;
	ListOfArguments->Table->kind="var";
	ListOfArguments->Table->type="integer";
	//printf("name:%s,names:%s,kind:%s,type:%s\n",ListOfArguments->name,ListOfArguments->Table->name,ListOfArguments->Table->kind,ListOfArguments->Table->type);
	
	//initialize the second arg and cube
	ListOfArguments->Next->name=tree->token;
	ListOfArguments->Next->Table->name= "NULL";
	ListOfArguments->Next->Table->kind="NULL";
	ListOfArguments->Next->Table->type="NULL";
	//printf("name:%s,names:%s,kind:%s,type:%s\n",ListOfArguments->Next->name,ListOfArguments->Next->Table->name,ListOfArguments->Next->Table->kind,ListOfArguments->Next->Table->type);
	
	//initialize the third arg and cube
	ListOfArguments->Next->Next->name=tree->right->token;
	ListOfArguments->Next->Next->Table->name= tree->right->token;
	ListOfArguments->Next->Next->Table->kind="var";
	ListOfArguments->Next->Next->Table->type="integer";
	//printf("name:%s,names:%s,kind:%s,type:%s\n",ListOfArguments->Next->Next->name,ListOfArguments->Next->Next->Table->name,ListOfArguments->Next->Next->Table->kind,ListOfArguments->Next->Next->Table->type);
	return ListOfArguments; */

Program* GetNextProgram(node* tree)
{
	int i=counterForBuilding;
	
	Program* NextPro=(Program*)malloc(sizeof(Program));
	
	NextPro->numOfProgram=i+1;

	NextPro->block=BuildBlock(tree->left);

	NextPro->next=NULL;

	return NextPro;
}

Program* BuildProgram(node* tree)
{
	Program* temp = (Program*)malloc(sizeof(Program));

	int i=counterForBuilding;
 
	Program* ListOfPrograms=(Program*)malloc(sizeof(Program));
		
	ListOfPrograms->numOfProgram=i;

	ListOfPrograms->block=BuildBlock(tree->left);
	/*
	ListOfPrograms->next=NULL;

	temp->next=ListOfPrograms->next;

	if(tree->middle!=NULL)
	{
		ListOfPrograms->next=GetNextProgram(tree->middle);

		printf("next1:%d\n",ListOfPrograms->next->numOfProgram);
	}
	
	while(tree->middle->middle!=NULL)
	{	
		temp->next->next=GetNextProgram(tree->middle->middle);

		temp->next->next=temp->next->next->next;

		int c=2;

		printf("next%d:%d\n",c,ListOfPrograms->next->next->numOfProgram);

		printf("next%d:%d\n",c,temp->next->next->numOfProgram);

		c++;

		tree->middle->middle=tree->middle->middle->middle;

	}*/

	return ListOfPrograms;
}

int CheckCode(Program* Program)
{
 	/*if(strcmp(arguments->Next->name,"+")==0)
	{
		if((strcmp(arguments->Table->type,"integer")==0) && (strcmp(arguments->Next->Next->Table->type,arguments->Table->type)==0))
			return 1;
	}
	return 0;*/
}
node *mknode(char *token,node *left,node *middle,node *right)
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
	printf("%s\n",tree->token);
	if(tree->left)
	      printtree(tree->left);
	if(tree->middle)
	      printtree(tree->middle);
	if(tree->right)
		printtree(tree->right);
}
void yyerror(const char *str)
{
	printf("%s - %s in line:%d \n",str,yytext,counter);
}
char* GetToken(node* s)
{
	return s->token;
}

