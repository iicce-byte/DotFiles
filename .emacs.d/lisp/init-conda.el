; (use-package conda
;   :ensure t
;   :defer t
;   :init
;   (setq conda-anaconda-home (expand-file-name "/opt/homebrew/Caskroom/miniconda/base"))
;   (setq conda-env-home-directory (expand-file-name "/opt/homebrew/Caskroom/miniconda/base"))
; 
;   :config
;   (conda-env-autoactivate-mode nil)
;   ; (global-set-key (kbd "C-c c a") 'conda-env-activate)
;   (add-hook 'conda-postactivate-hook
;             (lambda () (lsp-restart-workspace))))
; 
; (provide 'init-conda)
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

(provide 'init-conda)
