(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0
        company-quick-access t))
(defvar +lsp-defer-shutdown 3)
(defvar +lsp--default-read-process-output-max nil)
(defvar +lsp--default-gcmh-high-cons-threhold)

(define-minor-mode +lsp-optimization-mode
  "Doom 风格的 LSP 性能优化"
  :global t
  :init-value nil
  (if (not +lsp-optimization-mode)
      (when +lsp--optimization-init-p
        (setq-default read-process-output-max +lsp--default-read-process-output-max)
        (setq +lsp--optimization-init-p nil))
    (unless +lsp--optimization-init-p
      (setq +lsp--default-read-process-output-max (default-value 'read-process-output-max))
      (setq-default read-process-output-max (* 1024 1024))
      (setq +lsp--optimization-init-p t))))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((python-mode c-mode c++-mode c-ts-mode c++-ts-mode) . lsp-deferred)
  :hook (lsp-before-initialize . lsp-optimization-mode)
  :init
  (setq lsp-session-file (expand-file-name ".local/cache/lsp-session" user-emacs-directory)
        lsp-server-install-dir (expand-file-name ".local/etc/lsp" user-emacs-directory)
        lsp-keep-workspace-alive nil)
  :config
  (setq lsp-pylsp-server-command
        '("/opt/homebrew/Caskroom/miniconda/base/envs/na/bin/python" "-m" "pylsp"))
  (add-to-list 'lsp-language-id-configuration '(python-mode . "python"))
  ;; 延迟关闭服务器
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
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  ;; 调整检查时机，不要打字打一半就报错，稍微停顿后再检查
  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
        flycheck-idle-change-delay 0.5))

(provide 'init-lsp)
