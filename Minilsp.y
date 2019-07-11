%{
#include <stdio.h>
	void yyerror(const char *message);
	int yylex();
	struct stack{
		char* a;
		char type;
		int value;
	}; 
	struct stack var[999];
	int index = 0;
%}

%union{
	struct str{
		int ival;		
		char type;
		char* word;
	}str;
}

%token<str> number
%token<str> ID 
%token<str> bool_val 
%token<str> _and
%token<str> _or
%token<str> _not 
%token<str> mod
%token<str> print_num 
%token<str> print_bool  
%token<str> define
%token<str> _if


%type<str> PROGRAM STMT PRINT_STMT EXP 
%type<str> NUM_OP PLUS P_EXP MINUS MULTIPLY MUL_EXP DIVIDE MODULUS 
%type<str> GREATER SMALLER EQUAL EQ_EXP LOGICAL_OP AND_OP AND_EXP OR_OP OR_EXP NOT_OP
%type<str> IF_EXP TEST_EXP THEN_EXP ELSE_EXP DEF_STMT VARIABLE

%left _and _or
%left _not '='
%left '<' '>'
%left '+' '-'
%left '*' '/' mod
%left '(' ')'
%%

PROGRAM : STMT STMTS
;
STMTS 	: STMT STMTS
		|
;
STMT    : EXP
		| DEF_STMT
		| PRINT_STMT
;
PRINT_STMT : '(' print_num EXP ')'  {printf("%d\n", $3.ival);}
		   | '(' print_bool EXP ')' {if($3.ival>0){printf("#t\n");}else{printf("#f\n");}}
;
EXP	    : '(' NUM_OP ')'  {$$.ival=$2.ival;$$.type=$2.type;}
		| '(' LOGICAL_OP ')' {$$.ival=$2.ival;$$.type=$2.type;}
		| '(' IF_EXP ')'   {$$.ival=$2.ival;$$.type=$2.type;}
		|bool_val {$$.ival=$1.ival;$$.type=$1.type;}
		| number   {$$.ival=$1.ival;$$.type=$1.type;}
		| VARIABLE {$$.ival=$1.ival;$$.type=$1.type;}
		
;


NUM_OP  : PLUS     {$$.ival=$1.ival;$$.type=$1.type;}
		| MINUS    {$$.ival=$1.ival;$$.type=$1.type;}
		| MULTIPLY {$$.ival=$1.ival;$$.type=$1.type;}
		| DIVIDE   {$$.ival=$1.ival;$$.type=$1.type;}
		| MODULUS  {$$.ival=$1.ival;$$.type=$1.type;}
		| GREATER  {$$.ival=$1.ival;$$.type=$1.type;}
		| SMALLER  {$$.ival=$1.ival;$$.type=$1.type;}
		| EQUAL    {$$.ival=$1.ival;$$.type=$1.type;}
;
PLUS    :  '+' EXP P_EXP  {if($2.type!=$3.type){yyerror("type error");return 0;}$$.ival=$2.ival+$3.ival;$$.type=$2.type;}
;
P_EXP   : EXP P_EXP {if($1.type!=$2.type){yyerror("type error");return 0;}$$.ival=$1.ival+$2.ival;$$.type=$1.type;}
		| EXP {$$.ival=$1.ival;$$.type=$1.type;}
;
MINUS   :  '-' EXP EXP  {if($2.type!=$3.type){yyerror("type error");return 0;}$$.ival=$2.ival-$3.ival;$$.type=$2.type;}
;
MULTIPLY:  '*' EXP MUL_EXP  {if($2.type!=$3.type){yyerror("type error");return 0;}$$.ival=$2.ival*$3.ival;$$.type=$2.type;}
;
MUL_EXP : EXP MUL_EXP {if($2.type!=$1.type){yyerror("type error");return 0;}$$.ival=$1.ival*$2.ival;$$.type=$1.type;}
		| EXP {$$.ival=$1.ival;$$.type=$1.type;}
;
DIVIDE  :  '/' EXP EXP  {if($2.type!=$3.type){yyerror("type error");return 0;}$$.ival=$2.ival/$3.ival;$$.type=$2.type;}
;
MODULUS :  mod EXP EXP  {if($2.type!=$3.type){yyerror("type error");return 0;}$$.ival=$2.ival%$3.ival;$$.type=$2.type;}
;
GREATER :  '>' EXP EXP  {if($2.type!=$3.type){yyerror("type error");return 0;}if($2.ival>$3.ival){$$.ival=1;}
							   else{$$.ival=0;}$$.type=$2.type;}
;
SMALLER :  '<' EXP EXP  {if($2.type!=$3.type){yyerror("type error");return 0;}if($2.ival<$3.ival){$$.ival=1;}
							   else{$$.ival=0;}$$.type=$2.type;}
;
EQUAL   :  '=' EXP EQ_EXP  {if($2.type!=$3.type){yyerror("type error");return 0;}if($2.ival==$3.ival){$$.ival=1;}
								  else{$$.ival=0;}$$.type=$2.type;}
;
EQ_EXP  : EXP EQ_EXP {if($2.type!=$1.type){yyerror("type error");return 0;}if($1.ival==$2.ival){$$.ival=$1.ival;}
					  else{$$.ival=0;}$$.type=$1.type;}
		| EXP {$$.ival=$1.ival;$$.type=$1.type;}
;
LOGICAL_OP : AND_OP
           | OR_OP
		   | NOT_OP
AND_OP  :  _and EXP AND_EXP  {if($2.type!=$3.type){yyerror("type error");return 0;}if($2.ival&$3.ival){$$.ival=1;}else{$$.ival=0;}$$.type=$2.type;}
;
AND_EXP : EXP AND_EXP {if($1.ival&$2.ival){$$.ival=1;}else{$$.ival=0;}$$.type=$1.type;}
        | EXP {if(!$1.ival){$$.ival=0;}else{$$.ival=1;}$$.type=$1.type;}
;
OR_OP   :  _or EXP OR_EXP   {if($2.type!=$3.type){yyerror("type error");return 0;}if($2.ival|$3.ival){$$.ival=1;}else{$$.ival=0;}$$.type=$2.type;}
;
OR_EXP : EXP OR_EXP {if($1.ival|$2.ival){$$.ival=1;}else{$$.ival=0;}}
	   | EXP {if(!$1.ival){$$.ival=0;}else{$$.ival=1;}$$.type=$1.type;}
;
NOT_OP :  _not EXP  {if($2.type!='b'){yyerror("type error");return 0;}if($2.ival){$$.ival=0;}else{$$.ival=1;}$$.type=$2.type;}
;
IF_EXP :  _if TEST_EXP THEN_EXP ELSE_EXP  {if(!$2.ival){$$.ival=$4.ival;}else{$$.ival=$3.ival;}$$.type=$2.type;}
;
TEST_EXP : EXP {$$.ival=$1.ival;$$.type=$1.type;}
;
THEN_EXP : EXP {$$.ival=$1.ival;$$.type=$1.type;}
;
ELSE_EXP : EXP {$$.ival=$1.ival;$$.type=$1.type;}
;
DEF_STMT    : '(' define ID EXP ')'	{var[index].a=$3.word; var[index].value=$4.ival;var[index].type=$4.type; index++; $$.ival=$4.ival;$$.type=$4.type;}
;
VARIABLE    : ID {$$.ival=var[index-1].value;$$.type=var[index-1].type;index--;}
;
%%

void yyerror (const char *message)
{
	printf("syntax error : %s\n",message);
}

int main(int argc, char** argv)
{
    yyparse();
    return 0;
}
