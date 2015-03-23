# scm
export EDITOR='vim'

export FIG_REMOTE_URL="ftp://devnas/builds/Fig/repos"

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
export GOPATH="$HOME/code/gocode"
export PATH="$PATH:${GOROOT}/bin:${GOPATH}/bin"

# vpn
export PATH="/opt/cisco/vpn/bin:$PATH"

# yourkit
export PATH="/opt/yourkit/current/bin:$PATH"

# intellij
export PATH="/opt/intellij/current/bin:$PATH"
