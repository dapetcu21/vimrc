#My personal vimrc

Feel free to use it / modify it / do whatever with it.

## Installing dependencies

This vimrc needs a vim with Python and Ruby support, Clang (to compile youcompleteme), the Python headers (ycm) and npm (for JSHint) to work perfectly.

### Ubuntu:

```
sudo apt-get install build-essential python-dev cmake nodejs vim-nox
```

### OS X with Homebrew:

```
brew install python cmake node vim
```

### Works anyway

However, CommandT will not be loaded if you don't have Ruby support in your vim, JSHint support won't be loaded if you don't have npm and YouCompleteMe won't be loaded if you don't have a Python-compatible version of vim (making CMake, python-dev and build-essential not needed anymore)

So, essentially, it should work decently even if you don't have all of these dependencies installed.

## Installing the vimrc

Just run:

```
git clone https://github.com/dapetcu21/vimrc.git
cd vimrc
./install.sh
```

It's as simple as that.

If you need C/C++ autocompletion, then you should run the installer as such:

```
./install.sh --with-clang
```
