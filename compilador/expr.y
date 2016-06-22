%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double
%}

%token TID TLITERAL TABLOC TFBLOC TADD TMUL TSUB TDIV TAPAR TFPAR TNUM TFIM TVIRG TPEV TBIP TATRIB TIMP TAND TOR TEQUAL TNEQUAL TBIGEQUAL TSMALLEQUAL TBIG TSMALL TIF TELSE TWHILE  TNOT TDO TRETURN TSTRING TINT TVOID TREAD TPRINT
%%
 
Inicio:         Funcoes BlocoPrincipal
                |BlocoPrincipal
                ;
Funcoes:        Funcoes Funcao
                |Funcao
                ;
Funcao:         TipoRetorno TID TAPAR DeclParametros TFPAR BlocoPrincipal
                |TipoRetorno TID TAPAR TFPAR Bloco   
                ;
Bloco:          TABLOC Comandos TFBLOC
                ;
Tipo:           TINT
                |TSTRING
                ;
TipoRetorno:    Tipo
                |TVOID
                ;
DeclParametros: DeclParametros TVIRG Parametro
                |Parametro
                ;
BlocoPrincipal: TABLOC Declaracoes Comandos TFBLOC
                |TABLOC Comandos TFBLOC
                ;
Parametro:      Tipo TID
                ;
Declaracoes:    Declaracoes Declaracao
                |Declaracao
                ;
Declaracao:     Tipo Ids TPEV
                ;
Ids:            Ids TVIRG TID
                |TID
                ;
Comandos:       Comandos Comando
                |Comando
                ;
Comando:        CmdIf
                |CmdWhile
                |CmdAtrib
                |CmdReturn
                |CmdIn
                |CmdOut
                |ChamadaFuncao
                ;
CmdIf:          TIF TAPAR ExprLogica TFPAR Bloco
                |TIF TAPAR ExprLogica TFPAR Bloco TELSE Bloco
                ;
CmdWhile:       TWHILE TAPAR ExprLogica TFPAR Bloco
                ;
CmdReturn:      TRETURN ExprArit TPEV
                ;
CmdIn:          TREAD TAPAR TID TFPAR TPEV
                ;
CmdOut:         TPRINT TAPAR ExprArit TFPAR TPEV
                |TPRINT TAPAR TLITERAL TFPAR TPEV
                ;
CmdAtrib:       TID TATRIB ExprArit TPEV
                |TID TATRIB TLITERAL TPEV
                |TID TATRIB ChamadaFuncao
                ;
ChamadaFuncao:  TID TAPAR Parametros TFPAR TPEV
                |TID TAPAR TFPAR TPEV
                ;
Parametros:     Parametros TVIRG ExprArit
                |ExprArit
                ;
ExprArit:       ExprArit TADD Termo {$$ = $1 + $3;}
	        |ExprArit TSUB Termo {$$ = $1 - $3;}
	        |Termo
	        ;
Termo:          Termo TMUL Fator {$$ = $1 * $3;}
	        |Termo TDIV Fator {$$ = $1 / $3;}
	        |Fator
	        ;
Fator:          TNUM 
	        |TID 
                |TAPAR ExprArit TFPAR
                |TSUB Fator
	        ;
ExprRelacional: ExprArit OpRelacional ExprArit
                |TAPAR ExprRelacional TFPAR
                ;
OpRelacional:   TSMALL
                |TBIG
                |TSMALLEQUAL
                |TBIGEQUAL
                |TEQUAL
                |TNEQUAL
                ; 
ExprLogica:     ExprLogica TAND TermoLogico
                |ExprLogica TOR TermoLogico
                |TermoLogico
                ;
TermoLogico:    TNOT TermoLogico
                |ExprRelacional
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
