;;; modo-utils.el --- utility functions -*- lexical-binding: t -*-
;;; Commentary:

;; Useful interactive functions.

;;; Code:

(defun modo-find-dotfile ()
  "Opens init.el in modo-emacs-dir."
  (interactive)
  (let* ((dotfile (file-truename (expand-file-name "init.el" modo-emacs-dir)))
         (buffer-name (get-file-buffer dotfile)))
    (if buffer-name
        (switch-to-buffer buffer-name) ;; If buffer already exists, simply switch to it
      (find-file dotfile)
      ;; Needed to make saveplace work with this function
      (run-hooks 'find-file-hook))))

(defun modo-delete-auto-save-file ()
  "Delete the autosave file in the currently visited buffer, if it exists."
  (interactive)
  (let ((auto-file (file-truename (make-auto-save-file-name))))
    (if (and (buffer-file-name)
             (file-exists-p auto-file))
        (delete-file auto-file)
      (message "No auto-save file exists."))))

;; Two useful functions borrowed from Steve Purcell
(defun modo-delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (unless (buffer-file-name)
    (error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
                             (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))

(defun modo-rename-this-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless filename
      (error "Buffer '%s' is not visiting a file!" name))
    (progn
      (when (file-exists-p filename)
        (rename-file filename new-name 1))
      (set-visited-file-name new-name)
      (rename-buffer new-name))))

(provide 'modo-utils)
;;; modo-utils.el ends here