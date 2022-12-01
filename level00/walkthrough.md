# Walkthrough

## Solution
```
(python -c "print '5276'"; cat) | ./level00
```  

## Explanation

### Execution

```
level00@OverRide:~$ ./level00 
***********************************
* 	     -Level00 -		  *
***********************************
Password:hello

Invalid Password!
```  
-> The program asks for a password

### Disassembly

You can view the commented asm code [here](resources/disassembly.asm)  
You can view the asm code translated to C [here](source.c)  

### Steps

The program launches a shell if the password = 0x149c (= 5276)