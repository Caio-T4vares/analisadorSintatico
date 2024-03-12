%{
/* analisador sintático para reconhecer frases em português */
#include <iostream>
using std::cout;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
%}

%token SOME ALL VALUE MIN MAX EXACTLY THAT NOT AND 
  OR ONLY Class EquivalentTo Individuals SubClassOf DisjointClasses 
  ID PROP NAME NUMERO RELATIONAL TYPE VIRGULA ABREPARENTESES FECHAPARENTESES
	ABRECHAVE FECHACHAVE ABRECOLCHETE FECHACOLCHETE

%%

programa: programa classeDecl 
			| classeDecl
			;

classeDecl: Class ID classBody {cout << "A classe é válida!";}
			;
classBody: subclasse opcional
					 | equivalencia opcional
opcional: individuos disjuncao 
					| individuos 
					| disjuncao individuos 
					| disjuncao
					|
			;

/*SubClassOf*/
subclasse: SubClassOf subclasseBody
			;
subclasseBody: subclasseBody subClasseProperty 
					| subClasseProperty
			;
subClasseProperty: PROP SOME ID divisor
					| PROP SOME TYPE divisor
					| PROP ONLY onlyExpression divisor
					| PROP minMaxExactly NUMERO optionalType divisor
					| PROP VALUE NAME divisor
			;
optionalType: TYPE | 
			;
onlyExpression: ABREPARENTESES onlyExpressionClasses FECHAPARENTESES 
					| ID
			;
onlyExpressionClasses: onlyExpressionClasses ID OR 
					| onlyExpression ID
			;
/*EquivalentTo*/
equivalencia: EquivalentTo ID conjuntoDescricoes
			;
conjuntoDescricoes: conjuntoDescricoes descricao 
					| descricao
			;
descricao: AND ABREPARENTESES equivalenciaExpression FECHAPARENTESES
			;
equivalenciaExpression:	PROP SOME ID
					| PROP SOME TYPE ABRECOLCHETE RELATIONAL NUMERO FECHACOLCHETE
					| PROP SOME TYPE
			;
/*Individuals*/
individuos: Individuals listaIndividios
			;
listaIndividios: listaIndividios NAME divisor 
					| NAME divisor
			;
/*DisjointClasses*/
disjuncao: DisjointClasses listaClasses
			;
listaClasses: listaClasses ID divisor 
					| ID divisor
			;
palavraChave: OR | AND | THAT | ALL
			;
minMaxExactly: MIN | MAX | EXACTLY 
			;
idOrType: ID | TYPE
			;
divisor: VIRGULA |
			;
/*Após o value sempre vem instâncias*/
%%

/* definido pelo analisador léxico */
extern FILE * yyin;  

int main(int argc, char ** argv)
{
	/* se foi passado um nome de arquivo */
	if (argc > 1)
	{
		FILE * file;
		file = fopen(argv[1], "r");
		if (!file)
		{
			cout << "Arquivo " << argv[1] << " não encontrado!\n";
			exit(1);
		}
		
		/* entrada ajustada para ler do arquivo */
		yyin = file;
	}

	yyparse();
}

void yyerror(const char * s)
{
	/* variáveis definidas no analisador léxico */
	extern int yylineno;    
	extern char * yytext;   

	/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
    cout << "Erro sintático: símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
}
