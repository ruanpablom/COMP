#include <stdio.h>

#define YYSTYPE ListaVet
#define ERROPARAMETRO -1
#define ERROLEITURAARQUIVO -2
extern FILE *yyin;

int main(int argc, char **argv)
{
        if(argc < 2){
            printf("Erro %i\n", ERROPARAMETRO);
            return ERROPARAMETRO;
        }
	if((yyin = fopen(argv[1],"r"))==NULL){
            printf("Erro %i\n", ERROLEITURAARQUIVO);
            return ERROLEITURAARQUIVO;
        }
	yyparse();
        fclose(yyin);
	return 0;
}

