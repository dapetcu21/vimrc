import os
import ycm_core

flags = [
'-Wall',
'-Wextra',
'-Werror',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
'-DNDEBUG',

# Local includes
'-I',
'.',

# Homebrew-installed libraries
'-F',
'/usr/local/Frameworks',
'-isystem',
'/usr/include',
'-isystem',
'/usr/local/include',

# Xcode trickery
'-isystem',
'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1',
'-isystem',
'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include',
]

def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )

def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
  if not working_directory:
    return list( flags )
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
  cplusplus = False
  relative_to = DirectoryOfThisScript()
  final_flags = MakeRelativePathsInFlagsAbsolute( flags, relative_to )
  if filename.endswith('.cpp'):
    final_flags += [ "-x", "c++" ]
    cplusplus = True
  elif filename.endswith('.c'):
    final_flags += [ "-x", "c" ]
  elif filename.endswith('.m'):
    final_flags += [ "-x", "objective-c" ]
    objc = True
  elif filename.endswith('.mm') or filename.endswith('.h'):
    final_flags += [ "-x", "objective-c++" ]
    cplusplus = True
    objc = True

  if cplusplus:
    final_flags += [ '-std=c++11' ]
  else:
    final_flags += [ '-std=c99' ]

  return {
    'flags': final_flags,
    'do_cache': True
  }
