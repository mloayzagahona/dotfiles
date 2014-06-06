BASE_DIR = $(HOME)
SOURCES = .bash_aliases .bash_profile .bashrc .bashrc.ubuntu .gitconfig .tmux.conf .vimrc bin .i3 .vim .emacs-live.el
DOTFILES = $(addprefix $(BASE_DIR)/,$(SOURCES))
EMACS_LIVE = $(BASE_DIR)/.emacs.d
LIVE_PACKS = $(BASE_DIR)/.live-packs
PACKAGES = vim curl emacs24 i3 fonts-inconsolata xfce4-terminal tmux tig python2.7 python-virtualenv python-pip ipython ipython-notebook inotify-tools ack-grep chromium-browser oracle-jdk7-installer
SANDBOX = $(BASE_DIR)/sandbox
GO3RD = $(SANDBOX)/go3rd
GOCODE = $(SANDBOX)/gocode
GOVERSION = go1.2.2.linux-amd64
VIM_BUNDLES = $(BASE_DIR)/.vim/bundle/ctrlp $(BASE_DIR)/.vim/bundle/nerdcommenter $(BASE_DIR)/.vim/bundle/nerdtree $(BASE_DIR)/.vim/bundle/snipmate $(BASE_DIR)/.vim/bundle/vim-surround
EMACS_REPOS = $(EMACS_LIVE) $(LIVE_PACKS)/gjones-pack $(LIVE_PACKS)/solarized-pack
PIP_INSTALLS = i3-py

all: ppas $(PACKAGES) $(PIP_INSTALLS) backup $(DOTFILES) vim-bundles emacs-live golang leiningen

packages: $(PACKAGES)

$(PACKAGES):
	@echo $@
	@if ! dpkg -s $@ > /dev/null; then sudo apt-get install $@; fi
.PHONY: $(PACKAGES)

$(PIP_INSTALLS):
	@echo $@
	@sudo pip install $@ --exists-action i
.PHONY: $(PIP_INSTALLS)

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

refresh:
	@for d in $(VIM_BUNDLES) $(EMACS_REPOS); do echo refreshing $$d && cd $$d && git pull 1> /dev/null 2>&1; done

# Code dirs

$(SANDBOX):
	mkdir -p $@

$(GO3RD):
	mkdir -p $@

$(GOCODE):
	mkdir -p $@

$(DOTFILES):
	ln -s $(realpath $(notdir $@)) $@

# Golang

$(BASE_DIR)/$(GOVERSION).tar.gz:
	curl -o $@ https://storage.googleapis.com/golang/$(GOVERSION).tar.gz

$(BASE_DIR)/go: $(BASE_DIR)/$(GOVERSION).tar.gz
	tar xzvf $^ -C $(BASE_DIR)
	touch $@

golang: $(BASE_DIR)/go $(GO3RD) $(GOCODE)
.PHONY: golang

# Vim stuff

$(BASE_DIR)/.vim/bundle/ctrlp:
	git clone https://github.com/kien/ctrlp.vim.git $@
	touch $@

$(BASE_DIR)/.vim/bundle/nerdcommenter:
	git clone http://github.com/scrooloose/nerdcommenter.git $@
	touch $@

$(BASE_DIR)/.vim/bundle/nerdtree:
	git clone http://github.com/scrooloose/nerdtree.git $@
	touch $@

$(BASE_DIR)/.vim/bundle/snipmate:
	git clone http://github.com/msanders/snipmate.vim.git $@
	touch $@

$(BASE_DIR)/.vim/bundle/vim-surround:
	git clone http://github.com/tpope/vim-surround.git $@
	touch $@

vim-bundles: $(VIM_BUNDLES)
.PHONY: vim-bundles

# Emacs

emacs-live: $(EMACS_LIVE) $(LIVE_PACKS) $(LIVE_PACKS)/gjones-pack $(LIVE_PACKS)/solarized-pack
.PHONY: emacs-live

$(LIVE_PACKS):
	mkdir -p $@

$(EMACS_LIVE):
	git clone git@github.com:overtone/emacs-live.git $@

$(LIVE_PACKS)/gjones-pack:
	git clone git@github.com:gar3thjon3s/live-pack.git $@

$(LIVE_PACKS)/solarized-pack:
	git clone git@github.com:siancu/solarized-pack.git $@
	cd $@ && git submodule update --init

ppas:
	-test -z "`find /etc/apt/sources.list.d/ -name 'cassou-emacs*'`" && sudo apt-add-repository ppa:cassou/emacs && sudo apt-get update
	-test -z "`find /etc/apt/sources.list.d/ -name 'webupd8team*'`" && sudo apt-add-repository ppa:webupd8team/java && sudo apt-get update
.PHONY: ppas

# leiningen

$(BASE_DIR)/bin/lein:
	curl -o $@ https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
	chmod +x $@
	touch $@

leiningen: $(BASE_DIR)/bin/lein
.PHONY: leiningen
