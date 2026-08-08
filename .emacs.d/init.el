;;; init.el --- 主配置 -*- lexical-binding: t; -*-

;;; 设置 custom-file
(setq custom-file "~/.emacs.d/.emacs.custom.el")

;;; basic ui
(setq frame-resize-pixelwise t)
(setq window-divider-default-places '(right-edge))
(setq window-divider-default-right-edge 0)
(add-hook 'after-init-hook (lambda () (window-divider-mode 1)))
(add-hook 'after-init-hook (lambda () (menu-bar-mode -1)))

;;; 相对行号
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(setq display-line-numbers-type 'relative
      display-line-numbers-current-absolute t
      display-line-numbers-width 3)

;;; 易用性配置
(setq use-short-answers t)
;(defalias 'yes-or-no-p 'y-or-n-p)
(setq create-lockfiles nil
      make-backup-files nil)
(put 'upcase-region 'disabled nil)

;;; 编码环境 & 字体
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-face-attribute 'fixed-pitch nil    :font "DejaVuSansM Nerd Font Mono-20")
(set-face-attribute 'variable-pitch nil :font "DejaVuSansM Nerd Font Mono-20")
(set-fontset-font "fontset-default" 'mathematical "Latin Modern Math")

;;; 括号配对
(add-hook 'after-init-hook (lambda () (electric-pair-mode 1)))
(setq electric-pair-inhibit-predicate
      (lambda (c) (eq c ?<)))
(defun cst/enable-angle-brackets ()
  (setq-local electric-pair-inhibit-predicate (lambda (c) nil)))
(add-hook 'nxml-mode-hook #'cst/enable-angle-brackets)
(add-hook 'xml-mode-hook  #'cst/enable-angle-brackets)
(add-hook 'web-mode-hook  #'cst/enable-angle-brackets)

;;; indent
(setq-default standard-indent 4
              indent-tabs-mode nil
              tab-width 4
              c-basic-offset 4      ;; C/C++/Java
              js-indent-level 4     ;; JS/TS
              python-indent-offset 4
              sgml-basic-offset 4   ;; HTML
              css-indent-offset 4
              go-indent-level 4)

;;; whitespace-mode
(defun cst/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 1)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))
(dolist (h '(tuareg-mode-hook c++-mode-hook c-mode-hook simpc-mode-hook
                              emacs-lisp-mode-hook java-mode-hook
                              lua-mode-hook rust-mode-hook
                              scala-mode-hook haskell-mode-hook
                              python-mode-hook erlang-mode-hook
                              asm-mode-hook fasm-mode-hook
                              go-mode-hook nim-mode-hook
                              yaml-mode-hook porth-mode-hook))
  (add-hook h #'cst/set-up-whitespace-handling))

;;; 内置补全 / 辅助
(add-hook 'after-init-hook (lambda () (ido-mode 1)))
(add-hook 'ido-mode-hook (lambda () (ido-everywhere 1)))
(add-hook 'after-init-hook #'which-key-mode)

;;; keyboard settings
(global-set-key (kbd "C-S-d") 'delete-backward-char)
(global-set-key (kbd "C-c C-c C-d") 'bs-show)
(global-set-key (kbd "C-c C-m") 'magit)

;;; 标签页配置
(with-eval-after-load 'tab-bar
  (setq tab-bar-show 1))

(add-hook 'emacs-startup-hook
          (lambda ()
            (dolist (dir '("/opt/homebrew/bin"
                           "/opt/homebrew/sbin"
                           "~/.local/bin"))
              (let ((p (expand-file-name dir)))
                (when (file-directory-p p)
                  (add-to-list 'exec-path p)
                  (setenv "PATH" (concat p ":" (getenv "PATH"))))))))

;;; functions
(defun yabai-frame-border ()
  "切换当前窗口的边框:无边框 <-> 带边框"
  (interactive)
  (if (frame-parameter nil 'undecorated-round)
      (progn
        (set-frame-parameter nil 'undecorated-round nil)
        (set-frame-parameter nil 'internal-border-width 0))
    (progn
      (set-frame-parameter nil 'undecorated-round t)
      (set-frame-parameter nil 'internal-border-width 0))))

(defun toggle-window-split ()
  "Toggle between horizontal and vertical split with two windows."
  (interactive)
  (if (> (length (window-list)) 2)
      (error "目前只能在 2 个窗口的情况下进行一键切换!")
    (let ((func (if (window-full-height-p)
                    #'split-window-vertically
                  #'split-window-horizontally)))
      (delete-other-windows)
      (funcall func)
      (save-selected-window
        (other-window 1)
        (switch-to-buffer (other-buffer))))))
(global-set-key (kbd "C-c w") 'toggle-window-split)

(defun cst/duplicate-line-with-cursor ()
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
(global-set-key (kbd "C-,") 'cst/duplicate-line-with-cursor)
(global-set-key (kbd "C-.") 'duplicate-line)
(global-set-key (kbd "C-;") 'copy-from-above-command)

(defun set-transparency (active inactive)
  (interactive "n选中透明度 (0-100): \nn失焦透明度 (0-100): ")
  (set-frame-parameter nil 'alpha (cons active inactive)))

(defun rime-phrase ()
  (interactive)
  (find-file "~/Library/Rime/custom_phrase_double.txt"))

;;; themes
(add-to-list 'load-path "~/.emacs.d/lisp/themes")
(add-to-list 'custom-theme-load-path "~/.emacs.d/lisp/themes")
(defun cst/apply-theme (appearance)
  "根据系统的 APPEARANCE (深色或浅色) 切换主题."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'ef-deuteranopia-light t))
    ('dark  (load-theme 'ef-deuteranopia-dark  t))))
(add-hook 'ns-system-appearance-change-functions #'cst/apply-theme)

;;; package
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))
(setq package-check-signature nil)

(setq use-package-always-ensure t
      use-package-always-defer t
      use-package-enable-imenu-support t
      use-package-expand-minimally t)

;;; smex
(use-package smex :defer t
  :bind (("M-x" . smex)
         ("C-c C-c M-x" . execute-extended-command)))

;;; multiple-cursors
(use-package multiple-cursors :defer t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C-<"         . mc/mark-previous-like-this)
         ("C->"         . mc/mark-next-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-\""        . mc/skip-to-next-like-this)
         ("C-:"         . mc/skip-to-previous-like-this)))

;;; simpc-mode
(add-to-list 'load-path "~/.emacs.d/lisp/")
(autoload 'simpc-mode "simpc-mode" "Simple C mode." t)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
(add-to-list 'auto-mode-alist '("\\.[b]\\'" . simpc-mode))

;;; yasnippet
;(use-package yasnippet
;  :defer t
;  :hook ((prog-mode simpc-mode c++-mode org-mode latex-mode LaTeX-mode) . yas-minor-mode)
;  :config
;  (setq yas/triggers-in-field nil
;        yas-snippet-dirs '("~/.emacs.d/snippets/"))
;  (yas-reload-all))

;;; conda
(use-package conda
  :defer t
  :config
  (setq conda-anaconda-home "/opt/homebrew/Caskroom/miniconda/base"
        conda-env-home-directory "/opt/homebrew/Caskroom/miniconda/base")
  (conda-env-autoactivate-mode nil)
  (add-hook 'conda-postactivate-hook
            (lambda ()
              (when (fboundp 'lsp-restart-workspace)
                (lsp-restart-workspace)))))

;;; company
(use-package company
  :defer t
  :hook (lsp-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0))

;;; lsp-mode
(use-package lsp-mode
  :defer t :commands (lsp lsp-deferred)
  :hook ((python-mode python-ts-mode c-mode simpc-mode
                      c-ts-mode c++-mode c++-ts-mode) . lsp-deferred)
  :init
  (setq read-process-output-max (* 1024 1024)
        lsp-idle-delay 0.5)
  :config
  (setq lsp-enable-on-type-formatting nil)
  (add-to-list 'lsp-language-id-configuration '(simpc-mode . "c"))
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

;;; lsp-ui
(use-package lsp-ui
  :defer t
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
  :defer t
  :hook (lsp-mode . flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
        flycheck-idle-change-delay 0.5))

;;; magit
(use-package magit  :defer t)

;;; auctex
(use-package tex
  ;:ensure auctex
  :defer t
  :config
  (setq TeX-newline-function 'reindent-then-newline-and-indent)
  (setq LaTeX-indent-level 2)
  (setq LaTeX-item-indent 2))

; (use-package esup
;   :defer t
;   :commands esup
;   :config
;   (setq esup-depth 0))

(defvar cst/packages
  '(smex multiple-cursors which-key yasnippet conda company
    lsp-mode lsp-ui flycheck magit auctex)
  "本配置依赖的第三方包。")
(defun cst/install-packages ()
  "install all missing packages of `cst/packages' and refresh quickstart。"
  (interactive)
  (require 'package)
  (package-initialize)
  (package-refresh-contents)
  (dolist (p cst/packages)
    (unless (package-installed-p p)
      (package-install p)))
  (package-quickstart-refresh)
  (message "installed, please restart Emacs"))

(require 'init-org)
(require 'init-markdown)

; # 原生编译所有包和配置
; emacs --batch --eval "(progn (require 'comp) (native-compile-async \"~/.emacs.d/\" 'recursively))"
; # 生成 package-quickstart 合并文件
; emacs --batch --eval "(progn (require 'package)(setq package-quickstart t)(package-quickstart-refresh))"
