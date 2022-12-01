#include <stdio.h>


char a_user_name[256];

int verify_user_name(void)
{
	puts("verifying username....\n");
	return (strncmp(a_user_name, "dat_will", 7));
	
}

int verify_user_pass(char *pass)
{
	return (strncmp(pass, "admin", 5));
}


int main(void)
{
	int check;
	int buf[16];

	__builtin_memset(buf, 0, 64);

	check = 0;
	puts("********* ADMIN LOGIN PROMPT *********");
	printf("Enter Username: ");
	fgets(a_user_name, 256, stdin);

	check = verify_user_name();
	if (check != 0)
	{
		puts("nope, incorrect username...\n");
		return (1);
	}

	puts("Enter Password: ");
	fgets(buf, 100, stdin);
	check = verify_user_pass(buf);
	if (check == 0 || check != 0)
	{
		puts("nope, incorrect password...\n");
		return (1);
	}
	return (0);

}
