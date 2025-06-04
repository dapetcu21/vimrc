# My personal NeoVim config

Feel free to use it / modify it / do whatever with it.

## Mac / Linux:

```sh
cd ~/.config
git clone https://github.com/dapetcu21/vimrc.git nvim
cd nvim
./install.sh
```

Note: For Linux you'll have to install NeoVim and the dependencies using your respective package manager

## Windows:

```powershell
winget install --id Git.Git
cd ~\AppData\Local
git clone https://github.com/dapetcu21/vimrc.git nvim
cd nvim
.\install.ps1
```

You can add local, private configs by creating `lua/local/init.lua` and `lua/local/plugins.lua`.
