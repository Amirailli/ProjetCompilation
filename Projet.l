%{

    #include "Projet.tab.h"
    extern int nb_ligne ;
    extern int  nb_colonne ;
    #include <stdio.h>
    #include <stdlib.h>  // Pour strtol()
    extern YYSTYPE yylval; 

    void afficher_erreur(const char *type, const char *entite, const char *message) {
        printf("ERREUR : %s a la ligne %d, colonne %d : %s (%s)\n", 
               type, nb_ligne, nb_colonne, message, entite);
    }
%}

lettre [a-z]
chiffre [0-9]
entier_signe \([+-]?{chiffre}+)\

flottant {chiffre}+.{chiffre}+
flottant_signe \([+-]?{chiffre}+.{chiffre}+)\

IDF {lettre}({lettre}|{chiffre}|_)*  
ERREUR_NUM_IDENT {chiffre}+({lettre}|{chiffre}|_)*
ERREUR_UNDERS_IDENT _({lettre}|{chiffre}|_)*

%%

\{--(.|\n)*?--\}  {/* ignore les commentaires sur plusieurs lignes */}
"<!-"([^-]|-[^!])*"-!>" { /* ignore les commentaires de type <!- ... -!> */ }




"MainPrgm"      { printf("Mot-cle detecte : MainPrgm\n"); nb_colonne += yyleng; return MAINPRGM; }
"Var"           { printf("Mot-cle detecte : Var\n");nb_colonne += yyleng; return VAR; }
"BeginPg"       { printf("Mot-cle detecte : BeginPg\n");nb_colonne += yyleng; return BEGINPG; }
"EndPg"         { printf("Mot-cle detecte : EndPg\n"); nb_colonne += yyleng; return ENDPG; } 
"let"           { printf("Mot-cle detecte : let\n");nb_colonne += yyleng;  return LET; }
"@define"       { printf("Mot-cle detecte : @define\n"); nb_colonne += yyleng; return ATDEF; }
"Const"         { printf("Mot-cle detecte : Const\n");nb_colonne += yyleng; return CONST; }
"input"         { printf("Mot-cle detecte : input\n"); nb_colonne += yyleng; return INPUT; }
"output"        { printf("Mot-cle detecte : output\n");nb_colonne += yyleng;  return OUTPUT; }

"Int"       { printf("Type Int detecte : %s\n", yytext); nb_colonne += yyleng; return INT; }
"Float"     { printf("Type Float detecte : %s\n", yytext); nb_colonne += yyleng; return TYPEFLOAT; }

{chiffre}+  { 
                yylval = strtol(yytext, NULL, 10); /* conversion de yytext en entier : yytext → Contient la chaîne à convertir.
                                                  NULL → On ne veut pas récupérer la position du premier caractère non numérique, donc on ignore cet argument.
                                                  10 → Indique que le nombre est en base 10 (décimal). */
                if (yylval < -32768 || yylval > 32767) 
                    afficher_erreur("Valeur entiere hors limite", yytext, "Nombre trop grand ou trop petit");
                else 
                   printf("Entier : %s\n", yytext);
                nb_colonne += yyleng;
                return ENTIER;
            }

{entier_signe} { 
                  yylval = strtol(yytext, NULL, 10);
                    if (yylval < -32768 || yylval > 32767) 
                        afficher_erreur("Valeur entiere hors limite", yytext, "Nombre trop grand ou trop petit");
                    else 
                        printf("Entier : %s\n", yytext);
                    nb_colonne += yyleng;
                    return ENTIERSIGNE;
                } 

[+-]{chiffre}+ { 
    afficher_erreur("Syntaxe invalide", yytext, "Un entier signe doit etre entre parentheses");
    nb_colonne += yyleng;
     return ENTIERERROR;
}
[+-]{chiffre}+.{chiffre}+ { 
    afficher_erreur("Syntaxe invalide", yytext, "Un flottant signe doit etre entre parentheses");
    nb_colonne += yyleng;
    return ENTIERERROR;
}

{flottant}   { printf("float non signe %s\n", yytext);nb_colonne += yyleng; return FLOAT; }

{flottant_signe} { printf("float signe %s\n", yytext);nb_colonne += yyleng; return FLOAT;  }
 
{lettre}    { printf("Lettre: %s\n", yytext);nb_colonne += yyleng; return IDF; }

"if"|"then"|"else"|"do"|"while"|"for"|"from"|"to"|"step" { printf("Mot-cle : %s\n", yytext); nb_colonne += yyleng;}

{IDF}       { 
                if (yyleng > 14) 
                     afficher_erreur("Identificateur trop long", yytext, "Un IDF ne peut pas dépasser 14 caracteres");
                else if (strstr(yytext, "__") != NULL) 
                    afficher_erreur("Identificateur invalide", yytext, "Un IDF ne doit pas contenir '__'");
                else if (yytext[yyleng - 1] == '_') 
                    afficher_erreur("Identificateur invalide", yytext, "Un IDF ne doit pas se terminer par '_'");
                else 
                     printf("Identificateur valide : %s\n", yytext); 
                nb_colonne += yyleng;
                return IDF;
            }  
{ERREUR_NUM_IDENT}  { afficher_erreur("Identificateur invalide", yytext, "Un IDF ne peut pas commencer par un chiffre"); 
                      nb_colonne += yyleng;
                    }
{ERREUR_UNDERS_IDENT} {
                       afficher_erreur("Identificateur invalide", yytext, "Un IDF ne doit pas commencer par '_'");
                       nb_colonne += yyleng;
                      }

"+"   { printf("Operateur arithmetique : %s\n", yytext);nb_colonne += yyleng; return PLUS; }
"-"   { printf("Operateur arithmetique : %s\n", yytext);nb_colonne += yyleng; return MINUS; }
"*"   { printf("Operateur arithmetique : %s\n", yytext);nb_colonne += yyleng; return TIMES; }
"/"   { printf("Operateur arithmetique : %s\n", yytext);nb_colonne += yyleng; return DIV; }

"AND" { printf("Operateur logique : %s\n", yytext);nb_colonne += yyleng; return AND; }
"OR"  { printf("Operateur logique : %s\n", yytext);nb_colonne += yyleng; return OR; }
"!"   { printf("Operateur NOT : %s\n", yytext); nb_colonne += yyleng; return NOT; }

"=="  { printf("Operateur de comparaison : %s\n", yytext);nb_colonne += yyleng; return EQ; }
"!="  { printf("Operateur de comparaison : %s\n", yytext);nb_colonne += yyleng; return NEQ; }
"<="  { printf("Operateur de comparaison : %s\n", yytext);nb_colonne += yyleng; return IE; }
">="  { printf("Operateur de comparaison : %s\n", yytext);nb_colonne += yyleng; return SE; }
"<"   { printf("Operateur de comparaison : %s\n", yytext);nb_colonne += yyleng; return I; }
">"   { printf("Operateur de comparaison : %s\n", yytext);nb_colonne += yyleng; return S; }

"{"   { printf("Ouverture de bloc\n");nb_colonne += yyleng; return OUVEREBLOC; }
"}"   { printf("Fermeture de bloc\n");nb_colonne += yyleng; return FERMETBLOC; }
"["   { printf("Crochet ouvrant\n");nb_colonne += yyleng; return CROCHETOUVERT; }
"]"   { printf("Crochet fermant\n"); nb_colonne += yyleng; return  CROCHETFERME; }
"("   { printf("Parenthese ouvrante\n"); nb_colonne += yyleng; return PARENTHESEOUVERT; }
")"   { printf("Parenthese fermante\n"); nb_colonne += yyleng; return  PARENTHESEFERME; }

";"   { printf("Point virgule\n");nb_colonne += yyleng; return PVG; }
":"   { printf("Deux points\n"); nb_colonne += yyleng; return DEUXPOINT; }
","   { printf("Virgule\n");nb_colonne += yyleng; return VRG; }
"\'"  { printf("Guillemets\n");nb_colonne += yyleng; return GUILLEMET; }
"="   { printf("Egal\n"); nb_colonne += yyleng; return EGAL; }
":="  { printf("Affectation\n"); nb_colonne += yyleng; return AFFECTATION ;}

[ \t]+      {nb_colonne += yyleng;}
\n          { nb_ligne++,nb_colonne = 1; }
.           { afficher_erreur("Erreur lexicale", yytext, "Caractere inconnu"); 
              nb_colonne += yyleng; return ERREUR; 
            }

%%

