/*
 * ========================================================================
 *
 * symtab.h -------- A header file to be used in conjunction with our bison
 *		               parser; contains #defines and global declarations for
 *									 the symbol table.
 *
 * Programmer ------ Avery Hall
 *
 * ========================================================================
 */

 #include <string.h>

//Symbol data types
#define ST_INT 		  0
#define ST_REAL 	  1

//Symbol kinds
#define SK_SCALAR 	0
#define SK_ARRAY  	1
//#define SK_FUNCTION   2

#define CAPACITY 1024


//Defines a symbol for a symbol table entry
struct symbol {
	char *varname;
	char kind;
	char type;
	int size;
	int address;
};

struct symboltable {

	struct symbol st[CAPACITY];
	int size;
	int nextAddress;

};

extern struct symboltable symtab;
