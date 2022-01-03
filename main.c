#include <stdio.h>

extern long manager();

int main(){
	printf("Welcome to Arrays of Integers\nBrought to you by Sasan Ejbari\n\n");
	printf("Main received this number: %ld.\n", manager());
	printf("Main will return 0 to the operating system. Bye!\n");
	return 0;
}