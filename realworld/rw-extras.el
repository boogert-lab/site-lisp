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


(provide 'rw-extras)
