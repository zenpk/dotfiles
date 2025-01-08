# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# Linux only
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

source <(fzf --zsh)
autoload -U compinit; compinit
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/go/bin:/usr/local/bin:$HOME/.local/bin:/usr/local/go/bin:$PATH"

# fzf file explorer
function fcd () {
    current_path="${1:-$(pwd)}"

    # remove trailing / if not the root directory 
    if [ "$current_path" != "/" ]; then
        current_path="${current_path%/}"
    fi

    while :; do
        path_prefix="$current_path"
        if [ "$path_prefix" = "/" ]; then
            path_prefix=""
        fi

        selected=$(find "$current_path" -maxdepth 1 -type f -o -type d \
            | awk -v p="$path_prefix/" 'NR == 1 {print ".."; next} {sub("^"p, ""); print}' \
            | fzf --preview 'f () {
            path="'"$path_prefix"'"/$1
            lowered=$(echo "$path" | /usr/bin/tr "[:upper:]" "[:lower:]")
            if [ -d "$path" ]; then
                /bin/ls -lah "$path"
            elif [ -f "$path" ]; then
                case "$lowered" in
                    *.exe|*.mp3|*.wav|*.mp4|*.mov|*.jpg|*.jpeg|*.png)
                        /usr/bin/file "$path"
                        ;;
                    *)
                        /bin/bat "$path"
                        ;;
                esac
            else
                echo "No preview available"
            fi
        }; f {}')

        # get the absolute path
        full="${current_path}/${selected}"
        if [ "$current_path" = "/" ]; then
            full="${current_path}${selected}"
        fi

        # if esc / ctrl+c, cd to the current path
        if [ -z "$selected" ]; then
            cd $current_path
            return
        # if directory, continue
        elif [ -d "$full" ]; then
            if [ "$selected" = ".." ]; then
                current_path=$(dirname "$current_path")
            else
                current_path="$full"
            fi
        else
            echo "$full"
            return
        fi
    done
}

# https://www.reddit.com/r/zsh/comments/wq4mq8/zsh_history_isnt_working/
export HISTFILE=$HOME/.zsh_history # location of the history file
export HISTSIZE=2000 # current session's history limit, also following this https://unix.stackexchange.com/a/595475 $HISTSIZE should be at least 20% bigger than $SAVEHIST 
export SAVEHIST=1000 # zsh saves this many lines from the in-memory history list to the history file upon shell exit
setopt SHARE_HISTORY # allows multiple Zsh sessions to share the same command history 
setopt APPENDHISTORY # ensures that each command entered in the current session is appended to the history file immediately after execution

alias ll="ls -l --color=auto"

# https://stackoverflow.com/questions/16727459/what-makes-ctrlq-work-in-zsh
unsetopt flow_control
bindkey "^q" fzf-cd-widget

export FZF_DEFAULT_OPTS="--cycle --no-mouse --no-height --layout=default --bind='ctrl-p:up,ctrl-n:down,ctrl-k:preview-up,ctrl-j:preview-down,tab:toggle-out' --preview-window=wrap"
export BAT_THEME="OneHalfDark"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
