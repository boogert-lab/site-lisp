;;
;; File containing additions and changes to load
;;

(require 'rw-templates)
(require 'rw-findstr)
(require 'rw-cb-enhancements)
(require 'rw-magik-extras)
(require 'rw-load-shortcuts)
(require 'rw-pragma-changes)
(require 'rw-dev-tools-enhancements)
(require 'rw-key-bindings)


;;;###autoload
(defun rw-find-file-under-point ()
  "Jumps to file"
  (interactive)
  (find-file-other-window (rw-path-under-point))
  )

;;;###autoload
(defun rw-path-under-point ()
  "Retrieves path of file-or-directory-name under point"
  (interactive)
  (let*
      (
       (l-start-regexp (if (eq system-type 'windows-nt) "\\(\\\\\\\\\\|\\([a-zA-Z]:\\)\\)" " \\(/\\)")) ;; also stop at unc-path-beginning at winnt
       (l-start-pos    (save-excursion (when (re-search-backward l-start-regexp (line-beginning-position) t) (match-beginning 1))))
       (l-skip-string  (if (eq system-type 'windows-nt) "-#~/\\\\_a-zA-Z0-9.:!=" "-#~/\\\\_a-zA-Z0-9.:!="))
       (l-end-pos      (save-excursion          (skip-chars-forward  l-skip-string) (point)))
       (l-file-name    (when l-start-pos (buffer-substring        l-start-pos l-end-pos)))
       )
    (cond ((not l-file-name)
	   (error "No suitable start-point found for file-path!")
	   )
	  ((not (file-exists-p l-file-name))
	   (error "File or directory \"%s\" cannot be found!" l-file-name)
	   )
	  (t
	   l-file-name
	   )
	  )
    )
  )

;; aliases_compat.el
;;
;; The following function is changed to accomodate the different path of
;; the LAYERED_PRODUCTS file in 43 and 5.
;;
(defun aliases-update-sw-menu ()
  "Update 'resources-menu-sw-alias-files' submenu in SW menu bar."
  (interactive)
  (if (and (boundp 'sw-set-keys) (symbol-value 'sw-set-keys))
      (let (default-files
	    lp-files
	    buffers
	    (rescan (list "---" (vector resources-aliases-sw-menu-rescan 'aliases-update-sw-menu t))))
	(dolist (f (append aliases-user-file-list aliases-common-file-list ))
	  (push `[,f
		  (progn
		    (find-file (aliases-expand-file ,f))
		    (aliases-mode))
		  (and ,f (aliases-expand-file ,f))
		  ]
		default-files))

	;; FOR 43
	(when (getenv "SMALLWORLD_GIS")
	  (dolist (lp (aliases-layered-products-file
		       (aliases-expand-file "$SMALLWORLD_GIS/config/LAYERED_PRODUCTS")))
	    (push `[,(format "%s: %s" (car lp) (cdr lp)) 
		    (progn
		      (find-file ,(concat (cdr lp) "/config/gis_aliases"))
		      (aliases-mode))
		    ,(cdr lp)
		    ]
		  lp-files))
	  (push "---" lp-files))
	;; END CHANGE

	(when (getenv "SMALLWORLD_GIS")
	  (dolist (lp (aliases-layered-products-file
		       (aliases-expand-file "$SMALLWORLD_GIS/../smallworld_registry/LAYERED_PRODUCTS")))
	    (push `[,(format "%s: %s" (car lp) (cdr lp)) 
		    (progn
		      (find-file ,(concat (cdr lp) "/config/gis_aliases"))
		      (aliases-mode))
		    ,(cdr lp)
		    ]
		  lp-files))
	  (push "---" lp-files))

	(loop for buf in (sw-buffer-mode-list 'aliases-mode)
	      do (push (vector (buffer-file-name (get-buffer buf))
			       (list 'switch-to-buffer buf)
			       t) buffers))
	(or (eq (length buffers) 0) (push "---" buffers))

	(easy-menu-change (list resources-menu-sw)
			  resources-menu-sw-alias-files
			  (append default-files lp-files buffers rescan)))))
  

(provide 'rw-extras)
