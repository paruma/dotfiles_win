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