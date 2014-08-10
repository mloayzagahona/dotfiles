BASE_DIR = $(HOME)
SOURCES = .bash_aliases .bash_profile .bashrc .bashrc.ubuntu .gitconfig .tmux.conf .vimrc bin .i3 .vim .emacs.d
DOTFILES = $(addprefix $(BASE_DIR)/,$(SOURCES))
PACKAGES = vim curl emacs24 emacs24-el emacs24-common-non-dfsg i3 fonts-inconsolata xfce4-terminal tmux tig python2.7 python-virtualenv python-pip ipython ipython-notebook inotify-tools ack-grep google-chrome-stable oracle-jdk7-installer gksu nmap inxi redshift-gtk valgrind alleyoop mercurial wireshark

SANDBOX = $(BASE_DIR)/sandbox
GO3RD = $(SANDBOX)/go3rd
GOCODE = $(SANDBOX)/gocode
GOVERSION = go1.3.linux-amd64
VIM_BUNDLES = $(BASE_DIR)/.vim/bundle/ctrlp $(BASE_DIR)/.vim/bundle/nerdcommenter $(BASE_DIR)/.vim/bundle/nerdtree $(BASE_DIR)/.vim/bundle/snipmate $(BASE_DIR)/.vim/bundle/vim-surround
PIP_INSTALLS = i3-py

all: signingkeys ppas $(PACKAGES) $(PIP_INSTALLS) backup $(DOTFILES) vim-bundles golang gocode leiningen

packages: $(PACKAGES)

$(PACKAGES):
	@echo $@
	@if ! dpkg -s $@ > /dev/null; then sudo apt-get install $@ -y; fi
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
	@for d in $(VIM_BUNDLES) ; do echo refreshing $$d && cd $$d && git pull 1> /dev/null 2>&1; done

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

gocode: golang
	go get -u code.google.com/p/rog-go/exp/cmd/godef
	go get -u github.com/nsf/gocode
.PHONY: gocode

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

signingkeys:
	-test -z "sudo apt-key list | grep 'Google, Inc\. Linux Package Signing Key'" && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
.PHONY: signingkeys

ppas:
	-test -z "`find /etc/apt/sources.list.d/ -name 'ubuntu-elisp*'`" && sudo apt-add-repository ppa:ubuntu-elisp/ppa
	-test -z "`find /etc/apt/sources.list.d/ -name 'webupd8team*'`" && sudo apt-add-repository ppa:webupd8team/java
	-test ! -e /etc/apt/sources.list.d/google.list && sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
	-sudo apt-get update
.PHONY: ppas

# leiningen

$(BASE_DIR)/bin/lein:
	curl -o $@ https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
	chmod +x $@
	touch $@

leiningen: $(BASE_DIR)/bin/lein
.PHONY: leiningen
