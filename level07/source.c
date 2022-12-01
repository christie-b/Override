#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

void clear_stdin()
{
	int i = 0;

	while (i != 10 && i != 255)
		i = getchar();
	return;
}

unsigned int get_unum()
{
	unsigned int i = 0;

	fflush(stdout);
	__isoc99_scanf("%u", &i);
	clear_stdin();
	return (i);
}

int store_number(char *buf)
{
	int number;
	int index;

	printf(" Number");
	number = get_unum();
	printf(" Index: ");
	index = get_unum();

	if((index % 3) == 0 || index >> 24 == 183)
	{
		puts(" *** ERROR! ***");
		puts("   This index is reserved for wil!");
		puts(" *** ERROR! ***");
		return(1);
	}
	buf[index << 2] = number;
	return (0);
}

int read_number(char *buf)
{
	unsigned int i;

	printf(" Index: ");
	i = get_unum();
	printf(" Number at data[%u] is %u\n", i, buf[i << 2]);
	return (0);
}

int main(int argc, char **argv, char** environ)
{
	int i = 0;
	char j[4] = {0};
	char k[4] = {0};
	char l[4] = {0};
	char m[4] = {0};
	char n[4] = {0};
	char buf[400] = {0};
	
	while (*argv != 0)
	{
		memset(*argv, 0, __builtin_strlen(*argv));
		argv++;
	}
	while (*environ != 0)
	{		
		memset(*environ, 0, __builtin_strlen(*argv));
		environ++;
	}
	puts(
	"----------------------------------------------------\n"
	"  Welcome to wil's crappy number storage service!   \n"
	"----------------------------------------------------\n"
	" Commands:                                          \n"
	"    store - store a number into the data storage    \n"
	"    read  - read a number from the data storage     \n"
	"    quit  - exit the program                        \n"
	"----------------------------------------------------\n"
	"   wil has reserved some storage :>                 \n"
	"----------------------------------------------------\n"
	);
	while (1)
	{
		printf("Input command: ");
		i = 1;
		fgets(j, 20, 0x804a040);
		j[__builtin_strlen(j) - 1] = 0; 
		if (__builtin_strcmp(j, "store") == 0)
		{
			i = store_number(buf);
		}
		else if (__builtin_strcmp(j, "read") == 0)
		{
			i = read_number(buf);
		}
		else if (__builtin_strcmp(j, "quit") == 0)
		{
			break;
		}
		if (i != 0)
		{
			printf(" Failed to do %s command\n", j);
		}
		else
		{
			printf(" Completed %s command successfully\n", j);
		}
	}
	return (0);
}