#include <stdio.h>
#include "const_comp.h"

extern FILE *yyin;

int main()
{
	yyin = stdin;
	printf("Digite uma express�o:");
	yyparse();
	return 0;
}

