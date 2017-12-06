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
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>

struct symboltable symtab;

struct symbolList {
	struct symbolList *symlink;
	struct symbol *thisSym;
};

struct symbolList *symList;

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

%}

%union{
   char  *cptr;
   int    ival;
   float  rval;


   char		       				symkind;
   struct symbol       	*sym;
   struct symbolList   	*symListPoint;
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

%type  <symList>  			decstmt
%type  <symListPoint>  	decitemlist
%type  <symkind>  			typename
%type  <sym>      			decitem




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
              ;

statementlist : statement statementlist
              | statement
              |
              ;

statement     : RWEXIT SEMICOLON
              | varref ASSIGNOP expr SEMICOLON
              | whilestmt statementlist endwhilestmt
              | countupstmt statementlist endcountstmt
              | countdownstmt statementlist endcountstmt
              | ifstmt statementlist endifstmt
              | elsestmt statementlist
              | readstmt
              | printstmt
              ;

varref        : VARNAME
              | VARNAME LSQBRAC expr RSQBRAC
              ;

whilestmt     : RWWHILE expr SEMICOLON
              ;

endwhilestmt  : RWEND RWWHILE SEMICOLON
              ;

countupstmt   : RWCOUNTING VARNAME RWUPWARD expr RWTO expr SEMICOLON
              ;

countdownstmt : RWCOUNTING VARNAME RWDOWNWARD expr RWTO expr SEMICOLON
              ;

endcountstmt  : RWEND RWCOUNTING SEMICOLON
              ;

ifstmt        : RWIF expr SEMICOLON
              ;

elsestmt      : RWELSE SEMICOLON
              ;

endifstmt     : RWEND RWIF SEMICOLON
              ;

readstmt      : RWREAD varref SEMICOLON
              ;

printstmt     : RWPRINT printlist SEMICOLON
              ;

printlist     : printitem COMMA printlist
              | printitem
              ;

printitem     : expr
              | STRCONST
              | CARRIAGERETURN
              ;

expr          : expr ANDOP bool
              | expr OROP bool
              | NOTOP bool
              | bool
              ;

bool          : bool LTOP exp
              | bool LEQOP exp
              | bool GTOP exp
              | bool GEQOP exp
              | bool EQOP exp
              | bool NEQOP exp
              | exp
              ;

exp           : exp ADDOP term
              | exp SUBOP term
              | term
              ;

term          : term MULTOP factor
              | term DIVOP factor
              | term MODOP factor
              | factor
              ;

factor        : SUBOP unit
              | unit
              ;

unit          : LPAREN expr RPAREN
              | number
              ;

number        : INTCONST
              | FLTCONST
              | varref
              ;


%%

int yyerror(char *msg)
{
   printf("Error: %s\n", msg);
   return(0);
}
