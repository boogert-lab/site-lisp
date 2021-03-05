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

;; Define two new magik file types
(defconst wo-magik-ftype 'wo-magik-ftype
  "The type for all Magik files in Water Office")

(defconst bl-magik-ftype 'bl-magik-ftype
  "The type for all Magik files in BOOGERT-LAB")

;; Polulate the magik-template-file-type-alist with the templates by the add function
(magik-template-file-type-alist-add "Template" t magik-template-file-type-templates-default 'replace)
(magik-template-file-type-alist-add "Water Office Template" nil '((wo-magik-ftype "Water Office" "template_wo.magik")) 'replace)
(magik-template-file-type-alist-add "Boogert-lab Template" nil '((bl-magik-ftype "Boogert-Lab" "template_boogert-lab.magik")) 'replace)

;; Get date in normal format
(defun rw-month ()
    "MONTH/YEAR"
    (format "%s%s%s" (substring (current-time-string) 4 7) "/" (substring (current-time-string) 20))
  )

;; Add function to the magik-template-initialise-hook
(defun rw-magik-default-initialise-template ()
  "Fills header elements and substitute <FILE>, <CREATEDATE>, <AUTHOR> and <YEAR> if present in the file."
  (let ((leafname (if buffer-file-name
		      (file-name-nondirectory buffer-file-name)
		    "")))
    (global-replace-regexp "<FILE>" leafname)
    (global-replace-regexp "<CREATEDATE>" (rw-month))
    (global-replace-regexp "<AUTHOR>" (getenv "USERNAME"))
    (global-replace-regexp "<YEAR>" (substring (current-time-string) 20))
    
    (goto-char (point-max)))
  )

(defun fill-header()
  "Just execute the rw-magik-default-initialise-template function in the current buffer"
  (interactive)
  (rw-magik-default-initialise-template)
  )

(add-hook 'magik-template-initialise-hook 'rw-magik-default-initialise-template)


;;(defun rw-magik-template-file-type (&optional args)
(defun rw-magik-template-file-type (&optional args)
  "Determines the magik-file-type for the buffer"
  (let ((ftype
	 (cond ((string-match "boogert-lab" buffer-file-name)
		bl-magik-ftype)
	       ((string-match "water.office" buffer-file-name)
		wo-magik-ftype)
	       (t
		'default)
	       )
	 ))
    ftype))


(add-hook 'magik-template-file-type-hook 'rw-magik-template-file-type)
	 
(provide 'rw-templates)
