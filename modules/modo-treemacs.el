;;; modo-treemacs.el --- treemacs file browser -*- lexical-binding: t -*-
;;; Commentary:

;; Sometimes a visual overview is kind of nice.

;;; Code:

(straight-use-package 'treemacs)
(use-package treemacs
  :general
  ("C-<tab>" 'treemacs)
  (:keymaps 'treemacs-mode-map
            "M-<return>" 'treemacs-RET-action-and-quit)
  :init
  (setq treemacs-persist-file
        (expand-file-name
         "treemacs-persist" modo-cache-dir)
        treemacs-last-error-persist-file
        (expand-file-name
         "treemacs-persist-at-last-error" modo-cache-dir))
  :config
  (when (featurep 'doom-themes)
    (doom-themes-treemacs-config))
  (defun treemacs-RET-action-and-quit (&optional arg)
    (interactive "P")
    (let ((treewin (selected-window)))
      (treemacs-RET-action arg)
      (quit-window nil treewin)))
  (defun modo-select-window-0-dispatch ()
    "Dispatches to a window in the following ordered priority:

1. Active minibuffer
2. Visible treemacs window
3. Otherwise, calls `winum-select-window-0-or-10'"
    (interactive)
    (pcase (if-let ((minibuff (active-minibuffer-window)))
               minibuff
             (treemacs-current-visibility))
      ((and (pred windowp) minibuff)
       (select-window minibuff))
      ('visible (treemacs-select-window))
      (_ (winum-select-window-0-or-10))))
  (modo-define-leader-key :keymaps 'override
    "0" '(modo-select-window-0-dispatch :wk "select-window-0-dispatch")))

(straight-use-package 'treemacs-evil)
(use-package treemacs-evil
  :after (evil treemacs)
  :demand t)

(straight-use-package 'treemacs-projectile)
(use-package treemacs-projectile
  :after (projectile treemacs)
  :demand t)

(straight-use-package 'treemacs-magit)
(use-package treemacs-magit
  :after (magit treemacs)
  :demand t)

(provide 'modo-treemacs)
;;; modo-treemacs.el ends here
