---
title: Partial Passwords
summary: Using secret sharing to allow checking of partial passwords in linear space.
---

For a webapp I was working on a while ago, we needed to provide a particular user experience around the security and login features. The users expected something very similar to the UK bank style of memorable information or PIN, in addition to requiring a username and password or certificate. I looked for existing libraries and wrote a quick prototype, but in the short time available I didn't manage to get anything working. We ended up writing a simpler feature, but it always bugged me that I didn't find a useful library and that I didn't manage to build a working prototype.

The problem is to allow the user to authenticate by providing only a portion of some code. On login, the server randomly selects some indices, and the user must provide the characters from their code which correspond to those indices. The server will want to check that the user provided the correct characters, but of course it should not store them as cleartext.

Here is my Scala implementation of [partial passwords](https://github.com/benhyland/partial-pass) using threshold [secret sharing](http://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing). The main advantage to this solution is that it requires only linear space.

Briefly, the way it works is:

Setup

- pick a length (or maximum length) for the code and the number of characters to require for authentication. These will be hard to change so get them right.

Registration

- when a user is registered, select a code (e.g. have them enter one and make sure it passes basic strength criteria).
- generate a random secret value and store it (or its hash)
- generate random coefficients for a polynomial which has its intercept at the secret and has degree one less than the number of characters to be required for authentication.
- calculate successive values of the polynomial when setting its variable to the indices of the code.
- for each value, combine it with the corresponding character and store the result.

Authentication

- for authentication, randomly select some indices and require those characters from the user.
- derive the original polynomial values for each character and use them to find the intercept.
- if the intercept calculated is the same as the intercept stored, the user must have supplied correct characters.

Note that we store only the intercept value and one polynomial value for each character in the code.

More links and caveats are given in the repository readme. I hope this might help somebody, but it was written as an exercise - my requirement is lost in the mists of time. As always, feedback is welcome.
