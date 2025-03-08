%{
    #include <stdio.h>
    int nb_ligne = 1;
    int nb_colonne = 1;
%}

%start Program

%token MAINPRGM VAR BEGINPG ENDPG LET ATDEF CONST INPUT OUTPUT
%token INT TYPEFLOAT ENTIER FLOAT IDF ENTIERSIGNE ENTIERERROR

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

/* Définition des priorités et associativités */
%left OR
%left AND
%left NOT
%left EQ NEQ IE SE I S
%left PLUS MINUS
%left TIMES DIV

%%

Program:
    MAINPRGM IDF PVG declaration_part BEGINPG OUVEREBLOC instruction_part FERMETBLOC ENDPG PVG
;

declaration_part:
    VAR declaration_list
;

declaration_list:
    declaration
    | declaration_list declaration
;

declaration:
    declaration_variables
    | declaration_tableau
    | declaration_constantes
;

declaration_variables:
    LET liste_IDF DEUXPOINT type PVG
;

liste_IDF:
    IDF
    | liste_IDF VRG IDF
;

type:
    INT
    | TYPEFLOAT
;

declaration_tableau:
    LET liste_IDF  DEUXPOINT CROCHETOUVERT ENTIER CROCHETFERME DEUXPOINT type PVG
;

declaration_constantes:
    ATDEF CONST IDF DEUXPOINT type EGAL valeur_const PVG
;

valeur_const:
    ENTIER
    | FLOAT
    | ENTIERSIGNE
;

instruction_part:
    instruction
    | instruction_part instruction
;

instruction:
    expression PVG
;

/* Définition des expressions */
expression:
    expression PLUS expression
    | expression MINUS expression
    | expression TIMES expression
    | expression DIV expression
    | expression AND expression
    | expression OR expression
    | NOT expression
    | expression EQ expression
    | expression NEQ expression
    | expression IE expression
    | expression SE expression
    | expression I expression
    | expression S expression
    | PARENTHESEOUVERT expression PARENTHESEFERME
    | IDF
    | ENTIER
    | FLOAT
    | ENTIERSIGNE
;

%%

int main() {
    return yyparse();
}

int yyerror(char *msg) {
    printf("Erreur syntaxique à la ligne %d, colonne %d : %s\n", nb_ligne, nb_colonne, msg);
    return 1;
}
