#include <stdio.h>

int main(int argc, char **argv)
{
	int	buf1[24] = {0};
	int	buf2[11] = {0};
	int	buf3[25] = {0};
	FILE *file = 0;
	unsigned int	nb_bytes = 0;

	file = fopen("/home/users/level03/.pass", "r");
	if (file == 0)
	{
		fwrite("ERROR: failed to open password file\n", 1, 36, stderr);
		exit(1);
	}
	nb_bytes = fread(buf2, 1, 41, file);
	buf2[strcspn(buf2, "\n")] = 0;
	if (nb_bytes != 41)
	{
		fwrite("ERROR: failed to read password file\n", 1, 36, stderr);
		exit(1);
	}
	fclose(file);
	puts("===== [ Secure Access System v1.0 ] =====");
	puts("/***************************************\\");
	puts("| You must login to access this system. |");
	puts("\\**************************************/");
	printf("--[ Username: ");
	fgets(buf1, 100, stdin);
	buf1[strcspn( buf1  , "\n")] = 0;
	printf("--[ Password: ");
	fgets(buf3, 100, stdin);
	buf3[strcspn(buf3, "\n")] = 0;
	puts("*****************************************");
	if (strncmp(buf2, buf3, 41) == 0)
	{
		printf("Greetings, %s!\n", buf1);
		system("/bin/sh");
		return (0);
	}
	printf(buf1);
	puts(" does not have access!");
	exit(1);
}