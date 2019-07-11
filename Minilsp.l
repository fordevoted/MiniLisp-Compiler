%{
#include "Minilsp.tab.h"
%}
separator   [\t\n\r ]
letter      [a-z]
digit       [0-9]

number	    0|[1-9]{digit}*|-[1-9]{digit}*
ID	        {letter}({letter}|{digit}|-)*

%%

"print-num" {return(print_num);}
"print-bool" {return(print_bool);}
"+"|"-"|"*"|"/"|">"|"<"|"="|"("|")" {;return(yytext[0]);}
"mod" {return(mod);}
"and" {return(_and);}
"or" {return(_or);}
"not" {return(_not);}
"if" {return(_if);}
"define" {yylval.str.word=strdup(yytext);return(define);}
{number} {yylval.str.ival=atoi(yytext);yylval.str.type='n';return(number);}
{ID} {yylval.str.word=strdup(yytext);yylval.str.type='n';return(ID);}
"#t" {yylval.str.word=strdup(yytext);yylval.str.type='b';yylval.str.ival=1;return(bool_val);}
"#f" {yylval.str.word=strdup(yytext);yylval.str.type='b';yylval.str.ival=0;return(bool_val);}
{separator}	{;}
. {return(yytext[0]);}
%%
int yywrap(){return 1;}
