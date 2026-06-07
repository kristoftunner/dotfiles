script_dir="$(dirname "$0")"

echo "Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

cp $script_dir/exports ~/.exports
echo "source ~/.exports" >> ~/.bashrc
echo "export PATH=~/.local/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

echo "Installing zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

echo "removing neovim configs"
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
mkdir ~/.config
cp -r $script_dir/nvim ~/.config/nvim

echo "Installing vimrc"
cp $script_dir/.vimrc ~/.vimrc

echo "Installing tmux"
sudo apt update
sudo apt install install tmux fd-find libfuse2 xclip -y
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp $script_dir/.tmux.conf ~/.tmux.conf

echo "Installing yazi"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env

echo "Updating Rust"
if ! command -v rustup >/dev/null 2>&1; then
  echo "Rust is not installed"
  exit 1
fi
rustup update

if ! command -v cargo >/dev/null 2>&1; then
  echo "Cargo is not installed"
  exit 1
fi

cargo install --force yazi-build

mkdir ~/.config/yazi
git clone https://github.com/yazi-rs/flavors.git ~/.config/yazi/flavors
cp $script_dir/theme.toml ~/.config/yazi/

echo "Install atuin"
curl -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
if [ $? -ne 0 ]; then
  echo "Failed to install autin"
fi

echo "Installing aliases"
cp $script_dir/.aliases ~/
cp $script_dir/.setup_tooling ~/
echo "source ~/.aliases" >> ~/.bashrc
echo "source ~/.setup_tooling" >> ~/.bashrc
echo '. "$HOME/.atuin/bin/env"' >> ~/.bashrc

echo "Installing neovim"
sudo apt remove nvim
wget https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.appimage
mkdir ~/.local/bin
mv nvim-linux-x86_64.appimage ~/.local/bin/nvim
chmod +x ~/.local/bin/nvim

nvim ~/.config/nvim
echo "Make sure to update neovim plugins with Lazy and install LSP from Mason"

echo "Installing Claude Code settings"
if [[ -d ~/.claude ]]; then
    rm -rf ~/.claude
    mkdir -p ~/.claude
fi
cp $script_dir/claude/* ~/.claude/

echo "Installing rtk"
if ! curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh; then
  echo "Failed to install rtk"
  exit 1
fi
if ! rtk init -g; then
  echo "Failed to initialize rtk"
  exit 1
fi
