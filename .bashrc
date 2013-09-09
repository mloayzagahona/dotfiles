# scm
export EDITOR='vim'

# TERM
export TERM='xterm-256color'

if [ -f $HOME/.bashrc.ubuntu ]; then
    source $HOME/.bashrc.ubuntu
fi

if [ -f $HOME/.bash_colors ]; then
  source $HOME/.bash_colors
fi

if [ -f $HOME/.fehbg ]; then
  source $HOME/.fehbg
fi

# git in PS1
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

# golang
export GOROOT=$HOME/go
export GOPATH="$HOME/sandbox/go3rd:$HOME/sandbox/gocode:$HOME/sandbox"
export PATH="$PATH:${GOROOT}/bin"

# add all gopath/bin dirs to path
export PATH="$PATH:${GOPATH//://bin:}/bin"
