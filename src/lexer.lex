%{
#include <stdio.h>
#include <string.h>
#include "TeaplAst.h"
#include "y.tab.hpp"
extern int line, col;
%}
%s COMMENT1
%s COMMENT2
%%

<INITIAL>"//" {  col += 2; BEGIN(COMMENT1);  }
<INITIAL>"/*" {  col += 2; BEGIN(COMMENT2);  }
<COMMENT2>"\n" {  line += 1; col = 0; }
<COMMENT2>"*/" {  col += 2; BEGIN(INITIAL);  }
<COMMENT2>.  {col += 1;}
<COMMENT1>"\n" {  line += 1; col = 0; BEGIN(INITIAL);  }
<COMMENT1>.*  {col += strlen(yytext);}


<INITIAL>"fn" {yylval.pos = A_Pos(line, col); col += 2; return FUN;}
<INITIAL>"struct" {yylval.pos = A_Pos(line, col); col += 6; return STRUCT;}
<INITIAL>"if" {yylval.pos = A_Pos(line, col); col += 2; return IF;}
<INITIAL>"else" {yylval.pos = A_Pos(line, col); col += 4; return ELSE;}
<INITIAL>"while" {yylval.pos = A_Pos(line, col); col += 5; return WHILE;}
<INITIAL>"let" {yylval.pos = A_Pos(line, col); col += 3; return LET;}
<INITIAL>"int" {yylval.pos = A_Pos(line, col); col += 3; return INT;}
<INITIAL>"ret" {yylval.pos = A_Pos(line, col); col += 3; return RET;}
<INITIAL>"break" {yylval.pos = A_Pos(line, col); col += 5; return BREAK;}
<INITIAL>"continue" {yylval.pos = A_Pos(line, col); col += 8; return CONTINUE;}
<INITIAL>[a-zA-Z][a-zA-Z0-9]* {yylval.id = A_TokenId(A_Pos(line, col), strdup(yytext)); col += strlen(yytext); return ID;}
<INITIAL>[1-9][0-9]*|0 {yylval.num = A_TokenNum(A_Pos(line, col), atoi(yytext)); col += strlen(yytext); return NUM;}
<INITIAL>"("	{yylval.pos = A_Pos(line, col); col += 1; return LPAR;}
<INITIAL>")"	{yylval.pos = A_Pos(line, col); col += 1; return RPAR;}
<INITIAL>"[" {yylval.pos = A_Pos(line, col); col += 1; return LBRA;}
<INITIAL>"]" {yylval.pos = A_Pos(line, col); col += 1; return RBRA;}
<INITIAL>"{" {yylval.pos = A_Pos(line, col); col += 1; return LCUR;}
<INITIAL>"}" {yylval.pos = A_Pos(line, col); col += 1; return RCUR;}
<INITIAL>"+"	{yylval.pos = A_Pos(line, col); col += 1; return ADD;}
<INITIAL>"-"	{yylval.pos = A_Pos(line, col); col += 1; return SUB;}
<INITIAL>"*"	{yylval.pos = A_Pos(line, col); col += 1; return MUL;}
<INITIAL>"/"	{yylval.pos = A_Pos(line, col); col += 1; return DIV;}
<INITIAL>"&&" {yylval.pos = A_Pos(line, col); col += 2; return AND;}
<INITIAL>"||" {yylval.pos = A_Pos(line, col); col += 2; return OR;}
<INITIAL>"!" {yylval.pos = A_Pos(line, col); col += 1; return INVERSE;}
<INITIAL>"." {yylval.pos = A_Pos(line, col); col += 1; return DOT;}
<INITIAL>">" {yylval.pos = A_Pos(line, col); col += 1; return GT;}
<INITIAL>"<" {yylval.pos = A_Pos(line, col); col += 1; return LT;}
<INITIAL>">=" {yylval.pos = A_Pos(line, col); col += 2; return GTE;}
<INITIAL>"<=" {yylval.pos = A_Pos(line, col); col += 2; return LTE;}
<INITIAL>"!=" {yylval.pos = A_Pos(line, col); col += 2; return NE;}
<INITIAL>"==" {yylval.pos = A_Pos(line, col); col += 2; return EQUAL;}
<INITIAL>"=" {yylval.pos = A_Pos(line, col); col += 1; return ASSIGN;}
<INITIAL>"->" {yylval.pos = A_Pos(line, col); col += 2; return ARR;}
<INITIAL>"," {yylval.pos = A_Pos(line, col); col += 1; return COMMA;}
<INITIAL>":" {yylval.pos = A_Pos(line, col); col += 1; return COLON;}
<INITIAL>" "   {col += 1;}
<INITIAL>"\t" {col += 4;}
<INITIAL>"\n" {line++; col = 0;}
<INITIAL>";"     {yylval.pos = A_Pos(line, col); col += 1; return SEMICOLON;}
<INITIAL>.	{ printf("Unknown character!\n"); }

%%