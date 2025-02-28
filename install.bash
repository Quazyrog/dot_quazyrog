git clone https://github.com/Quazyrog/dot_quazyrog.git .quazyrog
ln -s .quazyrog/zshrc .zshrc
mkdir .zsh
cd .zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions
git clone --depth 1 https://github.com/junegunn/fzf.git fzf
./fzf/install

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
