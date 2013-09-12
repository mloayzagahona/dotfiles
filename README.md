## Dotfiles

Here live my dotfiles, installed with a Makefile. This file is to help my poor memory. It is (a little) specific to ubuntu and assumes you want to store your code in ~/sandbox and use i3 as your window manager. Will also install golang, leiningen, emacs-live and a bunch of other stuff I find useful.

### Installation

    $ git clone git@github.com:gar3thjon3s/dotfiles.git ~/dotfiles
    $ cd !$
    $ make

### Refreshing

To refresh dependent git repositories (e.g emacs-live, and all vim bundles):

    $ make refresh
