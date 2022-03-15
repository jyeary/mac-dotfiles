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
#sudo xcodebuild -license accept
#sudo xcode-select -r 

# Update global git config
git lfs install
# Update system git config
sudo git lfs install --system

# Quit System Preferences before updating macOS preferences.
killall System\ Preferences > /dev/null 2>&1

# Set macOS preferences
# We will run this last because this will reload the shell
# source .macos
