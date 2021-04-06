# Alias
PS1='[\u@\h \W]\$ '
alias doomsync="killall -9 emacs; $HOME/.emacs.d/bin/doom sync; nohup emacs & disown; sleep 2 && rm nohup.out; kill -9 $$"
alias doomupgrade="killall -9 emacs; yes | $HOME/.emacs.d/bin/doom upgrade; nohup emacs & disown; sleep 2 && rm nohup.out; kill -9 $$"
alias emc="emacsclient -t -a ''"
alias gwe="sudo nvidia-smi -pl 200; gwe"
alias ls="exa -abhl"
alias matlab="ogdir=$PWD; cd ~/Sync/University; matlab -nosplash; cd $ogdir"

# Export
export EDITOR="emacsclient -t -a ''"
export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'
export VISUAL="emacsclient -t -a emacs"

# Path
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Truecolor and Italic support
alias ssh="TERM=xterm-256color ssh"
export TERM=xterm-24bit
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# History
setopt HIST_IGNORE_DUPS
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Initiate Pure
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

# Tab hightlight
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit && compinit
zmodload -i zsh/complist
zstyle ':completion:*' menu select

# Fix capitalization errors.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'    # Lower to upper
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Upper to lower

# Load zsh plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set vi keybindings
bindkey -v
bindkey jk vi-cmd-mode
bindkey "^?" backward-delete-char

## Change cursor shape for different vi modes.
function zle-keymap-select {
   if [[ ${KEYMAP} == vicmd ]] ||
         [[ $1 = 'block' ]]; then
      echo -ne '\e[1 q'

   elif [[ ${KEYMAP} == main ]] ||
           [[ ${KEYMAP} == viins ]] ||
           [[ ${KEYMAP} = '' ]] ||
           [[ $1 = 'beam' ]]; then
      echo -ne '\e[5 q'
   fi
}
zle -N zle-keymap-select

## Use beam shape cursor for each new prompt.
_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)

## Yank command
function x11-clip-wrap-widgets() {
    # NB: Assume we are the first wrapper and that we only wrap native widgets
    # See zsh-autosuggestions.zsh for a more generic and more robust wrapper
    local copy_or_paste=$1
    shift

    for widget in $@; do
        # Ugh, zsh doesn't have closures
        if [[ $copy_or_paste == "copy" ]]; then
            eval "
            function _x11-clip-wrapped-$widget() {
                zle .$widget
                xclip -in -selection clipboard <<<\$CUTBUFFER
            }
            "
        else
            eval "
            function _x11-clip-wrapped-$widget() {
                CUTBUFFER=\$(xclip -out -selection clipboard)
                zle .$widget
            }
            "
        fi

        zle -N $widget _x11-clip-wrapped-$widget
    done
}


local copy_widgets=(
    vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line
)
local paste_widgets=(
    vi-put-{before,after}
)

x11-clip-wrap-widgets copy $copy_widgets
x11-clip-wrap-widgets paste  $paste_widgets
