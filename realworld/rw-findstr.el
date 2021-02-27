;;; rw-findstr.el --- Find a string in files

(defvar rw-findstr-dir nil "Directory searched.")
(defvar rw-findstr-file-pattern-history)
(defvar rw-findstr-search-string-history)

(defun rw-findstr ()
  "Find files with contents matching a pattern 
  (which is to supply on request of the function)"
  (interactive)
  (let* (
	 (l-dir (expand-file-name
		 (read-directory-name "Search (top) directory: " nil nil t)))
	 (l-files-pattern  
	  (read-string "File Pattern: " "*.magik" 'rw-findstr-file-pattern-history))
	 (l-search-string (read-string "String: " nil 'rw-findstr-search-string-history))
	 l-proc
	 l-params
	 (l-findstr-buffer-name "*rw-findstr*")
	 (l-files (subst-char-in-string (string-to-char "/") (string-to-char "\\")
					(expand-file-name l-files-pattern l-dir))))
    (setq l-params '("/R" "/S" "/I" "/N"))
    (setq rw-findstr-dir (file-name-as-directory l-dir))
    (save-excursion
      (set-buffer (get-buffer-create l-findstr-buffer-name))
      (if buffer-read-only
	  (toggle-read-only))
      (erase-buffer)
      ;; ----------
      ;; careful with " in the buffer: if there are then font-locking will make emacs hang!
      ;; ----------
      (insert (format 
	       "Search results for string: %s\nSearched files: %s\n\n" 
	       l-search-string l-files))
      (rw-findstr-mode)
      (message "Searching...")
      (pop-to-buffer l-findstr-buffer-name)
      ;; do the actual process
      (setq l-params (append l-params (list (format "/C:%s" l-search-string) l-files)))
      (setq l-proc (apply 'start-process "FINDSTR" l-findstr-buffer-name "FINDSTR"  l-params))
      (set-process-filter l-proc 'rw-findstr-filter)
      (set-process-sentinel l-proc 'rw-find-process-sentinel)))
  )

(defun rw-find-process-sentinel (p-proc p-what)
  "Signal a change in the find-process.
  Author        : Realworld Systems (GR)
  Date          : Apr/2003
  Parameters    : P-PROC: the running find-process
                  P-WHAT: the change in the find-process
  Returns       : -"
  (let* 
      (
       (l-what (if (string-match "\\(.*\\)\n$" p-what) (match-string 1 p-what) p-what))
       (l-buffer (process-buffer p-proc))
       )
    (when (buffer-live-p l-buffer)
      (with-current-buffer l-buffer
	(save-excursion (goto-char (point-max)) (insert "\n" (format "Process: %s" l-what))))
      )
    (message "Find-process: %s" l-what)
    )
  )

(defvar rw-findstr-mode-map nil "Local keymap for grep-mode buffers.")
(let ((map (make-keymap)))
  (suppress-keymap map)
  (define-key map "\C-m"    'rw-visit-file-in-findstr-mode-buffer)
  (define-key map [mouse-2] 'rw-visit-file-in-findstr-mode-buffer)
  (setq rw-findstr-mode-map map))

(defun rw-findstr-mode ()
  "Set the major mode of the current buffer to `rw-findstr-mode': mode for result of finding strings in files.
  Date          : Apr/2007
  Parameters    : 
  Returns       : 
  Methodology   : 
  Author        : Realworld EE (DAr)."
  (interactive)
  
  (kill-all-local-variables)
  (use-local-map rw-findstr-mode-map)
  (setq major-mode 'rw-findstr-mode)
  (setq mode-name "Findstr")
  (font-lock-mode)
  )

(defun rw-visit-file-in-findstr-mode-buffer ()
  "   Visit the file in another window. 
                  Highlights the search-string. 
                  This function is called when entering in a buffer in rw-findstr-mode
  Date          : Apr/2007
  Parameters    : 
  Returns       : 
  Methodology   : 
  Author        : Realworld EE (DAr)."
  (interactive)
  (let (l-file
	l-line)
    (save-excursion
      (beginning-of-line)
      (if (eq (re-search-forward "\\(.*\\):\\([0-9]+\\):.*" (line-end-position) t) nil)
	  (error "No file at this line!")
	)
      (setq l-file (match-string-no-properties 1))
      (setq l-line (match-string-no-properties 2))
      (switch-to-buffer-other-window (find-file-noselect 
				      (expand-file-name l-file rw-findstr-dir)))
      (goto-line (string-to-number l-line)))
    ))

(defun rw-findstr-filter (proc string)
  (with-current-buffer (process-buffer proc)
    (let (
	  (l-start (process-mark proc))
	  l-end)
      (save-excursion
        ;; Insert the text, advancing the process marker.
        (goto-char (process-mark proc))
        (insert string)
	(setq l-end (point))
	(save-excursion
	  (goto-char l-start)
	  (beginning-of-line)
	  (while (search-forward rw-findstr-dir nil t)
	    (replace-match "")))
        (set-marker (process-mark proc) (point)))
      )))



(provide 'rw-findstr)
