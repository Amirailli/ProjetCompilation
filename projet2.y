%{
    #include <stdio.h>
    #include <stdlib.h>
    extern int nb_ligne;
    extern int nb_colonne;

    void afficher_erreur(const char *type, const char *entite, const char *message) {
        printf("ERREUR : %s à la ligne %d, colonne %d : %s (%s)\n", 
               type, nb_ligne, nb_colonne, message, entite);
    }
%}

// Déclaration des tokens
%token MAINPRGM VAR BEGINPG ENDPG LET ATDEF CONST INPUT OUTPUT
%token INT TYPEFLOAT ENTIER FLOAT LETTRE
%token PLUS MINUS TIMES DIV AND OR NOT EQ NEQ IE SE I S
%token OUVEREBLOC FERMETBLOC CROCHETOUVERT CROCHETFERME PARENTHESEOUVERT PARENTHESEFERME
%token PVG DEUXPOINT VRG GUILLEMET EGAL AFFECTATION ERREUR
%token IF THEN ELSE DO WHILE FOR FROM TO STEP
%token IDF

%%

// Règles de la grammaire
programme : MAINPRGM IDF PVG declarations bloc ENDPG PVG
           {
               printf("Programme valide.\n");
           }
           ;

declarations : VAR  BEGINPG  declaration_list
             |
             ;

declaration_list : declaration_list declaration
                 | declaration
                 ;

declaration : LET IDF  DEUXPOINT type PVG
            | ATDEF CONST IDF DEUXPOINT type EGAL valeur PVG
            ;

type : INT
     | TYPEFLOAT
     ;

valeur : ENTIER
       | FLOAT
       ;

bloc : BEGINPG OUVEREBLOC instructions FERMETBLOC
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

int main(int argc, char **argv) {
    yyparse();  // Appeler l'analyseur syntaxique
    return 0;
}

int yyerror(const char *s) {
    fprintf(stderr, "Erreur syntaxique à la ligne %d, colonne %d : %s\n", nb_ligne, nb_colonne, s);
    return 0;
}