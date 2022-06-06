#!/bin/bash

echo "Setting up your Mac..."

echo "Checking Architecture"

arch_name="$(uname -m)"
 
if [ "${arch_name}" = "x86_64" ]; then
    if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        echo "Running on Rosetta 2"
    else
        echo "Running on native Intel"
    fi 
elif [ "${arch_name}" = "arm64" ]; then
    echo "Running on ARM"
else
    echo "Unknown architecture: ${arch_name}"
fi

# Check for M1 ARM architecture and install Rosetta 2
if [ "${arch_name}" = "arm64" ]; then
    if ! [ $(/usr/bin/pgrep oahd >/dev/null 2>&1;echo $?) -eq 0 ]; then
        echo "Installing Rosetta 2 for X86_64 emulation"
        softwareupdate --install-rosetta --agree-to-license
    else
        echo "Rosetta 2 already installed"
    fi
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle

if [ "${arch_name}" = "arm64" ]; then
   echo "Installing Brewfile.arm64"
   brew bundle install --file=Brewfile.arm64
else 
   echo "Installing Brewfile"
   brew bundle
fi 

# Set default MySQL root password and auth type.
# mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"

# Clone Github repositories
# ./clone.sh

# Install Oh My Zsh
if [ -d $HOME/.oh-my-zsh ]; then
	echo "Oh My ZSH is installed"
 else
 	echo "Oh My ZSH is not installed... beginning install"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Backup .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
if ! [ -f $HOME/.zshrc.backup ]  &&  ! [ -L $HOME/.zshrc ]; then
    echo "Backup .zshrc to .zshrc.backup"
    mv $HOME/.zshrc $HOME/.zshrc.backup
fi

# Setup ZSH
if ! [ -L $HOME/.zshrc ]; then
    ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
fi

# Install our custom Solarized Dark Profile to terminal
echo "Installing Solarized Dark Theme"
theme=$(<./terminal/Solarized%20Dark.terminal)
plutil -replace Window\ Settings.Solarized\ Dark -xml "$theme" ~/Library/Preferences/com.apple.Terminal.plist
defaults write com.apple.Terminal "Default Window Settings" -string "Solarized Dark"
defaults write com.apple.Terminal "Startup Window Settings" -string "Solarized Dark"
defaults write com.apple.Terminal "NSWindow Frame TTWindow Solarized Dark" -string  "163 195 1210 884 0 0 1728 1079 "

# Git SCM Configuration
if ! [ -L $HOME/.gitignore_global ]; then
    ln -s $HOME/.dotfiles/.gitignore_global $HOME/.gitignore_global
fi

# Mercurial (Hg) SCM Configuration
if ! [ -L $HOME/.hgrc ]; then
    ln -s $HOME/.dotfiles/.hgrc $HOME/.hgrc
fi

if ! [ -L $HOME/.hgignore_global ]; then
    ln -s $HOME/.dotfiles/.hgignore_global $HOME/.hgignore_global
fi

# Xcode License and reset develer tools 
sudo xcodebuild -license accept
sudo xcode-select -r 

# Update global git config
git lfs install
# Update system git config
sudo git lfs install --system

# Install Powerline Fonts
echo "Installing Poweline Fonts"
if ! [ -d ./fonts ]; then
    git clone https://github.com/powerline/fonts.git --depth=1
fi
cd fonts
./install.sh
cd ..
rm -rf fonts
echo "Updating Terminal Solarized Dark Profile font to use Powerline Font"
font=$(<./terminal/font.xml)
plutil -replace  Window\ Settings.Solarized\ Dark.Font -xml "$font" ~/Library/Preferences/com.apple.Terminal.plist

# Quit System Preferences before updating macOS preferences.
killall System\ Preferences > /dev/null 2>&1


# Install Docker
if [ "${arch_name}" = "arm64" ]; then 
    if ! [ -d /Applications/Docker.app ]; then
        echo "Installing Docker for Arm" \
        && curl -OL --output-dir $HOME/Downloads https://desktop.docker.com/mac/main/arm64/Docker.dmg \
        && sudo hdiutil attach $HOME/Downloads/Docker.dmg \
        && sudo cp -R /Volumes/Docker/Docker.app /Applications \
        && sudo hdiutil unmount /Volumes/Docker \
        && rm $HOME/Downloads/Docker.dmg \
        && echo "Docker installed"
    else 
        echo "Docker for Arm is installed"
    fi
elif [ "${arch_name}" = "x86_64" ]; then
    if ! [ -d /Applications/Docker.app ]; then
        echo "Installing Docker for Intel" \
        && curl -OL --output-dir $HOME/Downloads https://desktop.docker.com/mac/main/amd64/Docker.dmg \
        && sudo hdiutil attach $HOME/Downloads/Docker.dmg \
        && sudo cp -R /Volumes/Docker/Docker.app /Applications \
        && sudo hdiutil unmount /Volumes/Docker \
        && rm $HOME/Downloads/Docker.dmg \
        && echo "Docker installed"
     else 
        echo "Docker for Intel is installed"
    fi
fi


# Set macOS preferences
# We will run this last because this will reload the shell
# source .macos
