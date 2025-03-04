{%
#include <stdio.h>
int nb_ligne =1;
int nb_colonne =1;
}%
%start S

%token MAINPRGM VAR BEGINPG ENDPG LET ATDEF CONST INPUT OUTPUT

%token INT TYPEFLOAT ENTIER FLOAT LETTRE

/* Opérateurs arithmétiques */
%token PLUS MINUS TIMES DIV 

/* Opérateurs logiques */
%token AND OR NOT

/* Opérateurs de comparaison */
%token EQ NEQ IE SE I S

/* Symboles spéciaux */
%token OUVEREBLOC FERMETBLOC CROCHETOUVERT  CROCHETFERME PARENTHESEOUVERT PARENTHESEFERME 
%token PVG  DEUXPOINT VRG GUILLEMET EGAL AFFECTATION
%token ERREUR

%%


%%




%%
main ()
{
yyparse();
}
yywrap()
{}
int yyerror(char *msg)
{ printf(" Erreur syntaxique a la ligne %d a la colonne %d",nb_ligne,col);
    return 1;
}