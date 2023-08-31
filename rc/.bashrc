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
