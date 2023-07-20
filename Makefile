all:
	flex lex.l
	yacc -d translate.y
	gcc -o translate y.tab.c
	#clear
	./translate < programas/${file}
run:
	clear
	./translate < programas/${file}
instalarLex:
	sudo apt-get install flex
instalarYacc:
	sudo apt-get install bison