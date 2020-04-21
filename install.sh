#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

dotfiles_dir=$HOME/.dotfiles

symlink_dotfiles() {
	echo "Ensuring symlinks exist"
	find "$dotfiles_dir" -type f -name ".*" -exec ln -sf {} "$HOME" \; >/dev/null 2>&1
}

# Update dotfiles instead of install
if [[ $* == *--update* ]]; then
	echo "Updating dotfiles"
	git pull origin master
	symlink_dotfiles
	exit 0
fi

if [ "$DIR" = "$dotfiles_dir" ]; then
	echo "Already installed. Did you mean:"
	echo ""
	echo "	$0 --update"
	exit 1
fi

# Run noobs-term installation
if which curl 2>/dev/null; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/aaronkjones/noobs-term/master/noobs-term.sh)"
else
	sh -c "$(wget -q https://raw.githubusercontent.com/aaronkjones/noobs-term/master/noobs-term.sh -O -)"
fi

# Install additional cli utilities
if [ "$(uname)" = 'Darwin' ]; then
	brew install htop httpie archey fasd gcc php composer gibo pandoc screen
	echo "Installing FiraCode"
	git clone https://github.com/tonsky/FiraCode.git --depth=1
	cp FiraCode/distr/otf/*.otf ~/Library/Fonts
	rm -rf FiraCode
elif [ "$(uname)" = 'Linux' ]; then
	if which apt-get 2>/dev/null; then
		sudo add-apt-repository -y ppa:aacebedo/fasd
		sudo apt-get update
		sudo apt-get install -y htop httpie php screen pandoc fonts-firacode
	fi
fi

echo "Overwriting noobs-term .dotfiles dir"
rm -rf "$dotfiles_dir"
mv $HOME/dotfiles $dotfiles_dir

echo "Linking additional configs"
symlink_dotfiles


echo ""
echo "[OPTIONAL] Add the following line to ~/.ssh/config to enable VCS specific ssh configurations"
echo ""
echo "	Include ~/.dotfiles/.ssh/config"
echo ""
echo "---------------------"
echo "Installation complete"
echo "---------------------"

