(gdb) disas main
Dump of assembler code for function main:
   0x080486c8 <+0>:	push   %ebp
   0x080486c9 <+1>:	mov    %esp,%ebp
   0x080486cb <+3>:	push   %edi
   0x080486cc <+4>:	push   %ebx
   0x080486cd <+5>:	and    $0xfffffff0,%esp
   0x080486d0 <+8>:	sub    $0xb0,%esp							; allocates 176 bytes for variables
   0x080486d6 <+14>:	call   0x8048550 <fork@plt>				; fork()
   0x080486db <+19>:	mov    %eax,0xac(%esp)					; store return value (pid of child process) in esp+172 (var1)
   0x080486e2 <+26>:	lea    0x20(%esp),%ebx					; ebx = esp+32 //var2 (buf?)
   0x080486e6 <+30>:	mov    $0x0,%eax						; eax = 0
   0x080486eb <+35>:	mov    $0x20,%edx						; edx = 32
   0x080486f0 <+40>:	mov    %ebx,%edi						; edi = esp+32
   0x080486f2 <+42>:	mov    %edx,%ecx						; ecx = 32
   0x080486f4 <+44>:	rep stos %eax,%es:(%edi)				; memset(buf, 0, 32)
   0x080486f6 <+46>:	movl   $0x0,0xa8(%esp)					; esp+168 = 0 (var3)
   0x08048701 <+57>:	movl   $0x0,0x1c(%esp)					; esp+28 = 0 (var4)
   0x08048709 <+65>:	cmpl   $0x0,0xac(%esp)					; compare var1 to 0
   0x08048711 <+73>:	jne    0x8048769 <main+161>				; if not 0, jump to 161
   0x08048713 <+75>:	movl   $0x1,0x4(%esp)					; esp+4 = 1
   0x0804871b <+83>:	movl   $0x1,(%esp)						; esp = 1
   0x08048722 <+90>:	call   0x8048540 <prctl@plt>			; prctl(1,1)
   0x08048727 <+95>:	movl   $0x0,0xc(%esp)					; esp+12 = 0
   0x0804872f <+103>:	movl   $0x0,0x8(%esp)					; esp+8 = 0
   0x08048737 <+111>:	movl   $0x0,0x4(%esp)					; esp+4 = 0
   0x0804873f <+119>:	movl   $0x0,(%esp)						; esp = 0
   0x08048746 <+126>:	call   0x8048570 <ptrace@plt>			; ptrace(0, 0, 0, 0)
   0x0804874b <+131>:	movl   $0x8048903,(%esp)				; "Give me some shellcode, k"
   0x08048752 <+138>:	call   0x8048500 <puts@plt>				; puts("Give me some shellcode, k")
   0x08048757 <+143>:	lea    0x20(%esp),%eax					; eax = buf
   0x0804875b <+147>:	mov    %eax,(%esp)						; *esp = buf
   0x0804875e <+150>:	call   0x80484b0 <gets@plt>				; gets(buf)
   0x08048763 <+155>:	jmp    0x804881a <main+338>				; jump to 338
   0x08048768 <+160>:	nop										; no operation
   0x08048769 <+161>:	lea    0x1c(%esp),%eax					; eax = var4
   0x0804876d <+165>:	mov    %eax,(%esp)						; *esp = var4
   0x08048770 <+168>:	call   0x80484f0 <wait@plt>				; wait(var4)
   0x08048775 <+173>:	mov    0x1c(%esp),%eax					; eax = var4
   0x08048779 <+177>:	mov    %eax,0xa0(%esp)					; esp+160 = var4
   0x08048780 <+184>:	mov    0xa0(%esp),%eax					; eax = var4
   0x08048787 <+191>:	and    $0x7f,%eax						; var4 AND 127
   0x0804878a <+194>:	test   %eax,%eax						; test if = 0
   0x0804878c <+196>:	je     0x80487ac <main+228>				; if equal, jump to 228
   0x0804878e <+198>:	mov    0x1c(%esp),%eax					; eax = var4
   0x08048792 <+202>:	mov    %eax,0xa4(%esp)					; esp+164 = var4
   0x08048799 <+209>:	mov    0xa4(%esp),%eax					; eax = var4
   0x080487a0 <+216>:	and    $0x7f,%eax						; var4 AND 127
   0x080487a3 <+219>:	add    $0x1,%eax						; var4 + 1
   0x080487a6 <+222>:	sar    %al								; shift al by 1 bit // Shift Arithmetic Right
   0x080487a8 <+224>:	test   %al,%al							; test if = 0
   0x080487aa <+226>:	jle    0x80487ba <main+242>				; if less or equal, jump to 242
   0x080487ac <+228>:	movl   $0x804891d,(%esp)				; "child is exiting..."
   0x080487b3 <+235>:	call   0x8048500 <puts@plt>				; puts("child is exiting...")
   0x080487b8 <+240>:	jmp    0x804881a <main+338>				; jump to 338
   0x080487ba <+242>:	movl   $0x0,0xc(%esp)					; esp+12 = 0
   0x080487c2 <+250>:	movl   $0x2c,0x8(%esp)					; esp+8 = 44
   0x080487ca <+258>:	mov    0xac(%esp),%eax					; eax = var1
   0x080487d1 <+265>:	mov    %eax,0x4(%esp)					; esp+4 = var1
   0x080487d5 <+269>:	movl   $0x3,(%esp)						; esp = 3
   0x080487dc <+276>:	call   0x8048570 <ptrace@plt>			; ptrace(3, var1, 44, 0)
   0x080487e1 <+281>:	mov    %eax,0xa8(%esp)					; var3 = return value of ptrace
   0x080487e8 <+288>:	cmpl   $0xb,0xa8(%esp)					; compare var3 to 11
   0x080487f0 <+296>:	jne    0x8048768 <main+160>				; if not equal, jump to 160
   0x080487f6 <+302>:	movl   $0x8048931,(%esp)				; "no exec() for you"
   0x080487fd <+309>:	call   0x8048500 <puts@plt>				; puts("no exec() for you")
   0x08048802 <+314>:	movl   $0x9,0x4(%esp)					; esp+4 = 9
   0x0804880a <+322>:	mov    0xac(%esp),%eax					; eax = var1
   0x08048811 <+329>:	mov    %eax,(%esp)						; *esp = var1
   0x08048814 <+332>:	call   0x8048520 <kill@plt>				; kill(var1, 9)
   0x08048819 <+337>:	nop
   0x0804881a <+338>:	mov    $0x0,%eax
   0x0804881f <+343>:	lea    -0x8(%ebp),%esp
   0x08048822 <+346>:	pop    %ebx
   0x08048823 <+347>:	pop    %edi
   0x08048824 <+348>:	pop    %ebp
   0x08048825 <+349>:	ret    
End of assembler dump.
