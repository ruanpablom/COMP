CC=gcc
CFLAGS= -c -Wall
OBJECTS= expr.tab.c main.c
CLEAN= expr.tab.c lex.yy.c expr

all: expr

expr: $(OBJECTS)
	$(CC) $(OBJECTS) -o expr

expr.tab.c: expr.y
	flex expr.l
	bison expr.y

clean:
	rm $(CLEAN)
