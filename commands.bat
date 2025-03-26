flex Projet.l 
bison -d Projet.y
gcc lex.yy.c Projet.tab.c -lfl -ly -o mon_compilateur.exe
mon_compilateur.exe<Projet.txt



