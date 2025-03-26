#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define TAILLE_INITIALE 10
#pragma once

// Déclaration de la TS
typedef struct {
    char NomEntite[20];
    char CodeEntite[20];
    char TypeEntite[20];
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
    ts = NULL;
    tabM = NULL;
    tabS = NULL;

    ts = (TypeTS*)malloc(capaciteTS * sizeof(TypeTS));
    tabM = (TypeSM*)malloc(capaciteM * sizeof(TypeSM));
    tabS = (TypeSM*)malloc(capaciteS * sizeof(TypeSM));

    if (ts == NULL || tabM == NULL || tabS == NULL) {
        printf("Erreur : allocation mémoire échouée\n");
        exit(EXIT_FAILURE);
    }
}

// Fonction d'agrandissement de la TS
void agrandirTS() {
    TypeTS* temp = (TypeTS*)realloc(ts, capaciteTS * 2 * sizeof(TypeTS));
    if (temp == NULL) {
        printf("Erreur lors de l'agrandissement de la TS\n");
        exit(EXIT_FAILURE);
    }
    ts = temp;
    capaciteTS *= 2;
}


// Fonction d'agrandissement de tabM
void agrandirM() {
    TypeSM* temp = (TypeSM*)realloc(tabM, capaciteM * 2 * sizeof(TypeSM));
    if (temp == NULL) {
        printf("Erreur lors de l'agrandissement de tabM\n");
        exit(EXIT_FAILURE);
    }
    tabM= temp;
    capaciteM *= 2;
}


// Fonction d'agrandissement de tabS
void agrandirS() {
    TypeSM* temp = (TypeSM*)realloc(tabS, capaciteS * 2 * sizeof(TypeSM));
    if (temp == NULL) {
        printf("Erreur lors de l'agrandissement de la TS\n");
        exit(EXIT_FAILURE);
    }
    tabS = temp;
    capaciteS*= 2;
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

void insererTS(char entite[], char code[]) {
    if (rechercheTS(entite) == -1) { 
        if (CpTS >= capaciteTS) {  
            agrandirTS();
        }

        // Vérifie encore si l'agrandissement a réussi avant d'insérer
        if (CpTS < capaciteTS) {
            // Copie sécurisée avec strncpy pour éviter les dépassements
            strncpy(ts[CpTS].NomEntite, entite, 19);
            ts[CpTS].NomEntite[19] = '\0';  // Assurer la terminaison

            strncpy(ts[CpTS].CodeEntite, code, 19);
            ts[CpTS].CodeEntite[19] = '\0';

            strncpy(ts[CpTS].TypeEntite, "", 19);
            ts[CpTS].TypeEntite[19] = '\0';

            CpTS++;
        } else {
            printf("ERREUR : Impossible d'insérer l'entité, mémoire insuffisante\n");
        }
    } else {
        printf("ERREUR : Entité '%s' déjà existante dans la Table des Symboles\n", entite);
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
char* rechercheType(char entite[]) {
    int posEntite = rechercheTS(entite);
    if (posEntite == -1 || strcmp(ts[posEntite].TypeEntite, "") == 0) 
        return NULL;  // Pas déclaré
    return ts[posEntite].TypeEntite;  // Retourne le type
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

void afficherCapacites() {
    printf("\n--- Informations Mémoire ---\n");
    printf("Capacité TS : %d, Utilisé : %d\n", capaciteTS, CpTS);
    printf("Capacité Mots-clés : %d, Utilisé : %d\n", capaciteM, CpM);
    printf("Capacité Séparateurs : %d, Utilisé : %d\n", capaciteS, CpS);
}


void libererMemoire() {
    free(ts);
    free(tabM);
    free(tabS);
    ts = NULL;
    tabM = NULL;
    tabS = NULL;
}


