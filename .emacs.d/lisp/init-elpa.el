; (setq package-archives
;       '(("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
;         ("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
; 	("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
;         ("org" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
;; 关闭包签名检查（国内环境常用）
(setq package-check-signature nil)

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

(provide 'init-elpa)
