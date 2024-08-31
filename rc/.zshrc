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
            | fzf --cycle \
            --bind="ctrl-k:preview-up,ctrl-j:preview-down" \
            --preview 'f () {
            path="'"$path_prefix"'"/$1
            lowered=$(echo "$path" | /usr/bin/tr "[:upper:]" "[:lower:]")
            if [ -d "$path" ]; then
                /bin/ls -lah "$path"
            elif [ -f "$path" ]; then
                case "$lowered" in
                    *.exe|*.mp3|*.wav|*.mp4|*.mov|*.ts|*.jpg|*.jpeg|*.png)
                        /usr/bin/file "$path"
                        ;;
                    *)
                        /bin/bat "$path"
                        ;;
                esac
            else
                echo "No preview available"
            fi
        }; f {}' --preview-window=wrap)

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

bindkey "^q" fzf-cd-widget
SAVEHIST=1000  # Save most-recent 1000 lines
HISTFILE=~/.zsh_history
