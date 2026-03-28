# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export ZSH="/Users/humphreyahn/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-completions)

source $ZSH/oh-my-zsh.sh
autoload -U compinit && compinit

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
export PATH=$PWD/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/humphreyahn/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/humphreyahn/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/humphreyahn/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/humphreyahn/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/Users/humphreyahn/devs/personal/dbt-yaml-builder/bin:$PATH"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
export PATH="/usr/local/opt/libpq/bin:$PATH"

# aliases
alias k="kubectl"
alias glr="gl --rebase"
alias cc="claude"
alias ccd="claude --dangerously-skip-permissions"
alias cca="claude --permissions auto"

