BASE_DIR = $(HOME)
SOURCES = .bash_aliases .bash_profile .bashrc .bashrc.ubuntu .gitconfig .tmux.conf .vimrc bin .i3 .vim .emacs-live.el
DOTFILES = $(addprefix $(BASE_DIR)/,$(SOURCES))
EMACS_LIVE = $(BASE_DIR)/.emacs.d
LIVE_PACKS = $(BASE_DIR)/.live-packs
PACKAGES = emacs24 i3 ttf-inconsolata xfce4-terminal google-chrome tmux tig python2.7 python-virtualenv python-pip ipython ipython-notebook inotify-tools ack-grep
SANDBOX = $(BASE_DIR)/sandbox
GO3RD = $(SANDBOX)/go3rd
GOCODE = $(SANDBOX)/gocode
VIM_BUNDLES = $(BASE_DIR)/.vim/bundle/command-t $(BASE_DIR)/.vim/bundle/nerdcommenter $(BASE_DIR)/.vim/bundle/nerdtree $(BASE_DIR)/.vim/bundle/snipmate $(BASE_DIR)/.vim/bundle/vim-surround
EMACS_REPOS = $(EMACS_LIVE) $(LIVE_PACKS)/gjones-pack $(LIVE_PACKS)/solarized-pack

all: ppas $(PACKAGES) backup $(DOTFILES) emacs-live golang dropbox leiningen

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

$(BASE_DIR)/go1.1.2.linux-amd64.tar.gz:
	curl -o $@ https://go.googlecode.com/files/go1.1.2.linux-amd64.tar.gz

$(BASE_DIR)/go: $(BASE_DIR)/go1.1.2.linux-amd64.tar.gz
	tar xzvf $^ -C $(BASE_DIR) 
	touch $@

golang: $(BASE_DIR)/go $(GO3RD) $(GOCODE)
.PHONY: golang

# Vim stuff

$(BASE_DIR)/.vim/bundle/command-t:
	git clone git://git.wincent.com/command-t.git $@
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

ppas:
	-test -z "`find /etc/apt/sources.list.d/ -name 'cassou-emacs*'`" && sudo apt-add-repository ppa:cassou/emacs && sudo apt-get update
.PHONY: ppas

# dropbox

$(BASE_DIR)/.dropbox-dist:
	cd $(BASE_DIR) && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
	touch $@

dropbox: $(BASE_DIR)/.dropbox-dist
.PHONY: dropbox

# leiningen

$(BASE_DIR)/bin/lein:
	curl -o $@ https://raw.github.com/technomancy/leiningen/stable/bin/lein
	chmod +x $@
	touch $@

leiningen: $(BASE_DIR)/bin/lein
.PHONY: leiningen
