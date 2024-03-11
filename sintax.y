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
  ID PROP NAME NUMERO SYMBOL TYPE VIRGULA ABREPARENTESES FECHAPARENTESES
	ABRECHAVE FECHACHAVE

%%

decl: decl classeDecl 
			| classeDecl
			;

classeDecl: Class ID definicao {cout << "A classe é válida!";}
			;

definicao: definicao axioma 
					| axioma
			;

axioma: subClasse |
			 listaIndividuos |
			 equivalencia |
			 disjoint | 
				;
subClasse: SubClassOf subClassBody /*Tem que especificar o que é uma subClasse (começa com subClassOf)*/
				;
subClassBody: subClassBody PROP palavraChave idOrType divisor | 
idOrType: ID | TYPE
				;
listaIndividuos: listaIndividuos Individuals listaIndividuosBody /*Tem que especificar o que é um individuo (começa com individuos))*/
				;
listaIndividuosBody : listaIndividuosBody NAME VIRGULA | NAME VIRGULA
equivalencia: EquivalentTo equivalenciaBody /*Tem que especificar o que é o axioma de equivalencia (começa com EquivalentTo))*/
				;
equivalenciaBody: ID palavraChave ; /*Esse simbol tem que ser simbolos especificos*/
disjoint: DisjointClasses disjointBody  /*Tem que especificar o que é o axioma de disjointClasses (começa com a keyword DisjointClasses))*/
				;
disjointBody: disjointBody ID divisor |
divisor: VIRGULA |
				;
palavraChave : SOME | ALL | VALUE | MIN | MAX | EXACTLY | THAT | NOT | AND | OR | ONLY
				;
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
