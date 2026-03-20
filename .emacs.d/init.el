(add-to-list 'load-path (expand-file-name (concat user-emacs-directory "lisp")))


(require 'init-startup)
(require 'init-functions)
(require 'init-elpa)

(require 'init-themes)
(require 'init-evil)
(require 'init-lsp)
