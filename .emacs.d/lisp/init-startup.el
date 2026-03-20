(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-hl-line-mode 1)

(setq inhibit-startup-screen t)
(set-face-foreground 'hl-line nil)
(add-to-list 'default-frame-alist '(undecorated . t))

(defalias 'yes-or-no-p 'y-or-n-p)
(setq create-lockfiles nil
      make-backup-files nil)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-current-absolute t
      display-line-numbers-width 3
      display-line-numbers-minimum-width 3)


(setq-default indent-tabs-mode nil
              tab-width 4)
(setq-default c-basic-offset 4)    ;; C/C++/Java
(setq-default js-indent-level 4)   ;; JS/TS
(setq-default python-indent-offset 4) ;; Python
(setq-default sgml-basic-offset 4) ;; HTML
(setq-default css-indent-offset 4) ;; CSS
(setq-default go-indent-level 4)   ;; Go

(add-to-list 'default-frame-alist '(font . "JetbrainsMono Nerd Font"))
(set-face-attribute 'fixed-pitch nil :font "JetbrainsMono Nerd Font")
(set-face-attribute 'variable-pitch nil :font "JetbrainsMono Nerd Font")

; (add-hook 'prog-mode-hook 'whitespace-mode)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(provide 'init-startup)
