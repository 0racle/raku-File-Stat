NAME
====

File::Stat - Access file stat fields


SYNOPSIS
========

Implements a File::Stat class, as well as exportable `stat` and `lstat` functions that will return a File::Stat object.

This object has methods that return the similarly named structure field name from the `stat(2)` function.


```raku
use File::Stat < stat lstat >;

say File::Stat.new(path => $?FILE).mode;
say stat($?FILE).uid

# or use `lstat`

say File::Stat.new(path => $?FILE, :l).mode;
say lstat($?FILE).uid

# Augment your IO::Path, stat!

role Stat {
    method stat { File::Stat.new(path => self) }
}

my $file = $?FILE.IO but Stat;
say ($file.s, $file.stat.blksize);
```


ALTERNATIVES
============

When this module was first written, there was no easy way to get certain stats (eg. `gid`) from an [IO::Path](https://docs.raku.org/type/IO/Path) object. Since then, several more methods have been added to `IO::Path`, which means you may not even need this module.

Below I will document the methods provided by `File::Stat`, and - where available - it's equivalent core `IO::Path` method (as well as any differences).

Initial descriptions below are verbatim from `man 2 stat`.


METHODS
=======

## dev

This field describes the device on which this file resides.

Core alternative: [IO::Path.dev](https://docs.raku.org/type/IO/Path#method_dev)

```raku
say stat($?FILE).dev;
say $?FILE.IO.dev;
```

## ino

This field contains the file's inode number.

Core alternative: [IO::Path.inode](https://docs.raku.org/type/IO/Path#method_inode)

```raku
say stat($?FILE).ino;
say $?FILE.IO.inode;
```

## mode

This field contains the file type and mode.

Core alternative: [IO::Path.mode](https://docs.raku.org/type/IO/Path#method_mode)

**NOTE:** The `IO::Path.mode` method only returns the 8-least significant bits, as the higher bits are not platform-independent.

```raku
my &permissions = *.base(2).flip.comb(3)».flip.reverse;

say permissions( stat($?FILE).mode );  # (1 000 000 111 101 101)
say permissions( $?FILE.IO.mode );     #           (111 101 101)
```

See also: `IO::Path` methods `.r`, `.w`, `.x.`, `.rw`, `.rwx`, `.f`, `.d`;

## nlink

This field contains the number of hard links to the file.

Core alternative: None that I'm aware of. Send PR if this changes.

```raku
say stat($?FILE).nlink;
```

## uid

This field contains the user ID of the owner of the file.

Core alternative: [IO::Path.user](https://docs.raku.org/type/IO/Path#method_user)

```raku
say stat($?FILE).uid;
say $?FILE.IO.user;
```

## gid

This field contains the ID of the group owner of the file.

Core alternative: [IO::Path.group](https://docs.raku.org/type/IO/Path#method_group)

```raku
say stat($?FILE).gid;
say $?FILE.IO.group;
```

## rdev

This field describes the device that this file (inode) represents.

Core alternative: [IO::Path.devtype](https://docs.raku.org/type/IO/Path#method_devtype)

```raku
say stat($?FILE).rdev;
say $?FILE.IO.devtype;
```

## size

This field gives the size of the file (if it is a regular file or a symbolic link) in bytes. The size of a symbolic link is the length of the pathname it contains, without a terminating null byte.

Core alternative: [IO::Path.s](https://docs.raku.org/type/IO/Path#method_s)

```raku
say stat($?FILE).size;
say $?FILE.IO.s;
```

## atime

This is the time of the last access of file data.

Core alternative: [IO::Path.accessed](https://docs.raku.org/type/IO/Path#method_accessed)

**NOTE:** See "TIME DIFFERENCES" section.

```raku
say stat($?FILE).atime;  # --> Int
say $?FILE.IO.accessed;  # --> Instant
```

## mtime

This is the time of last modification of file data.

Core alternative: [IO::Path.modified](https://docs.raku.org/type/IO/Path#method_modified)

**NOTE:** See "TIME DIFFERENCES" section.

```raku
say stat($?FILE).mtime;  # --> Int
say $?FILE.IO.modified;  # --> Instant
```

## ctime

This is the file's last status change timestamp (time of last change to the inode).

Core alternative: [IO::Path.created](https://docs.raku.org/type/IO/Path#method_created)

**NOTE:** See "TIME DIFFERENCES" section.

```raku
say stat($?FILE).ctime;  # --> Int
say $?FILE.IO.created;   # --> Instant
```

## blksize

This field gives the "preferred" block size for efficient filesystem I/O.

Core alternative: None that I'm aware of. Send PR if this changes.

```raku
say stat($?FILE).blksize;
```

## blocks

This field indicates the number of blocks allocated to the file, in 512-byte units. (This may be smaller than `size`/512 when the file has holes.)

Core alternative: None that I'm aware of. Send PR if this changes.

```raku
say stat($?FILE).blocks;
```


ADDITIONAL METHODS
==================

## Hash

You can return all fields as a `Hash`.

Useful if you want to pull out multiple fields (via a hash slice) or convert to JSON (or other format).

```raku
say stat($?FILE).Hash
```


TIME DIFFERENCES
================

The time related functions (eg. `mtime`) will differ slightly from their core alternatives (eg. `modified`).

This module will return an `Int`, where as Raku will return an `Instant`.  You may notice that when this `Instant` is coerced to an `Int` that there is a difference of 37 seconds.

```raku
say stat($?FILE).mtime;      # 1692319800
say $?FILE.IO.modified.Int;  # 1692319837
```

However, when converting to a `DateTime` object, both should resolve the same second.

```raku
say DateTime.new(stat($?FILE).mtime);  # 2023-08-18T00:50:00Z
say $?FILE.IO.modified.DateTime;       # 2023-08-18T00:50:00.837761Z
```

This difference is due to leap-seconds, of which Raku is aware.

CAVEATS
=======

Some methods do not mean anything in non-POSIX systems.

This module uses NQP ops.
