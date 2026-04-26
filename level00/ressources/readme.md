# LEVEL 00 - Caesar ROT13

```shell
ssh level00@IP_ADDRESS -p 4242
```

lets do a quick recon to know where we are :

```shell
level00@SnowCrash:~$ ls -la
total 12
dr-xr-x---+ 1 level00 level00  100 Mar  5  2016 .
d--x--x--x  1 root    users    340 Aug 30  2015 ..
-r-xr-x---+ 1 level00 level00  220 Apr  3  2012 .bash_logout
-r-xr-x---+ 1 level00 level00 3518 Aug 30  2015 .bashrc
-r-xr-x---+ 1 level00 level00  675 Apr  3  2012 .profile
```

```shell
level00@SnowCrash:~$ pwd
/home/user/level00
```

```shell
level00@SnowCrash:~$ id
uid=2000(level00) gid=2000(level00) groups=2000(level00),100(users)
```

```shell
level00@SnowCrash:~$ find / -user level00 2>/dev/null # Looking for files owned by level00
/dev/pts/0
/proc/1884
/proc/1884/task
/proc/1884/task/1884
/proc/1884/task/1884/attr
/proc/1884/net
/proc/1884/attr
/proc/1885
/proc/1885/task
/proc/1885/task/1885
/proc/1885/task/1885/fd
/proc/1885/task/1885/fd/0
/proc/1885/task/1885/fd/1
/proc/1885/task/1885/fd/2
/proc/1885/task/1885/fd/255
/proc/1885/task/1885/fdinfo
/proc/1885/task/1885/fdinfo/0
/proc/1885/task/1885/fdinfo/1
/proc/1885/task/1885/fdinfo/2
/proc/1885/task/1885/fdinfo/255
/proc/1885/task/1885/ns
/proc/1885/task/1885/ns/net
/proc/1885/task/1885/ns/uts
/proc/1885/task/1885/ns/ipc
/proc/1885/task/1885/environ
/proc/1885/task/1885/auxv
/proc/1885/task/1885/status
...<SNIP>...
```

```shell
level00@SnowCrash:~$ cut -d: -f1 /etc/passwd # Looking for all users
root
daemon
bin
sys
sync
games
man
lp
mail
news
uucp
proxy
www-data
backup
list
irc
gnats
nobody
libuuid
syslog
messagebus
whoopsie
landscape
sshd
level00
level01
level02
level03
level04
level05
level06
level07
level08
level09
level10
level11
level12
level13
level14
flag00
flag01
flag02
flag03
flag04
flag05
flag06
flag07
flag08
flag09
flag10
flag11
flag12
flag13
flag14
```

as we can see there is a user for every levels and flags.

```shell
level00@SnowCrash:~$ find / -user flag00 2>/dev/null # looking for files owned by flag00
/usr/sbin/john
/rofs/usr/sbin/john
```

Lets `cat` them : 

```bash
level00@SnowCrash:~$ cat /usr/sbin/john && echo && cat /rofs/usr/sbin/john 
cdiiddwpgswtgt

cdiiddwpgswtgt
```

Those are encrypted strings.

Lets think about them :
-  no `==` at the end not base64
-  too short to be big algorithm md5 etc
-  repeating characters

Lets go to CyberChef to decrypt this :

> I tried using the `magic` feature of [cyberchef](https://gchq.github.io/CyberChef/), but it output no logical output

After a few try of encoding/decoding, i got a human readable string with the [CyberChef Rot13 Bruteforce](https://gchq.github.io/CyberChef/#recipe=ROT13_Brute_Force(true,true,false,100,0,true,'')&input=Y2RpaWRkd3Bnc3d0Z3Q&oenc=65001).

```shell
Amount =  1: dejjeexqhtxuhu
Amount =  2: efkkffyriuyviv
Amount =  3: fgllggzsjvzwjw
Amount =  4: ghmmhhatkwaxkx
Amount =  5: hinniibulxbyly
Amount =  6: ijoojjcvmyczmz
Amount =  7: jkppkkdwnzdana
Amount =  8: klqqllexoaebob
Amount =  9: lmrrmmfypbfcpc
Amount = 10: mnssnngzqcgdqd
Amount = 11: nottoohardhere #flag00
Amount = 12: opuuppibseifsf
Amount = 13: pqvvqqjctfjgtg
Amount = 14: qrwwrrkdugkhuh
Amount = 15: rsxxsslevhlivi
Amount = 16: styyttmfwimjwj
Amount = 17: tuzzuungxjnkxk
Amount = 18: uvaavvohykolyl
Amount = 19: vwbbwwpizlpmzm
Amount = 20: wxccxxqjamqnan
Amount = 21: xyddyyrkbnrobo
Amount = 22: yzeezzslcospcp
Amount = 23: zaffaatmdptqdq
Amount = 24: abggbbunequrer
Amount = 25: bchhccvofrvsfs
```

### Flag : `nottoohardhere`

Here is how to validate the flag to go on next level.

```shell
level00@SnowCrash:~$ su flag00
Password: nottoohardhere 
Don't forget to launch getflag !
flag00@SnowCrash:~$ getflag
Check flag.Here is your token : x24ti5gi3x0ol2eh4esiuxias
```