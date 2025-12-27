echo "Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

cp exports ~/.exports
echo "source ~/.exports" >> ~/.bashrc
echo "export PATH=~/.local/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

echo "Installing zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

echo "removing neovim configs"
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
mkdir ~/.config
cp -r ./nvim ~/.config/nvim

echo "Installing vimrc"
cp ./.vimrc ~/.vimrc

echo "Installing tmux"
sudo apt update
sudo apt install install tmux fd-find libfuse2 -y
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp ./.tmux.conf ~/.tmux.conf

echo "Installing yazi"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
cargo install --locked yazi-fm yazi-cli

mkdir ~/.config/yazi
git clone https://github.com/yazi-rs/flavors.git ~/.config/yazi/flavors
cp ./theme.toml ~/.config/yazi/

echo "Installing aliases"
cp .aliases ~/.aliases
echo "source ~/.aliases" >> ~/.bashrc
echo "source ~/.aliases" >> ~/.zshrc

echo "Installing neovim"
sudo apt remove nvim
wget https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.appimage
mkdir ~/.local/bin
mv nvim-linux-x86_64.appimage ~/.local/bin/nvim
chmod +x ~/.local/bin/nvim

nvim ~/.config/nvim
echo "Make sure to update neovim plugins with Lazy and install LSP from Mason"
