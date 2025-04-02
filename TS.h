#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define TAILLE_INITIALE 10


// Déclaration de la TS
typedef struct {
    char NomEntite[20];
    char CodeEntite[20];
    char TypeEntite[20];
    union {
        int valeurInt;
        float valeurFloat;
    } valeur;
    int estInitialise; // Indique si la valeur a été initialisée
} TypeTS;


// Déclaration de la SM (pour mots-clés et séparateurs)
typedef struct {
    char NomEntite[20];
    char CodeEntite[20];
} TypeSM;

TypeTS *ts;
TypeSM *tabM;
TypeSM *tabS;
int capaciteTS = TAILLE_INITIALE;
int capaciteM = TAILLE_INITIALE;
int capaciteS = TAILLE_INITIALE;
int CpTS = 0;
int CpM = 0;
int CpS = 0;

// Fonction d'initialisation dynamique
void dynamicInit() {
    ts = (TypeTS*)malloc(capaciteTS * sizeof(TypeTS));
    tabM = (TypeSM*)malloc(capaciteM * sizeof(TypeSM));
    tabS = (TypeSM*)malloc(capaciteS * sizeof(TypeSM));
}
// Fonction d'agrandissement de la TS
void agrandirTS() {
    capaciteTS *= 2;
    ts = (TypeTS*)realloc(ts, capaciteTS * sizeof(TypeTS));
    if (ts == NULL) {
        printf("Erreur lors de l'agrandissement de la TS\n");
        exit(EXIT_FAILURE);
    }
}

// Fonction d'agrandissement de tabM
void agrandirM() {
    capaciteM *= 2;
    tabM = (TypeSM*)realloc(tabM, capaciteM * sizeof(TypeSM));
    if (tabM == NULL) {
        printf("Erreur lors de l'agrandissement de tabM\n");
        exit(EXIT_FAILURE);
    }
}

// Fonction d'agrandissement de tabS
void agrandirS() {
    capaciteS *= 2;
    tabS = (TypeSM*)realloc(tabS, capaciteS * sizeof(TypeSM));
    if (tabS == NULL) {
        printf("Erreur lors de l'agrandissement de tabS\n");
        exit(EXIT_FAILURE);
    }
}

// Fonction de recherche dans la TS
int rechercheTS(char entite[]) {
    int i;
    for (i = 0; i < CpTS; i++) {
        if (strcmp(entite, ts[i].NomEntite) == 0)
            return i;
    }
    return -1;
}

// Fonction de recherche dans la SM (Mots-clés)
int rechercheM(char entite[]) {
    int i;
    for (i = 0; i < CpM; i++) {
        if (strcmp(entite, tabM[i].NomEntite) == 0)
            return i;
    }
    return -1;
}

// Fonction de recherche dans la SM (Séparateurs)
int rechercheS(char entite[]) {
    int i;
    for (i = 0; i < CpS; i++) {
        if (strcmp(entite, tabS[i].NomEntite) == 0)
            return i;
    }
    return -1;
}

float obtenirValeurFloat(char* idf);  // Déclaration explicite
int obtenirValeurInt(char* idf);     // Pour cohérence

float getValeur(char* idf) {
    int pos = rechercheTS(idf);
    if (pos != -1) {
        if (strcmp(ts[pos].TypeEntite, "int") == 0) {
            return (float)obtenirValeurInt(idf);
        } else if (strcmp(ts[pos].TypeEntite, "float") == 0) {
            return obtenirValeurFloat(idf);
        } else {
            return 0.0f;
        }
    } else {
        printf("Erreur sémantique : Variable '%s' non déclarée\n", idf);
        return 0.0f;
    }
}

int variable_declaree(char *var) {
    return rechercheType(var); // Vérifie si la variable est présente dans la table des symboles
}


int obtenirValeurInt(char* idf) {
    int pos = rechercheTS(idf);
    if (pos != -1) {
        if (strcmp(ts[pos].TypeEntite, "int") == 0) {
            if (ts[pos].estInitialise) {
                return ts[pos].valeur.valeurInt;
            } else {
                printf("Erreur : la variable entière '%s' n'est pas initialisée.\n", idf);
                exit(EXIT_FAILURE);
            }
        } else {
            printf("Erreur : la variable '%s' n'est pas de type entier.\n", idf);
            exit(EXIT_FAILURE);
        }
    } else {
        printf("Erreur : variable '%s' non déclarée.\n", idf);
        exit(EXIT_FAILURE);
    }
}



float obtenirValeurFloat(char* idf) {
    int pos = rechercheTS(idf);
    if (pos != -1) {
        if (strcmp(ts[pos].TypeEntite, "float") == 0) {
            if (ts[pos].estInitialise) {
                return ts[pos].valeur.valeurFloat;
            } else {
                printf("Erreur : la variable flottante '%s' n'est pas initialisée.\n", idf);
                exit(EXIT_FAILURE);
            }
        } else {
            printf("Erreur : la variable '%s' n'est pas de type flottant.\n", idf);
            exit(EXIT_FAILURE);
        }
    } else {
        printf("Erreur : variable '%s' non déclarée.\n", idf);
        exit(EXIT_FAILURE);
    }
}

void assignerValeurInt(char* idf, int valeur) {
    int pos = rechercheTS(idf);
    if (pos != -1) {
        if (strcmp(ts[pos].TypeEntite, "int") == 0) {
            ts[pos].valeur.valeurInt = valeur;
            ts[pos].estInitialise = 1;
        } else {
            printf("Erreur : la variable '%s' n'est pas de type entier.\n", idf);
            exit(EXIT_FAILURE);
        }
    } else {
        printf("Erreur : variable '%s' non déclarée.\n", idf);
        exit(EXIT_FAILURE);
    }
}

void assignerValeurFloat(char* idf, float valeur) {
    int pos = rechercheTS(idf);
    if (pos != -1) {
        if (strcmp(ts[pos].TypeEntite, "float") == 0) {
            ts[pos].valeur.valeurFloat = valeur;
            ts[pos].estInitialise = 1;
        } else {
            printf("Erreur : la variable '%s' n'est pas de type flottant.\n", idf);
            exit(EXIT_FAILURE);
        }
    } else {
        printf("Erreur : variable '%s' non déclarée.\n", idf);
        exit(EXIT_FAILURE);
    }
}


void insererTS(char entite[], char code[]) {
    if (rechercheTS(entite) == -1) {
        if (CpTS >= capaciteTS) {  // Vérifie la capacité avant insertion
            agrandirTS();
        }
        // Vérifie la place après l'agrandissement
        strcpy(ts[CpTS].NomEntite, entite);
        strcpy(ts[CpTS].CodeEntite, code);
        strcpy(ts[CpTS].TypeEntite, "");
        CpTS++;   
    }
}



// Fonction d'insertion dans tabM (Mots-clés)
void insererM(char entite[], char code[]) {
    if (rechercheM(entite) == -1) {
        if (CpM >= capaciteM) {
            agrandirM();  // Agrandir si la capacité est atteinte
        } 
        strcpy(tabM[CpM].NomEntite, entite);
        strcpy(tabM[CpM].CodeEntite, code);
        CpM++;
        
    }
}

// Fonction d'insertion dans tabS (Séparateurs)
void insererS(char entite[], char code[]) {
    if (rechercheS(entite) == -1) {
        if (CpS >= capaciteS) {
            agrandirS();  // Agrandir si la capacité est atteinte
        }
        strcpy(tabS[CpS].NomEntite, entite);
        strcpy(tabS[CpS].CodeEntite, code);
        CpS++;
        
    }
}

// fonction qui insère le type d'une etité une fois il va être reconnu dans la syntaxe 
void insererType(char entite[], char type[])
{
   int posEntite=rechercheTS(entite);
    if (posEntite!=-1) // si l'entité existe dans la TS
    { 
        strcpy(ts[posEntite].TypeEntite,type);
        //printf("lentite est %s, son type est %s\n",ts[posEntite].NomEntite,ts[posEntite].TypeEntite);
    }
}

// Fonction RechercheType : retourne le type de l'entité
int rechercheType(char entite[])
{
    int posEntite = rechercheTS(entite);
    if (posEntite == -1) return -1; 

    if (strcmp(ts[posEntite].TypeEntite, "") == 0) 
        return 0; // L'entité n'est pas encore déclarée
    else 
        return 1; // L'entité est déclarée
}



// Fonction d'affichage de la TS
void afficherTS() {
    printf("\n/*************** Table des symboles (TS) ******************/\n");
    printf("_________________________________________________\n");
    printf("\t| NomEntite |  CodeEntite  | TypeEntite | \n");
    printf("_________________________________________________\n");
    int i = 0;
    while (i < CpTS)
    {
      printf("\t|%10s |%12s |%12s |\n", ts[i].NomEntite, ts[i].CodeEntite, ts[i].TypeEntite);
      i++;
    }
}

// Fonction d'affichage de tabM (Mots-clés)
void afficherM() {
    printf("\n/*************** Table des mots-clés ******************/\n");
    printf("____________________________________\n");
    printf("\t| NomEntite |  CodeEntite  | \n");
    printf("____________________________________\n");
    int i = 0;
    while (i < CpM)
    {
      printf("\t|%10s |%12s  |\n", tabM[i].NomEntite, tabM[i].CodeEntite);
      i++;
    }
}

// Fonction d'affichage de tabS (Séparateurs)
void afficherS() {
    printf("\n/*************** Table des séparateurs ******************/\n");
    printf("____________________________________\n");
    printf("\t| NomEntite |  CodeEntite  | \n");
    printf("____________________________________\n");
    int i = 0;
    while (i < CpS)
    {
      printf("\t|%10s |%12s  |\n", tabS[i].NomEntite, tabS[i].CodeEntite);
      i++;
    }
}
void libererMemoire() {
    free(ts);
    free(tabM);
    free(tabS);
}

