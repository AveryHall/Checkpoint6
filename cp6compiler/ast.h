/*
 * ========================================================================
 *
 * ast.h -------- A header file to be used in conjunction with our bison
 *		            parser; contains #defines and global declarations for
 *							  the abstract syntax tree (AST).
 *
 * Programmer ------ Avery Hall
 *
 * ========================================================================
 */

 //#include <string.h>

//Statement kinds
#define SK_EXIT 	    0
#define SK_ASSIGN     1
#define SK_WHILE      2
#define SK_COUNTUP    3
#define SK_COUNTDOWN  4
#define SK_IF         5
#define SK_IF_ELSE    6
#define SK_READ       7
#define SK_PRINT      8


//Expression kinds
#define EK_OP   0
#define EK_INT  1
#define EK_REAL 2
#define EK_VAR  3

//Expression Operators
#define OP_AND  0
#define OP_OR   1
#define OP_NOT  2
#define OP_LT   3
#define OP_LEQ  4
#define OP_GT   5
#define OP_GEQ  6
#define OP_EQ   7
#define OP_NEQ  8
#define OP_ADD  9
#define OP_SUB  10
#define OP_MUL  11
#define OP_DIV  12
#define OP_MOD  13
#define OP_UMIN 14

//PrintItem kinds
#define PK_EXP  0
#define PK_STR  1
#define PK_CRLF 2

//Defines a symbol for a symbol table entry
struct statementList {
  struct statementList *nextStatement;
  struct statement     *thisStatement;
};

struct printlist {
  struct printlist *nextItem;
  struct printitem *thisItem;
};

struct statement {
  char  stmtkind;
  char *varname;
  int   index;
  struct expression    *expr1;
  struct expression    *expr2;
  struct statementList *body1;
  struct statementList *body2;
  struct printlist     *plist;
};

struct printitem {
  char pkind;
  char *outstr;
  struct expression *expr1;
  ;
};

struct expression {
  char kind;
  char operator;
  struct expression *l_operand;
  struct expression *r_operand;
  int     ivalue;
  double  rvalue;
  int     index;
};

extern struct statementList *ast;
