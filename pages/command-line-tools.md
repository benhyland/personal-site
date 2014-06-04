---
title: Command Line Tools
summary: Quick descriptions of program I use often during my normal work, and also some network focused tools I encountered for the first time when working on rotation with our Information Services team.
---

# Filesystem

### [ls](http://man7.org/linux/man-pages/man1/ls.1.html)
	-s shows allocated blocks
	-a shows all, -A shows all except . and ..
	-l shows long detail
	-h shows human readable sizes
	-1 ouputs one directory entry per line
	-d stats a directory rather than its contents

### [mv](http://man7.org/linux/man-pages/man1/mv.1.html)
Sometimes thought of as being an atomic cp/rm but isn't really.
Within a single filesystem, mv is generally a call to rename(), which is atomic.
It removes an i-node reference from the directory block of the source and adds it to that of the target.

### [chmod](http://man7.org/linux/man-pages/man1/chmod.1.html)
Change mode of files and directories. Mode consists of **r**ead, **w**rite, e**x**ecute/search, **s**et uid/gid, s**t**icky, and is set for **u**ser, **g**roup, **o**ther and **a**ll.
Multiple clauses can be used in a single invocation e.g.

	chmod a+r,go-wx foo

### [chown](http://man7.org/linux/man-pages/man1/chown.1.html)
	chown bhyland:wheel foo

	-R for recursive
	--from=owner:group to filter on current

	
### [ln](http://man7.org/linux/man-pages/man1/ln.1.html)
Create hard links or symbolic links. A hard link is just another directory entry to an existing i-node. A symbolic link is a special file that links indirectly to the target i-node. It can link across filesystems and to directories as well as files. A symbolic link is not included in the link count of the target, and can point to targets that don't exist.
	
	ln target link

	-s for symbolic link
	-f to attempt to remove existing files with the same name as the link (force)

### [mktemp](http://man7.org/linux/man-pages/man1/mktemp.1.html)
Safely create temporary files, avoiding various security related race conditions. Files are created with rw for the owner only. Not to be confused with the unsafe [mktemp](http://man7.org/linux/man-pages/man3/mktemp.3.html) function, which was replaced by [mkstemp](http://man7.org/linux/man-pages/man3/mkstemp.3.html).

	mktemp foo/bar.XXXXX

	-d to create a directory

### dirname/basename
### pushd/popd
### dd
### truncate
### vim
### less
### tail
### head
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
