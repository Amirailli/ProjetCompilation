%{
    #include "projet2.tab.h"  // Inclure le fichier d'en-tête généré par Bison
    extern int nb_ligne;
    extern int nb_colonne;
    #include <stdio.h>
    #include <stdlib.h>
    int nb_ligne = 1;
    int nb_colonne = 1;

    extern void afficher_erreur(const char *type, const char *entite, const char *message);  // Déclaration externe
    extern int nb_ligne;
    extern int nb_colonne;
%}

lettre [a-z]
chiffre [0-9]
entier_signe \([+-]?{chiffre}+\)

flottant {chiffre}+.{chiffre}+
flottant_signe \([+-]?{chiffre}+.{chiffre}+\)

IDF {lettre}({lettre}|{chiffre}|_)*  
ERREUR_NUM_IDENT {chiffre}+({lettre}|{chiffre}|_)*
ERREUR_UNDERS_IDENT _({lettre}|{chiffre}|_)*

%%

\{--(.|\n)*?--\}  {/* ignore les commentaires sur plusieurs lignes */}
"<!-"([^-]|-[^!])*"-!>" { /* ignore les commentaires de type <!- ... -!> */ }

"MainPrgm"      { printf("Mot-clé détecté : MainPrgm\n"); nb_colonne += yyleng; return MAINPRGM; }
"Var"           { printf("Mot-clé détecté : Var\n"); nb_colonne += yyleng; return VAR; }
"BeginPg"       { printf("Mot-clé détecté : BeginPg\n"); nb_colonne += yyleng; return BEGINPG; }
"EndPg"         { printf("Mot-clé détecté : EndPg\n"); nb_colonne += yyleng; return ENDPG; } 
"let"           { printf("Mot-clé détecté : let\n"); nb_colonne += yyleng; return LET; }
"@define"       { printf("Mot-clé détecté : @define\n"); nb_colonne += yyleng; return ATDEF; }
"Const"         { printf("Mot-clé détecté : Const\n"); nb_colonne += yyleng; return CONST; }
"input"         { printf("Mot-clé détecté : input\n"); nb_colonne += yyleng; return INPUT; }
"output"        { printf("Mot-clé détecté : output\n"); nb_colonne += yyleng; return OUTPUT; }

"Int"       { printf("Type Int détecté : %s\n", yytext); nb_colonne += yyleng; return INT; }
"Float"     { printf("Type Float détecté : %s\n", yytext); nb_colonne += yyleng; return TYPEFLOAT; }

{chiffre}+  { 
                yylval = strtol(yytext, NULL, 10);
                if (yylval < -32768 || yylval > 32767) 
                    afficher_erreur("Valeur entière hors limite", yytext, "Nombre trop grand ou trop petit");
                else 
                    printf("Entier : %s\n", yytext);
                nb_colonne += yyleng;
                return ENTIER;
            }

{entier_signe} { 
                  yylval = strtol(yytext, NULL, 10);
                  if (yylval < -32768 || yylval > 32767) 
                      afficher_erreur("Valeur entière hors limite", yytext, "Nombre trop grand ou trop petit");
                  else 
                      printf("Entier : %s\n", yytext);
                  nb_colonne += yyleng;
                  return ENTIER;
              } 

[+-]{chiffre}+ { 
    afficher_erreur("Syntaxe invalide", yytext, "Un entier signé doit être entre parenthèses");
    nb_colonne += yyleng;
    return ENTIER;
}

{flottant}   { printf("Float non signé : %s\n", yytext); nb_colonne += yyleng; return FLOAT; }

{flottant_signe} { printf("Float signé : %s\n", yytext); nb_colonne += yyleng; return FLOAT; }

{lettre}    { printf("Lettre : %s\n", yytext); nb_colonne += yyleng; return LETTRE; }

"if"|"then"|"else"|"do"|"while"|"for"|"from"|"to"|"step" { printf("Mot-clé : %s\n", yytext); nb_colonne += yyleng; }

{IDF}       { 
                if (yyleng > 14) 
                    afficher_erreur("Identificateur trop long", yytext, "Un IDF ne peut pas dépasser 14 caractères");
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

"+"   { printf("Opérateur arithmétique : %s\n", yytext); nb_colonne += yyleng; return PLUS; }
"-"   { printf("Opérateur arithmétique : %s\n", yytext); nb_colonne += yyleng; return MINUS; }
"*"   { printf("Opérateur arithmétique : %s\n", yytext); nb_colonne += yyleng; return TIMES; }
"/"   { printf("Opérateur arithmétique : %s\n", yytext); nb_colonne += yyleng; return DIV; }

"AND" { printf("Opérateur logique : %s\n", yytext); nb_colonne += yyleng; return AND; }
"OR"  { printf("Opérateur logique : %s\n", yytext); nb_colonne += yyleng; return OR; }
"!"   { printf("Opérateur NOT : %s\n", yytext); nb_colonne += yyleng; return NOT; }

"=="  { printf("Opérateur de comparaison : %s\n", yytext); nb_colonne += yyleng; return EQ; }
"!="  { printf("Opérateur de comparaison : %s\n", yytext); nb_colonne += yyleng; return NEQ; }
"<="  { printf("Opérateur de comparaison : %s\n", yytext); nb_colonne += yyleng; return IE; }
">="  { printf("Opérateur de comparaison : %s\n", yytext); nb_colonne += yyleng; return SE; }
"<"   { printf("Opérateur de comparaison : %s\n", yytext); nb_colonne += yyleng; return I; }
">"   { printf("Opérateur de comparaison : %s\n", yytext); nb_colonne += yyleng; return S; }

"{"   { printf("Ouverture de bloc\n"); nb_colonne += yyleng; return OUVEREBLOC; }
"}"   { printf("Fermeture de bloc\n"); nb_colonne += yyleng; return FERMETBLOC; }
"["   { printf("Crochet ouvrant\n"); nb_colonne += yyleng; return CROCHETOUVERT; }
"]"   { printf("Crochet fermant\n"); nb_colonne += yyleng; return CROCHETFERME; }
"("   { printf("Parenthese ouvrante\n"); nb_colonne += yyleng; return PARENTHESEOUVERT; }
")"   { printf("Parenthese fermante\n"); nb_colonne += yyleng; return PARENTHESEFERME; }

";"   { printf("Point-virgule\n"); nb_colonne += yyleng; return PVG; }
":"   { printf("Deux-points\n"); nb_colonne += yyleng; return DEUXPOINT; }
","   { printf("Virgule\n"); nb_colonne += yyleng; return VRG; }
"\'"  { printf("Guillemets\n"); nb_colonne += yyleng; return GUILLEMET; }
"="   { printf("Égal\n"); nb_colonne += yyleng; return EGAL; }
":="  { printf("Affectation\n"); nb_colonne += yyleng; return AFFECTATION; }

[ \t]+      { nb_colonne += yyleng; }
\n          { nb_ligne++; nb_colonne = 1; }
.           { afficher_erreur("Erreur lexicale", yytext, "Caractère inconnu"); 
              nb_colonne += yyleng; return ERREUR; 
            }

%%

