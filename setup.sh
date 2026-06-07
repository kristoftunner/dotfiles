#!/bin/bash
set -x
echo "Installing fzf"
echo "" >> ~/.bashrc
echo "#----- MOVE THIS PART TO THE END OF THE .bashrc FILE -----" >> ~/.bashrc
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

cp user_exports ~/.user_exports
echo "source ~/.user_exports" >> ~/.bashrc
echo "export PATH=~/.local/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

echo "Installing zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh -s -- -y

echo "removing neovim configs"
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
mkdir ~/.config
cp -r ./nvim ~/.config/nvim

echo "Installing vimrc"
cp ./.vimrc ~/.vimrc

echo "Installing tmux"
apt update
apt install install tmux fd-find libfuse2 xclip nvtop btop -y
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp ./.tmux.conf ~/.tmux.conf

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
cp ./theme.toml ~/.config/yazi/

echo "Installing aliases"
cp .aliases ~/.aliases
echo "source ~/.aliases" >> ~/.bashrc
echo "source ~/.aliases" >> ~/.zshrc
echo "#----- UNTIL THIS PART -----" >> ~/.bashrc

echo "Installing neovim"
sudo apt remove nvim
wget https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz -O ~/.local/bin/nvim-linux-x86_64.tar.gz
if [ ! -d ~/.local/bin ]; then
    mkdir -p ~/.local/bin
fi
mkdir ~/.local/bin/nvim-linux-x86_64
if ! tar -xzf ~/.local/bin/nvim-linux-x86_64.tar.gz -C ~/.local/bin/; then
    echo "Failed to extract nvim tar.gz"
    exit 1
fi
chmod +x ~/.local/bin/nvim-linux-x86_64/bin/nvim
ln -s ~/.local/bin/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim

if ! command -v python3 >/dev/null 2>&1; then
    echo "Python is not installed"
    exit 1
fi

# installing tools for ai dev
python3 -m pip install gdown wandb dvc
if curl -LsSf https://hf.co/cli/install.sh | bash; then
    echo "Hugging Face CLI installed successfully."
else
    echo "Failed to install Hugging Face CLI."
    exit 1
fi

if ! curl https://rclone.org/install.sh | bash; then
    echo "Failed to install Rclone."
    exit 1
fi
