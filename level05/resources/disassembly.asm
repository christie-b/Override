Dump of assembler code for function main:
   0x08048444 <+0>:	push   %ebp
   0x08048445 <+1>:	mov    %esp,%ebp
   0x08048447 <+3>:	push   %edi
   0x08048448 <+4>:	push   %ebx
   0x08048449 <+5>:	and    $0xfffffff0,%esp
   0x0804844c <+8>:	sub    $0x90,%esp						; allocates 144 bytes for variables
   0x08048452 <+14>:	movl   $0x0,0x8c(%esp)				; esp+140 = 0 // var1
   0x0804845d <+25>:	mov    0x80497f0,%eax				; eax = stdin
   0x08048462 <+30>:	mov    %eax,0x8(%esp)				; esp+8 = stdin
   0x08048466 <+34>:	movl   $0x64,0x4(%esp)				; esp+4 = 100
   0x0804846e <+42>:	lea    0x28(%esp),%eax				; eax = esp+40 // buf?
   0x08048472 <+46>:	mov    %eax,(%esp)					; esp = *esp+40
   0x08048475 <+49>:	call   0x8048350 <fgets@plt>		; fgets(buf, 100, stdin)
   0x0804847a <+54>:	movl   $0x0,0x8c(%esp)				; var1 = 0
   0x08048485 <+65>:	jmp    0x80484d3 <main+143>			; jump to 143
   0x08048487 <+67>:	lea    0x28(%esp),%eax				; eax = buf
   0x0804848b <+71>:	add    0x8c(%esp),%eax				; buf = buf + var1
   0x08048492 <+78>:	movzbl (%eax),%eax
   0x08048495 <+81>:	cmp    $0x40,%al					; compares al to 64
   0x08048497 <+83>:	jle    0x80484cb <main+135>			; if less or equal, jump to 135
   0x08048499 <+85>:	lea    0x28(%esp),%eax				; eax = buf
   0x0804849d <+89>:	add    0x8c(%esp),%eax				; buf = buf + var1
   0x080484a4 <+96>:	movzbl (%eax),%eax
   0x080484a7 <+99>:	cmp    $0x5a,%al					; compares al to 90
   0x080484a9 <+101>:	jg     0x80484cb <main+135>			; if greater, jump to 135
   0x080484ab <+103>:	lea    0x28(%esp),%eax				; eax = buf
   0x080484af <+107>:	add    0x8c(%esp),%eax				; buf = buf + var1
   0x080484b6 <+114>:	movzbl (%eax),%eax
   0x080484b9 <+117>:	mov    %eax,%edx					; edx = buf
   0x080484bb <+119>:	xor    $0x20,%edx					; xor buf ^ 32
   0x080484be <+122>:	lea    0x28(%esp),%eax				; eax = buf
   0x080484c2 <+126>:	add    0x8c(%esp),%eax				; buf = buf + var1
   0x080484c9 <+133>:	mov    %dl,(%eax)					; eax = dl (lower 8 bits of DX = result of xor operation)
   0x080484cb <+135>:	addl   $0x1,0x8c(%esp)				; var1 + 1
   0x080484d3 <+143>:	mov    0x8c(%esp),%ebx				; ebx = var1
   0x080484da <+150>:	lea    0x28(%esp),%eax				; eax = buf
   0x080484de <+154>:	movl   $0xffffffff,0x1c(%esp)		; esp+28 = -1
   0x080484e6 <+162>:	mov    %eax,%edx					; edx = buf
   0x080484e8 <+164>:	mov    $0x0,%eax					; eax = 0
   0x080484ed <+169>:	mov    0x1c(%esp),%ecx				; ecx = esp+28 = -1
   0x080484f1 <+173>:	mov    %edx,%edi					; edi = edx = buf
   0x080484f3 <+175>:	repnz scas %es:(%edi),%al			; equivalent to strlen(buf)
   0x080484f5 <+177>:	mov    %ecx,%eax					; eax = ecx (counter)
   0x080484f7 <+179>:	not    %eax							; reverse the bits in eax (counter)
   0x080484f9 <+181>:	sub    $0x1,%eax					; eax -= 1
   0x080484fc <+184>:	cmp    %eax,%ebx					; compares var1 with counter-1
   0x080484fe <+186>:	jb     0x8048487 <main+67>			; if below, jump to 67
   0x08048500 <+188>:	lea    0x28(%esp),%eax				; eax = buf
   0x08048504 <+192>:	mov    %eax,(%esp)					; esp = buf
   0x08048507 <+195>:	call   0x8048340 <printf@plt>		; printf(buf)
   0x0804850c <+200>:	movl   $0x0,(%esp)
   0x08048513 <+207>:	call   0x8048370 <exit@plt>			; exit(0)
End of assembler dump.
