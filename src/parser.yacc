%{
#include <stdio.h>
#include "TeaplAst.h"

extern A_pos pos;
extern A_program root;

extern int yylex(void);
extern "C"{
extern void yyerror(char *s); 
extern int  yywrap();
}

%}

// TODO:
// your parser

%union {
  A_pos pos;
  A_program program;
  A_programElementList programElementList;
  A_programElement programElement;
  A_arithExpr arithExpr;
  A_exprUnit exprUnit;
  A_structDef structDef;
  A_varDeclStmt varDeclStmt;
  A_fnDeclStmt fnDeclStmt;
  A_fnDef fnDef;
  A_fnCall fnCall;
  A_rightValList rightValList;
  A_rightVal rightVal;
  A_boolExpr boolExpr;
  A_boolUnit boolUnit;
  A_fnDecl fnDecl;
  A_varDeclList varDecls;
  A_varDecl varDecl;
  A_paramDecl paramDecl;
  A_type type;
  A_codeBlockStmtList codeBlockStmtList;
  A_codeBlockStmt codeBlockStmt;
  A_tokenId id;
  A_tokenNum num;
  A_varDef varDef;
  A_leftVal leftVal;
}

%token <pos> ADD
%token <pos> SUB
%token <pos> MUL
%token <pos> DIV
%token <pos> SEMICOLON // ;
%token <id> ID
%token <num> NUM

%token <pos>FUN
%token <pos>STRUCT
%token <pos>LET
%token <pos>IF
%token <pos>ELSE
%token <pos>WHILE
%token <pos>COMMA // ,
%token <pos>COLON // :
%token <pos>DOT
%token <pos>INT
%token <pos>ARR
%token <pos>RET CONTINUE BREAK
%token <pos>AND OR INVERSE
%token <pos>GT LT GTE LTE EQUAL NE ASSIGN
%token <pos>LPAR RPAR
%token <pos>LBRA RBRA
%token <pos>LCUR RCUR

%type <program> Program
%type <arithExpr> ArithExpr
%type <programElementList> ProgramElementList
%type <programElement> ProgramElement
%type <exprUnit> ExprUnit
%type <structDef> StructDef
%type <varDeclStmt> VarDeclStmt
%type <fnDeclStmt> FnDeclStmt
%type <fnDef> FnDef

%type <rightValList> RightVals
%type <rightVal> RightVal
%type <fnCall> FnCall
%type <boolExpr> BoolExpr
%type <boolUnit> BoolUnit
%type <fnDecl> FnDecl
%type <varDecls> VarDecls
%type <varDecl> VarDecl
%type <paramDecl> ParamDecl
%type <type> Type
%type <codeBlockStmtList> CodeBlock
%type <codeBlockStmtList> Stmts
%type <codeBlockStmt> Stmt
%type <varDef> VarDef
%type <leftVal>LeftVal

%left ADD SUB
%left MUL DIV

%start Program

/*structDef VarDeclStmt FnDeclStmt FnDef */
%%                   /* beginning of rules section */

Program: ProgramElementList 
{  
  root = A_Program($1);
  $$ = A_Program($1);
}
;

ProgramElementList: ProgramElement ProgramElementList
{
  $$ = A_ProgramElementList($1, $2);
}
|
{
  $$ = NULL;
}
;

ProgramElement: VarDeclStmt
{
  $$ = A_ProgramVarDeclStmt($1->pos, $1);
}
| StructDef
{
  $$ = A_ProgramStructDef($1->pos, $1);
}
| FnDeclStmt
{
  $$ = A_ProgramFnDeclStmt($1->pos, $1);
}
| FnDef
{
  $$ = A_ProgramFnDef($1->pos, $1);
}
| SEMICOLON
{
  $$ = A_ProgramNullStmt($1);
}
;


BoolExpr : BoolExpr AND BoolUnit
{
  $$ = A_BoolBiOp_Expr($1->pos, A_BoolBiOpExpr($1->pos, A_and, $1, $3));
}
|BoolExpr OR BoolUnit 
{
  $$ = A_BoolBiOp_Expr($1->pos, A_BoolBiOpExpr($1->pos, A_or, $1, $3));
}
| BoolUnit
{
  $$ = A_BoolExpr($1->pos, $1);
}
;
BoolUnit : LPAR ExprUnit GT  ExprUnit RPAR  
{
  $$ = A_ComExprUnit($1, A_ComExpr($1, A_gt, $2, $4));
}
| LPAR ExprUnit LT ExprUnit RPAR  
{
  $$ = A_ComExprUnit($1, A_ComExpr($1, A_lt, $2, $4));
}
| LPAR ExprUnit GTE ExprUnit RPAR  
{
  $$ = A_ComExprUnit($1, A_ComExpr($1, A_ge, $2, $4));
}
| LPAR ExprUnit LTE ExprUnit RPAR  
{
  $$ = A_ComExprUnit($1, A_ComExpr($1, A_le, $2, $4));
}
| LPAR ExprUnit EQUAL ExprUnit RPAR  
{
  $$ = A_ComExprUnit($1, A_ComExpr($1, A_eq, $2, $4));
}
| LPAR ExprUnit NE ExprUnit RPAR  
{
  $$ = A_ComExprUnit($1, A_ComExpr($1, A_ne, $2, $4));
}
| LPAR BoolExpr RPAR 
{
  $$ = A_BoolExprUnit($1, $2);
}
| INVERSE BoolUnit 
{
  $$ = A_BoolUOpExprUnit($1, A_BoolUOpExpr($1, A_not, $2));
}
;




ArithExpr: ArithExpr ADD ArithExpr
{
  $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_add, $1, $3));
}
| ArithExpr SUB ArithExpr
{
  $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_sub, $1, $3));
}
| ArithExpr MUL ArithExpr
{
  $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_mul, $1, $3));
}
| ArithExpr DIV ArithExpr
{
  $$ = A_ArithBiOp_Expr($1->pos, A_ArithBiOpExpr($1->pos, A_div, $1, $3));
}
| ExprUnit
{
  $$ = A_ExprUnit($1->pos, $1);
}
;

ExprUnit : NUM
{
  $$ = A_NumExprUnit($1->pos, $1->num);
}
| ID
{
  $$ = A_IdExprUnit($1->pos, $1->id);
}
| LPAR ArithExpr RPAR
{
  $$ = A_ArithExprUnit($1, $2);
}
| FnCall
{
  $$ = A_CallExprUnit($1->pos, $1);
}
| ID LBRA ID RBRA
{
  $$ = A_ArrayExprUnit($1->pos, A_ArrayExpr($1->pos, $1->id, A_IdIndexExpr($1->pos, $3->id)));
}
| ID LBRA NUM RBRA
{
  $$ = A_ArrayExprUnit($1->pos, A_ArrayExpr($1->pos, $1->id, A_NumIndexExpr($1->pos, $3->num)));
}
| ID DOT ID
{
  $$ = A_MemberExprUnit($1->pos, A_MemberExpr($1->pos, $1->id, $3->id));
}
| SUB ExprUnit
{
  $$ = A_ArithUExprUnit($1, A_ArithUExpr($1, A_neg ,$2));
}
;

RightVal : ArithExpr 
{
  $$ = A_ArithExprRVal($1->pos, $1);
}
| BoolExpr
{
  $$ = A_BoolExprRVal($1->pos, $1);
}
;
LeftVal : ID 
{
  $$ = A_IdExprLVal($1->pos, $1->id);
}
| ID LBRA ID RBRA 
{
  $$ = A_ArrExprLVal($1->pos, A_ArrayExpr($1->pos, $1->id, A_IdIndexExpr($1->pos, $3->id)));
}
|ID LBRA NUM RBRA
{
  $$ = A_ArrExprLVal($1->pos, A_ArrayExpr($1->pos, $1->id, A_NumIndexExpr($1->pos, $3->num)));
}
| ID DOT ID
{
  $$ = A_MemberExprLVal($1->pos, A_MemberExpr($1->pos, $1->id, $3->id));
}
;
RightVals:RightVal COMMA RightVals
{
  $$=A_RightValList($1, $3);
}
|RightVal
{
  $$=A_RightValList($1, NULL);
}
;
FnCall : ID LPAR RightVals RPAR
{
  $$ = A_FnCall($1->pos, $1->id,$3);
}
|ID LPAR RPAR
{
  $$ = A_FnCall($1->pos, $1->id, NULL);
}
;

FnDeclStmt : FnDecl SEMICOLON
{
  $$ = A_FnDeclStmt($1->pos, $1);
}
;
FnDecl : FUN ID LPAR ParamDecl RPAR 
{
  $$ = A_FnDecl($1, $2->id, $4, A_NativeType($1, A_intTypeKind));//不给type默认int
}
| FUN ID LPAR ParamDecl RPAR ARR Type 
{
  $$ = A_FnDecl($1, $2->id, $4, $7);
}
;
Type:INT
{
  $$ = A_NativeType($1, A_intTypeKind);
}
|ID
{
  $$ = A_StructType($1->pos, $1->id);
}
;
VarDecls:VarDecl COMMA VarDecls
{
  $$ = A_VarDeclList($1, $3);
}
|VarDecl
{
  $$ = A_VarDeclList($1, NULL);
}
;
ParamDecl : VarDecls
{
  $$ = A_ParamDecl($1);
}
|
{
  $$ = NULL;
}
;


FnDef : FnDecl CodeBlock
{
  $$ = A_FnDef($1->pos, $1, $2);
}  
;
CodeBlock : LCUR Stmts RCUR
{
  $$ = $2;
} 
;
Stmts:Stmt Stmts
{
  $$ = A_CodeBlockStmtList($1, $2);
}
|Stmt
{
  $$ = A_CodeBlockStmtList($1, NULL);
}
;

Stmt: VarDeclStmt
{
  $$ = A_BlockVarDeclStmt($1->pos, $1);
}
| LeftVal ASSIGN RightVal SEMICOLON 
{
  $$ = A_BlockAssignStmt($1->pos, A_AssignStmt($1->pos, $1, $3));
}
| FnCall SEMICOLON
{
  $$ = A_BlockCallStmt($1->pos, A_CallStmt($1->pos, $1));
}
| IF LPAR BoolExpr RPAR CodeBlock ELSE CodeBlock 
{
  $$ = A_BlockIfStmt($1, A_IfStmt($1, $3, $5, $7));
}
|IF LPAR BoolExpr RPAR CodeBlock
{
  $$ = A_BlockIfStmt($1, A_IfStmt($1, $3, $5, NULL));
}
| WHILE LPAR BoolExpr RPAR CodeBlock 
{
  $$ = A_BlockWhileStmt($1, A_WhileStmt($1, $3, $5));
}
| RET RightVal SEMICOLON
{
  $$ =A_BlockReturnStmt($1, A_ReturnStmt($1, $2));
}
| CONTINUE SEMICOLON 
{
  $$ =A_BlockContinueStmt($1);
}
| BREAK SEMICOLON
{
  $$ = A_BlockBreakStmt($1);
}
| SEMICOLON
{
  $$ = A_BlockNullStmt($1);
}
;


VarDeclStmt: LET VarDecl SEMICOLON
{
  $$ = A_VarDeclStmt($1, $2);
}
| LET VarDef SEMICOLON
{
  $$ = A_VarDefStmt($1,  $2);
}
;

VarDecl: ID COLON Type
{
  $$ = A_VarDecl_Scalar($1->pos, A_VarDeclScalar($1->pos, $1->id, $3));
}
| ID LBRA NUM RBRA COLON Type
{
  $$ = A_VarDecl_Array($1->pos,  A_VarDeclArray($1->pos, $1->id, $3->num, $6));
}
| ID
{
  $$ = A_VarDecl_Scalar($1->pos,  A_VarDeclScalar($1->pos, $1->id, NULL));
}
| ID LBRA NUM RBRA
{
  $$ = A_VarDecl_Array($1->pos,  A_VarDeclArray($1->pos, $1->id, $3->num, NULL));
};

VarDef: ID COLON Type ASSIGN RightVal
{
  $$ = A_VarDef_Scalar($1->pos, A_VarDefScalar($1->pos, $1->id, $3, $5));
}
| ID ASSIGN RightVal  //primitive type
{
  $$ = A_VarDef_Scalar($1->pos, A_VarDefScalar($1->pos, $1->id, A_NativeType($1->pos, A_intTypeKind), $3));
}
| ID LBRA NUM RBRA COLON Type ASSIGN LCUR RightVals RCUR
{
  $$ = A_VarDef_Array($1->pos, A_VarDefArray($1->pos, $1->id, $3->num, $6, $9));
}
| ID LBRA NUM RBRA ASSIGN LCUR RightVals RCUR //array
{
  $$ = A_VarDef_Array($1->pos, A_VarDefArray($1->pos, $1->id, $3->num, A_NativeType($1->pos, A_intTypeKind), $7));
}
;

StructDef: STRUCT ID LCUR VarDecls RCUR
{
  $$ = A_StructDef($2->pos, $2->id, $4);
}
;

%%

extern "C"{
void yyerror(char * s)
{
  fprintf(stderr, "%s\n",s);
}
int yywrap()
{
  return(1);
}
}


