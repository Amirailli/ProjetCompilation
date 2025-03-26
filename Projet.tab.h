
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     MAINPRGM = 258,
     VAR = 259,
     BEGINPG = 260,
     ENDPG = 261,
     LET = 262,
     ATDEF = 263,
     CONST = 264,
     INPUT = 265,
     OUTPUT = 266,
     TYPEINT = 267,
     TYPEFLOAT = 268,
     ENTIER = 269,
     ENTIERSIGNE = 270,
     FLOAT = 271,
     ENTIERERROR = 272,
     IDF = 273,
     lettre = 274,
     PLUS = 275,
     MINUS = 276,
     TIMES = 277,
     DIV = 278,
     AND = 279,
     OR = 280,
     NOT = 281,
     EQ = 282,
     NEQ = 283,
     IE = 284,
     SE = 285,
     I = 286,
     S = 287,
     OUVEREBLOC = 288,
     FERMETBLOC = 289,
     CROCHETOUVERT = 290,
     CROCHETFERME = 291,
     PARENTHESEOUVERT = 292,
     PARENTHESEFERME = 293,
     PVG = 294,
     DEUXPOINT = 295,
     VRG = 296,
     GUILLEMET = 297,
     EGAL = 298,
     AFFECTATION = 299,
     ERREUR = 300,
     IF = 301,
     THEN = 302,
     ELSE = 303,
     DO = 304,
     WHILE = 305,
     FOR = 306,
     FROM = 307,
     TO = 308,
     STEP = 309
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 10 "Projet.y"

int entier;
char* str;



/* Line 1676 of yacc.c  */
#line 113 "Projet.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


