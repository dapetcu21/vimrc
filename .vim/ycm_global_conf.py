import os
import ycm_core
from clang_helpers import PrepareClangFlags

flags = [
"-fblocks",
"-fexceptions"
]


def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )


def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
  if not working_directory:
    return flags
  new_flags = []
  make_next_absolute = False
  path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
  for flag in flags:
    new_flag = flag

    if make_next_absolute:
      make_next_absolute = False
      if not flag.startswith( '/' ):
        new_flag = os.path.join( working_directory, flag )

    for path_flag in path_flags:
      if flag == path_flag:
        make_next_absolute = True
        break

      if flag.startswith( path_flag ):
        path = flag[ len( path_flag ): ]
        new_flag = path_flag + os.path.join( working_directory, path )
        break

    if new_flag:
      new_flags.append( new_flag )
  return new_flags


def FlagsForFile( filename ):
  relative_to = DirectoryOfThisScript()
  final_flags = MakeRelativePathsInFlagsAbsolute( flags, relative_to )
  if filename.endswith('.cpp'):
    final_flags += [ "-x", "c++" ]
  elif filename.endswith('.c'):
    final_flags += [ "-x", "c" ]
  elif filename.endswith('.m'):
    final_flags += [ "-x", "objective-c" ]
    objc = True
  elif filename.endswith('.mm') or filename.endswith('.h'):
    final_flags += [ "-x", "objective-c++" ]
    objc = True

  return {
    'flags': final_flags,
    'do_cache': True
  }
