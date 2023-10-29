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

<INITIAL>"//" {  col += 2; BEGIN COMMENT1;  }
<INITIAL>"/*" {  col += 2; BEGIN COMMENT2;  }
<COMMENT1>"\n" {  line += 1; col = 0; BEGIN INITIAL;  }
<COMMENT2>"*/" {  col += 2; BEGIN INITIAL;  }

<INITIAL>
"fn" {yylval.pos = A_Pos(line, col); col += 2; return FUN;}
"struct" {yylval.pos = A_Pos(line, col); col += 6; return STRUCT;}
"if" {yylval.pos = A_Pos(line, col); col += 2; return IF;}
"else" {yylval.pos = A_Pos(line, col); col += 4; return ELSE;}
"while" {yylval.pos = A_Pos(line, col); col += 5; return WHILE;}
"let" {yylval.pos = A_Pos(line, col); col += 3; return LET;}
"int" {yylval.pos = A_Pos(line, col); col += 3; return INT;}
"ret" {yylval.pos = A_Pos(line, col); col += 3; return RET;}
"break" {yylval.pos = A_Pos(line, col); col += 5; return BREAK;}
"continue" {yylval.pos = A_Pos(line, col); col += 8; return CONTINUE;}
[a-zA-Z][a-zA-Z0-9]* {yylval.id = A_TokenId(A_Pos(line, col), yytext); col += strlen(yytext); return ID;}
[1-9][0-9]*|0 {yylval.num = A_TokenNum(A_Pos(line, col), atoi(yytext)); col += strlen(yytext); return NUM;}
"("	{yylval.pos = A_Pos(line, col); col += 1; return LPAR;}
")"	{yylval.pos = A_Pos(line, col); col += 1; return RPAR;}
"[" {yylval.pos = A_Pos(line, col); col += 1; return LBRA;}
"]" {yylval.pos = A_Pos(line, col); col += 1; return RBRA;}
"{" {yylval.pos = A_Pos(line, col); col += 1; return LCUR;}
"}" {yylval.pos = A_Pos(line, col); col += 1; return RCUR;}
"+"	{yylval.pos = A_Pos(line, col); col += 1; return ADD;}
"-"	{yylval.pos = A_Pos(line, col); col += 1; return SUB;}
"*"	{yylval.pos = A_Pos(line, col); col += 1; return MUL;}
"/"	{yylval.pos = A_Pos(line, col); col += 1; return DIV;}
"&&" {yylval.pos = A_Pos(line, col); col += 2; return AND;}
"||" {yylval.pos = A_Pos(line, col); col += 2; return OR;}
"!" {yylval.pos = A_Pos(line, col); col += 1; return INVERSE;}
"." {yylval.pos = A_Pos(line, col); col += 1; return DOT;}
">" {yylval.pos = A_Pos(line, col); col += 1; return GT;}
"<" {yylval.pos = A_Pos(line, col); col += 1; return LT;}
">=" {yylval.pos = A_Pos(line, col); col += 2; return GTE;}
"<=" {yylval.pos = A_Pos(line, col); col += 2; return LTE;}
"!=" {yylval.pos = A_Pos(line, col); col += 2; return NE;}
"==" {yylval.pos = A_Pos(line, col); col += 2; return EQUAL;}
"=" {yylval.pos = A_Pos(line, col); col += 1; return ASSIGN;}
"->" {yylval.pos = A_Pos(line, col); col += 2; return ARR;}
"," {yylval.pos = A_Pos(line, col); col += 1; return COMMA;}
":" {yylval.pos = A_Pos(line, col); col += 1; return COLON;}
" "   {col += 1;}
"\t" {col += 4;}
"\n" {line++; col = 0;}
";"     {yylval.pos = A_Pos(line, col); col += 1; return SEMICOLON;}
<COMMENT1>
.*  {col += strlen(yytext);}
<COMMENT2>
.*  {col += strlen(yytext);}
"\n"  {line += 1; col = 0;}


%%