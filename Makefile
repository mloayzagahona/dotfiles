BASE_DIR = $(HOME)
SRC_DIR = $(BASE_DIR)/src
SOURCES = .bash_aliases .bash_profile .bashrc .bashrc.ubuntu .gitconfig .tmux.conf .vimrc bin .i3 .vim .emacs.d
DOTFILES = $(addprefix $(BASE_DIR)/,$(SOURCES))
PACKAGES = vim curl emacs24 emacs24-el emacs24-common-non-dfsg i3 fonts-inconsolata xfce4-terminal tmux tig python2.7 python2.7-dev python-virtualenv python-pip ipython ipython-notebook inotify-tools ack-grep google-chrome-stable oracle-jdk7-installer gksu nmap inxi redshift-gtk valgrind alleyoop mercurial bzr

# seem to be having problems with these packages :/
# wireshark wireshark-common

SANDBOX = $(BASE_DIR)/sandbox
GOCODE = $(SANDBOX)/gocode
GOPATH = $(GOCODE)
GOVERSION = go1.3.1.linux-amd64
VIM_BUNDLES = $(BASE_DIR)/.vim/bundle/ctrlp $(BASE_DIR)/.vim/bundle/nerdcommenter $(BASE_DIR)/.vim/bundle/nerdtree $(BASE_DIR)/.vim/bundle/snipmate $(BASE_DIR)/.vim/bundle/vim-surround
PIP_INSTALLS = i3-py
SQL_WORKBENCH = Workbench-Build116.zip
POSTGRES_DRIVER = postgresql-9.3-1102.jdbc41.jar

all: signingkeys ppas $(PACKAGES) $(PIP_INSTALLS) backup $(DOTFILES) vim-bundles golang gocode leiningen suspend-permissions

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

refresh-vim-bundles:
	@for d in $(VIM_BUNDLES) ; do echo refreshing $$d && cd $$d && git pull 1> /dev/null 2>&1; done

# useful if you want to setup wireshark correctly to capture
wireshark:
	sudo dpkg-reconfigure wireshark-common
	sudo usermod -a -G wireshark $$USER
.PHONY: wireshark

# Code dirs

$(GOCODE):
	mkdir -p $@

$(SRC_DIR):
	mkdir -p $@

$(DOTFILES):
	ln -s $(realpath $(notdir $@)) $@

# Golang

$(BASE_DIR)/$(GOVERSION).tar.gz:
	curl -o $@ https://storage.googleapis.com/golang/$(GOVERSION).tar.gz
	touch $@

$(BASE_DIR)/go: $(BASE_DIR)/$(GOVERSION).tar.gz
	tar xzvf $^ -C $(BASE_DIR)
	touch $@

golang: $(BASE_DIR)/go $(GOCODE)
.PHONY: golang

gocode: golang
	GOPATH=$(GOPATH) $(BASE_DIR)/go/bin/go get -u code.google.com/p/rog-go/exp/cmd/godef github.com/nsf/gocode
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

signingkeys:
	-test -z "$(apt-key list | grep 'Google, Inc\. Linux Package Signing Key')" && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
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

# omg sqlworkbench

$(SRC_DIR)/sqlworkbench:
	curl -o $@.zip http://www.sql-workbench.net/$(SQL_WORKBENCH)
	unzip -d $@ $@.zip
	chmod +x $@/sqlworkbench.sh

$(SRC_DIR)/sqlworkbench/$(POSTGRES_DRIVER):
	curl -o $@ http://jdbc.postgresql.org/download/$(POSTGRES_DRIVER)

sqlworkbench: $(SRC_DIR)/sqlworkbench $(SRC_DIR)/sqlworkbench/$(POSTGRES_DRIVER)

/etc/sudoers.d/suspend:
	@sudo bash -c 'echo "${USER} ALL=(ALL) NOPASSWD: /usr/sbin/pm-suspend" > $@'
	@sudo bash -c 'chmod 0440 $@'

suspend-permissions: /etc/sudoers.d/suspend
.PHONY: suspend-permissions
