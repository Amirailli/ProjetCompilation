flex projet2.l
bison -d projet2.y
gcc lex.yy.c projet2.tab.c -lfl -ly -o AnaLexProjet
AnaLexProjet.exe < Projet2.txt