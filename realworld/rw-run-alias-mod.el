(require 'aliases)

(defun aliases-run-program (&optional alias file dir)
  "Run gis.exe on the aliases file.

With a prefix arg, ask user for current directory to use."
  (interactive (if (not (aliases-at-alias-definition))
		   (list
		    (completing-read (concat resources-aliases-definition-prompt " ")
				     (mapcar (function
					      (lambda (d) (cons d d)))
					     (aliases-list))
				     nil t)
		    nil nil)))
  (cond (current-prefix-arg
	 (setq dir (file-name-as-directory
		    (expand-file-name
		     (read-file-name (concat resources-aliases-cwd-prompt " "))))))
	((null dir)
	 (setq dir default-directory)))

  (let ((program aliases-program)
	(args    aliases-program-args)
	(file    (or file (buffer-file-name)))
	(buf     "gis")
	(version (if (boundp 'gis-version-current)
		     (symbol-value 'gis-version-current)))
	(process-environment-aliases aliases-process-environment)
	(exec-path-aliases aliases-exec-path))
    (save-excursion
      (cond (alias nil)
	    ((re-search-backward aliases-definition-regexp nil t)
	     (setq alias (match-string-no-properties 1)))
	    (t
	     (error resources-aliases-no-definition)))
      (if (running-under-nt)
	  (if (file-exists-p (concat (file-name-directory file) "environment.bat"))
	      (setq args (append args (list "-e" (concat (file-name-directory file) "environment.bat")) nil))))
      ;;
      ;; START CHANGE
      ;; Make logfile unique, Avoid preventing not starting gis because of an already existing file
      ;; with the same name
      ;; (setq args (append args (list "-i" "-q" "-l" (expand-file-name (concat alias ".log") (getenv "TEMP")))))
      (setq args (append args (list "-i" "-q" "-l" (make-temp-file (concat alias ".log")))))
      ;;
      ;; END CHANGE
      ;;
      (setq args (append args (list "-a" file alias) nil)) ;; alias name MUST be last 

      (if (stringp version)
	  (setq buf (concat buf " " version)))
      (if alias
	  (setq buf (concat buf " " alias)))
      (setq buf (generate-new-buffer (concat "*" buf "*")))
      (set-buffer buf)
      (gis-mode)
      
      (insert resources-aliases-command ": " program " ")
      (mapc (function (lambda (s) (insert s " "))) args)
      (setq default-directory dir
	    args (append (list program) args)
	    gis-exec-path (copy-list (or exec-path-aliases exec-path))
	    gis-process-environment (copy-list (or process-environment-aliases process-environment))
	    gis-current-command (mapconcat 'identity args " "))
      (if (stringp version)
	  (set 'gis-version-current version))
	    
      (insert "\n" (format resources-aliases-cwd default-directory) "\n\n")
      (gis-start-process args))
    (if (aliases-switch-to-buffer alias)
	(switch-to-buffer buf))))

(provide 'rw-run-alias-mod)
