# hold key
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# clear proxy
networksetup -setwebproxystate Wi-Fi off
networksetup -setsecurewebproxystate Wi-Fi off
export http_proxy=""
export https_proxy=""
export JAVA_OPTS="$JAVA_OPTS -DsocksProxyPort"
echo done

# mount nfs
sudo mount -o hard,intr,rsize=8192,wsize=8192,bg,tcp example.com:/apps /System/Volumes/Data/build/apps
