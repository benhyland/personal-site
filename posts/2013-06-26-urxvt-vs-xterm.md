---
title: Which terminal?
summary: Choose rxvt-unicode.
---

When setting up FreeBSD, I needed to choose a terminal emulator. Not being especially familiar with all this, my criteria were:

* actively supported
* handles unicode properly
* reasonably fast
* don't waste ages deciding
* available in ports

Using

	time seq -f 'omgomgomg %g' 100000
	
We find for xterm:

	real    0m13.525s
	user    0m0.058s
	sys     0m0.050s

and for uxrvt:

	real	0m0.351s
	user	0m0.060s
	sys	0m0.068s

Good enough for me.

[rxvt-unicode website](http://software.schmorp.de/pkg/rxvt-unicode.html).
