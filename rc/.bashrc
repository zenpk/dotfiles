# https://dev.to/equiman/zsh-on-windows-without-wsl-4ah9
if [ -t 1 ]; then
  /c/Windows/System32/chcp.com 65001 > /dev/null 2>&1
  exec zsh
fi
