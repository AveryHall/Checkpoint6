%{

/*
 * ========================================================================
 *
 * sample.l ----- A simple version of our flex scanner for the Slic language.
 *                It identifies and returns the tokens for the language.
 *
 * Programmer --- Avery Hall
 *
 * ========================================================================
 */

#define  DEBUG 0
#include "y.tab.h"
#include <stdio.h>

%}

%%
[mM][aA][iI][nN]                        {
                                          if(DEBUG) printf("RWMAIN ");
                                          return (RWMAIN);
                                        }

[dD][aA][tT][aA]                        {
                                          if(DEBUG) printf("RWDATA ");
                                          return (RWDATA);
                                        }

[aA][lL][gG][oO][rR][iI][tT][hH][mM]    {
                                          if(DEBUG) printf("RWALGORITHM ");
                                          return (RWALGORITHM);
                                        }


[eE][xX][iI][tT]                        {
                                          if(DEBUG) printf("RWEXIT ");
                                          return (RWEXIT);
                                        }


[iI][nN][tT][eE][gG][eE][rR]            {
                                          if(DEBUG) printf("RWINTEGER ");
                                          return (RWINTEGER);
                                        }


[rR][eE][aA][lL]                        {
                                          if(DEBUG) printf("RWREAL ");
                                          return (RWREAL);
                                        }


[iI][fF]                                {
                                          if(DEBUG) printf("RWIF ");
                                          return (RWIF);
                                        }


[eE][lL][sS][eE]                        {
                                          if(DEBUG) printf("RWELSE ");
                                          return (RWELSE);
                                        }


[cC][oO][uU][nN][tT][iI][nN][gG]        {
                                          if(DEBUG) printf("RWCOUNTING ");
                                          return (RWCOUNTING);
                                        }


[uU][pP][wW][aA][rR][dD]                {
                                          if(DEBUG) printf("RWUPWARD ");
                                          return (RWUPWARD);
                                        }


[dD][oO][wW][nN][wW][aA][rR][dD]        {
                                          if(DEBUG) printf("RWDOWNWARD ");
                                          return (RWDOWNWARD);
                                        }


[tT][oO]                                {
                                          if(DEBUG) printf("RWTO ");
                                          return (RWTO);
                                        }


[wW][hH][iI][lL][eE]                    {
                                          if(DEBUG) printf("RWWHILE ");
                                          return (RWWHILE);
                                        }


[rR][eE][aA][dD]                        {
                                          if(DEBUG) printf("RWREAD ");
                                          return (RWREAD);
                                        }


[pP][rR][iI][nN][tT]                    {
                                          if(DEBUG) printf("RWPRINT ");
                                          return (RWPRINT);
                                        }


[eE][nN][dD]                            {
                                          if(DEBUG) printf("RWEND ");
                                          return (RWEND);
                                        }

[A-Za-z][A-Za-z0-9]*                    {
                                          if(DEBUG) printf("VARNAME (%s) ", yytext);
                                          yylval.cptr = strdup(yytext);
                                          return (VARNAME);
                                        }

";"                                     {
                                          if(DEBUG) printf("SEMICOLON ");
                                          return (SEMICOLON);
                                        }


":"                                     {
                                          if(DEBUG) printf("COLON ");
                                          return (COLON);
                                        }


","                                     {
                                          if(DEBUG) printf("COMMA ");
                                          return (COMMA);
                                        }


#.*                                     {
                                          if(DEBUG) printf("COMMENT ");
                                        }


"+"                                     {
                                          if(DEBUG) printf("ADDOP ");
                                          return (ADDOP);
                                        }


"-"                                     {
                                          if(DEBUG) printf("SUBOP ");
                                          return (SUBOP);
                                        }


"*"                                     {
                                          if(DEBUG) printf("MULTOP ");
                                          return (MULTOP);
                                        }


"/"                                     {
                                          if(DEBUG) printf("DIVOP ");
                                          return (DIVOP);
                                        }


"%"                                     {
                                          if(DEBUG) printf("MODOP ");
                                          return (MODOP);
                                        }


"<"                                     {
                                          if(DEBUG) printf("LTOP ");
                                          return (LTOP);
                                        }


"<="                                    {
                                          if(DEBUG) printf("LEQOP ");
                                          return (LEQOP);
                                        }


">"                                     {
                                          if(DEBUG) printf("GTOP ");
                                          return (GTOP);
                                        }


">="                                    {
                                          if(DEBUG) printf("GEQOP ");
                                          return (GEQOP);
                                        }


"="                                     {
                                          if(DEBUG) printf("EQOP ");
                                          return (EQOP);
                                        }


"<>"                                    {
                                          if(DEBUG) printf("NEQOP ");
                                          return (NEQOP);
                                        }


"&"                                     {
                                          if(DEBUG) printf("ANDOP ");
                                          return (ANDOP);
                                        }


"|"                                     {
                                          if(DEBUG) printf("OROP ");
                                          return (OROP);
                                        }


"~"                                     {
                                          if(DEBUG) printf("NOTOP ");
                                          return (NOTOP);
                                        }


"("                                     {
                                          if(DEBUG) printf("LPAREN ");
                                          return (LPAREN);
                                        }


")"                                     {
                                          if(DEBUG) printf("RPAREN ");
                                          return (RPAREN);
                                        }


"["                                     {
                                          if(DEBUG) printf("LSQBRAC ");
                                          return (LSQBRAC);
                                        }


"]"                                     {
                                          if(DEBUG) printf("RSQBRAC ");
                                          return (RSQBRAC);
                                        }


":="                                    {
                                          if(DEBUG) printf("ASSIGNOP ");
                                          return (ASSIGNOP);
                                        }


"!"                                     {
                                          if(DEBUG) printf("CARRIAGERETURN ");
                                          return (CARRIAGERETURN);
                                        }


(([0-9]+\.[0-9]+)|([0-9]+(\.[0-9]+)?[eE][-+]?[0-9]+))         {
                                                                if(DEBUG) printf("FLTCONST (%s) ", yytext);
                                                                yylval.rval = atof(yytext);
                                                                return (FLTCONST);
                                                              }


\"([^"\n]|(\"\"))*\"                    {
                                          if(DEBUG) printf("STRCONST (%s) ", yytext);
                                          return (STRCONST);
                                        }


[0-9]+                             {
                                          if(DEBUG) printf("INTCONST (%s) ", yytext);
                                          yylval.ival = atoi(yytext);
                                          return(INTCONST);
                                        }

"\n"                                    {
                                          if(DEBUG) printf("NEWLINE ");
                                        }

[\t ]+                                  {
                                          if (DEBUG) printf("WHTSPCE ");
                                        }

.                                       {
                                          if (DEBUG) printf("IGNORE ");
                                          return (IGNORE);
                                        }

%%
