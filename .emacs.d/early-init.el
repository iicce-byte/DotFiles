;;; early-init.el --- 在 GUI 与 package 系统加载前执行 -*- lexical-binding: t; -*-

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(defvar cst/saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 64 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist cst/saved-file-name-handler-alist))
          100)

;; 安装/删除包之后执行一次: M-x package-quickstart-refresh
(setq package-quickstart t)

(push '(menu-bar-lines . 0)          default-frame-alist)
(push '(tool-bar-lines . 0)          default-frame-alist)
(push '(vertical-scroll-bars)        default-frame-alist)
(push '(horizontal-scroll-bars)      default-frame-alist)
;(push '(undecorated . t)             default-frame-alist)
(push '(undecorated-round . t)             default-frame-alist)
(push '(internal-border-width . 0)   default-frame-alist)
(push '(ns-transparent-titlebar . t) default-frame-alist)
(push '(ns-appearance . dark)        default-frame-alist)
(push '(font . "DejaVuSansM Nerd Font Mono-20") default-frame-alist)
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)

(setq frame-inhibit-implied-resize t)

(setq site-run-file nil
      inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      ;initial-scratch-message nil
      inhibit-compacting-font-caches t)

(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors 'silent
        native-comp-jit-compilation t))
