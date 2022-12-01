# Walkthrough

## Solution

```
322424845 - 18 = 322424827
--> enter 322424827 as password
```

```
n=322424824; while [ "$n" -lt 322424845 ]; do (python -c "print $n"; cat) | ./level03; n=$(($n+1)); done
```

## Explanation

<!-- To call the decrypt function, the result of the operation password - 322424845 had to be less than 22, for it would allow a jump to a call to a decrypt with the password as a value. -->

The program takes an int as a password, which gets substracted from 322424845.  
The result of the substraction has to be < 22.
var1 = "Q}|u`sfg~sf{}|a3"
The decrypt function is doing a XOR on each character of the var1, and the result of the substraction.

`xor` will compare the 2nd arg bit by bit.  
If one of the bit is 1, the result will be 1.  
If both are 0 or 1, the result will be 0.  

example :  

```
1st arg = 0001
2nd arg = 0010
1st arg ^(xor) 2nd arg =
    	  0011 -->  3
```

Decrypt compares var1 to "Congratulations":  
```
   0x080486fc <+156>:	mov    %edx,%esi                 ; esi = var1 = "Q}|u`sfg~sf{}|a3"
   0x080486fe <+158>:	mov    %eax,%edi                 ; edi = "Congratulations!"
   0x08048700 <+160>:	repz cmpsb %es:(%edi),%ds:(%esi) ; compare esi to edi
```  
so "Q}|u`sfg~sf{}|a3" has to be equal to Congratulations after doing a XOR on it, in order to launch a shell.  

```
Q   == 01010001
key == ????????
C   == 01000011

Let's find the key, in order to get the C in binary after executing a XOR on Q:  
Q   == 01010001
key == 00010010 --> 18
C   == 01000011

Let's try with the second letter to see if the key is the same:

}   == 01111101
key == ????????
o   == 01101111

}   == 01111101
key == 00010010 --> 18
o   == 01101111
```  

--> The xor key is ^18

-> We need to have : 322424845 - X = 18  
--> X = 322424845 - 18 = 322424827

<!-- Using a simple loop, we easily find the value 322424827 as the password. -->


### Execution

```
level03@OverRide:~$ ./level03
***********************************
*		level03		**
***********************************
Password:hello

Invalid Password
```

### Disassembly

```
info var
0x0804a030  data_start

info function
0x080485f4  clear_stdin
0x08048617  get_unum
0x0804864f  prog_timeout
0x08048660  decrypt
0x08048747  test
0x0804885a  main
```

You can view the commented asm code [here](resources/disassembly.asm)  
You can view the asm code translated to C [here](source.c)
