The current version of the compiler includes a fully functioning scanner and parser, and correctly builds the symbol table.

Building the AST tree would be the next step so that GSTAL instructions could written for each Slic statement in a code generator. Since neither the code generator or AST are built yet,
however, using this compiler just returns the contents of the symbol table and indicates if there is a syntax error.

Also it would probably be best to test this on cygwin.