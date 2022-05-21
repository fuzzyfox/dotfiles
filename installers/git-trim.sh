#!/usr/bin/env bash
if which curl >/dev/null 2>&1; then
	curl -s https://raw.githubusercontent.com/jasonmccreary/git-trim/main/git-trim -o $HOME/.local/bin/git-trim
else
	wget -q https://raw.githubusercontent.com/jasonmccreary/git-trim/main/git-trim -O $HOME/.local/bin/git-trim
fi
chmod +x "$HOME/.local/bin/git-trim"
