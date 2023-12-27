# configs
my tmux, fish, bash, etc.. configs

for vim use this config and add additional configs: https://github.com/amix/vimrc

for git beyond compare - git cooperations use this example git config:
```
diff.tool=bc
difftool.bc.cmd="c:/Program Files/Beyond Compare 4/BComp.exe" "$LOCAL" "$REMOTE"
difftool.prompt=false
merge.tool=bc
mergetool.bc.path=C:\Program Files\Beyond Compare 4\BComp.exe
```
## Dependencies:
- TPM for tmux: https://github.com/tmux-plugins/tpm
## Neovim config
For neovim config first remove package configs in `packer.lua` and `remap.lua` and after that add the packages and do the `PackerSync`, otherwise you will get weird lua errors from neovim
## Keyboard shortcuts
Leader key for shortcuts per application:
-Tiling window manager: `alt`
-Vim: `ctrl`

