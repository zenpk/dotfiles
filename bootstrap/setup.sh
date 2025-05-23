#!/bin/bash

# apt
sudo apt update
sudo apt install -y zsh
sudo apt install -y tmux
sudo apt install -y vim-gtk3
sudo apt install -y nginx

sudo ufw allow "Nginx Full"

# tmux
cat << EOF > ~/.tmux.conf
# change prefix to C-a
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

set -sg escape-time 10 # prevent 0;10;1c
# set-environment -g TZ UTC
# address vim mode switching delay (http://superuser.com/a/252717/65504)
set -s escape-time 0
# increase tmux messages display duration from 750ms to 3s
set -g display-time 3000
# refresh 'status-left' and 'status-right' more often, from every 15s to 5s
set -g status-interval 5
# focus events enabled for terminals that support them
set -g focus-events on
set -g mode-keys vi
set -g status-keys vi
set -g mouse off
set -g history-limit 10000 
set -g default-terminal 'tmux-256color'
set -ag terminal-overrides ",xterm-256color:RGB"  # correct color
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
set hlsearch
set incsearch
set scrolloff=10
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set smartindent
set nowrap
set noswapfile
set nobackup
set undofile
set undodir=$HOME/.vim/undo
set updatetime=50
set clipboard=

map <space> <leader>
" sane clipboard
nnoremap c "_c
nnoremap C "_C
nnoremap x "_x
xnoremap x "_x
nnoremap X "+x
xnoremap X "+x
nnoremap d "_d
xnoremap d "_d
nnoremap D "_D
nnoremap <leader>d "+dd
nnoremap <leader>D "+D
nnoremap p "+p
xnoremap p "_d"+P
nnoremap P "+P
xnoremap P "_d"+P
nnoremap y "+y
noremap <leader>y y
noremap <leader>p p
" yank without jump
xnoremap y "+ygv<esc>
" redo
nnoremap U <C-r>
" no highlight
nnoremap Q :noh<CR>
" sane scroll
nnoremap <C-u> Hzz
nnoremap <C-d> Lzz
noremap H ^
noremap L $
" visual block
nnoremap <leader>v <C-v>
" search and replace
nnoremap <leader>ss /<C-r>+<CR>
xnoremap <leader>ss "zy/<C-r>z<CR>
nnoremap <leader>sr :%s/<C-r>+/<C-r>+/gc<left><left><left>
xnoremap <leader>sr "zy:%s/<C-r>z/<C-r>z/gc<left><left><left>
" sudo write
nnoremap <leader>sw :w !sudo tee > /dev/null %<CR>
" set paste
nnoremap <leader>sp :set paste<CR>
" set copy
nnoremap <leader>sc :set nonumber norelativenumber signcolumn=no wrap<CR>
" ctrl-s save
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>
" easy motion
noremap s <leader><leader>w
noremap S <leader><leader>b
EOF

# zsh
sudo sed s/required/sufficient/g -i /etc/pam.d/chsh
sudo chsh -s $(which zsh) $(whoami)
sudo sed s/sufficient/required/g -i /etc/pam.d/chsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k
git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# ssh
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# manual
echo "done"
echo "run source ~/.zshrc to do p10k configure"
echo "run tmux source ~/.tmux.conf and press prefix + I to install tmux plugins"

# optional
# homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# brew install fzf
# nginx user group
# sudo usermod -aG [username] www-data
