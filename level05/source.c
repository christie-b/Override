#include <stdio.h>
#include <string.h>

int main()
{
	unsigned int i;
	unsigned int buf[28];

	i = 0;
	fgets(buf, 100, stdin);
	i = 0;
	while (i < strlen((char *)buf)) {
		if (((char *)buf)[i] > 64 && ((char *)buf)[i] <= 90)	// uppercase
		{
			((char *)buf)[i] ^= 32; // tolower
		}
		++i;
	}
	printf(buf);
	exit(0);
}