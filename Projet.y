%{
    #include <stdio.h>
    int nb_ligne = 1;
    int nb_colonne = 1;
    char SauvType[20];
%}

%start Program

%union {
int entier;
char* str;
}

%token MAINPRGM VAR BEGINPG ENDPG LET ATDEF CONST INPUT OUTPUT
%token <str> TYPEINT TYPEFLOAT 
%token <entier> ENTIER ENTIERSIGNE
%token FLOAT ENTIERERROR
%token <str> IDF lettre
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

%token IF THEN ELSE DO WHILE FOR FROM TO STEP

/* Définition des priorités et associativités */
%left OR
%left AND
%left NOT
%left EQ NEQ IE SE I S
%left PLUS MINUS
%left TIMES DIV

%%

Program:
    MAINPRGM IDF PVG declaration_part BEGINPG OUVEREBLOC instructions FERMETBLOC ENDPG PVG
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
    LET liste_let DEUXPOINT type PVG
;

liste_let:
    liste_let VRG lettre  { 
                            if(rechercheType($3)==0) {
                                insererType($3,SauvType);
                            } else {
                                printf("Erreur Semantique: double declaration de %s, a la ligne %d\n", $3, nb_ligne);
                            } 
                       }
    |lettre  {      
                if (rechercheType($1)==0){
                    insererType($1,SauvType);
                } else {
                    printf("Erreur Semantique: double declaration de %s, a la ligne %d\n", $1, nb_ligne);
                }
         }
   ;
;

type:
    TYPEINT {strcpy(SauvType,"INT");}
    | TYPEFLOAT {strcpy(SauvType,"FLOAT");}
;

declaration_tableau:
    LET liste_let  DEUXPOINT CROCHETOUVERT ENTIER CROCHETFERME DEUXPOINT type PVG
;

declaration_constantes:
    ATDEF CONST IDF DEUXPOINT type EGAL valeur_const PVG {
        if (rechercheType($3) == 0) {
            insererType($3, SauvType); 
        } else {
            printf("Erreur Semantique: double declaration de la constante %s, a la ligne %d\n", $3, nb_ligne);
        }
    }
;

valeur_const:
    ENTIER
    | FLOAT
    | ENTIERSIGNE
;

instructions : instructions instruction
             | instruction
             ;

instruction : affectation PVG
            | condition
            | boucle
            | input PVG
            | output PVG
            ;

affectation : IDF AFFECTATION expression
            ;

condition : IF PARENTHESEOUVERT expression PARENTHESEFERME THEN OUVEREBLOC instructions FERMETBLOC ELSE OUVEREBLOC instructions FERMETBLOC
           ;

boucle : DO OUVEREBLOC instructions FERMETBLOC WHILE PARENTHESEOUVERT expression PARENTHESEFERME PVG
       | FOR IDF FROM ENTIER TO ENTIER STEP ENTIER OUVEREBLOC instructions FERMETBLOC
       ;

input : INPUT PARENTHESEOUVERT IDF PARENTHESEFERME
      ;

output : OUTPUT PARENTHESEOUVERT expression PARENTHESEFERME
        ;

expression : expression PLUS terme
           | expression MINUS terme
           | terme
           ;

terme : terme TIMES facteur
      | terme DIV facteur
      | facteur
      ;

facteur : ENTIER
        | FLOAT
        | IDF
        | PARENTHESEOUVERT expression PARENTHESEFERME
     ;

%%

int main() {
    dynamicInit();

    yyparse();

    afficherTS();         // Affiche les résultats une fois l'analyse terminée
    afficherM();
    afficherS();

    libererMemoire();
}

int yyerror(char *msg) {
    printf("Erreur syntaxique à la ligne %d, colonne %d : %s\n", nb_ligne, nb_colonne, msg);
    return 1;
}
