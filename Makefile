BASE_DIR = $(HOME)/foo
SOURCES = .bash_aliases .bash_profile .bashrc .bashrc.ubuntu .gitconfig .tmux.conf .vimrc bin .i3 .vim .emacs-live.el
DOTFILES = $(addprefix $(BASE_DIR)/,$(SOURCES))
EMACS_LIVE = $(BASE_DIR)/.emacs.d
LIVE_PACKS = $(BASE_DIR)/.live-packs
PACKAGES = emacs24 i3 ttf-inconsolata

all: ppas $(PACKAGES) $(DOTFILES) $(EMACS_LIVE) $(LIVE_PACKS) $(LIVE_PACKS)/gjones-pack $(LIVE_PACKS)/solarized-pack

.PHONY: $(PACKAGES)
$(PACKAGES):
	if [ -z "`dpkg -l | grep $@`" ]; then sudo apt-get install $@; fi

$(LIVE_PACKS):
	mkdir -p $@

$(DOTFILES):
	ln -s $(realpath $(notdir $@)) $@ 

$(EMACS_LIVE):
	git clone git@github.com:overtone/emacs-live.git $@

$(LIVE_PACKS)/gjones-pack:
	git clone git@github.com:gar3thjon3s/live-pack.git $@

$(LIVE_PACKS)/solarized-pack:
	git clone git@github.com:siancu/solarized-pack.git $@

.PHONY: ppas
ppas:
	-test -z "`find /etc/apt/sources.list.d/ -name 'cassou-emacs*'`" && sudo apt-add-repository ppa:cassou/emacs && sudo apt-get update
