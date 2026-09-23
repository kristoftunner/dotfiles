script_dir="$(dirname "$0")"
failed_installs=""

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

echo "Installing gdb config"
cp $script_dir/.gdbinit ~/.gdbinit
cp $script_dir/.inputrc ~/.inputrc

echo "Installing tmux"
sudo apt update
sudo apt install install tmux fd-find libfuse2 xclip xsel fd-find ripgrep -y
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
# used by the neovim lang.rust extra (rustaceanvim)
rustup component add rust-analyzer

if ! command -v cargo >/dev/null 2>&1; then
  echo "Cargo is not installed"
  exit 1
fi

# `yazi-build` normally installs yazi-fm/yazi-cli via a nested `cargo install`
# whose output goes straight to the tty and whose exit status is never checked,
# so it silently no-ops when run non-interactively (e.g. from this script).
# Set YAZI_CRATE_BUILD and install yazi-fm/yazi-cli directly instead.
YAZI_CRATE_BUILD=1 cargo install --force --locked --git https://github.com/sxyazi/yazi.git --tag v26.1.4 yazi-fm yazi-cli
if ! command -v yazi >/dev/null 2>&1; then
  echo "Failed to install yazi"
  failed_installs="$failed_installs yazi"
fi

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
# LazyVim and the lang.rust extra require neovim >= 0.12
NVIM_VERSION="v0.12.4"
sudo apt remove -y neovim
mkdir -p ~/.local/bin
wget -O ~/.local/bin/nvim "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.appimage"
chmod +x ~/.local/bin/nvim

if ! ~/.local/bin/nvim --version | head -1 | grep -qE 'v0\.(1[2-9]|[2-9][0-9])'; then
  echo "Failed to install neovim >= 0.12"
  exit 1
fi

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

if [ -n "$failed_installs" ]; then
  echo "The following installs failed:$failed_installs"
fi
