#include <sys/types.h>

int main()
{
	pid_t pid = fork();
	int buf[32] = {0};
	long var3 = 0;
	int var4 = 0;

	if (pid == 0)
	{
		prctl(1, 1);
		ptrace(0, 0, 0, 0);
		puts("Give me some shellcode, k");
		gets(buf);
	}
	else
	{
		while (1)
		{
			wait(&var4);
			if ((var4 & 127) == 0 || ((char)((var4 & 127) + 1) >> 1) > 0) 
			{
				puts("child is exiting...");
				break;
			}
			var3 = ptrace(3, pid, 44, 0);
			if (var3 != 11)
			{
				continue;
			}
			puts("no exec() for you");
			kill(pid, 9);
			break;
		}
	}
	return (0);
}