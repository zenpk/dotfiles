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
    echo $current_path

    while :; do
        path_prefix="$current_path"
        if [ "$path_prefix" = "/" ]; then
            path_prefix=""
        fi

        selected=$(find "$current_path" -maxdepth 1 -type f -o -type d \
            | awk -v p="$path_prefix/" 'NR == 1 {print ".."; next} {sub("^"p, ""); print}' \
            | fzf --cycle \
            --bind="tab:accept,enter:print(ENTER)+accept,ctrl-k:preview-up,ctrl-j:preview-down" \
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
                        /bin/cat "$path"
                        ;;
                esac
            else
                echo "No preview available"
            fi
        }; f {}' --preview-window=wrap)

        # check if enter was pressed
        case ${selected} in
            ENTER*)
                enter_pressed=1
                # remove ENTER\n
                selected=${selected:6}
                ;;
            *)
                enter_pressed=0
                ;;
        esac

        # get the absolute path
        full="${current_path}/${selected}"
        if [ "$current_path" = "/" ]; then
            full="${current_path}${selected}"
        fi

        # if esc / ctrl+c, print the current path
        if [ -z "$selected" ]; then
            print $current_path
            return
        # if directory, tab -> continue, enter -> cd into it
        elif [ -d "$full" ]; then
            if [ "$selected" = ".." ]; then
                current_path=$(dirname "$current_path")
            else
                current_path="$full"
            fi
            if [ "${enter_pressed}" = "1" ]; then
                cd $current_path
                return
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
