;; -*- lexical-binding: t -*-

;;; This file bootstraps the configuration, which is divided into
;;; a number of other files.

(let ((minver "24.3"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version< emacs-version "24.5")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-benchmarking) ;; Measure startup time
;; (benchmark-init/activate)

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;;----------------------------------------------------------------------------
;; Adjust garbage collection thresholds during startup, and thereafter
;;----------------------------------------------------------------------------
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'after-init-hook
            (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;; Calls (package-initialize)
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH

;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-preload-local.el"
;;----------------------------------------------------------------------------
(require 'init-preload-local nil t)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------

(require-package 'wgrep)
(require-package 'project-local-variables)
(require-package 'diminish)
(require-package 'scratch)
(require-package 'command-log-mode)

;; init use-package
(require-package 'use-package)
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure nil)
(setq use-package-always-defer nil)
;; (require 'diminish)                ;; if you use :diminish
(require-package 'bind-key)
(require 'bind-key)

(require 'init-xterm)
(require 'init-themes)
;; (require 'init-osx-keys)
(require 'init-gui-frames)
(require 'init-dired)
(require 'init-isearch)
;; (require 'init-grep)
(require 'init-uniquify)
(require 'init-ibuffer)
(require 'init-flycheck)

(require 'init-recentf)
(require 'init-smex)
(require 'init-ivy)
(require 'init-hippie-expand)
(require 'init-company)
(require 'init-windows)
(require 'init-sessions)
(require 'init-fonts)
(require 'init-mmm)

(require 'init-editing-utils)
(require 'init-whitespace)

(require 'init-vc)
(require 'init-darcs)
(require 'init-git)
(require 'init-github)

(require 'init-projectile)

(require 'init-compile)
;;(require 'init-crontab)
(require 'init-textile)
(require 'init-markdown)
(require 'init-matlab)
;; (require 'init-csv)
;; (require 'init-erlang)
(require 'init-javascript)
(require 'init-php)
(require 'init-org)
(require 'init-ox)
;; (require 'init-ox-latex)
;;(require 'init-ox-beamer)
(require 'init-org-query)
;; (require 'init-nxml)
(require 'init-html)
(require 'init-css)
;;(require 'init-haml)
(require 'init-http)
(require 'init-python-mode)
(unless (version<= emacs-version "24.3")
  (require 'init-haskell))
;; (require 'init-elm)
;; (require 'init-purescript)
;; (require 'init-ruby-mode)
;; (require 'init-rails)
;; (require 'init-sql)
;; (require 'init-toml)
;; (require 'init-yaml)
;; (require 'init-docker)
;; (require 'init-terraform)
(require 'init-paredit)
(require 'init-lisp)
(require 'init-slime)
(require 'init-clojure)
(require 'init-clojure-cider)
(require 'init-common-lisp)

(when *spell-check-support-enabled*
  (require 'init-spelling))

(require 'init-misc)

(require 'init-folding)
(require 'init-dash)
(require 'init-ledger)
;; Extra packages which don't require any configuration

(require-package 'gnuplot)
(require-package 'lua-mode)
(require-package 'htmlize)
(require-package 'dsvn)
(when *is-a-mac*
  (require-package 'osx-location))
(maybe-require-package 'regex-tool)
(maybe-require-package 'dotenv-mode)

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p)
  (setq server-auth-dir "~/.emacs.d/server/")
  (setq server-name "emacs-server-file")
  (server-start))


;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(when (file-exists-p custom-file)
  (load custom-file))


;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-local" containing personal settings
;;----------------------------------------------------------------------------
(require 'init-local nil t)


;;----------------------------------------------------------------------------
;; Locales (setting them earlier in this file doesn't work in X)
;;----------------------------------------------------------------------------
(require 'init-locales)


(when (maybe-require-package 'uptimes)
  (add-hook 'after-init-hook (lambda () (require 'uptimes))))


(provide 'init)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
