flex Projet.l 
bison -d Projet.y
gcc lex.yy.c Projet.tab.c -lfl -ly -o compiler
compiler.exe<Projet.txt


