# Summary

## level00

The password is easily identifiable in the binary.

## level01

Buffer overflow of the password input (shellcode injection at 2nd fgets).

## level02

Print the stack to see the password
or
printf exploit to replace puts by the address of greetings

## level03

xor on string to get Congratulations

## level04

ret2libc at offset

## level05

printf exploit -> inject shellcode from env into return address of printf (arithmetic)

## level06

change EIP when calling ptrace to check serial

## level07

ret2libc << 2 (index 114)%3

## level08

symbolic link

## level09

change len + message BOF to write secret_backdoor() address

## Tips

- Use `gdb -batch -ex "disas main" <file>` to disassemble in the stdout
