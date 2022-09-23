#
# Tmux
#

if [ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ] && [ -z "$TMUX" ] # When zsh is started attach to current tmux session or create a new one
then
    tmux attach -t TMUX || tmux new -s TMUX
    exit 0
fi

#
# Neovim
#

export EDITOR="nvim"
alias vim="nvim"

#
# Oh-my-zsh
#

export ZSH="$HOME/.oh-my-zsh"

SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true # Show prefix before first line in prompt
ZSH_THEME="spaceship" # Set theme

plugins=(
  git # https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git
  git-extras
  node
  npm
  nvm
  docker
  docker-compose
  laravel
  extract
  fasd
  aws
  #history-substring-search # ZSH port of Fish history search. Begin typing command, use up arrow to select previous use
  zsh-autosuggestions # Suggests commands based on your history
  zsh-completions # More completions
  zsh-syntax-highlighting # Fish shell like syntax highlighting for Zsh
  colored-man-pages # Self-explanatory
  )
autoload -U compinit && compinit # reload completions for zsh-completions

source $ZSH/oh-my-zsh.sh # required

# Colorize autosuggest
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

#
# Spaceship-prompt
#

# Spaceship-prompt customization
SPACESHIP_PROMPT_ORDER=(
dir             # Current directory section
user            # Username section
host            # Hostname section
git             # Git section (git_branch + git_status)
time          # Time stampts section
# hg            # Mercurial section (hg_branch  + hg_status)
package       # Package version
node          # Node.js section
# ruby          # Ruby section
# elixir        # Elixir section
# xcode         # Xcode section
# swift         # Swift section
# golang        # Go section
php           # PHP section
# rust          # Rust section
# haskell       # Haskell Stack section
# julia         # Julia section
docker        # Docker section
# aws           # Amazon Web Services section
# venv          # virtualenv section
# conda         # conda virtualenv section
# pyenv         # Pyenv section
# dotnet        # .NET section
# ember         # Ember.js section
# kubecontext   # Kubectl context section
exec_time       # Execution time
line_sep        # Line break
battery         # Battery level and status
vi_mode         # Vi-mode indicator
jobs            # Background jobs indicator
# exit_code     # Exit code section
char            # Prompt character
)

SPACESHIP_DIR_PREFIX="%{$fg[blue]%}┌─[%b "
SPACESHIP_DIR_SUFFIX="%{$fg[blue]%} ] "
SPACESHIP_CHAR_SYMBOL="%{$fg[blue]%}└─▪%b "
SPACESHIP_CHAR_SYMBOL_ROOT=$SPACESHIP_CHAR_SYMBOL

#
# Other
#

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

#
# Path
#
export PATH=$PATH:/usr/local/sbin:$HOME/.local/bin

#
# Aliases
#
if [ -f "$HOME/.zsh_aliases" ]
then
	source $HOME/.zsh_aliases
fi

#
# Functions
#
if [ -f "$HOME/.zsh_functions" ]
then
	source $HOME/.zsh_functions
fi

#
# Homebrew
#
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]
then
	eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

#
# WSL
#
if grep -q microsoft /proc/version
then
	# Export WSL host IP
	export WSL_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')

	# Configure ssh forwarding
	export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

	# need `ps -ww` to get non-truncated command for matching
	# use square brackets to generate a regex match for the process we want, but that doesnt match the grep process
	ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
	if [[ $ALREADY_RUNNING != "0" ]]
	then
		if [[ -S $SSH_AUTH_SOCK ]]
		then
			# not expecting the socket to exist as forwarding command isnt running (http://www.tldp.org/LDP/abs/html/fto.html)
			echo "removing previous socket..."
			rm $SSH_AUTH_SOCK
		fi

		echo "Starting ssh-agent relay..."
		# setsid to force new session to keep running
		# set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
		(setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
	fi

	# Redirect display to X410
	if nc -z -w 1 "$WSL_HOST" 6000; then
		export DISPLAY="$WSL_HOST:0"
	else
		export DISPLAY=
	fi

	# Set default browser to host
	export BROWSER=wslview
fi

#
# NeoFetch
#
if which neofetch >/dev/null 2>&1; then
	neofetch
fi

#
# LESS COLORS
#
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

#
# Local Machine Only
#
if [ -f "$HOME/.zshrc.local" ]; then
	source "$HOME/.zshrc.local"
fi

#
# Variables
#
export WTTR_PARAMS="2 q F"
