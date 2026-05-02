(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'after-init-hook #'(lambda() (setq gc-cons-threshold 800000)))

;;; 设置custom-file
(setq custom-file "~/.emacs.d/.emacs.custom.el")

;;; basic ui
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;; ido-mode
(ido-mode)
(ido-everywhere)

;;; 无边框
(add-to-list 'default-frame-alist '(undecorated . t))
(add-to-list 'default-frame-alist '(internal-border-width . 0))
(add-to-list 'default-frame-alist '(border-width . 0))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq frame-resize-pixelwise t)
(setq window-divider-default-places '(right-edge))
(setq window-divider-default-right-edge 0)
(window-divider-mode 1)

;;; 相对行号
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative
      display-line-numbers-current-absolute t
      display-line-numbers-width 3
      display-line-numbers-minimum-width 3)

;;; 易用性配置
(defalias 'yes-or-no-p 'y-or-n-p)
(setq create-lockfiles nil
      make-backup-files nil)

;;; 编码环境 & 字体
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(add-to-list 'default-frame-alist '(font . "DejaVuSansM Nerd Font Mono"))
(set-face-attribute 'fixed-pitch nil :font "DejaVuSansM Nerd Font Mono")
(set-face-attribute 'variable-pitch nil :font "DejaVuSansM Nerd Font Mono")

;;; 括号配对
(electric-pair-mode 1)
(setq electric-pair-inhibit-predicate
      (lambda (c)
        (eq c ?<)))
(defun my-enable-angle-brackets ()
  (setq-local electric-pair-inhibit-predicate
              (lambda (c) nil)))
(add-hook 'nxml-mode-hook       #'my-enable-angle-brackets)
(add-hook 'xml-mode-hook        #'my-enable-angle-brackets)
(add-hook 'web-mode-hook        #'my-enable-angle-brackets)

;;; indent
(setq-default indent-tabs-mode nil
              tab-width 4)
(setq-default c-basic-offset 4)    ;; C/C++/Java
(setq-default js-indent-level 4)   ;; JS/TS
(setq-default python-indent-offset 4) ;; Python
(setq-default sgml-basic-offset 4) ;; HTML
(setq-default css-indent-offset 4) ;; CSS
(setq-default go-indent-level 4)   ;; Go

;;; 标签页配置
(with-eval-after-load 'tab-bar
  (setq tab-bar-show 1))

;;; functions
(defun yabai-frame-border ()
  "切换当前窗口的边框：无边框 <-> 带边框"
  (interactive)
  (if (frame-parameter nil 'undecorated)
      (progn
        (set-frame-parameter nil 'undecorated nil)
        (set-frame-parameter nil 'internal-border-width 0))
    (progn
      (set-frame-parameter nil 'undecorated t)
      (set-frame-parameter nil 'internal-border-width 0))))

(defun duplicate-line-with-cursor ()
  "Duplicate current line with moving your cursors"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'duplicate-line-with-cursor)
(global-set-key (kbd "C-.") 'duplicate-line)
(global-set-key (kbd "C-;") 'copy-from-above-command)


;;; melpa
(setq package-archives
      '(("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
	;("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
	;("gnu" . "https://elpa.gnu.org/packages/")
        ;("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
	;("org" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
	    ))

(setq package-check-signature nil)

;;; package
(require 'package)
(unless (bound-and-true-p package--initialized)
  (package-initialize))

(unless package-archive-contents
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t
      use-package-always-defer t
      use-package-enable-imenu-support t
      use-package-expand-minimally t)

(require 'use-package)

;;; theme
(use-package doom-themes
  :demand t
  :config
  (load-theme 'doom-acario-dark t)
  (set-face-background 'default "#000000"))

;;; smex
(use-package smex
  :ensure t
  :config (add-hook 'after-init-hook 'smex))
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;; multiple-cursor
(use-package multiple-cursors
  :ensure t
  :config (add-hook 'after-init-hook 'multiple-cursors))
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-\"") 'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:") 'mc/skip-to-previous-like-this)

;;; simpc-mode
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

;;; conda
(use-package conda
  :ensure t
  :defer t
  :init
  (setq conda-anaconda-home "/opt/homebrew/Caskroom/miniconda/base")
  (setq conda-env-home-directory "/opt/homebrew/Caskroom/miniconda/base")
  :config
  (conda-env-autoactivate-mode nil)
  (add-hook 'conda-postactivate-hook
            (lambda ()
              (when (fboundp 'lsp-restart-workspace)
                (lsp-restart-workspace)))))

;;; company
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0))

;;; lsp-mdoe
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((python-mode python-ts-mode c-mode simpc-mode c-ts-mode c++-mode c++-ts-mode) . lsp-deferred)
  :config
  (setq +lsp-defer-shutdown 3)
  (defvar +lsp--deferred-shutdown-timer nil)
  (advice-add 'lsp--shutdown-workspace :around
              (lambda (fn &optional restart)
                (if (or restart (null +lsp-defer-shutdown) (= +lsp-defer-shutdown 0))
                    (funcall fn restart)
                  (when (timerp +lsp--deferred-shutdown-timer)
                    (cancel-timer +lsp--deferred-shutdown-timer))
                  (setq +lsp--deferred-shutdown-timer
                        (run-at-time +lsp-defer-shutdown nil
                                     (lambda (workspaces)
                                       (dolist (ws workspaces)
                                         (unless (cl-some #'buffer-live-p (lsp--workspace-buffers ws))
                                           (with-lsp-workspace ws
                                                               (let ((lsp-restart 'ignore))
                                                                 (funcall fn))))))
                                     lsp--buffer-workspaces))))))

(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-max-height 8
        lsp-ui-doc-max-width 72
        lsp-ui-doc-delay 0.75
        lsp-ui-doc-show-with-mouse nil
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-ignore-duplicate t))

;;; flycheck
(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
        flycheck-idle-change-delay 0.5))


;;; load custom-file
(load-file custom-file)
