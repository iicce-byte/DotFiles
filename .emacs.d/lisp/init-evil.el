(use-package evil
  :demand t
  :ensure t
  :init
  ; (setq evil-default-state 'normal)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-redo)
  (setq evil-leader/leader "SPC")
  :config
  (evil-mode 1)
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))

  (evil-define-key 'normal 'global
    (kbd "C-e") 'evil-normal-state
    (kbd "S") 'evil-write
    (kbd "Q") 'evil-window-delete
    (kbd "h") 'evil-insert
    (kbd "H") 'evil-insert-line

    (kbd "j") 'evil-backward-char
    (kbd "l") 'evil-forward-char
    (kbd "i") 'evil-previous-line
    (kbd "k") 'evil-next-line

    (kbd "J") (lambda () (interactive) (evil-backward-char 5))
    (kbd "L") (lambda () (interactive) (evil-forward-char 5))
    (kbd "I") (lambda () (interactive) (evil-previous-line 5))
    (kbd "K") (lambda () (interactive) (evil-next-line 5))
    (kbd "<leader>i") 'evil-window-up
    (kbd "<leader>j") 'evil-window-left
    (kbd "<leader>k") 'evil-window-down
    (kbd "<leader>l") 'evil-window-right

    (kbd "s") nil

    (kbd "s s") (lambda() (interactive) (evil-window-vsplit))
    (kbd "s d") (lambda() (interactive) (evil-window-split))

    (kbd "s e") 'tab-new
    (kbd "s j") 'tab-previous
    (kbd "s l") 'tab-next

    (kbd "s f") 'evil-end-of-line
    (kbd "s a") 'evil-beginning-of-line
    (kbd "s c") 'find-file

    (kbd "<") (lambda() (interactive) (tab-bar-move-tab -1))
    (kbd ">") (lambda() (interactive) (tab-bar-move-tab 1))
    (kbd ";") 'evil-ex)
 (evil-define-key 'visual 'global
    (kbd "h") 'evil-insert
    (kbd "j") 'evil-backward-char
    (kbd "l") 'evil-forward-char
    (kbd "i") 'evil-previous-line
    (kbd "k") 'evil-next-line
    (kbd "C-e") 'evil-normal-state)
 (evil-define-key 'insert 'global
  (kbd "C-e") 'evil-normal-state)
 (with-eval-after-load 'dired
   (evil-define-key 'normal dired-mode-map
     (kbd "RET") 'dired-find-file
     (kbd "d")   'dired-flag-file-deletion
     (kbd "x")   'dired-do-flagged-delete
     (kbd "u") 'dired-unmark
     (kbd "U") 'dired-unmark-all-marks
     (kbd "s m") 'dired-jump)))

(add-hook 'compilation-mode-hook #'evil-normal-state)
(evil-set-initial-state 'compilation-mode 'normal)

(provide 'init-evil)
