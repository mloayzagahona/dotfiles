(require 'cl)

(add-to-list 'default-frame-alist '(font . "Inconsolata 12"))
(load-theme 'wombat 'no-confirm)

;; i hate bold fonts, make them go away!
(mapc
  (lambda (face)
    (set-face-attribute face nil :weight 'normal :underline nil))
  (face-list))

;; srsly
(defalias 'yes-or-no-p 'y-or-n-p)

(defvar gaz/vendor-dir (concat user-emacs-directory "vendor/"))

;; some nice defaults from phil hagelcheeseberger
(add-to-list 'load-path gaz/vendor-dir)
(require 'better-defaults)

;; yay packages
(load "package")
(package-initialize)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(defvar gaz/packages '(auto-complete
                       ac-slime
                       paredit
                       clojure-mode
                       clojurescript-mode
                       align-cljlet
                       go-mode
                       go-autocomplete
                       go-eldoc
                       magit
                       markdown-mode
                       cider
                       ac-nrepl
                       git-gutter
                       window-number
                       find-file-in-project
                       flx-ido
                       idomenu
                       ido-ubiquitous
                       undo-tree
                       restclient
                       python-environment
                       jedi
                       golden-ratio
                       popwin
                       ;; whitespace-cleanup-mode
                       smooth-scrolling
                       eval-sexp-fu
                       js2-mode
                       ace-jump-mode
                       multiple-cursors
                       volatile-highlights
                       smex
                       elisp-slime-nav
                       git-timemachine))

(catch 'break
  (dolist (p gaz/packages)
    (when (not (package-installed-p p))
      (package-refresh-contents)
      (throw 'break nil))))

(dolist (p gaz/packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; paredit

(dolist (n '(scheme emacs-lisp lisp clojure cider-repl))
  (add-hook (intern (concat (symbol-name n) "-mode-hook")) 'enable-paredit-mode))

;; whitespace
;; (global-whitespace-cleanup-mode t)

;; golang

(add-hook 'before-save-hook #'gofmt-before-save)
(add-hook 'go-mode-hook (lambda ()
                          (local-set-key (kbd "M-.") #'godef-jump)))


(require 'auto-complete-config)
(require 'go-autocomplete)

(require 'go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)
(set-face-attribute 'eldoc-highlight-function-argument nil
                    :underline t :foreground "green"
                    :weight 'bold)

;; popwin
(require 'popwin)
(popwin-mode 1)

;; slime nav
(require 'elisp-slime-nav)
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'turn-on-elisp-slime-nav-mode))

;; ido
(require 'flx-ido)
(setq ido-mode 1)
(setq ido-everywhere 1)

(setq flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; apparently a good idea on modern machines
(setq gc-cons-threshold 20000000)

;; multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; python stuff
(require 'jedi)
(setq jedi:setup-keys t)
(add-hook 'python-mode-hook 'jedi:setup)

(setq python-remove-cwd-from-path nil)
(setq python-guess-indent nil)
(setq python-indent 4)

;; undo tree
(global-undo-tree-mode t)

;; git-gutter
(global-git-gutter-mode t)

;; hide initial crap
(setq inhibit-splash-screen t
      initial-scratch-message nil)

;; golden ratio
(golden-ratio-mode 1)

;; indenting
(setq default-tab-width 2)

(setq clojure-defun-style-default-indent t)

;; keybindings

;; general
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-x \\") 'align-regexp)

(global-set-key (kbd "C-x C-i") 'idomenu)
(global-set-key (kbd "C-x g") 'magit-status)

(global-set-key  (kbd "M-p") 'outline-previous-visible-heading)
(global-set-key  (kbd "M-n") 'outline-next-visible-heading)

(global-set-key (kbd "C-o") 'ace-jump-mode)

;; clojure
(require 'clojure-mode)
(define-key clojure-mode-map (kbd "C-c l l") 'align-cljlet)
(define-key clojure-mode-map (kbd "C-M-z")   'align-cljlet)

;; cider
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(setq cider-repl-print-length 100)

;; undo
(global-set-key (kbd "C-M-_") 'undo-tree-undo)
(global-set-key (kbd "C-_")   'undo-tree-undo)

;; files
(global-set-key (kbd "C-x M-f")   'ido-find-file-other-window)
(global-set-key (kbd "C-x C-M-f") 'find-file-in-project)
(global-set-key (kbd "C-x f")     'live-recentf-ido-find-file)
(global-set-key (kbd "C-x C-r")   'ido-recentf-open)
(global-set-key (kbd "M-`")       'file-cache-minibuffer-complete)
(global-set-key (kbd "C-x C-b")   'ibuffer)

;; smex
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; window number
(require 'window-number)
(window-number-mode 1)
(window-number-meta-mode 1)

;; auto completion
(require 'auto-complete-config)
(ac-config-default)

(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))

(require 'ac-nrepl)
(add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
(add-hook 'cider-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'cider-repl-mode))

;; temporary files
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; lemme downcase sucker
(put 'downcase-region 'disabled nil)
