# LEVEL 02 - WireShark my beloved

```shell
level02@SnowCrash:~$ ls -la
total 24
dr-x------ 1 level02 level02  120 Mar  5  2016 .
d--x--x--x 1 root    users    340 Aug 30  2015 ..
-r-x------ 1 level02 level02  220 Apr  3  2012 .bash_logout
-r-x------ 1 level02 level02 3518 Aug 30  2015 .bashrc
----r--r-- 1 flag02  level02 8302 Aug 30  2015 level02.pcap # Interesting file
-r-x------ 1 level02 level02  675 Apr  3  2012 .profile
```

> A PCAP (Packet Capture) file is a data file used to store network traffic captured during packet sniffing. It records the raw data packets traveling across a network, allowing IT and security teams to analyze network behavior, troubleshoot issues, and detect security threats.

We need to open it with wireshark, so we download the pcap file on our kali vm.

```shell
scp -P 4242 level02@10.0.2.3:/home/user/level02/level02.pcap .
```

you will need to enter the precedent password obtained : `f2av5il02puano7naaf6adaaf`

Once you obtain your pcap file open it with wireshark like this (dont forget sudo).
```shell
┌──(kali㉿kali)-[~/Documents]
└─$ sudo wireshark level02.pcap
```

To look what been transmited during this session go to : `Analyze > Follow > TCP Stream` / `CTRL+ALT+SHIFT+T`

![follow tcp Stream](https://github.com/ftTower/ftTower/blob/main/assets/Snowcrash/level02/wireshark_tcp.png)

![TCP Follow](https://github.com/ftTower/ftTower/blob/main/assets/Snowcrash/level02/tcp_follow.png)

```
..
Password: 
ft_wandr...NDRel.L0L
```

we can try to understand what been typed into this network connection.

Highliting the `f char` we can see wireshark shows us the request concerned for this char.

Look for `PSH` requests as they contain the DATA, PSH mean PUSH.

![wireshark analyse](https://github.com/ftTower/ftTower/blob/main/assets/Snowcrash/level02/wireshark_analyse.png)


As we can see on the Hex row on ASCII table that `66` is the `f` char like we search for.

![wireshark analyse](https://upload.wikimedia.org/wikipedia/commons/1/1b/ASCII-Table-wide.svg)


If we are doing this on the point : `.` is `7f` which in the ascii table is `DEL`.

To interpret this the user was typing : ft_wandr and `DEL` 3 times and continued typing. (same for the last . in string)

We get the string `ft_waNDReL0L` out of `ft_wandr...NDRel.L0L`

```shell
level02@SnowCrash:~$ su flag02
Password: ft_waNDReL0L
Don't forget to launch getflag !
flag02@SnowCrash:~$ getflag
Check flag.Here is your token : kooda2puivaav1idi4f57q8iq
```
