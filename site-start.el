;;; site-start.el - emacs startup file.

;;; This file, if it exists in the emacs load path is loaded before
;;; the users' .emacs file.

;; Smallworld lisp:

(require 'load_sw_defs)
(require 'sw_defaults)
(require 'sw-autoload)
(require 'menu-sw)

;;
;; From the Smallworld GNU Emacs default configuration file, `default.el'.
;; --------------------------------------------------------------------

;; Set SW keybindings (that will enable the SW menu too)
(or sw-set-keys (sw-set-keys))

;; Skeleton-pair mode
(require 'skeleton)
(setq skeleton-pair-on-word nil)  ;; don't apply skeleton trick in front of a word.
(global-set-key (kbd "(")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "[")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "{")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(defun skeleton-pair-mode (&optional arg)
  "Toggle value of `skeleton-pair'.
Primarily used for keys that use `skeleton-pair-insert-maybe'
for example: [, (, { and \".
"
  (interactive "P")
  (setq skeleton-pair (not skeleton-pair))) 

;;
;; Set the top dir variables
;;
(defvar site-lisp-dir
  (file-name-directory (locate-library "site-start.el" t)))
(defvar site-lisp-features-dir
  (file-name-as-directory (concat site-lisp-dir "features")))
(defvar site-lisp-data-dir
  (file-name-as-directory (concat site-lisp-dir "data")))
(defvar rw-site-lisp-dir
  (file-name-as-directory (concat site-lisp-dir "realworld")))


;;
;; From the Realworld site-lisp:
;; --------------------------------------------------------------------
(require 'rw-custom-group)
(require 'htmlize)
(require 'rw-extras)

;;; site-start.el ends here
