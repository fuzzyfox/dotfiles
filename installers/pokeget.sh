#!/usr/bin/env bash
if which curl >/dev/null 2>&1; then
	curl -s https://raw.githubusercontent.com/talwat/pokeget/master/pokeget -o "$HOME/.local/bin/pokeget"
else
	wget -q https://raw.githubusercontent.com/talwat/pokeget/master/pokeget -O "$HOME/.local/bin/pokeget"
fi
chmod +x "$HOME/.local/bin/pokeget"
