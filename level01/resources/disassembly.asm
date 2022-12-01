(gdb) disas main
Dump of assembler code for function main:
   0x080484d0 <+0>:	push   %ebp
   0x080484d1 <+1>:	mov    %esp,%ebp
   0x080484d3 <+3>:	push   %edi
   0x080484d4 <+4>:	push   %ebx
   0x080484d5 <+5>:	and    $0xfffffff0,%esp
   0x080484d8 <+8>:	sub    $0x60,%esp							; allocates 96 bytes for variables
   0x080484db <+11>:	lea    0x1c(%esp),%ebx					; saves pointer in esp+28 in ebx (buffer?)
   0x080484df <+15>:	mov    $0x0,%eax						; eax = 0
   0x080484e4 <+20>:	mov    $0x10,%edx						; edx = 16
   0x080484e9 <+25>:	mov    %ebx,%edi						; edi = esp+28
   0x080484eb <+27>:	mov    %edx,%ecx						; ecx = 16
   0x080484ed <+29>:	rep stos %eax,%es:(%edi)				; equivalent to memset(esp+28, 0, 16)
   0x080484ef <+31>:	movl   $0x0,0x5c(%esp)					; esp+92 = 0 | variable to check if username/password is valid
   0x080484f7 <+39>:	movl   $0x80486b8,(%esp)				; "********* ADMIN LOGIN PROMPT *********"
   0x080484fe <+46>:	call   0x8048380 <puts@plt>				; puts("********* ADMIN LOGIN PROMPT *********")
   0x08048503 <+51>:	mov    $0x80486df,%eax					; "Enter Username: " to eax
   0x08048508 <+56>:	mov    %eax,(%esp)						; "Enter Username: " to *esp
   0x0804850b <+59>:	call   0x8048360 <printf@plt>			; printf("Enter Username: ")
   0x08048510 <+64>:	mov    0x804a020,%eax					; eax = 0x804a020 = stdin
   0x08048515 <+69>:	mov    %eax,0x8(%esp)					; esp+8 = stdin
   0x08048519 <+73>:	movl   $0x100,0x4(%esp)					; esp+4 = 256
   0x08048521 <+81>:	movl   $0x804a040,(%esp)				; esp = <a_user_name>
   0x08048528 <+88>:	call   0x8048370 <fgets@plt>			; fgets(a_user_name, 256, stdin)
   0x0804852d <+93>:	call   0x8048464 <verify_user_name>		; 
   0x08048532 <+98>:	mov    %eax,0x5c(%esp)					; store return value to esp+92
   0x08048536 <+102>:	cmpl   $0x0,0x5c(%esp)					; compare return value to 0
   0x0804853b <+107>:	je     0x8048550 <main+128>				; if 0, jump to 128
   0x0804853d <+109>:	movl   $0x80486f0,(%esp)				; "nope, incorrect username...\n"
   0x08048544 <+116>:	call   0x8048380 <puts@plt>				; puts("nope, incorrect username...\n")
   0x08048549 <+121>:	mov    $0x1,%eax						; eax = 1
   0x0804854e <+126>:	jmp    0x80485af <main+223>				; jump to 223
   0x08048550 <+128>:	movl   $0x804870d,(%esp)				; "Enter Password: "
   0x08048557 <+135>:	call   0x8048380 <puts@plt>				; puts("Enter Password: ")
   0x0804855c <+140>:	mov    0x804a020,%eax					; eax = stdin
   0x08048561 <+145>:	mov    %eax,0x8(%esp)					; esp+8 = stdin
   0x08048565 <+149>:	movl   $0x64,0x4(%esp)					; esp+4 = 100
   0x0804856d <+157>:	lea    0x1c(%esp),%eax					; move pointer in esp+28 (buffer?) to eax
   0x08048571 <+161>:	mov    %eax,(%esp)						; esp = eax (buffer?)
   0x08048574 <+164>:	call   0x8048370 <fgets@plt>			; fgets(buffer, 100, stdin)
   0x08048579 <+169>:	lea    0x1c(%esp),%eax					; move pointer in esp+28 (buffer?) to eax
   0x0804857d <+173>:	mov    %eax,(%esp)						; esp = buffer
   0x08048580 <+176>:	call   0x80484a3 <verify_user_pass>		; verify_user_pass(buffer)
   0x08048585 <+181>:	mov    %eax,0x5c(%esp)					; store return value of function in esp+92
   0x08048589 <+185>:	cmpl   $0x0,0x5c(%esp)					; compare to 0
   0x0804858e <+190>:	je     0x8048597 <main+199>				; if 0, jump to 199
   0x08048590 <+192>:	cmpl   $0x0,0x5c(%esp)					; else, compare to 0 (again?)
   0x08048595 <+197>:	je     0x80485aa <main+218>				; if 0, jump to 218
   0x08048597 <+199>:	movl   $0x804871e,(%esp)				; "nope, incorrect password...\n"
   0x0804859e <+206>:	call   0x8048380 <puts@plt>				; puts("nope, incorrect password...\n")
   0x080485a3 <+211>:	mov    $0x1,%eax						; eax = 1
   0x080485a8 <+216>:	jmp    0x80485af <main+223>				; jump to 223
   0x080485aa <+218>:	mov    $0x0,%eax						; eax = 0
   0x080485af <+223>:	lea    -0x8(%ebp),%esp
   0x080485b2 <+226>:	pop    %ebx
   0x080485b3 <+227>:	pop    %edi
   0x080485b4 <+228>:	pop    %ebp
   0x080485b5 <+229>:	ret    									; return
End of assembler dump.


(gdb) disas verify_user_name 
Dump of assembler code for function verify_user_name:
   0x08048464 <+0>:	push   %ebp
   0x08048465 <+1>:	mov    %esp,%ebp
   0x08048467 <+3>:	push   %edi
   0x08048468 <+4>:	push   %esi
   0x08048469 <+5>:	sub    $0x10,%esp							; allocates 16 bytes for variables
   0x0804846c <+8>:	movl   $0x8048690,(%esp)					; "verifying username....\n"
   0x08048473 <+15>:	call   0x8048380 <puts@plt>				; puts("verifying username....\n")
   0x08048478 <+20>:	mov    $0x804a040,%edx					; edx = <a_user_name>
   0x0804847d <+25>:	mov    $0x80486a8,%eax					; eax = "dat_wil"
   0x08048482 <+30>:	mov    $0x7,%ecx						; ecx = 7
   0x08048487 <+35>:	mov    %edx,%esi						; esi = <a_user_name>
   0x08048489 <+37>:	mov    %eax,%edi						; edi = "dat_wil"
   0x0804848b <+39>:	repz cmpsb %es:(%edi),%ds:(%esi)		; equivalent to strncmp(a_user_name, "dat_will", 7)
   0x0804848d <+41>:	seta   %dl
   0x08048490 <+44>:	setb   %al
   0x08048493 <+47>:	mov    %edx,%ecx
   0x08048495 <+49>:	sub    %al,%cl
   0x08048497 <+51>:	mov    %ecx,%eax
   0x08048499 <+53>:	movsbl %al,%eax
   0x0804849c <+56>:	add    $0x10,%esp						; esp = esp+16
   0x0804849f <+59>:	pop    %esi
   0x080484a0 <+60>:	pop    %edi
   0x080484a1 <+61>:	pop    %ebp
   0x080484a2 <+62>:	ret    
End of assembler dump.


(gdb) disas verify_user_pass 
Dump of assembler code for function verify_user_pass:
   0x080484a3 <+0>:	push   %ebp
   0x080484a4 <+1>:	mov    %esp,%ebp
   0x080484a6 <+3>:	push   %edi
   0x080484a7 <+4>:	push   %esi
   0x080484a8 <+5>:	mov    0x8(%ebp),%eax						; allocates 8 bytes for variables
   0x080484ab <+8>:	mov    %eax,%edx
   0x080484ad <+10>:	mov    $0x80486b0,%eax					; "admin"
   0x080484b2 <+15>:	mov    $0x5,%ecx						; ecx = 5
   0x080484b7 <+20>:	mov    %edx,%esi						; esi = password variable, passed through parameter?
   0x080484b9 <+22>:	mov    %eax,%edi						; edi = "admin"
   0x080484bb <+24>:	repz cmpsb %es:(%edi),%ds:(%esi)		; equivalent to strncmp(password, "admin", 5)
   0x080484bd <+26>:	seta   %dl
   0x080484c0 <+29>:	setb   %al
   0x080484c3 <+32>:	mov    %edx,%ecx
   0x080484c5 <+34>:	sub    %al,%cl
   0x080484c7 <+36>:	mov    %ecx,%eax
   0x080484c9 <+38>:	movsbl %al,%eax
   0x080484cc <+41>:	pop    %esi
   0x080484cd <+42>:	pop    %edi
   0x080484ce <+43>:	pop    %ebp
   0x080484cf <+44>:	ret    
End of assembler dump.
