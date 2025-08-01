# Created by newuser for 5.8
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# ==== prezto ====
# autoload -Uz promptinit
# promptinit
# prompt pure

# ==== Starship ====
eval "$(starship init zsh)"

# ==== zsh-syntax-highlighting ====
source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ==== zsh-autosuggestions ====
source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh


# ==== asdf ====
. /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh


# ==== peco ====
# pecoを使って端末操作を爆速にする - Qiita https://qiita.com/reireias/items/fd96d67ccf1fdffb24ed
# history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=100000
export SAVEHIST=1000000

# share .zshhistory
setopt inc_append_history
setopt share_history

function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^E' peco-cdr

# ==== misc ====
export TZ="Asia/Tokyo"


# 参考: Perlで warning: Setting locale failed. と警告された時の対処 - Qiita https://qiita.com/suzuki-navi/items/b5f066db181092543854
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# 【WSL】クリップボードを使ってコピー & ペーストを行う - Qiita https://qiita.com/eyuta/items/b956a376ba719fd30f9f

alias pbcopy="clip.exe"
alias pbpaste="powershell.exe -command 'Get-Clipboard'"
[ -f "/home/paruma/.ghcup/env" ] && source "/home/paruma/.ghcup/env" # ghcup-env



# ~/bin

export PATH=$PATH:~/bin
export PATH=/home/paruma/.volta/bin:$PATH

export PIPENV_VENV_IN_PROJECT=1
source "$HOME/.rye/env"


# タイトル変更
preexec() {
  local -a words=(${(z)1})
  local shown=${(j: :)words[1,3]}
  print -Pn "\e]0;▶ $shown\a"
}

precmd() {
  local short_path
  short_path=$(print -P '%~')

  local parts=(${(s:/:)short_path})
  local len=${#parts}
  local start=$(( len > 3 ? len - 2 : 1 ))
  local last3=${(j:/:)parts[start,len]}

  print -Pn "\e]0;${last3}\a"
}

