#include <stdio.h>

struct s_input
{
	char msg[140];		// 0x0
	char username[40];	// 0x8c
	int len;			// 0xb4
}	t_input;

void secret_backdoor(void)
{
	char buf[128];

	fgets(buf, 128, stdin);
	system(buf);
}

void set_username(t_input *input)
{
	int i;
	int str[32];

	__builtin_memset(str, 0, 128);
	puts(">: Enter your username");
	printf(">>: ");
	fgets(str, 128, stdin);
	i = 0;
	while (i <= 40 && ((char *)str)[i] != 0)	// <= 40 -> 1 additional char is copied
	{
		msg->username[i] = ((char *)str)[i];
		++i; 
	}
	printf(">: Welcome, %s", msg->username);
}

void set_message(t_input *input)
{
	char	str[1024];

	memset(str, 0, 1024);
	puts(">: Msg @Unix-Dude");
	printf(">>: ");
	fgets(str, 1024, stdin);
	strncpy(input->msg, str, input->len);
}

void handle_msg()
{
	t_input	input;

	memset(input.username, 0, 40);
	input.len = 140;

	set_username(&input);
	set_message(&input);
	puts(">: Msg sent!");
}

int main()
{
	puts("--------------------------------------------"
		"\n|   ~Welcome to l33t-m$n ~    v1337        |\n"
		"--------------------------------------------"
	);
	handle_msg();

	return (0);
}