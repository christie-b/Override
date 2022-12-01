int main()
{
	int i;

	puts("***********************************");
	puts("* \t     -Level00 -\t\t  *");
	puts("***********************************");
	printf("Password:");
	__isoc99_scanf("%d", &i);
	if (i == 0x149c)
	{
		puts("\nAuthenticated!");
		system("/bin/sh");
	}
	else
	{
		puts("\nInvalid Password!");
		return(1);
	}	
	return (0);	
}
