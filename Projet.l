%{
    #include <stdio.h>
    #include <stdlib.h>  // Pour strtol()
    int nb_ligne = 1;
    int nb_colonne = 1;
    long yylval; // Déclaration de yylval

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




"MainPrgm"      { printf("Mot-cle detecte : MainPrgm\n"); }
"Var"           { printf("Mot-cle detecte : Var\n"); }
"BeginPg"       { printf("Mot-cle detecte : BeginPg\n"); }
"EndPg"         { printf("Mot-cle detecte : EndPg\n"); }
"let"           { printf("Mot-cle detecte : let\n"); }
"@define"       { printf("Mot-cle detecte : @define\n"); }
"Const"         { printf("Mot-cle detecte : Const\n"); }
"input"         { printf("Mot-cle detecte : input\n"); }
"output"        { printf("Mot-cle detecte : output\n"); }

"Int"       { printf("Type Int detecte : %s\n", yytext); nb_colonne += yyleng; }
"Float"     { printf("Type Float detecte : %s\n", yytext); nb_colonne += yyleng; }

{chiffre}+  { 
                yylval = strtol(yytext, NULL, 10); /* conversion de yytext en entier : yytext → Contient la chaîne à convertir.
                                                  NULL → On ne veut pas récupérer la position du premier caractère non numérique, donc on ignore cet argument.
                                                  10 → Indique que le nombre est en base 10 (décimal). */
                if (yylval < -32768 || yylval > 32767) 
                    afficher_erreur("Valeur entiere hors limite", yytext, "Nombre trop grand ou trop petit");
                else 
                   printf("Entier : %s\n", yytext);
                nb_colonne += yyleng;
            }

{entier_signe} { 
                  yylval = strtol(yytext, NULL, 10);
                    if (yylval < -32768 || yylval > 32767) 
                        afficher_erreur("Valeur entiere hors limite", yytext, "Nombre trop grand ou trop petit");
                    else 
                        printf("Entier : %s\n", yytext);
                    nb_colonne += yyleng;
                } 

[+-]{chiffre}+ { 
    afficher_erreur("Syntaxe invalide", yytext, "Un entier signe doit etre entre parentheses");
    nb_colonne += yyleng;
}
[+-]{chiffre}+.{chiffre}+ { 
    afficher_erreur("Syntaxe invalide", yytext, "Un flottant signe doit etre entre parentheses");
    nb_colonne += yyleng;
}

{flottant}   { printf("float non signe %s\n", yytext);nb_colonne += yyleng; }

{flottant_signe} { printf("float signe %s\n", yytext);nb_colonne += yyleng; }
 
{lettre}    { printf("Lettre: %s\n", yytext);nb_colonne += yyleng; }

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
            }  
{ERREUR_NUM_IDENT}  { afficher_erreur("Identificateur invalide", yytext, "Un IDF ne peut pas commencer par un chiffre"); 
                      nb_colonne += yyleng;
                    }
{ERREUR_UNDERS_IDENT} {
                       afficher_erreur("Identificateur invalide", yytext, "Un IDF ne doit pas commencer par '_'");
                       nb_colonne += yyleng;
                      }

[+\-*/]     { printf("Operateur arithemetique : %s\n", yytext); nb_colonne += yyleng;}
"AND"|"OR"    { printf("Operateur logique : %s\n", yytext);nb_colonne += yyleng; }
"!"           { printf("Operateur NOT : %s\n", yytext); nb_colonne += yyleng;}
"=="|"!="|"<="|">="|"<"|">"  { printf("Operateur de comparaison : %s\n", yytext); nb_colonne += yyleng;}

"{"         { printf("Ouverture de bloc\n"); }
"}"         { printf("Fermeture de bloc\n"); }
"["         { printf("Crochet ouvrant\n"); }
"]"         { printf("Crochet fermant \n"); }
"("         { printf("Parenthese ouvrant \n"); }
")"         { printf("Parenthese fermant \n"); }

";"         { printf("Point virgule\n"); }
":"         { printf("Declaration\n"); }
","         { printf("Virgule\n"); }
"\'"        { printf("Guillemets\n"); }
":="        { printf("Affectation\n"); }
"="        { printf("Egal\n"); }

[ \t]+      {nb_colonne += yyleng;}
\n          { nb_ligne++,nb_colonne = 1; }
.           { afficher_erreur("Erreur lexicale", yytext, "Caractere inconnu"); 
              nb_colonne += yyleng;
            }

%%

int main() {
    yylex();
    return 0;
}


