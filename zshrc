[ -f ~/.zsh/zshrc_local_pre.zsh ] && . ~/.zsh/zshrc_local_pre.zsh

######################################################## KEYBOARD MAGIC ########################################################
# TODO: where dit it come from and do I need that?
# Keys.
case $TERM in
    rxvt*|xterm*)
        bindkey "^[[7~" beginning-of-line #Home key
        bindkey "^[[8~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward #Up Arrow
        bindkey "^[[B" history-beginning-search-forward #Down Arrow
        bindkey "^[Oc" forward-word # control + right arrow
        bindkey "^[Od" backward-word # control + left arrow
        bindkey "^H" backward-kill-word # control + backspace
        bindkey "^[[3^" kill-word # control + delete
    ;;

    linux)
        bindkey "^[[1~" beginning-of-line #Home key
        bindkey "^[[4~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward
        bindkey "^[[B" history-beginning-search-forward
    ;;

    screen|screen-*)
        bindkey "^[[1~" beginning-of-line #Home key
        bindkey "^[[4~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward #Up Arrow
        bindkey "^[[B" history-beginning-search-forward #Down Arrow
        bindkey "^[Oc" forward-word # control + right arrow
        bindkey "^[OC" forward-word # control + right arrow
        bindkey "^[Od" backward-word # control + left arrow
        bindkey "^[OD" backward-word # control + left arrow
        bindkey "^H" backward-kill-word # control + backspace
        bindkey "^[[3^" kill-word # control + delete
    ;;
esac

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete
bindkey '^[^M' self-insert-unmeta
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey -v

############################################################ PROMPT ############################################################
# see https://ss64.com/bash/syntax-colors.html
fgColor=${fgColor:-027}
bgColor=${bgColor:-008}
bfgColor=${bfgColor:-021}

precmd ()
{
    local branch="$(git branch 2>/dev/null |grep '*' 2>/dev/null |sed -e 's/^\*[[:space:]]*//' |sed 's/detached from //' |cut -c -16)"

    if [ $LINES -gt 35 ]; then
        local workdir=`pwd`
        if [ ${#workdir} -gt $((COLUMNS-64)) ]; then
            local workdir=`ShortenPWD $((COLUMNS-64)) 1:1 "$workdir"`
        fi
        PROMPT='
%K{'$bgColor'}%F{'$bfgColor'}<<[ %! | '${branch}' ]>> :: %D{%F %T}  :: '$workdir' %E
%K{'$bgColor'}%F{'$bfgColor'}>>>%k%F{'$fgColor'}%n@%M%B%#%b%f '
        PROMPT2='%K{'$bgColor'}%F{'$bfgColor'}>>>%k%n@%M%B%#%b%f '
    else
        PROMPT="%F{$fgColor}[%n@%m %B%1//%b%F{$fgColor} %D{%H:%M:%S}]%B%#%f%b "
    fi
    RPROMPT="%B%(?:%F{green}[^_^]:%F{red}[x_x])  %?%b"
}

function _my-accept-line() {
    zle accept-line
    zle reset-prompt
}
zle -N _my-accept-line
bindkey "^J" _my-accept-line
bindkey "^M" _my-accept-line
bindkey "^O" _my-accept-line

###################################################### VAR/ENV/SHORTCUTS #######################################################
export PATH=":${HOME}/bin:${HOME}/.local/bin:${PATH}"
export EDITOR="vim"
export CXXFLAGS="-Wall -Wextra -std=c++17"

# misc
alias -g '@ca'='--color=always'
alias -g '@!'='>/dev/null 2>/dev/null &!'
alias open="xdg-open"

# filesystem
alias ls="ls --group-directories-first --color=tty --time-style=iso --file-type -h"
alias la="ls -a"
alias ll="ls -l"
alias md="mkdir -p"
alias rd="rmdir"

# git
alias glog="git log --stat --decorate --graph"
function gdlog { git fetch && git log --stat --decorate --reverse "$@" '@{u}'.. }
function gulog { git fetch && git log --stat --decorate --reverse "$@" ..'@{u}' }
alias grc='git rebase --continue'

# command shortcuts
bindkey -s "^[s" ' git status^M'
bindkey -s "^[l" ' ls^M'
bindkey -s "^[L" ' ls -hal^M'
bindkey -s "^[[1;3A" ' ..^M'


######################################################### MISC OPTIONS #########################################################
setopt autocd
setopt interactivecomments
setopt extendedglob
DIRSTACKSIZE=16
# zmv -  a command for renaming files by means of shell patterns.
autoload -U zmv
# Turn on command substitution in the prompt (and parameter expansion and arithmetic expansion).
setopt promptsubst
# History
setopt histignorealldups
setopt histignorespace
unsetopt sharehistory
HISTFILE="$HOME/.zsh_history"
SAVEHIST="10000"
HISTSIZE="10000"

# Completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'


############################################################ PLUGIN ############################################################
# https://github.com/zsh-users/zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# https://github.com/zsh-users/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# https://github.com/junegunn/fzf
if [[ ! "$PATH" == *$HOME/.zsh/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/.zsh/fzf/bin"
fi
source <(fzf --zsh)
# https://github.com/direnv/direnv  (optional)
type direnv >/dev/null && eval "$(direnv hook zsh)"

############################################################# END ##############################################################

[ -f ~/.zsh/zshrc_local_post.zsh ] && . ~/.zsh/zshrc_local_post.zsh
