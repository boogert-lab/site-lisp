;;;
;;; rw-cb-enhancements.el
;;; Includes enhancements to the Class Browser functions
;;;
 
(require 'cb)

(defun cb-generalise-file-name (f)
  "Translate F into a filename appropriate for Unix or Windows-NT:
Turn slash characters around.
Expand either $foo or %foo% variables
Introduce or remove drive names.
See the variable `cb-generalise-file-name-alist' to provide more customisation.
(RW) This implementation keeps looking for a pattern that actually *finds* something"
  (save-match-data
    (setq f (substitute-in-file-name f))
    (if cb-generalise-file-name-alist
	(progn
	  (subst-char-in-string ?\\ ?/ f t)
	  (loop for i in cb-generalise-file-name-alist
		if (and (string-match (car i) f)
;; NEW: keep looking for a pattern that actually *finds* something
			(file-exists-p (replace-match (cdr i) nil t f))
;; END
			(setq f (replace-match (cdr i) nil t f)))
		return f)))
    (if (running-under-nt)
	(progn
	  (subst-char-in-string ?/ ?\\ f t)
	  (if (or (string-match "^[a-zA-Z]:" f)
		  (string-match "^\\\\\\\\" f))
	      f
	    (let* ((buffer (cb-gis-buffer))
		   (drive-name (if (get-buffer buffer)
				   (save-excursion
				     (set-buffer buffer)
				     (substring default-directory 0 2))
				 (substring default-directory 0 2))))
	      (concat drive-name f))))
      (if (string-match "^[a-zA-Z]:" f)
	  (setq f (substring f 2)))
      (subst-char-in-string ?\\ ?/ f t))))

(provide 'rw-cb-enhancements)
