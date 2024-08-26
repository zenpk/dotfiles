# minimal outdated rc

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

function lazygit() {
	git add --all
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

source <(fzf --zsh)

export PATH="$HOME/.local/bin:/usr/local/go/bin:$PATH"

SAVEHIST=1000  # Save most-recent 1000 lines
HISTFILE=~/.zsh_history

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
