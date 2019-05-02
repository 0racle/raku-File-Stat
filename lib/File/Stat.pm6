
use Exportable;
use nqp;

class File::Stat {
    has Str $.path;
    method dev     { nqp::stat($!path, nqp::const::STAT_PLATFORM_DEV)       }
    method ino     { nqp::stat($!path, nqp::const::STAT_PLATFORM_INODE)     }
    method mode    { nqp::stat($!path, nqp::const::STAT_PLATFORM_MODE)      }
    method nlink   { nqp::stat($!path, nqp::const::STAT_PLATFORM_NLINKS)    }
    method uid     { nqp::stat($!path, nqp::const::STAT_UID)                }
    method gid     { nqp::stat($!path, nqp::const::STAT_GID)                }
    method rdev    { nqp::stat($!path, nqp::const::STAT_PLATFORM_DEVTYPE)   }
    method size    { nqp::stat($!path, nqp::const::STAT_FILESIZE)           }
    method atime   { nqp::stat($!path, nqp::const::STAT_ACCESSTIME)         }
    method mtime   { nqp::stat($!path, nqp::const::STAT_MODIFYTIME)         }
    method ctime   { nqp::stat($!path, nqp::const::STAT_CHANGETIME)         }
    method blksize { nqp::stat($!path, nqp::const::STAT_PLATFORM_BLOCKSIZE) }
    method blocks  { nqp::stat($!path, nqp::const::STAT_PLATFORM_BLOCKS)    }
}

sub stat($path) is exportable {
    File::Stat.new(:$path)
}

