;;
;; Additional functions for Magik
;;

(require 'magik)

(defun rw-debug-method-and-params()
  "Creates a DEBUG statement with args. Default key-binding is F4-t"
  (interactive)
  (let 
      ( (l-meth-signature-regex "^[ \t]*[_private]*[ \t]*_method[ \t]*\\([^\.]+\\)\\.\\([^(\n]+\\)\\(([^)]*)\\)*")
	l-meth-name
	l-params
	)
    (save-excursion
      (if (re-search-backward l-meth-signature-regex nil t)
	  (progn 
	    (setq l-meth-name (match-string-no-properties 2))
	    (setq l-params (match-string-no-properties 3))
	    (forward-line 1)
	    (re-search-forward "^\\s-*[^ \t#]" nil t)
	    (end-of-line 0)
	    (insert (format "\n#DEBUG %s\".%s" "write(_self, " l-meth-name))
	    (if l-params
		(progn 
		  (insert "(")
		  (setq l-params (split-string l-params "[ \t(),]+" t))
		  (delete "_optional" l-params)
		  (delete "_gather" l-params)
		  (if (> (length l-params) 1)
		      (insert (format "\", {%s}.join_as_strings(\", \"), \""
				      (mapconcat (lambda (x) x) l-params ", "))))
		  (if (= (length l-params) 1)
		      (insert (format "\", %s, \""
				      (mapconcat (lambda (x) x) l-params ", "))))
		  (insert ")")
		  )
	      )
	    (insert "\")")
	    )
	)
      )
))

(provide 'rw-magik-extras)
