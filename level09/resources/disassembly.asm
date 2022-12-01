(gdb) disas main
Dump of assembler code for function main:
   0x0000000000000aa8 <+0>:	push   %rbp
   0x0000000000000aa9 <+1>:	mov    %rsp,%rbp
   0x0000000000000aac <+4>:	lea    0x15d(%rip),%rdi        # 0xc10	; '-' <repeats 44 times>, "\n|   ~Welcome to l33t-m$n ~    v1337        |\n", '-' <repeats 44 times>
   0x0000000000000ab3 <+11>:	callq  0x730 <puts@plt>
   0x0000000000000ab8 <+16>:	callq  0x8c0 <handle_msg>			; handle_msg()
   0x0000000000000abd <+21>:	mov    $0x0,%eax
   0x0000000000000ac2 <+26>:	pop    %rbp
   0x0000000000000ac3 <+27>:	retq   
End of assembler dump.

(gdb) disas handle_msg 
Dump of assembler code for function handle_msg:
   0x00000000000008c0 <+0>:	push   %rbp
   0x00000000000008c1 <+1>:	mov    %rsp,%rbp
   0x00000000000008c4 <+4>:	sub    $0xc0,%rsp				; allocates 192 bytes for variables
   0x00000000000008cb <+11>:	lea    -0xc0(%rbp),%rax						; rax = rbp-192 // struct
   0x00000000000008d2 <+18>:	add    $0x8c,%rax							; rax += 140 // struct+140 = username
   0x00000000000008d8 <+24>:	movq   $0x0,(%rax)							; rax = 0
   0x00000000000008df <+31>:	movq   $0x0,0x8(%rax)						; rax+8 = 0
   0x00000000000008e7 <+39>:	movq   $0x0,0x10(%rax)						; rax+16 = 0
   0x00000000000008ef <+47>:	movq   $0x0,0x18(%rax)						; rax+24 = 0
   0x00000000000008f7 <+55>:	movq   $0x0,0x20(%rax)						; rax+32 = 0 // set the 5 * 8 bytes of the username to 0
   0x00000000000008ff <+63>:	movl   $0x8c,-0xc(%rbp)						; rbp-12 = 140
   0x0000000000000906 <+70>:	lea    -0xc0(%rbp),%rax						; rax = var1
   0x000000000000090d <+77>:	mov    %rax,%rdi							; rdi = var1
   0x0000000000000910 <+80>:	callq  0x9cd <set_username>					; set_username(var1)
   0x0000000000000915 <+85>:	lea    -0xc0(%rbp),%rax						; rax = var1
   0x000000000000091c <+92>:	mov    %rax,%rdi							; rdi = var1
   0x000000000000091f <+95>:	callq  0x932 <set_msg>						; set_msg(var1)
   0x0000000000000924 <+100>:	lea    0x295(%rip),%rdi        # 0xbc0		; ">: Msg sent!"
   0x000000000000092b <+107>:	callq  0x730 <puts@plt>
   0x0000000000000930 <+112>:	leaveq 
   0x0000000000000931 <+113>:	retq   
End of assembler dump.

(gdb) disas set_username 
Dump of assembler code for function set_username:
   0x00000000000009cd <+0>:	push   %rbp
   0x00000000000009ce <+1>:	mov    %rsp,%rbp
   0x00000000000009d1 <+4>:	sub    $0xa0,%rsp					   ; allocates 160 bytes for variables
   0x00000000000009d8 <+11>:	mov    %rdi,-0x98(%rbp)			   ; rbp-152 = rdi (param)
   0x00000000000009df <+18>:	lea    -0x90(%rbp),%rax			   ; rax = rbp-144 // var1
   0x00000000000009e6 <+25>:	mov    %rax,%rsi					   ; rsi = var1
   0x00000000000009e9 <+28>:	mov    $0x0,%eax					   ; eax = 0
   0x00000000000009ee <+33>:	mov    $0x10,%edx					   ; edx = 16
   0x00000000000009f3 <+38>:	mov    %rsi,%rdi					   ; rdi = var1
   0x00000000000009f6 <+41>:	mov    %rdx,%rcx					   ; rcx = 16
   0x00000000000009f9 <+44>:	rep stos %rax,%es:(%rdi)		   ; memset(var1, 0, 16)
   0x00000000000009fc <+47>:	lea    0x1e1(%rip),%rdi           # 0xbe4		; ">: Enter your username"
   0x0000000000000a03 <+54>:	callq  0x730 <puts@plt>			   ; puts(">: Enter your username")
   0x0000000000000a08 <+59>:	lea    0x1d0(%rip),%rax           # 0xbdf		; ">>: "
   0x0000000000000a0f <+66>:	mov    %rax,%rdi					   ; rdi = ">>: "
   0x0000000000000a12 <+69>:	mov    $0x0,%eax					   ; eax = 0
   0x0000000000000a17 <+74>:	callq  0x750 <printf@plt>		   ; printf(">>: ")
   0x0000000000000a1c <+79>:	mov    0x201595(%rip),%rax        # 0x201fb8	; 0 -> stdin
   0x0000000000000a23 <+86>:	mov    (%rax),%rax   
   0x0000000000000a26 <+89>:	mov    %rax,%rdx					   ; rdx = stdin
   0x0000000000000a29 <+92>:	lea    -0x90(%rbp),%rax			   ; rax = var1
   0x0000000000000a30 <+99>:	mov    $0x80,%esi					   ; esi = 128
   0x0000000000000a35 <+104>:	mov    %rax,%rdi					   ; rdi = var1
   0x0000000000000a38 <+107>:	callq  0x770 <fgets@plt>			; fgets(var1, 128, stdin)
   0x0000000000000a3d <+112>:	movl   $0x0,-0x4(%rbp)				; rbp-4 = 0 // var2
   0x0000000000000a44 <+119>:	jmp    0xa6a <set_username+157>	; jump to 157
   0x0000000000000a46 <+121>:	mov    -0x4(%rbp),%eax				; eax = var2
   0x0000000000000a49 <+124>:	cltq   									; Convert Long To Quad : 4 -> 8 bytes
   0x0000000000000a4b <+126>:	movzbl -0x90(%rbp,%rax,1),%ecx	; ecx = var1 + rax*1 = var1[var2]
   0x0000000000000a53 <+134>:	mov    -0x98(%rbp),%rdx				; rdx = param
   0x0000000000000a5a <+141>:	mov    -0x4(%rbp),%eax				; eax = var2
   0x0000000000000a5d <+144>:	cltq   									; Convert Long To Quad
   0x0000000000000a5f <+146>:	mov    %cl,0x8c(%rdx,%rax,1)		; param+140 + rax*1 = cl
   0x0000000000000a66 <+153>:	addl   $0x1,-0x4(%rbp)				; var2 += 1
   0x0000000000000a6a <+157>:	cmpl   $0x28,-0x4(%rbp)				; compare var2 to 40
   0x0000000000000a6e <+161>:	jg     0xa81 <set_username+180>	; if >, jump to 180
   0x0000000000000a70 <+163>:	mov    -0x4(%rbp),%eax				; eax = var2
   0x0000000000000a73 <+166>:	cltq   									; Convert Long To Quad
   0x0000000000000a75 <+168>:	movzbl -0x90(%rbp,%rax,1),%eax	; ecx = var1 + rax*1 = var1[var2]
   0x0000000000000a7d <+176>:	test   %al,%al
   0x0000000000000a7f <+178>:	jne    0xa46 <set_username+121>	; if not =, jump to 121
   0x0000000000000a81 <+180>:	mov    -0x98(%rbp),%rax				; rax = param
   0x0000000000000a88 <+187>:	lea    0x8c(%rax),%rdx				; rdx = param+140
   0x0000000000000a8f <+194>:	lea    0x165(%rip),%rax        # 0xbfb		; ">: Welcome, %s"
   0x0000000000000a96 <+201>:	mov    %rdx,%rsi						; rsi = param+140
   0x0000000000000a99 <+204>:	mov    %rax,%rdi						; rdi = ">: Welcome, %s"
   0x0000000000000a9c <+207>:	mov    $0x0,%eax						; eax = 0
   0x0000000000000aa1 <+212>:	callq  0x750 <printf@plt>			; printf(">: Welcome, %s", param+140)
   0x0000000000000aa6 <+217>:	leaveq 
   0x0000000000000aa7 <+218>:	retq   
End of assembler dump.

(gdb) disas set_msg 
Dump of assembler code for function set_msg:
   0x0000000000000932 <+0>:	push   %rbp
   0x0000000000000933 <+1>:	mov    %rsp,%rbp
   0x0000000000000936 <+4>:	sub    $0x410,%rsp								; allocates 1040 bytes for variables
   0x000000000000093d <+11>:	mov    %rdi,-0x408(%rbp)					; rbp-1032 = rdi (param)
   0x0000000000000944 <+18>:	lea    -0x400(%rbp),%rax					; rax = rbp-1024 // var1
   0x000000000000094b <+25>:	mov    %rax,%rsi							; rsi = var1
   0x000000000000094e <+28>:	mov    $0x0,%eax							; eax = 0
   0x0000000000000953 <+33>:	mov    $0x80,%edx							; edx = 128
   0x0000000000000958 <+38>:	mov    %rsi,%rdi							; rdi = var1
   0x000000000000095b <+41>:	mov    %rdx,%rcx							; rcx = 128 * 8 = 1024
   0x000000000000095e <+44>:	rep stos %rax,%es:(%rdi)					; memset(var1, 0, 1024)
   0x0000000000000961 <+47>:	lea    0x265(%rip),%rdi        # 0xbcd		; ">: Msg @Unix-Dude"
   0x0000000000000968 <+54>:	callq  0x730 <puts@plt>						; puts(">: Msg @Unix-Dude")
   0x000000000000096d <+59>:	lea    0x26b(%rip),%rax        # 0xbdf		; ">>: "
   0x0000000000000974 <+66>:	mov    %rax,%rdi							; rdi = ">>: "
   0x0000000000000977 <+69>:	mov    $0x0,%eax							; eax = 0
   0x000000000000097c <+74>:	callq  0x750 <printf@plt>					; printf(">>: ")
   0x0000000000000981 <+79>:	mov    0x201630(%rip),%rax        # 0x201fb8	; 0 // stdin
   0x0000000000000988 <+86>:	mov    (%rax),%rax
   0x000000000000098b <+89>:	mov    %rax,%rdx							; rdx = stdin
   0x000000000000098e <+92>:	lea    -0x400(%rbp),%rax					; rax = var1
   0x0000000000000995 <+99>:	mov    $0x400,%esi							; esi = 1024
   0x000000000000099a <+104>:	mov    %rax,%rdi							; rdi = var1
   0x000000000000099d <+107>:	callq  0x770 <fgets@plt>					; fgets(var1, 1024, stdin)
   0x00000000000009a2 <+112>:	mov    -0x408(%rbp),%rax					; rax = param
   0x00000000000009a9 <+119>:	mov    0xb4(%rax),%eax						; eax = param+180
   0x00000000000009af <+125>:	movslq %eax,%rdx							; move and sign-extend a value from a 32-bit source to a 64-bit destination
   0x00000000000009b2 <+128>:	lea    -0x400(%rbp),%rcx					; rcx = var1
   0x00000000000009b9 <+135>:	mov    -0x408(%rbp),%rax					; rax = param
   0x00000000000009c0 <+142>:	mov    %rcx,%rsi							; rsi = var1
   0x00000000000009c3 <+145>:	mov    %rax,%rdi							; rdi = param
   0x00000000000009c6 <+148>:	callq  0x720 <strncpy@plt>					; strncpy(param, var1, param+180)
   0x00000000000009cb <+153>:	leaveq 
   0x00000000000009cc <+154>:	retq   
End of assembler dump.



(gdb) disas secret_backdoor 
Dump of assembler code for function secret_backdoor:
   0x000000000000088c <+0>:	push   %rbp
   0x000000000000088d <+1>:	mov    %rsp,%rbp
   0x0000000000000890 <+4>:	add    $0xffffffffffffff80,%rsp
   0x0000000000000894 <+8>:	mov    0x20171d(%rip),%rax        # 0x201fb8	; 0 = stdin
   0x000000000000089b <+15>:	mov    (%rax),%rax
   0x000000000000089e <+18>:	mov    %rax,%rdx
   0x00000000000008a1 <+21>:	lea    -0x80(%rbp),%rax						; rax = rbp-128 // buf
   0x00000000000008a5 <+25>:	mov    $0x80,%esi							; esi = 128
   0x00000000000008aa <+30>:	mov    %rax,%rdi							; rdi = buf
   0x00000000000008ad <+33>:	callq  0x770 <fgets@plt>					; fgets(buf, 128, stdin)
   0x00000000000008b2 <+38>:	lea    -0x80(%rbp),%rax						; rax = buf
   0x00000000000008b6 <+42>:	mov    %rax,%rdi							; rdi = buf
   0x00000000000008b9 <+45>:	callq  0x740 <system@plt>					; system(buf)
   0x00000000000008be <+50>:	leaveq 
   0x00000000000008bf <+51>:	retq   
End of assembler dump.
