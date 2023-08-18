
use Exportable;

class File::Stat:auth<zef:elcaro>:ver<1.0.1> {

    use nqp;
    my sub nqp-stat($path,  \const) { nqp::stat($path,  const) }
    my sub nqp-lstat($path, \const) { nqp::lstat($path, const) }

    has Str() $.path;
    has Bool $.l = False;
    has &!stat = $!l ?? &nqp-lstat !! &nqp-stat;

    method dev     { &!stat($!path, nqp::const::STAT_PLATFORM_DEV)       }
    method ino     { &!stat($!path, nqp::const::STAT_PLATFORM_INODE)     }
    method mode    { &!stat($!path, nqp::const::STAT_PLATFORM_MODE)      }
    method nlink   { &!stat($!path, nqp::const::STAT_PLATFORM_NLINKS)    }
    method uid     { &!stat($!path, nqp::const::STAT_UID)                }
    method gid     { &!stat($!path, nqp::const::STAT_GID)                }
    method rdev    { &!stat($!path, nqp::const::STAT_PLATFORM_DEVTYPE)   }
    method size    { &!stat($!path, nqp::const::STAT_FILESIZE)           }
    method atime   { &!stat($!path, nqp::const::STAT_ACCESSTIME)         }
    method mtime   { &!stat($!path, nqp::const::STAT_MODIFYTIME)         }
    method ctime   { &!stat($!path, nqp::const::STAT_CHANGETIME)         }
    method blksize { &!stat($!path, nqp::const::STAT_PLATFORM_BLOCKSIZE) }
    method blocks  { &!stat($!path, nqp::const::STAT_PLATFORM_BLOCKS)    }

    method Hash {
        $(
            dev     => .dev,
            ino     => .ino,
            mode    => .mode,
            nlink   => .nlink,
            uid     => .uid,
            gid     => .gid,
            rdev    => .rdev,
            size    => .size,
            atime   => .atime,
            mtime   => .mtime,
            ctime   => .ctime,
            blksize => .blksize,
            blocks  => .blocks,
        ) with self
    }

}

sub stat($path) is exportable {
    File::Stat.new(:$path)
}
sub lstat($path) is exportable {
    File::Stat.new(:$path, :l)
}

