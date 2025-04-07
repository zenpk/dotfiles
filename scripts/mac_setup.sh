# hold key
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 3

# proxy on
networksetup -setwebproxy Wi-Fi 127.0.0.1 1080
networksetup -setsecurewebproxy Wi-Fi 127.0.0.1 1080
networksetup -setwebproxystate Wi-Fi on
networksetup -setsecurewebproxystate Wi-Fi on
export http_proxy="http://127.0.0.1:1080"
export https_proxy="http://127.0.0.1:1080"

# clear proxy
networksetup -setwebproxystate Wi-Fi off
networksetup -setsecurewebproxystate Wi-Fi off
export http_proxy=""
export https_proxy=""
export JAVA_OPTS="$JAVA_OPTS -DsocksProxyPort"
echo done

# mount nfs
sudo mount -o hard,intr,rsize=8192,wsize=8192,bg,tcp example.com:/apps /System/Volumes/Data/build/apps
