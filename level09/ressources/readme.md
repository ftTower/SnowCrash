# LEVEL09 - Final Boss

```shell
$ ls -la
-rwsr-sr-x 1 flag09  level09 7640 Mar  5  2016 level09
----r--r-- 1 flag09  level09   26 Mar  5  2016 token
```

```shell
$ ./level09
You need to provied only one arg.

$ ./level09 coucou
cpwfsz

$ ./level09 blabla
bmcepf
```

```shell
$ cat token
f4kmm6p|=�p�n��DB�Du{��
```

```shell
$ ./level09 $(cat token)
f5mpq;v�E��{�{��TS�W�����
```

```shell
$ scp -P 4242 level09@192.168.1.27:/home/user/level09/token .
```

```shell
$ ./level09 1
1

$ ./level09 11
12

$ ./level09 111
123

$ ./level09 1111
1234

$ ./level09 11111
12345
```

```py
#! /usr/bin/python3

import sys

# on encode la chaine reçue en parametre en utf-8 et errors="surrogateescape" pour eviter les erreurs d'encodage de python "codec can't encode character '\udc82' in position 9: surrogates not allowed"
for i, c in enumerate(sys.argv[1].encode("utf-8", errors="surrogateescape")):
	# end='' supprime le \n a la fin du print
	print(chr(c - i), end='')
print()
```

```shell
$ ./script.py $(cat token)
XXXXXXXXXXXXXXXXXXXXXXX
```