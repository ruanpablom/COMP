%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double
%}

%token TADD TMUL TSUB TDIV TAPAR TFPAR TNUM TFIM

%%
Linha :Expr TFIM {printf("Resultado:%lf\n", $1);exit(0);}
	; 
Expr: Expr TADD Termo {$$ = $1 + $3;}
	| Expr TSUB Termo {$$ = $1 - $3;}
	| Termo
	;
Termo: Termo TMUL Fator {$$ = $1 * $3;}
	| Termo TDIV Fator {$$ = $1 / $3;}
	| Fator
	;
Fator: TNUM 
	| TAPAR Expr TFPAR {$$ = $2;}
	;
Prog: Funcoes Bloco
        | Bloco
        ;
Funcoes: Funcoes Funcao
        |Funcao
        ;
Funcao: Tipo id (Dparametros) Bloco
        |Tipo id () Bloco   
        ;
Tipo:   int
        |String
        |void
        ;
Dparametros: Dparametros, Dparametro
        |Parametro
        ;
Dparametro: Tipo id
        ;
Bloco: {Declaracoes Comandos}
        |{Comandos}
        ;
Declaracoes: Declaracoes Declaracao
        |Declaracao
        ;
Declaracao: Tipo Ids
        ;
Ids:    Ids, id
        |id
        ;
Comandos: Comandos Comando
        |Comando
        ;
Comando: If
        |While
        |Cfuncao
        |Return
        |In
        |Out
        |Atrib
        ;
If:     if (Elogica) Bloco
        |if(Elogica) Bloco else Bloco
        ;
While: while (Elogica) Bloco
        ;
Cfuncao: id (Parametros);
        |id ();
Return: return Expressoes
        ;
In:     read(id);
        ;
Out:    print(Earitimetica);
        |print(literal)
        ;
Atrib: id = Earitmtica;
        |id = literal
        ;
Parametros: Parametros, Parametro
        |Parametro
        ;
Parametro: id
        |Earitimetica
        |literal
        ;
Earitimetica: Earitimetica + Earitimetica
        | Earitimetica - Earitimetica
        | Earitimeticaa
        ;
Earitimeticaa: Earitimeticaa * Num
        | Earitimeticaa / Num
        | Num
        ;
Num:    (Earitimetica)
        |- Earitimetica
        |num
        |id
        ;
Elogica: Imp Elogicaa
        ;
Elogicaa: <-> Imp Elogicaa




%%
#include "lex.yy.c"

int yyerror (char *str)
{
	printf("%s - antes %s\n", str, yytext);
	
} 		 

int yywrap()
{
	return 1;
}
