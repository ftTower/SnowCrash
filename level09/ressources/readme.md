# LEVEL09 - Final Boss

```shell
level09@SnowCrash:~$ ls -la
-rwsr-sr-x 1 flag09  level09 7640 Mar  5  2016 level09
----r--r-- 1 flag09  level09   26 Mar  5  2016 token
```

## Observation

```shell
$ ./level09
You need to provied only one arg.

level09@SnowCrash:~$ ./level09 
You need to provied only one arg.

level09@SnowCrash:~$ ./level09 coucou
cpwfsz

level09@SnowCrash:~$ ./level09 blabla
bmcepf

level09@SnowCrash:~$ ./level09 AAA
ABC

level09@SnowCrash:~$ ./level09 AAAAAAAAA
ABCDEFGHI

level09@SnowCrash:~$ ./level09 1
1

level09@SnowCrash:~$ ./level09 11
12

level09@SnowCrash:~$ ./level09 111
123

level09@SnowCrash:~$ ./level09 1111
1234

level09@SnowCrash:~$ ./level09 11111
12345
```

```shell
level09@SnowCrash:~$ cat token
f4kmm6p|=�p�n��DB�Du{��

level09@SnowCrash:~$ ./level09 `cat token`
f5mpq;vE{{TSW
```

### What is going on 

```shell
level09@SnowCrash:~$ ./level09 1
1
level09@SnowCrash:~$ ./level09 11
12
level09@SnowCrash:~$ ./level09 111
123
```

This sequence is pretty clear : `(character + index) % 255`

So we have to do the opposite with the token to be decrypt.

`(character - index) % 255`

## Exploitation

```py
#!/usr/bin/env python
import sys

buf = sys.stdin.buffer.read()
buf = buf.strip(b'\n')

for i, b in enumerate(buf):
    b = b - i
    if b < 0:
        b = 255 + b
    sys.stdout.buffer.write(b.to_bytes())
print()
```

### Goes into a new tab onto your kali.

before we saw that token was full of unprintable char. to pass them into the script on kali we **HAVE** to `scp` here.

```shell
scp -P 4242 level09@10.0.2.3:/home/user/level09/token .
```

```shell
┌──(kali㉿kali)-[~]
└─$ chmod +x script.py
                                                                                                                    
┌──(kali㉿kali)-[~]
└─$ ./script.py <token
f3iji1ju5yuevaus41q1afiuq
```

```shell
level09@SnowCrash:~$ su -c getflag flag09
Password: 
Check flag.Here is your token : s5cAJpM8ev6XHw998pRWG728z
```