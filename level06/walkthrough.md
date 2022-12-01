# Walkthrough

## Solution
```
b *0x080487b5
b *0x08048866
run
set $eip=0x080487ed
continue
x/d $ebp-0x10
```

## Execution

```
level06@OverRide:~$ ./level06 
***********************************
*		level06		  *
***********************************
-> Enter Login: hello
***********************************
***** NEW ACCOUNT DETECTED ********
***********************************
-> Enter Serial: 42
```

## Explanation

We want to see what the program is comparing the serial we enter to (line 286 in the asm file).  
Let's put a breakpoint at `0x080487b5`, before the call to ptrace, and another one at the check on line 286 `0x08048866`.  
When we try to run the program, with a login length > 5, we get a tampering detected message, because the program is monitoring it with ptrace.  
We need to bypass this check, by changing the eip to after the call to ptrace.  

```
(gdb) run
Starting program: /home/users/level06/level06 
***********************************
*		level06		  *
***********************************
-> Enter Login: christie
***********************************
***** NEW ACCOUNT DETECTED ********
***********************************
-> Enter Serial: 42

Breakpoint 1, 0x080487b5 in auth ()
(gdb) i r
eax            0x8	8
ecx            0x1	1
edx            0xffffd6dc	-10532
ebx            0xf7fceff4	-134418444
esp            0xffffd680	0xffffd680
ebp            0xffffd6a8	0xffffd6a8
esi            0x0	0
edi            0x0	0
eip            0x80487b5	0x80487b5 <auth+109> <<<<

(gdb) set $eip=0x080487ed <- after the jump following the ptrace call
(gdb) i r 
eax            0x8	8
ecx            0x1	1
edx            0xffffd6dc	-10532
ebx            0xf7fceff4	-134418444
esp            0xffffd680	0xffffd680
ebp            0xffffd6a8	0xffffd6a8
esi            0x0	0
edi            0x0	0
eip            0x80487ed	0x80487ed <auth+165> <<<<

(gdb) c
Continuing.

Breakpoint 2, 0x08048866 in auth ()
(gdb) i r
eax            0x2a	42
ecx            0x5f1ed9	6233817
edx            0x2d3	723
ebx            0xf7fceff4	-134418444
esp            0xffffd680	0xffffd680
ebp            0xffffd6a8	0xffffd6a8
esi            0x0	0
edi            0x0	0
eip            0x8048866	0x8048866 <auth+286>

```

We managed to bypass the ptrace check, we can now see what value it is comparing.  
```
(gdb) x/d $ebp-0x10
0xffffd698:	6234511
```

We can now get the flag:  
```
level06@OverRide:~$ ./level06 
***********************************
*		level06		  *
***********************************
-> Enter Login: christie
***********************************
***** NEW ACCOUNT DETECTED ********
***********************************
-> Enter Serial: 6234511
Authenticated!
$ whoami
level07
$ cat /home/users/level07/.pass
GbcPDRgsFK77LNnnuh7QyFYA2942Gp8yKj9KrWD8
```