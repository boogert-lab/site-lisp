;;
;; Handy functions edttting xsl
;;

(defun rw-toggle-message-as-debug ()
  "Toggles a <xsl:message> element as debug or not "
  (interactive)
  (let*
      (
       (l-dstart-regexp  "<!--DEBUG<xsl:message>")
       (l-dend-regexp    "</xsl:message>-->")
       (l-start-regexp  "<xsl:message>")
       (l-end-regexp    "</xsl:message>")
       )
    (progn
      (if (rw-region-bounded l-dstart-regexp l-dend-regexp)
	  (message "Remove debug")
	(if (rw-region-bounded l-start-regexp l-end-regexp)
	    (message "Add debug")
	  )
	)
      )
    )
  )

(defun rw-region-bounded (start-regexp end-regexp)
  (let*
      (
       (l-start-pos    (save-excursion (re-search-backward start-regexp (line-beginning-position) t)))
       (l-end-pos      (save-excursion (when (re-search-forward end-regexp (point) t))))
       (l-substr       (when l-start-pos (buffer-substring l-start-pos l-end-pos)))
       )
    l-substr l-start-pos l-end-pos
    )
  )

  
