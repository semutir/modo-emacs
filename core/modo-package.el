;;; modo-package.el --- package management -*- lexical-binding: t -*-
;;; Commentary:

;; Handles package management for modo emacs.

;;; Code:

;;; org shenanigans
;; This deletes the built-in org from the load path, _hopefully_ preventing it
;; from interfering with the straight provided one
;; TODO: condition this on org module being requested
(when-let* ((org-path (locate-library "org")))
 (setq load-path (delete (substring (file-name-directory org-path) 0 -1)
                         load-path)))

;;; straight.el
;; Initial setup
(setq straight-repository-branch "develop"
      straight-recipes-gnu-elpa-use-mirror t
      straight-recipes-emacsmirror-use-mirror t
      ;; Startup checks are expensive, and I'm used to manually
      ;; rebuilding when necessary anyway
      straight-check-for-modifications nil)
(setq straight-profiles '((modo . "../../versions.el")))
(setq straight-current-profile 'modo)

;; Bootstrap snippet
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Early loading of recipe packages
(dolist (repo straight-recipe-repositories)
  (straight-use-package repo))

;; Prefer newer files
(setq load-prefer-newer t)

;; Macro for requiring modules
(defmacro modo-module (&rest modules)
  "Load all the modules listed in MODULES, with the prefix modo-.
For example, the module name git translates to a call to (require 'modo-git)."
  (macroexp-progn
   (mapcar
    (lambda (module)
      `(require ',(intern (format "modo-%s" module))))
    modules)))

;;; use-package
(straight-use-package 'diminish)
(straight-use-package 'use-package)

(setq use-package-verbose t)
(setq use-package-always-defer t)
(eval-when-compile
  (require 'use-package))
(require 'diminish)

(provide 'modo-package)
;;; modo-package.el ends here
