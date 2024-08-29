# minimal zshrc
plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
    fzf-tab
)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.local/bin:/usr/local/go/bin:$PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source <(fzf --zsh)

# fzf file explorer
function fcd () {
    local current_path="${1:-$(pwd)}"
    # remove the last / if necessary
    if [ "${current_path:0-1}" "==" "/" ]; then
        if [ "$current_path" "!=" "/" ]; then
            current_path=${current_path::-1}
        fi
    fi

    while true; do
        local find_path=$current_path
        if [ -z "$current_path" ]; then
            find_path="/"
        fi
        local selected=$(find "$find_path" -maxdepth 1 -type f -o -type d | 
            awk -v p="$current_path/" 'NR == 1 {print ".."; next} {sub("^"p, ""); print}' |
            fzf --cycle --preview 'f () {
            local path="'"$current_path"'"/$1
            local lowered=$(echo $path | /usr/bin/tr "[:upper:]" "[:lower:]")
            if [ -d "$path" ]; then
                /bin/ls -lah "$path"
            elif [ -f "$path" ]; then
                case "$lowered" in
                    *.exe|*.mp3|*.wav|*.mp4|*.mov|*.ts|*.jpg|*.jpeg|*.png) /usr/bin/file "$path" ;;
                    *) /bin/cat "$path" ;;
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

bindkey "^q" fzf-cd-widget
SAVEHIST=1000  # Save most-recent 1000 lines
HISTFILE=~/.zsh_history
