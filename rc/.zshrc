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
    fzf-tab
)

source $ZSH/oh-my-zsh.sh

source <(fzf --zsh)
bindkey "^q" fzf-cd-widget

# fzf file explorer
function fcd () {
    local current_path="${1:-$(pwd)}"

    while true; do
        local find_path=$current_path
        if [ -z "$current_path" ]; then
            find_path="/"
        fi
        local selected=$(find "$find_path" -maxdepth 1 -type f -o -type d | 
            sed 's,'^"$current_path"/',,' |
            sed "1c .." |
            fzf --preview 'f () {
            local path="'"$current_path"'"/$1
            local lowered=$(echo $path | tr "[:upper:]" "[:lower:]")
            if [ -d "$path" ]; then
                ls -lah "$path"
            elif [ -f "$path" ]; then
                case "$lowered" in
                    *.exe|*.mp3|*.wav|*.mp4|*.mov|*.ts|*.jpg|*.jpeg|*.png) file "$path" ;;
                    *) cat "$path" ;;
                esac
            else
                echo "No preview available"
            fi
        }; f {}' --preview-window=wrap)

        local full="${current_path}/${selected}"
        if [ -z "$selected" ]; then  # if no selection is made, cd to the last selection
            cd $current_path
            return
        elif [ -d "$full" ]; then  # if directory, continue
            if [ "$selected" "==" ".." ]; then
                # remove everything after the last "/"
                current_path="${current_path%/*}"
            else
                current_path=$full
            fi
        else  # if file, echo it
            echo $full
            return
        fi
    done
}

export PATH="$HOME/.local/bin:/usr/local/go/bin:$PATH"

SAVEHIST=1000  # Save most-recent 1000 lines
HISTFILE=~/.zsh_history

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
