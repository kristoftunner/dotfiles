echo "Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "Installing zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

echo "removing neovim configs"
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
cp -r ./nvim ~/.config/

echo "installing neovim"
sudo apt remove nvim
wget $HOME/.local/bin/nvim https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.appimage
nvim ~/.config/nvim
echo "Make sure to update neovim plugins with Lazy and install LSP from Mason"
