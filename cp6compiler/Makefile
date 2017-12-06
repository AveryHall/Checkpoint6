cp6:	cp6.l cp6.y main.c symtab.h
	flex cp6.l
	bison -y -d cp6.y
	gcc -o cp6 main.c lex.yy.c y.tab.c -lfl

cp6.c:
	true

clean:
	rm -f core *.o lex.yy.c y.tab.c y.tab.h cp6 cp6.exe
