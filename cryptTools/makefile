3des : main.o 3desAlgoritm.o utils.o
	gcc -o 3des main.o 3desAlgoritm.o utils.o

all: clean 3des


main.o : main.c
	gcc -c main.c

3desAlgoritm.o : 3desAlgoritm.c
	gcc -c 3desAlgoritm.c

utils.o : utils.c
	gcc -c utils.c

clean :
	rm 3des main.o utils.o 3desAlgoritm.o

wclean :
	del 3des main.o utils.o 3desAlgoritm.o
