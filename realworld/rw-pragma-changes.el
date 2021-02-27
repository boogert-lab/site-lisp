(require 'pragma)

(defcustom rw-auto-deprecated-pragma-insert t
  "*If t, a deprecated template is automatically inserted and removed when the classify_level
is changed."
  :group 'rw-custom-group
  :type  'boolean)

(defun pragma-if-match-insert-classify_level (current next reverse)
"Insert the classify_level according to the current setting.
Also adds a template in the comment section when the classify_level is set to deprecated.
When the classify_level is changed from deprecrated then the template is removed.
However, if data has been changed in the fields of the template then the user is asked
if they wish to remove the contents of the depreacted template."
;;Ensure point stays immediately after = by searching for = and doing the replace inside save-excursion
(search-forward "=")
(save-excursion
  (let ((res (pragma-do-if-match pragma-classify_level-list
				 '(default (looking-at "\\([^,]*\\),") pragma-if-match-replace-with-next 1)
				 reverse)))
    (cond ((eq (caadr res) 'deprecated)
	   (if (eq rw-auto-deprecated-pragma-insert t)
	       ;;next element is deprecated i.e. user has just selected deprecated
	       (pragma-insert-magik-deprecated-template)))
	   ((eq (caar res) 'deprecated)
	    (if (eq rw-auto-deprecated-pragma-insert t)
		;;current element is deprecated i.e. user has just deselected deprecated
		(pragma-remove-magik-deprecated-template)))
	   (t nil)))))

(provide 'rw-pragma-changes)
