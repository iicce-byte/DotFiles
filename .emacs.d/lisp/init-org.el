;;; org-roam
(use-package org-roam
  :config
  (setq org-roam-directory "~/Program/roam-home/")
  (org-roam-db-autosync-mode))
(global-set-key (kbd "C-c n f")  'org-roam-node-find)
(global-set-key (kbd "C-c n i")  'org-roam-node-insert)
(global-set-key (kbd "C-c n c")  'org-roam-capture)
(global-set-key (kbd "C-c n l")  'org-roam-buffer-toggle)
(global-set-key (kbd "C-c n u")  'org-roam-ui-mode)

;;; org-roam-ui
(use-package org-roam-ui
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t))

(with-eval-after-load 'org
  (set-face-attribute 'org-table nil
                      :family "Noto Sans Mono CJK SC"
                      :height 140
                      :weight 'normal
                      :slant 'normal))

(setq org-startup-with-inline-images t)
(setq org-pretty-entities t)
(setq org-latex-pdf-process '("tectonic -Z shell-escape %f"))

(use-package markdown-mode
  :defer t
  :mode ("\\.md\\'" . markdown-mode)
  :hook
  (markdown-mode . visual-line-mode)
  :custom
  (markdown-hide-markup t)
  (markdown-hide-urls t)
  (markdown-fontify-code-blocks-natively t))

;(use-package mixed-pitch
;  :defer t
;  :hook
;  (markdown-mode . mixed-pitch-mode))

;(use-package valign
;  :defer t
;  :hook
;  (markdown-mode . valign-mode))

(provide 'init-org)
