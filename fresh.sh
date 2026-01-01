#!/bin/sh

echo "Setting up your Mac..."

# Hide "last login" line when starting a new terminal session
touch $HOME/.hushlogin

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
  echo "Xcode Command Line Tools not found. Installing..."
  xcode-select --install
else
  echo "Xcode Command Line Tools already installed."
fi

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/usr/local/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Update Homebrew recipes
brew update
brew analytics off

# Install all our dependencies with bundle (See Brewfile)
brew bundle --file ./Brewfile

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/fdellwing/zsh-bat.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-bat

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Add gitconfig
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

# Add global gitignore
ln -s $HOME/.dotfiles/.global-gitignore $HOME/.global-gitignore
#git config --global core.excludesfile $HOME/.global-gitignore

# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Clone Github repositories
./clone.sh

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos
