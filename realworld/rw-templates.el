;;
;; This adds the default "Template" to the list of magik-template-file-type-templates-default and
;; Add the hook 'rw-magik-default-initialise-template to 'magik-template-initialise-hook
;; It uses realworld/templates/magik-template-file-type (template_default.magik)
;; 

(require 'magik-template)
(require 'default)

;; Set dir with Magik templates
(setq magik-template-dir 
      (expand-file-name (concat site-lisp-dir "realworld/templates")))

;; Set the default template
(magik-template-file-type-alist-add "Template" t magik-template-file-type-templates-default)
(magik-template-file-type-alist-add "Water Office" t '((wo "Water Office" "template_wo.magik")))

;; Get date in normal format
(defun rw-date ()
    "YEAR"
    (format "%s%s%s" (substring (current-time-string) 4 7) "/" (substring (current-time-string) 20))
  )

;; Add function to the hook
(defun rw-magik-default-initialise-template ()
  "Fills header elements and substitute <FILE>, <CREATEDATE>, <AUTHOR> and <YEAR> if present in the file."
  (if (eq 'default (magik-template-file-type))
      (let ((leafname (if buffer-file-name
			  (file-name-nondirectory buffer-file-name)
			"")))
	(global-replace-regexp "<FILE>" leafname)
	(global-replace-regexp "<CREATEDATE>" (rw-date))
	(global-replace-regexp "<AUTHOR>" (getenv "USERNAME"))
	(global-replace-regexp "<YEAR>" (substring (current-time-string) 20))

	(goto-char (point-max))))
  )

(add-hook 'magik-template-initialise-hook 'rw-magik-default-initialise-template)


(defun rw-magik-template-file-type (bfname)
  "Determines the magik-file-type for the bufferfilename bfname"
  'default)

(add-hook 'magik-template-file-type-hook 'rw-magik-template-file-type)

(provide 'rw-templates)
