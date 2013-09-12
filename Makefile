BASE_DIR = $(HOME)/foo
SOURCES = .bash_aliases .bash_profile .bashrc .bashrc.ubuntu .gitconfig .tmux.conf .vimrc bin .i3 .vim .emacs-live.el
DOTFILES = $(addprefix $(BASE_DIR)/,$(SOURCES))
EMACS_LIVE = $(BASE_DIR)/.emacs.d
LIVE_PACKS = $(BASE_DIR)/.live-packs
PACKAGES = emacs24 i3 ttf-inconsolata xfce4-terminal
SANDBOX = $(BASE_DIR)/sandbox
GO3RD = $(SANDBOX)/go3rd
GOCODE = $(SANDBOX)/gocode

all: ppas $(PACKAGES) backup $(DOTFILES) emacs-live golang

$(PACKAGES):
	if [ -z "`dpkg -l | grep $@`" ]; then sudo apt-get install $@; fi
.PHONY: $(PACKAGES)

backup:
	@for f in $(DOTFILES); do \
		if [ -h $$f ]; \
		then \
			unlink $$f; \
		elif [ -f $$f ]; \
		then \
			mv $$f $$f.bak; \
		fi \
	done
.PHONY: backup

$(SANDBOX):
	mkdir -p $@

$(GO3RD):
	mkdir -p $@

$(GOCODE):
	mkdir -p $@

$(DOTFILES):
	ln -s $(realpath $(notdir $@)) $@ 

$(BASE_DIR)/go1.1.2.linux-amd64.tar.gz:
	curl -o $@ https://go.googlecode.com/files/go1.1.2.linux-amd64.tar.gz

$(BASE_DIR)/go: $(BASE_DIR)/go1.1.2.linux-amd64.tar.gz
	tar xzvf $^ -C $(BASE_DIR) 
	touch $@

golang: $(BASE_DIR)/go $(GO3RD) $(GOCODE)
.PHONY: golang

emacs-live: $(EMACS_LIVE) $(LIVE_PACKS) $(LIVE_PACKS)/gjones-pack $(LIVE_PACKS)/solarized-pack
.PHONY: emacs-live

update-emacs-live:
	cd $(EMACS_LIVE) && git pull
	cd $(LIVE_PACKS)/gjones-pack && git pull
	cd $(LIVE_PACKS)/solarized-pack && git pull

$(LIVE_PACKS):
	mkdir -p $@

$(EMACS_LIVE):
	git clone git@github.com:overtone/emacs-live.git $@

$(LIVE_PACKS)/gjones-pack:
	git clone git@github.com:gar3thjon3s/live-pack.git $@

$(LIVE_PACKS)/solarized-pack:
	git clone git@github.com:siancu/solarized-pack.git $@

ppas:
	-test -z "`find /etc/apt/sources.list.d/ -name 'cassou-emacs*'`" && sudo apt-add-repository ppa:cassou/emacs && sudo apt-get update
.PHONY: ppas
