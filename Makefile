# Compile and Link Variable
CC := gcc
CC_FLAGS := -Wall -m64 -gdwarf-2 -c
ASM := yasm
ASM_FLAGS := -f elf64 -gdwarf2
LINKER := gcc
LINKER_FLAGS := -Wall -m64 -gdwarf-2 -no-pie 


# Executable name
BIN_NAME := my-program
BIN := ./$(BIN_NAME)

run:	build
	@echo "Running program!"
	./my-program

build: $(BIN)
.PHONY: build

#
$(BIN): manager.o main.o display_array.o reverse.o
	$(LINKER) $(LINKER_FLAGS) display_array.o reverse.o manager.o main.o libPuhfessorP.asm.so -o my-program
	@echo "Done"

reverse.o: reverse.cpp
	g++ -g -Wall -std=c++17 -c -o reverse.o reverse.cpp

display_array.o: display_array.asm
	$(ASM) $(ASM_FLAGS) display_array.asm -o display_array.o

manager.o: manager.asm
	$(ASM) $(ASM_FLAGS) manager.asm -o manager.o

main.o: main.c
	$(CC) $(CC_FLAGS) main.c -o main.o


# ca make targets as many as want

clean: 
	-rm *.o
	-rm $(BIN)














