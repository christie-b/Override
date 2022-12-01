int auth(char *login, unsigned int serial)
{
	size_t len;
	int var1;

	login[strcspn(login, "\n")] = '\0';
	len = strnlen(login, 32);
	if(len > 5)
	{
		if(ptrace(0, 0, 1, 0) == -1)
		{
			puts("\033[32m.---------------------------.");
			puts("\033[31m| !! TAMPERING DETECTED !!  |");
			puts("\033[32m'---------------------------'");
			return(1);
		}
		var1 = login[3] ^ 4919 + 6221293;
		for(int i = 0; i < len; i++)
		{
			if (username[i] <= 31)
			{
				return 1;
			}
			var1 += (username[i] ^ var1) * 1337;
		}
		if (serial == var1)
			return(0);
	}
	return(1);
}



int main(int argc, char **argv)
{
	char login[32];
	unsigned int serial;

	puts("***********************************");
	puts("*\t\tlevel06\t\t  *");
	puts("***********************************");
	printf("-> Enter Login: ");
	fgets(login, 32, stdin);
	puts("***********************************");
	puts("***** NEW ACCOUNT DETECTED ********");
	puts("***********************************");
	puts("-> Enter Serial: ");
	scanf("%u", &serial);
	if (auth(login, serial) == 0)
	{
		puts("Authenticated!");
		system("/bin/sh");
		return(0);
	}
	return (1);
}