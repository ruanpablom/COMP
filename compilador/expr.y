%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double
%}

%token TID TLITERAL TABLOC TFBLOC TADD TMUL TSUB TDIV TAPAR TFPAR TNUM TFIM TVIRG TPEV TBIP TATRIB TIMP TAND TOR TEQUAL TNEQUAL TBIGEQUAL TSMALLEQUAL TBIG TSMALL TIF TELSE TWHILE  TNOT TDO TRETURN TSTRING TINT TVOID TREAD TPRINT
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
Funcao: Tipo TID TAPAR Dparametros TFPAR Bloco
        |Tipo TID TAPAR TFPAR Bloco   
        ;
Tipo:   TINT
        |TSTRING
        |TVOID
        ;
Dparametros: Dparametros TVIRG Dparametro
        |Parametro
        ;
Dparametro: Tipo TID
        ;
Bloco: TABLOC Declaracoes Comandos TFBLOC
        |TABLOC Comandos TFBLOC
        ;
Declaracoes: Declaracoes Declaracao
        |Declaracao
        ;
Declaracao: Tipo Ids
        ;
Ids:    Ids TVIRG TID
        |TID
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
If:     TIF TAPAR Elogica TFPAR Bloco
        |TIF TAPAR Elogica TFPAR Bloco TELSE Bloco
        ;
While: TWHILE TAPAR Elogica TFPAR Bloco
        ;
Cfuncao: TID TAPAR Parametros TFPAR
        |TID TAPAR TFPAR
        ;
Return: TRETURN Expr
        ;
In:     TREAD TAPAR TID TFPAR TPEV
        
Out:    TPRINT TAPAR Earitimetica TFPAR TPEV
        |TPRINT TAPAR TLITERAL TFPAR
        ;
Atrib: TID TATRIB Earitimetica TPEV
        |TID TATRIB TLITERAL
        ;
Parametros: Parametros TVIRG Parametro
        |Parametro
        ;
Parametro: TID
        |Earitimetica
        |TLITERAL
        ;
Earitimetica: Earitimetica TADD Earitimetica
        | Earitimetica TSUB Earitimetica
        | Earitimeticaa
        ;
Earitimeticaa: Earitimeticaa TMUL Num
        | Earitimeticaa TDIV Num
        | Num
        ;
Num:    TAPAR Earitimetica TFPAR
        |TSUB Earitimetica
        |TNUM
        |TID
        ;
Elogica: TIMP Elogicaa
        ;
Elogicaa: TBIP TIMP Elogicaa
        ;



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
