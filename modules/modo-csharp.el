;;; modo-csharp.el --- defying Visual Studio -*- lexical-binding: t -*-
;;; Commentary:

;; Making C# coding in Emacs doable.

;;; Code:

(defun modo-omnisharp-setup-hook ()
  (require 'company)
  (add-to-list 'company-backends #'company-omnisharp)
  (setq-local company-idle-delay 0.3)
  (setq-local company-minimum-prefix-length 3)
  (add-hook 'before-save-hook #'omnisharp-code-format-entire-file nil t))

(defun omnisharp-add-dot-and-company-complete ()
  (interactive)
  (insert ".")
  (company-complete))

(straight-use-package 'csharp-mode)
(use-package csharp-mode
  :hook ((csharp-mode . flycheck-mode)
         (csharp-mode . omnisharp-mode))
  :config
  (require 'omnisharp)
  (general-define-key :states 'normal
                      :keymaps 'csharp-mode-map
                      "gd" 'omnisharp-go-to-definition)
  (general-define-key :states '(motion normal visual)
                      :keymaps 'csharp-mode-map
                      ",u" 'omnisharp-find-usages
                      ",p" 'omnisharp-find-implementations
                      ",i" 'omnisharp-current-type-information
                      ",I" 'omnisharp-current-type-documentation
                      ",n" 'omnisharp-rename
                      ",r" 'omnisharp-run-code-action-refactoring
                      ",c" 'recompile)
  (general-define-key :states 'insert
                      :keymaps 'csharp-mode-map
                      "." 'omnisharp-add-dot-and-company-complete))

(straight-use-package 'omnisharp)
(use-package omnisharp
  :diminish omnisharp-mode
  :hook ((omnisharp-mode . modo-omnisharp-setup-hook))
  :init
  (setq omnisharp-autocomplete-want-documentation nil
        omnisharp-cache-directory (concat modo-cache-dir "omnisharp")))

(provide 'modo-csharp)
;;; modo-csharp.el ends here
