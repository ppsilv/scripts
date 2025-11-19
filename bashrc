# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
. "$HOME/.cargo/env"
export PICO_SDK_PATH=/home/pdsilva/projects/pico-sdk
export PICO_SDK_PATH=/home/pdsilva/pico/pico-sdk
export PICO_EXAMPLES_PATH=/home/pdsilva/pico/pico-examples
export PICO_EXTRAS_PATH=/home/pdsilva/pico/pico-extras
export PICO_PLAYGROUND_PATH=/home/pdsilva/pico/pico-playground

echo "Escolha no .bashrc"
export PATH=/usr/local/bin:/home/pdsilva/.rustup/toolchains/1.81-x86_64-unknown-linux-gnu/bin:$PATH
if [ -f ~/GCC_M68K_enable ]; then
    echo "GCC M68K"
export PATH=.:/home/pdsilva/bin:/home/pdsilva/bin/usr/local/bin:/home/pdsilva/bin/usr/local/m68k-uclinux/bin:$PATH
export PATH=${PATH}:${HOME}/z88dk/bin
export ZCCCFG=${HOME}/z88dk/lib/config
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
elif [ -f ~/GCC_NORMAL_enable ];then
    echo "GCC NORMAL"
export PATH=.:/home/pdsilva/bin:/usr/bin:/usr/sbin:/bin:/usr/local/bin:/home/pdsilva/.rustup/toolchains/1.81-x86_64-unknown-linux-gnu/bin
elif [ -f ~/GCC_472_enable ];then
    echo "gcc (GCC) 4.7.2"
export PATH=.:/home/pdsilva/bin:$PATH
else
    echo "VOCE PRECISA HABILITAR UMA VERSAO DE GCC"
fi
export WATCOM=/usr/bin/watcom
#export PATH=/home/pdsilva/bin/gcc-1.27/bin:$WATCOM/binl64:$WATCOM/binl:$PATH
#export PATH=/home/pdsilva/gcc-ia16_A/bin:$WATCOM/binl64:$WATCOM/binl:$PATH
export EDPATH=$WATCOM/eddat
export INCLUDE=$WATCOM/lh
export LD_LIBRARY_PATH=
export QT_QPA_PLATFORM=wayland
#/opt/Qt/6.9.1/gcc_64
#/opt/Qt/Tools/QtCreator/bin
#/opt/Qt/Tools/QtCreator/lib/Qt/lib
#Configurando QT6
export QT6_PATH=/opt/Qt/6.9.1
export PATH="$QT6_PATH/gcc_64/bin:/opt/Qt/Tools/QtCreator/bin:$PATH"
export LD_LIBRARY_PATH="$QT6_PATH/../Tools/QtCreator/lib/Qt/lib:/opt/Qt/Tools/QtCreator/lib:$LD_LIBRARY_PATH"
export QT_PLUGIN_PATH="$QT6_PATH/plugins"
export QML2_IMPORT_PATH="$QT6_PATH/gcc_64/qml"

export QT_SELECT=qt6
#needed by FreeCad
export QT_QPA_PLATFORM=xcb



