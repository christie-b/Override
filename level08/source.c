#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int log_wrapper(FILE *file, char *str, char *arg)
{
	char buf[256];
	char filename[100];
	int len;
	int i;

	strcpy(buf, str);
	i = __builtin_strlen(buf);
}

int main(int argc, char **argv)
{
	char c = -1;
	int fd = -1;
	FILE *file1;	// [rbp-0x88]
	FILE *file2;	// [rbp-0x80]

	if (argc != 2) {
		printf("Usage: %s filename\n", *argv);
	}

	file1 = fopen("./backups/.log", "w");
	if (file1 == 0) {
		printf("ERROR: Failed to open %s\n", "./backups/.log");
		exit(1);
	}
	log_wrapper(file1, "Starting back up: ", argv[1]);

	file2 = fopen(argv[1], "r");
	if (file2 == 0)
	{
		printf("ERROR: Failed to open %s\n", argv[1]);
		exit(1);
	}
	len = strlen("./backups/");
	strcpy(filename, "./backups/");
	strncat(filename, argv[1], 99 - len);
	fd = open("./backups/", 193, 432);
	if (fd < 0)
	{
		printf("ERROR: Failed to open %s%s\n", "./backups/", argv[1]);
		exit(1);
	}
	while (1)
	{
		c = fgets(file2);
		if (c == -1)
			break ;
		write(fd, &c, 1);
	}
	log_wrapper(file1, "Finished back up ", argv[1]);
	fclose(file2);
	close(fd);
	return 0;
}