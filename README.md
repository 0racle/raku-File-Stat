NAME
====

File::Stat - Get file status

SYNOPSIS
========

Implements a File::Stat class, and a `stat` function that will return a File::Stat object;

This object has methods that return the similarly named structure field name from the `stat(2)` function; namely: `dev`, `ino`, `mode`, `nlink`, `uid`, `gid`, `rdev`, `size`, `atime`, `mtime`, `ctime`, `blksize`, and `blocks`.

```perl-6
use File::Stat <stat>;

say File::Stat.new($?FILE).mode;

say stat($?FILE).uid

```

CAVEATS
=======

This module is uses underlying NQP ops, and will likely function incorrectly on non-POSIX systems.
