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

### cat
### od
### xxd
### tar
### gzip
### find

# Remoting

### ssh
### scp
### rsync
### curl
### wget

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
