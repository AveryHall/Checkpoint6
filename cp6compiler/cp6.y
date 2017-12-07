%{

/*
 * ========================================================================
 *
 * cp4parser.y ---- A simple version of our parser for the Slic language
 *        which should match the regular expressions of our language
 *        using the tokens defined in our flex scanner. This
 *		    iteration additionally should successfully build a
 *		    symbol table for the variables defined in the data
 *		    data section of an input Slic program
 *
 * Programmer ---   Avery Hall
 *
 * ========================================================================
 */

#include "symtab.h"
#include "ast.h"
#include "y.tab.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

// Define struct for symtab
struct symboltable symtab;

// Additional structs for building the symbol table
struct symbolList {
	struct symbolList *symlink;
	struct symbol *thisSym;
};

struct symbolList *symList;

// Define struct for Abstract Syntax Tree (AST)
struct statementList *ast;


//
// Symbol Table Functions
//

/*
 * =======================================================================
 * InitTable()
 * =======================================================================
 */

 void initTable()
 {
	 symtab.size = 0;
	 symtab.nextAddress = 0;
 }

 /*
  * =======================================================================
  * addSymToTable()
  * =======================================================================
  */

  void addSymToTable(char *name, char k, char t, int s) //(, int addr)
  {

		struct symbol sym;

		//if(findSymbol(name) == -1) In parser is best
		//{

		//Set the values of the symbol
		sym.varname = name;
		sym.kind = k;
		sym.type = t;
		sym.size = s;
		sym.address = symtab.nextAddress;

		//Insert the symbol into the symtab at the current available location
		symtab.st[symtab.size] = sym;

		//Update the next available address in the gstal stack and the next available slot in the symtab
		symtab.nextAddress += s;
		symtab.size += 1;

		//return (symtab.size-1);

		//} else { You really want to do this in parser
		//		//Throw an error
		//}
  }

  /*
   * =======================================================================
   * findSymbol()
   * =======================================================================
   */

   int findSymbol(char *name)
   {

		 for(int i=0; i< symtab.size; i++)
		 {
			 if(strcmp(name, symtab.st[i].varname) == 0)
			 {
				 return i;
			 }
		 }

		 return -1;
   }

	 /*
 * ========================================================================
 * eval(p) -- Evaluate an integer expression.  p is a pointer to the
 *            expression.  Return the resulting int value.
 * ========================================================================
 */

int eval(struct expression *p)
{
   int value;

   if (p->kind == EK_INT) {
      value = p->ivalue;
   }
   else {
      switch (p->operator) {
         case OP_ADD:  value = eval(p->l_operand) + eval(p->r_operand);
                       break;
         case OP_SUB:  value = eval(p->l_operand) - eval(p->r_operand);
                       break;
         case OP_MUL:  value = eval(p->l_operand) * eval(p->r_operand);
                       break;
         case OP_DIV:  value = eval(p->l_operand) / eval(p->r_operand);
                       break;
         case OP_UMIN: value = - eval(p->r_operand);
                       break;
      }
   }
   return (value);
 }

%}

%union{
   char  *cptr;
   int    ival;
   float  rval;

   char		       				symkind;
   struct symbol       	*sym;
   struct symbolList   	*symListPoint;

	 struct statementList *stmtList;
	 struct statement 		*stmt;
	 struct expression    *exprpoint;
	 int                   indexval;
	 struct printlist     *pl;
	 struct printitem     *pi;
}

%token        RWMAIN
%token        RWDATA
%token        RWALGORITHM
%token        RWEXIT
%token        RWINTEGER
%token        RWREAL
%token        RWIF
%token        RWELSE
%token        RWCOUNTING
%token        RWUPWARD
%token        RWDOWNWARD
%token        RWTO
%token        RWWHILE
%token        RWREAD
%token        RWPRINT
%token        RWEND
%token <cptr> VARNAME
%token        SEMICOLON
%token        COLON
%token        COMMA
%token        COMMENT
%token        ADDOP
%token        SUBOP
%token        MULTOP
%token        DIVOP
%token        MODOP
%token        LTOP
%token        LEQOP
%token        GTOP
%token        GEQOP
%token        EQOP
%token        NEQOP
%token        ANDOP
%token        OROP
%token        NOTOP
%token        RPAREN
%token        LPAREN
%token        RSQBRAC
%token        LSQBRAC
%token        ASSIGNOP
%token        CARRIAGERETURN
%token <rval> FLTCONST
%token <cptr> STRCONST
%token <ival> INTCONST
%token        NEWLINE
%token        IGNORE


%type  <symListPoint>  	decitemlist
%type  <symkind>  			typename
%type  <sym>      			decitem

%type  <stmtList>				statementlist
%type  <stmt>           statement
%type  <indexval>       varref
%type  <exprpoint>      whilestmt
%type  <stmt>           countupstmt
%type  <stmt>           countdownstmt
%type  <exprpoint>      ifstmt
%type  <indexval>       readstmt
%type  <pl>             printstmt
%type  <pl>             printlist
%type  <pi>             printitem
%type  <exprpoint>      expr
%type  <exprpoint>      bool
%type  <exprpoint>      exp
%type  <exprpoint>      term
%type  <exprpoint>      factor
%type  <exprpoint>      unit
%type  <exprpoint>      number


%%

prog          : mainstmt { initTable(); } datasect algrsect endmainstmt
              ;

mainstmt      : RWMAIN SEMICOLON
              ;

endmainstmt   : RWEND RWMAIN SEMICOLON
              ;

datasect      : RWDATA COLON decstmtlist
              | RWDATA COLON
              ;

decstmtlist   : decstmt decstmtlist
              | decstmt
              ;

decstmt       : typename COLON decitemlist SEMICOLON
			{

				char t = $1;
				//printf("%c\n",$1);
				symList = $3;

				while(symList != NULL) {
					struct symbol *s = symList->thisSym;

					if(findSymbol(s->varname) == -1) {
						if(symtab.size != CAPACITY) {
					    addSymToTable(s->varname, s->kind, t, s->size);
					  } else {
							yyerror("symbol table is full");
							YYERROR;
						}
				  } else {
						yyerror("duplicate declaration");
						YYERROR;
					}

					symList = symList->symlink;
				}
			}
              ;

typename      : RWREAL
			{
		  	$$ = ST_REAL;
			}
              | RWINTEGER
			{
		  	$$ = ST_INT;
			}
              ;

decitemlist   : decitem COMMA decitemlist
			{
		  	$$ = malloc(sizeof(struct symbolList));
		  	$$->symlink = $3;
		  	$$->thisSym = $1;
			}
              | decitem
			{
		  	$$ = malloc(sizeof(struct symbolList));
		  	$$->symlink = NULL;
		  	$$->thisSym = $1;
			}
              ;

decitem       : VARNAME
			{
				$$ = malloc(sizeof(struct symbol));
		  	$$->varname = $1;
		  	$$->kind = SK_SCALAR;
		  	$$->size = 1;
			}
              | VARNAME LSQBRAC INTCONST RSQBRAC
			{
				$$ = malloc(sizeof(struct symbol));
		  	$$->varname = $1;
		  	$$->kind = SK_ARRAY;
		  	$$->size = $3;
			}
              ;





algrsect      : RWALGORITHM COLON statementlist
							{
								$3 = ast;
							}
							| RWALGORITHM COLON
              ;

statementlist : statement statementlist
							{
								$$ = malloc(sizeof(struct statementList));
								$$->nextStatement = $2;
								$$->thisStatement = $1;
							}
              | statement
							{
								$$ = malloc(sizeof(struct statementList));
								$$->nextStatement = NULL;
								$$->thisStatement = $1;
							}
							|
							{

							}
              ;

statement     : RWEXIT SEMICOLON
							{
								$$ = malloc(sizeof(struct statement));
								$$->stmtkind = SK_EXIT;
							}
              | varref ASSIGNOP expr SEMICOLON
							{
								$$ = malloc(sizeof(struct statement));
								$$->stmtkind = SK_ASSIGN;
								$$->index = $1;
								$$->expr1 = $3;
							}
              | whilestmt statementlist endwhilestmt
							{
								$$ = malloc(sizeof(struct statement));
								$$->stmtkind = SK_WHILE;
								$$->expr1 = $1;
								$$->body1 = $2;
							}
              | countupstmt statementlist endcountstmt
							{
								$$ = malloc(sizeof(struct statement));
								$$->stmtkind = SK_COUNTUP;
								$$->expr1 = $1->expr1;
								$$->expr2 = $1->expr2;
								$$->body1 = $2;
							}
              | countdownstmt statementlist endcountstmt
							{
								$$ = malloc(sizeof(struct statement));
								$$->stmtkind = SK_COUNTDOWN;
								$$->expr1 = $1->expr1;
								$$->expr2 = $1->expr2;
								$$->body1 = $2;
							}
              | ifstmt statementlist endifstmt
							{
								$$ = malloc(sizeof(struct statement));
								$$->stmtkind = SK_IF;
								$$->expr1 = $1;
								$$->body1 = $2;
							}
              | ifstmt statementlist elsestmt statementlist endifstmt
							{
								$$ = malloc(sizeof(struct statement));
								$$->stmtkind = SK_IF_ELSE;
								$$->expr1 = $1;
								$$->body1 = $2;
								$$->body2 = $4;
							}
              | readstmt
							{
								$$ = malloc(sizeof(struct statement));
								$$->stmtkind = SK_READ;
								$$->index = $1;
							}
              | printstmt
							{
								$$ = malloc(sizeof(struct statement));
								$$->stmtkind = SK_PRINT;
								$$->plist = $1;
							}
              ;

varref        : VARNAME
							{
								int index = findSymbol($1);

								if(index == -1) {
									yyerror("Referenced variable was not declared");
									YYERROR;
								} else { // The variable was found
									$$ = index;
								}
							}
              | VARNAME LSQBRAC expr RSQBRAC
							{
								int index = findSymbol($1);

								if(index == -1) {
									yyerror("Referenced variable was not declared");
									YYERROR;
								} else { // The variable was find

									int relativeIndex = eval($3);
									//FIXME define expreval function for evaluating expressions

									if (relativeIndex < 0 || relativeIndex >= symtab.st[index].size) {
										yyerror("Array index out of bounds");
										YYERROR;
									} else {
										$$ = index + relativeIndex;
									}
								}
							}
              ;

whilestmt     : RWWHILE expr SEMICOLON
							{
								$$ = $2;
							}
              ;

endwhilestmt  : RWEND RWWHILE SEMICOLON
              ;

countupstmt   : RWCOUNTING VARNAME RWUPWARD expr RWTO expr SEMICOLON
							{
								$$ = malloc(sizeof(struct statement));
								$$->expr1 = $4;
								$$->expr2 = $6;
							}
              ;

countdownstmt : RWCOUNTING VARNAME RWDOWNWARD expr RWTO expr SEMICOLON
							{
								$$ = malloc(sizeof(struct statement));
								$$->expr1 = $4;
								$$->expr2 = $6;
							}
              ;

endcountstmt  : RWEND RWCOUNTING SEMICOLON
              ;

ifstmt        : RWIF expr SEMICOLON
							{
								$$ = $2;
							}
              ;

elsestmt      : RWELSE SEMICOLON
              ;

endifstmt     : RWEND RWIF SEMICOLON
              ;

readstmt      : RWREAD varref SEMICOLON
							{
								$$ = $2;
							}
              ;

printstmt     : RWPRINT printlist SEMICOLON
							{
								$$ = $2;
							}
              ;

printlist     : printitem COMMA printlist
							{
								$$ = malloc(sizeof(struct printlist));
								$$->nextItem = $3;
								$$->thisItem = $1;
							}
              | printitem
							{
								$$ = malloc(sizeof(struct printlist));
								$$->nextItem = NULL;
								$$->thisItem = $1;
							}
              ;

printitem     : expr
							{
								$$ = malloc(sizeof(struct printitem));
								$$->pkind = PK_EXP;
								$$->expr1 = $1;
							}
              | STRCONST
							{
								$$ = malloc(sizeof(struct printitem));
								$$->pkind = PK_STR;
								$$->outstr = $1;
							}
              | CARRIAGERETURN
							{
								$$ = malloc(sizeof(struct printitem));
								$$->pkind = PK_CRLF;
							}
              ;

expr          : expr ANDOP bool
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_AND;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | expr OROP bool
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_OR;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | NOTOP bool
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_NOT;
								$$->r_operand = $2;
							}
              | bool
							{
								$$ = $1;
							}
              ;

bool          : bool LTOP exp
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_LT;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | bool LEQOP exp
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_LEQ;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | bool GTOP exp
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_GT;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | bool GEQOP exp
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_GEQ;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | bool EQOP exp
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_EQ;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | bool NEQOP exp
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_NEQ;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | exp
							{
								$$ = $1;
							}
              ;

exp           : exp ADDOP term
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_ADD;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | exp SUBOP term
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_SUB;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | term
							{
								$$ = $1;
							}
              ;

term          : term MULTOP factor
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_MUL;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | term DIVOP factor
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_DIV;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | term MODOP factor
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_MOD;
								$$->l_operand = $1;
								$$->r_operand = $3;
							}
              | factor
							{
								$$ = $1;
							}
              ;

factor        : SUBOP unit
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_OP;
								$$->operator = OP_UMIN;
								$$->r_operand = $2;
							}
              | unit
							{
								$$ = $1;
							}
              ;

unit          : LPAREN expr RPAREN
							{
								$$ = $2;
							}
              | number
							{
								$$ = $1;
							}
              ;

number        : INTCONST
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_INT;
								$$->ivalue = $1;
							}
              | FLTCONST
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_REAL;
								$$->rvalue = $1;
							}
              | varref
							{
								$$ = malloc(sizeof(struct expression));
								$$->kind = EK_VAR;
								$$->index = $1;
							}
              ;


%%

int yyerror(char *msg)
{
   printf("Error: %s\n", msg);
   return(0);
}
