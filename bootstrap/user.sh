#!/bin/bash
# this script should be run by user

# apt
sudo apt update
sudo apt install -y zsh
sudo apt install -y tmux
sudo apt install -y htop
sudo apt upgrade -y

# tmux
cat << EOF > ~/.tmux.conf
# change prefix to C-a
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# address vim mode switching delay (http://superuser.com/a/252717/65504)
set -s escape-time 0
# increase tmux messages display duration from 750ms to 3s
set -g display-time 3000
# focus events enabled for terminals that support them
set -g focus-events on
set -g mode-keys vi
set -g status-keys vi
set -g mouse off
set -g history-limit 10000 
set -g default-terminal 'tmux-256color'
# mac
# set -g default-terminal 'screen-256color'

# vim-like pane switching
bind -r k select-pane -U
bind -r j select-pane -D
bind -r h select-pane -L
bind -r l select-pane -R

# use v to trigger selection    
bind -T copy-mode-vi v send-keys -X begin-selection
# use y to yank current selection
bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

# easier and faster switching between next/prev window
bind -r C-p previous-window
bind -r C-n next-window
# above bindings enhance the default prefix + p and prefix + n bindings by allowing you to hold Ctrl and repeat a + p/a + n (if your prefix is C-a), which is a lot quicker.
bind -r a last-window

# list of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -sg escape-time 1 # prevent 0;10;1c
set -g @plugin 'tmux-plugins/tmux-resurrect'

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
mkdir -p ~/.vim/undo
cat << EOF > ~/.vimrc
syntax on
set background=dark
set number
set relativenumber
set ignorecase
set smartcase
set incsearch
set nohlsearch
set scrolloff=8
set ts=4 sw=4 sts=4 expandtab smarttab
set smartindent
set nowrap
set noswapfile
set nobackup
set undofile
set undodir=$HOME/.vim/undo
set updatetime=50
set signcolumn=yes
set clipboard=unnamed

map <space> <leader>
noremap c "1c
noremap C "1C
noremap s "1s
noremap S "1S
noremap x "1x
noremap X x
noremap d "1d
noremap dd "1dd
noremap D dd
nnoremap U <C-r>
nnoremap Q <nop>
nnoremap <leader>v <C-v>
nnoremap <leader>w :w !sudo tee > /dev/null %<CR>
nnoremap <leader>dj oconsole.log("======== debug ========");<ESC>
nnoremap <leader>dg olog.Println("======== debug ========")<ESC>

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
	git commit -m "\$*"
	git push
}

function gitclonessh() {
    git clone "\$1" --config core.sshCommand="ssh -i ~/.ssh/\$2"
}

function gitsignssh() {
    git config gpg.format ssh
    git config user.signingkey "~/.ssh/\$1.pub"
    git config commit.gpgsign true
}

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
