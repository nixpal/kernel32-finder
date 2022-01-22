
## **** Shellcoding 101 ****
## This page I'm presenting two new methods to find kernel32 base address.
#### All rights reserved to the author of this article.
#### Author : Tarek Ahmed


## Method 1: Crack the Stack

In this method a return address of one of the kernel32 api calls will be retrieved from the stack and then the address will be validated.

#### Validation steps:

1- Check if address starts with 0x7.

2- Check if the address is a valid memory address with the help of custom exception handler function.

3- Zero out the last 2-bytes of the address example 0x79560000

4- Subtract 0x10000 from the address to get the base.

5- Check if the first type bytes the address is pointing at starts with "MZ" meaning a DLL file.

6- Walk the PE structure of the file to check if it's a kernel32.




## Method 2: Memory Sieve

#### - Use first assembly code if you are going to use it as a shellcode in a C program.
#### - Use second assembly code if you want to use it in an assembly .asm code

### How it's found ? 

Step 1: The .text section of the program will be parsed until an instruction " call dword ptr[]" is found.
 
Step 2: Once the instruction is found, the pointer will be derefrenced and the address it's pointing to will be verified if it starts with 0x7 or not.
 
Step 3: If it starts with the 0x7, the same process from the previous method will be used to verify if the DLL file is kernel32. Most likely it will be.


