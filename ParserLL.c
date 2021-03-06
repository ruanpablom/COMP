/*****************************************************************
 * Analisador Sintatico LL(1)                                     *
 * Exemplo p/ Disciplina de Compiladores                          *
 * Cristiano Damiani Vasconcellos                                 *
 ******************************************************************/

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <assert.h>

/* Nao terminais o bit mais significativo ligado indica que se trata de um nao
   terminal */
#define B  0x8001
#define BL 0x8002
#define I  0x8003
#define IL 0x8004
#define T  0x8005
#define TL 0x8006
#define E  0x8007

/*Terminais*/
#define ERRO   0x0000
#define CONST  0x0100
#define BIMP   0x0200
#define IMP    0x0300
#define AND    0x0400
#define OR     0X0500
#define NOT    0X0600
#define LPAR   0x0700
#define RPAR   0x0800
#define FIM    0x0900

//Mascaras
#define NTER   0x8000
#define NNTER  0x7FFF

#define TAMPILHA 100


struct Pilha {
	int topo;
	int dado[TAMPILHA];
};

/* Producoes a primeira posicao do vetor indica quantos simbolos
   gramaticais a producao possui em seu lado direito */

const int PROD1[] =  {2, I, BL};     	      // B  -> IB'
const int PROD2[] =  {3, BIMP, I, BL};        // B' -> <->IB'
const int PROD3[] =  {0};                     // B' -> vazio
const int PROD4[] =  {2, T, IL};              // I  -> TI'
const int PROD5[] =  {3, IMP, T, IL};         // I' -> ->TI'
const int PROD6[] =  {0};                     // I' -> vazio
const int PROD7[] =  {2, E, TL};              // T  -> ET'
const int PROD8[] =  {3, OR, E, TL};          // T' -> |ET'
const int PROD9[] =  {0};                     // T' -> vazio
const int PROD10[]=  {3, AND, E, TL};         // T' -> &ET'
const int PROD11[]=  {3, LPAR, B, RPAR};      // E  -> (B)
const int PROD12[]=  {2, NOT, E};             // E  -> ~E
const int PROD13[]=  {1, CONST};              // E  -> CONST

// vetor utilizado para mapear um numero e uma producao.
const int *PROD[] = {NULL, PROD1, PROD2, PROD3, PROD4, PROD5, PROD6, PROD7, PROD8, PROD9, PROD10, PROD11, PROD12, PROD13};

// Tabela sintatica LL(1). Os numeros correspondem as producoes acima.
const int STAB[7][9] = {{1, 0, 0, 0, 0, 1, 1, 0, 0},
	{0, 2, 0, 0, 0, 0, 0, 3, 3},
	{4, 0, 0, 0, 0, 4, 4, 0, 0},
	{0, 6, 5, 0, 0, 0, 0, 6, 6},
	{7, 0, 0, 0, 0, 7, 7, 0, 0},
	{0, 9, 9, 10, 8, 0, 0, 9, 9},
	{13, 0, 0, 0, 0, 12, 11, 0, 0}};

/*****************************************************************
 * int lex (char *str, int *pos)                                  *
 * procura o proximo token dentro de str a partir de *pos,incre-  *
 * menta o valor de *pos a medida que faz alguma tranzicao de     *
 * estados.                                                       *
 * Retorna o inteiro que identifica o token encontrado.           *
 ******************************************************************/

int lex (char *str, int *pos)
{
	int estado = 0;
	char c;

	while (1)
	{
		c =  str[*pos];
                switch(estado)
		{
			case 0:
				if (isdigit(c))
				{
					(*pos)++;
					estado = 1;
				}else if(c=='-'){
					(*pos)++;
					estado = 4;
				}else if(c=='<'){
                                    (*pos)++;
                                    estado = 5;
                                }
				else
					switch (c)
					{
						case ' ':
							(*pos)++;
							break;
						case '.':
							(*pos)++;
							estado = 2;
							break;
						case '|':
							(*pos)++;
							return OR;
						case '&':
							(*pos)++;
							return AND;
						case '~':
							(*pos)++;
							return NOT;
						case 'V':
							(*pos)++;
							return CONST;
						case 'F':
							(*pos)++;
							return CONST;	
						case '(':
							(*pos)++;
							return LPAR;
						case ')':
							(*pos)++;
							return RPAR;
						case '\0':
							return FIM;
                                                default:
							(*pos)++;
							return ERRO;
					}
				break;
			case 1:
				if(isdigit(c))
					(*pos)++;
				else
					if (c == '.')
					{
						estado = 3;
						(*pos)++;
					}
					else
					{
						//Adicionar constante na tabela de simbolos.
						return CONST;
					}
				break;
			case 2:
				if (isdigit(c))
				{
					(*pos)++;
					estado = 3;
				}
				else
				{
					(*pos)++;
					return ERRO;
				}
				break;
			case 3:
				if (isdigit(c))
					(*pos)++;
				else
				{
					//Adicionar a constante na tabela de simbolos.
					return CONST;
				}
				break;
                        case 4:
                                (*pos)++;
                                if(c=='>'){
                                    estado = 0;
                                    return IMP;
                                }
                                else return ERRO;
                        case 5:
                                (*pos)++;
                                if(c=='-'){
                                    estado = 6;
                                }else return ERRO;
                                break;
                        case 6:
                                (*pos)++;                        
                                if(c=='>'){
                                    estado = 0;
                                    return BIMP;
                                }
                                else return ERRO;
			default:
				printf("Lex:Estado indefinido");
				exit(1);
		}
	}
}

/*****************************************************************
 * void erro (char *erro, char *expr, int pos)                    *
 * imprime a mensagem apontado por erro, a expressao apontada por *
 * expr, e uma indicacao de que o erro ocorreu na posicao pos de  *
 * expr. Encerra a execucao do programa.                          *
 ******************************************************************/

void erro (char *erro, char *expr, int pos)
{
	int i;
	printf("%s", erro);
	printf("\n%s\n", expr);
	for (i = 0; i < pos-1; i++)
		putchar(' ');
	putchar('^');
	exit(1);
}

/*****************************************************************
 * void inicializa(struct Pilha *p)                               *
 * inicializa o topo da pilha em -1, valor que indica que a pilha *
 * esta vazia.                                                    *
 ******************************************************************/

void inicializa(struct Pilha *p)
{
	p->topo = -1;
}

/*****************************************************************
 * void insere (struct Pilha *p, int elemento                     *
 * Insere o valor de elemento no topo da pilha apontada por p.    *
 ******************************************************************/

void insere (struct Pilha *p, int elemento)
{
	if (p->topo < TAMPILHA)
	{
		p->topo++;
		p->dado[p->topo] = elemento;
	}
	else
	{
		printf("estouro de pilha");
		exit (1);
	}
}

/*****************************************************************
 * int remover (struct Pilha *p)                                  *
 * Remove e retorna o valor armazenado no topo da pilha apontada  *
 * por p                                                          *
 ******************************************************************/

int remover (struct Pilha *p)
{
	int aux;

	if (p->topo >= 0)
	{
		aux = p->dado[p->topo];
		p->topo--;
		return aux;
	}
	else
	{
		printf("Pilha vazia");
		exit(1);
	}
	return 0;
}

/*****************************************************************
 * int consulta (struct Pilha *p)                                 *
 * Retorna o valor armazenado no topo da pilha apontada por p     *
 ******************************************************************/


int consulta (struct Pilha *p)
{
	if (p->topo >= 0)
		return p->dado[p->topo];
	printf("Pilha vazia");
	exit(1);
}

/*****************************************************************
 * void parser (char *expr)                                       *
 * Verifica se a string apontada por expr esta sintaticamente     *
 * correta.                                                       *
 * Variaveis Globais Consultadas: STAB e PROD                     *
 ******************************************************************/


void parser(char *expr)
{
	struct Pilha pilha;
	int x, a, nProd, i, *producao;
	int pos = 0;

	inicializa(&pilha);
	insere(&pilha, FIM);
	insere(&pilha, B);
	if ((a = lex(expr, &pos)) == ERRO){	
		erro("Erro lexico", expr, pos);
	}
	do
	{
		x = consulta(&pilha);
		if (!(x&NTER))
		{
			if (x == a)
			{
				remover (&pilha);
				if ((a = lex(expr, &pos)) == ERRO){
					erro("Erro lexico", expr, pos);
				}
			}
			else
				erro("Erro sintatico",expr, pos);
		}
		if (x&NTER)
		{
			nProd = STAB[(x&NNTER)-1][(a>>8) - 1];
			if (nProd)
			{
				remover (&pilha);
				producao = PROD[nProd];
				for (i = producao[0]; i > 0; i--)
					insere (&pilha, producao[i]);
			}
			else
				erro ("Erro sintatico", expr, pos);
		}
	} while (x != FIM);
}

void main()
{
	char expr[100];
	printf("\nDigite uma expressao: ");
	gets(expr);
	parser(expr);
	printf("Expressao sintaticamente correta\n");
}
