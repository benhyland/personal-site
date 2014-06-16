---
title: Command Line Tools
summary: Quick descriptions of program I use often during my normal work, and also some network focused tools I encountered for the first time when working on rotation with our Information Services team.
---

# Filesystem

### [ls](http://man7.org/linux/man-pages/man1/ls.1.html)
`-s` shows allocated blocks\
`-a` shows all, `-A` shows all except . and ..\
`-l` shows long detail\
`-h` shows human readable sizes\
`-1` ouputs one directory entry per line\
`-d` stats a directory rather than its contents

### [mv](http://man7.org/linux/man-pages/man1/mv.1.html)
Sometimes thought of as being an atomic `cp`/`rm` but isn't really.
Within a single filesystem, `mv` is generally a call to `rename()`, which is atomic.
It removes an i-node reference from the directory block of the source and adds it to that of the target.

### [chmod](http://man7.org/linux/man-pages/man1/chmod.1.html)
Change mode of files and directories. Mode consists of **r**ead, **w**rite, e**x**ecute/search, **s**et uid/gid, s**t**icky, and is set for **u**ser, **g**roup, **o**ther and **a**ll.
Multiple clauses can be used in a single invocation e.g.

	chmod a+r,go-wx foo

### [chown](http://man7.org/linux/man-pages/man1/chown.1.html)
	chown bhyland:wheel foo

`-R` for recursive\
`--from=owner:group` to filter on current owner/group
	
### [ln](http://man7.org/linux/man-pages/man1/ln.1.html)
Create hard links or symbolic links. A hard link is just another directory entry to an existing i-node. A symbolic link is a special file that links indirectly to the target i-node. It can link across filesystems and to directories as well as files. A symbolic link is not included in the link count of the target, and can point to targets that don't exist.
	
	ln target link

`-s` for a symbolic link\
`-f` to attempt to remove existing files with the same name as the link (force)

### [mktemp](http://man7.org/linux/man-pages/man1/mktemp.1.html)
Safely create temporary files, avoiding various security related race conditions. Files are created with **rw** for the owner only. Not to be confused with the unsafe [mktemp](http://man7.org/linux/man-pages/man3/mktemp.3.html) function, which was replaced by [mkstemp](http://man7.org/linux/man-pages/man3/mkstemp.3.html).

	mktemp foo/bar.XXXXX

`-d` to create a directory

### [dirname](http://man7.org/linux/man-pages/man1/dirname.1.html)/[basename](http://man7.org/linux/man-pages/man1/basename.1.html)
`dirname` outputs the containing directory of the file or directory represented by the given path.

`basename` outputs the name of the file or directory represented by the given path with the path of containing directories removed.

### pushd/popd/dirs
These are [bash builtins](http://man7.org/linux/man-pages/man1/bash.1.html#SHELL_BUILTIN%20COMMANDS) for changing and remembering the working directory.

`pushd directory` adds `directory` to the stack and makes it the current working directory.\
`popd` removes a directory from the top of the stack and makes it the current working directory.\
Both take `-n` to suppress the cd.

`dirs` displays the stack.\
`-l` for full pathnames\
`-p` for one entry per line\
`-c` to clear the stack

`pushd` and `popd` display the new stack if successful, so some scripts will need to redirect their output.

### [dd](http://man7.org/linux/man-pages/man1/dd.1.html)
Streams input to output, and can perform some filtering and transformations.
There are some amusing [competing origin stories](http://www.roesler-ac.de/wolfram/acro/credits.htm#1) for the name.

One way to tie up a core:

	dd if=/dev/zero of=/dev/null

More [examples from Noah Spurrier](http://www.noah.org/wiki/Dd_-_Destroyer_of_Disks).

### [truncate](http://man7.org/linux/man-pages/man1/truncate.1.html)
Change a file's size. If the size is extended, no new blocks are allocated; you get a file hole instead.

	truncate -s 42m foo

### [vim](http://vimdoc.sourceforge.net/)
[Cheat sheet](http://www.fprintf.net/vimCheatSheet.html).

Stuff I need to remember:

`"+p` to paste from Ctrl+C buffer, `"*p` to paste from hilight buffer (usually).\
`:%s/foo/bar/g` for substitution.\
`u` for undo, `Ctrl+R` for redo.\
`~` to toggle case.

### [less](http://linux.die.net/man/1/less)
Doesn't need to load the whole file before displaying some of it.

`F` follows file.\
`/foo` searches, `n` next, `N` previous.\
`&foo` hides non-matching lines (awesome!).

### [tail](http://man7.org/linux/man-pages/man1/tail.1.html)
`-f` follows file by descriptor.\
`-F` follows file by name.

### [head](http://man7.org/linux/man-pages/man1/head.1.html)
`-n num` shows the first `num` lines of the given file.\
Combine with `tail` to pick out the interesting bit from the middle of a file:
	
	<foo head -n 30000 | tail -n -50

### [od](http://man7.org/linux/man-pages/man1/od.1.html)
Useful for examining small file fragments for oddities, such as malformed unicode, smashed arrays, messed up line endings.

### [xxd](http://linux.die.net/man/1/xxd)
Dump or recover file as hex (or binary).

For manual view with offsets and ascii:

	xxd -cols 64 foo

Dump and recover plain hex:

	xxd -p foo > out
	xxd -p -r out > foo2

### [tar](http://man7.org/linux/man-pages/man1/tar.1.html)
Create archives:

	tar cvf foo.tar foo/
	tar cvzf foo.tar.gz foo/
	tar cvjf foo.tar.bz2 foo/

Extract archives:

	tar xvf foo.tar
	tar xvzf foo.tar.gz
	tar xvjf foo.tar.bz2

### [find](http://man7.org/linux/man-pages/man1/find.1.html)
Search for files and do things to them.

There are a bunch of filter options; by default these form a conjunction but be combined with `-or` clauses and parentheses if more complex filters are needed.

For example: find files and directories under the current working directory having a `basename` starting with `foo`, and also find files having `bar` somewhere in their path which had their content modified within the last hour and are greater than 50 megabytes in size.

	find . -name 'foo*' -o \( -mtime -60m -path '*bar*' -type f -size +50M \)

Find can also invoke commands on its results.

`-exec command arg '{}' ';'` will execute command once for each result. `{}` are replaced with the path to the current target, `;` signifies the end of `command`'s arguments. `-exec command arg '{}' '+'` does the same but builds up a list of results to reduce the number of `command` invocations. There could be more than one invocation if the number of results is large enough to run over the maximum command length. Since the command is built by appending results, there cannot be any args between `{}` and `+`.

	find . ! -path './build*' -name '*.log' -exec tar cvf ~/logs.tar '{}' '+'

# Remoting

### [ssh](http://man7.org/linux/man-pages/man1/ssh.1.html)
Lots more to use and abuse here. Most of the time, I only need a small amount of the real ultimate power available. This is fortunate since I don't know ssh at all well.

`-A` forwards agent authentication to the remote host.\
`-L` and `-R` are for port forwarding, and take additional options to describe the tunnel.\
`-N` avoids running any remote command.\
`-T` avoids allocating a remote terminal.\
`-f` sends ssh to the background just before it runs any commands (but after it asks for passwords).\
`-l` sets login name.\
`-p` sets remote port.\
`-v` for debugging - just add `-v`s until the error messages start to make sense or you run out of keyboard.\
`-X` and `-Y` are for normal and trusted X forwarding.

Generate a new keypair with `ssh-keygen -t rsa -C 'public comment, e.g. email address or name'`.
The private key is generated in `~/.ssh/id_rsa` and the public key in `~/.ssh/id_rsa.pub`.

Supply the public key to appropriate hosts by appending it to `~/.ssh/authorized_keys` or using [ssh-copy-id](http://linux.die.net/man/1/ssh-copy-id), which also ensures file permissions are correct.

`ssh-add` can be used to add keys, or check what keys have been added, or check whether an agent is accessible.\
This can be useful in scripts that need to pre-authorise as they start up.

Some forwarding rules in the config file can save typing if you have a segregated network and regularly need to go via jump hosts.

### [scp](http://man7.org/linux/man-pages/man1/scp.1.html)
	
	scp user@sourcehost:/path/to/source user@targethost:/path/to/target

`-r` for recursive directory copy.\
`-l kbits` for rate limit of `kbits` per second.

### [rsync](http://linux.die.net/man/1/rsync)

rsync is a very flexible program for remote copying that I've so far tended only to use for backup or syncing.

`-H` preserves hard links.\
`-A` preserves ACLs.\
`-X` preserves extended attributes.\
`-a` archive mode: recursively copy subdirectories, preserves symbolic links, permissions, owner, group, times.\
`--delete` cleans the target.\
`--exclude-from=file` specifies file containing patterns to ignore.

### [curl](http://curl.haxx.se/docs/manpage.html)

Useful for scripted downloads and for command line testing of http apis.

`-H` adds a header.\
`-c` specifies cookie file to write to.\
`-b` specifies cookie file to read from.\
`-d` sends POST data. Other options exist for sending binary or url encoded data, reading from a file, sending form data, multipart data and so on.\
`-I` http HEAD.\
`-L` follows redirects.\
`-r` request a byte range.\
`-T` upload files with PUT.

### [wget](http://www.gnu.org/software/wget/manual/wget.html)

The main use case for `wget` over `curl` is recursively downloading directories of files, following links in dowloaded documents, and coverting links for local use.

# Networks

### ping
### traceroute
### telnet
### nc
### socat
### ifconfig, nc, other obsolete stuff
### ip
### iw
### ss
### lldpctrl
### tcpdump, dump analysis e.g. wireshark, handshakes etc

# Text Processing

### grep
### sed
### awk
### cut
### tr
### bc
### wc
### sort
### uniq
### comm
### join
### rev
### tee
### diff
### patch

# System

### ps
### pgrep/pkill
### kill
### killall
### top
### lsof
### df
### du
### sar
### mpstat
### vmstat
### iostat
### time
### strace
### dtrace
### perf
### hostname
### date
### whoami (whoami really? apue/dan script)
### uname
### group
### umask
### ulimit
### watch

# Building

### make
### gcc
### lld
### rpmbuild
### mock
