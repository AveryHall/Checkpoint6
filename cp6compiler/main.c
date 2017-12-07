/*
 * ========================================================================
 *
 * cp5main.c ---- A simple main program that includes code for building the
 *                the symbol
 *
 * Programmer --- Avery Hall
 *
 * ========================================================================
 */

#include "symtab.h"
#include "y.tab.h"
#include <stdio.h>

extern struct symboltable symtab;
void printSymTab();

/*
 * ========================================================================
 * main()
 * ========================================================================
 */

int main()
{
  /*
   * =======================================================================
   * Parse
   *=======================================================================
  */
   if (yyparse()) {
     printf("Parse failed.\n");
   }

   //printSymTab();

   return(0);
}



/*
 * =======================================================================
 * FUNCTIONS
 *=======================================================================
 */

void printSymTab() {

  /*
   * =======================================================================
   * Print out the contents of the Symbol Table
   *=======================================================================
  */

  printf("Table Size: %d\nNext Available GSTAL Address: %d\n", symtab.size, symtab.nextAddress);

  int i;
  for(i = 0; i < symtab.size; ++i) {
    //Name
    printf("Name: %s\n", symtab.st[i].varname);

    //Kind
    if(symtab.st[i].kind == SK_SCALAR) {
      printf("Kind: SCALAR\n");
    } else if(symtab.st[i].kind == SK_ARRAY) {
      printf("Kind: ARRAY\n");
    } else {
      printf("Kind: ?\n");
    }

    //Type
    if(symtab.st[i].type == ST_INT) {
      printf("Type: INT\n");
    } else if(symtab.st[i].type == ST_REAL) {
      printf("Type: REAL\n");
    } else {
      printf("Type: ?\n");
    }

    //Size
    printf("Size: %d\n", symtab.st[i].size);

    //Base Address in GSTAL
    printf("GSTAL Base Address: %d\n", symtab.st[i].address);
  }

  return;

}
