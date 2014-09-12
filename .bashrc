# scm
export EDITOR='vim'

# TERM
export TERM='xterm-256color'

if [ -f $HOME/.bashrc.ubuntu ]; then
    source $HOME/.bashrc.ubuntu
fi

if [ -f $HOME/.fehbg ]; then
  source $HOME/.fehbg
fi

# local to machine, not in source control
if [ -f $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local
fi

# git in PS1
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

# golang
export GOROOT=$HOME/go
export GOPATH="$HOME/sandbox/gocode"
export PATH="$PATH:${GOROOT}/bin:${GOPATH}/bin"

