#!/bin/bash
# this script should be run by user

# apt
sudo apt update
sudo apt install -y zsh
sudo apt install -y tmux
sudo apt install -y htop
sudo apt install -y net-tools
sudo apt upgrade -y
sudo snap install --beta nvim --classic

# tmux
cat << EOF > ~/.tmux.conf
set -g mode-keys vi
set -g status-keys vi
set -g mouse on
set -g history-limit 5000
set -g default-terminal 'tmux-256color'

# switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -sg escape-time 1 # prevent 0;10;1c
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-yank'

set -g @plugin 'dracula/tmux'
set -g @dracula-plugins "cpu-usage ram-usage time"
set -g @dracula-show-powerline true
set -g @dracula-show-flags true
set -g @dracula-show-left-icon session
set -g @dracula-day-month false
set -g @dracula-show-timezone false
set -g @dracula-military-time true

# should be at the bottom
run '~/.tmux/plugins/tpm/tpm'
EOF
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# vim
cat << EOF > ~/.vimrc
set number
set relativenumber
syntax on
set ignorecase
set smartcase
set incsearch
set ts=4 sw=4

EOF

# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" << "EOF"
Y
EOF
sudo sed s/required/sufficient/g -i /etc/pam.d/chsh
sudo chsh -s $(which zsh) $(whoami)
sudo sed s/sufficient/required/g -i /etc/pam.d/chsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/^plugins=.*/plugins=(\n    git\n    zsh-syntax-highlighting\n    zsh-autosuggestions\n)/' ~/.zshrc
cat << EOF >> ~/.zshrc

function lazygit() {
	git add .
	git commit -m "$*"
	git push
}

function gitclonessh() {
    git clone "$1" --config core.sshCommand="ssh -i ~/.ssh/$2"
}

function gitsignssh() {
    git config gpg.format ssh
    git config user.signingkey "~/.ssh/$1.pub"
    git config commit.gpgsign true
}

function gitcommit() {
    git commit -m "$*"
}

export PATH="$PATH:/snap/bin"

EOF

# ssh
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# manual
echo "done"
echo "run source ~/.zshrc to do p10k configure"
echo "run tmux source ~/.tmux.conf and press prefix + I to install tmux plugins"
echo "paste your SSH public key to ~/.ssh/authorized_keys"
