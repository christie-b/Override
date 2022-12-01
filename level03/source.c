void	decrypt(int nb)
{
	char msg[] = "Q}|u`sfg~sf{}|a3";
	unsigned long len;
	unsigned long i;


	len = __builtin_strlen(msg);
	i = 0;
	while (i < len) {
		msg[i] = nb ^ msg[i];
		i++;
	}
	if (__builtin_strcmp("Congratulations!", msg) == 0) {
		system("/bin/sh");
	}
	else {
		puts("\nInvalid Password");
	}
}


void test(int nb1, int nb2)
{
	unsigned int res = nb2 - nb1;

	if (res < 22)
	{
		goto *(unsigned int *)(*(unsigned int *)((res << 2) + 0x80489f0));
		decrypt (nb1);
	}
	else
	{
		decrypt(rand());
	}
}

int 	main(int argc, char **argv)
{
	srand(time(0));

	puts("***********************************");
	puts("*\t\tlevel03\t\t**");
	puts("***********************************");
	printf("Password:");
	
	int password;
	__isoc99_scanf("%d", &password);
	test(password, 322424845);

	return 0;
}