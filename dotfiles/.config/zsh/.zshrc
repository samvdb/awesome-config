# Example .zshrc file for zsh 4.0
#
# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#

# Search path for the cd command
cdpath=(.. ~)

source $ZDOTDIR/alias
source $ZDOTDIR/prompt
source $ZDOTDIR/hosts
source $ZDOTDIR/functions
source $ZDOTDIR/tty_colors
# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s

umask 022


# Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# экранируем спецсимволы в url, например &, ?, ~ и так далее 
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Some environment variables
PATH+=:$HOME/bin
PATH+=:/usr/local/bin
export PATH
manpath=($X11HOME/man /usr/share/man /usr/man /usr/lang/man /usr/local/man)
export MANPATH
export MAIL=/var/spool/mail/$USERNAME
export LESS=-cix3M
export HELPDIR=/usr/local/lib/zsh/help  # directory for run-help function to find docs
export CDPATH=..:$HOME:/media

MAILCHECK=300
DIRSTACKSIZE=20
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

LANG="ru_RU.UTF-8"
LC_NUMERIC="POSIX"
LC_MESSAGES="POSIX"

# Watch for my friends
#watch=( $(<~/.friends) )       # watch for people in .friends file
watch=(notme)                   # watch for everybody but me
LOGCHECK=300                    # check every 5 min for login/logout activity
WATCHFMT='%n %a %l from %m at %t.'

# Set/unset  shell options
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs appendhistory
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
setopt   nobeep
unsetopt bgnice autoparamslash

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

# Some nice key bindings
#bindkey '^X^Z' universal-argument ' ' magic-space
#bindkey '^X^A' vi-find-prev-char-skip
#bindkey '^Xa' _expand_alias
#bindkey '^Z' accept-and-hold
#bindkey -s '\M-/' \\\\
#bindkey -s '\M-=' \|
bindkey -v                 # vi key bindings
bindkey '^?'    backward-delete-char
bindkey '^[.'   insert-last-word
#bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand
bindkey "^R" history-incremental-search-backward

case $TERM in
 #
 # для системной консоли (/dev/tty*)
 #
 linux|screen|screen.linux|screen.rxvt)

 bindkey "^[[2~" yank
 bindkey "^[[3~" delete-char
 bindkey "^[[5~" up-line-or-history
 bindkey "^[[6~" down-line-or-history
 bindkey "^[[1~" beginning-of-line
 bindkey "^[[4~" end-of-line
 bindkey "^[e" expand-cmd-path      # C-e for expanding path of typed command
 bindkey "^[[A" up-line-or-search   # up arrow for back-history-search
 bindkey "^[[B" down-line-or-search # down arrow for fwd-history-search
 bindkey " "  magic-space           # do history expansion on space
 ;;

 #
 # для X-терминалов
 #
 *xterm*|rxvt|(dt|k|E)term)

 bindkey "^[[2~" yank
 bindkey "^[[3~" delete-char
 bindkey "^[[5~" up-line-or-history
 bindkey "^[[6~" down-line-or-history
 bindkey "^[[7~" beginning-of-line # Клавиша Home
 bindkey "^[[8~" end-of-line # Клавиша End
 bindkey "^E" expand-cmd-path      # C-e добавляет к набираемой команде её
                                   # абсолютный путь
                                   # т.е. например, ls заменяется на /bin/ls.

                                   # Действует аналогично команде `which ls`

 bindkey "^[[A" up-line-or-search  # Стрелка-вверх, пройтись назад по
                                   # истории введённых команд

 bindkey "^[[B" down-line-or-search # Стрелка-вверх, пройтись вперёд по
                                    # истории введённых команд
 bindkey " "  magic-space ## do history expansion on space
 ;;
esac

# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -U compinit
compinit -u

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' matcher-list 'm:{а-я}={А-Я}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro' '*\~'

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

zstyle ':completion:*:default' list-colors '${LS_COLORS}'


eval $(dircolors -b $ZDOTDIR/zcolors)

##vi insert mode like keybindings
##defining something more usable than the defaults vi bindings
##creating two keymaps
#bindkey -N myviins viins
#bindkey -N myvicmd vicmd
#
##defining widgets, to switch between them
#function my_viins_to_vicmd(){print -n "\033]0;zsh\a";bindkey -A myvicmd main}
#function my_vicmd_to_viinsi(){print -n "\033]0;zsh INSERT\a";bindkey -A myviins main}
#function my_vicmd_to_viinsa(){print -n "\033]0;zsh INSERT\a";zle vi-forward-char;bindkey -A myviins main}
#zle -N my_viins_to_vicmd
#zle -N my_vicmd_to_viinsi
#zle -N my_vicmd_to_viinsa
#bindkey -M myviins '^[' my_viins_to_vicmd
#bindkey -M myvicmd 'i' my_vicmd_to_viinsi
#bindkey -M myvicmd 'a' my_vicmd_to_viinsa
#
##Небольшая полезняшка - памятка с текущими привязками:
#
#function list_mappings(){bindkey}; zle -N list_mappings
#bindkey -M myvicmd ':map' list_mappings
#
##сделаем свой режим вставки режимом по умолчанию:
#
##setting my vi-like insert mode by default
#bindkey -A myviins main

