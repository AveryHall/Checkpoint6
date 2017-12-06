/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    RWMAIN = 258,
    RWDATA = 259,
    RWALGORITHM = 260,
    RWEXIT = 261,
    RWINTEGER = 262,
    RWREAL = 263,
    RWIF = 264,
    RWELSE = 265,
    RWCOUNTING = 266,
    RWUPWARD = 267,
    RWDOWNWARD = 268,
    RWTO = 269,
    RWWHILE = 270,
    RWREAD = 271,
    RWPRINT = 272,
    RWEND = 273,
    VARNAME = 274,
    SEMICOLON = 275,
    COLON = 276,
    COMMA = 277,
    COMMENT = 278,
    ADDOP = 279,
    SUBOP = 280,
    MULTOP = 281,
    DIVOP = 282,
    MODOP = 283,
    LTOP = 284,
    LEQOP = 285,
    GTOP = 286,
    GEQOP = 287,
    EQOP = 288,
    NEQOP = 289,
    ANDOP = 290,
    OROP = 291,
    NOTOP = 292,
    RPAREN = 293,
    LPAREN = 294,
    RSQBRAC = 295,
    LSQBRAC = 296,
    ASSIGNOP = 297,
    CARRIAGERETURN = 298,
    FLTCONST = 299,
    STRCONST = 300,
    INTCONST = 301,
    NEWLINE = 302,
    IGNORE = 303
  };
#endif
/* Tokens.  */
#define RWMAIN 258
#define RWDATA 259
#define RWALGORITHM 260
#define RWEXIT 261
#define RWINTEGER 262
#define RWREAL 263
#define RWIF 264
#define RWELSE 265
#define RWCOUNTING 266
#define RWUPWARD 267
#define RWDOWNWARD 268
#define RWTO 269
#define RWWHILE 270
#define RWREAD 271
#define RWPRINT 272
#define RWEND 273
#define VARNAME 274
#define SEMICOLON 275
#define COLON 276
#define COMMA 277
#define COMMENT 278
#define ADDOP 279
#define SUBOP 280
#define MULTOP 281
#define DIVOP 282
#define MODOP 283
#define LTOP 284
#define LEQOP 285
#define GTOP 286
#define GEQOP 287
#define EQOP 288
#define NEQOP 289
#define ANDOP 290
#define OROP 291
#define NOTOP 292
#define RPAREN 293
#define LPAREN 294
#define RSQBRAC 295
#define LSQBRAC 296
#define ASSIGNOP 297
#define CARRIAGERETURN 298
#define FLTCONST 299
#define STRCONST 300
#define INTCONST 301
#define NEWLINE 302
#define IGNORE 303

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 99 "cp6.y" /* yacc.c:1909  */

   char  *cptr;
   int    ival;
   float  rval;


   char		       				symkind;
   struct symbol       	*sym;
   struct symbolList   	*symListPoint;

#line 161 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
