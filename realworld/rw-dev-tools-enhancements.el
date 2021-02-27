;;;
;;; File contains fixes to sw functions
;;
;; 1) Mod : Add the dev_tools product first before loading the dev_tools_application
;;
(require 'dev-tools)

;; (defun dev-tools-vsd-open_with_file (filename)
;;   "Loads the magik_tools module if not already loaded."
;;   (magik-function
;;    "_proc(filename) 
;;         _handling sw_module_already_loaded_same_version _with procedure
;;         _dynamic !current_package!
;;         _if (prd << smallworld_product.product(:sw_dev_tools)) _is _unset 
;;         _then 
;; 	     _local dir << system.canonicalise('modules/sw_dev_tools',smallworld_product.product(:sw_core).directory)
;; 	     prd << smallworld_product.load_product_definition(dir)
;;              write('Added product ',prd)
;;         _else
;;              write('Already loaded ',Prd)
;;         _endif
;; 	sw_module_manager.load_module(:dev_tools_application, _unset, 
;;                                       :update_image?, _false)
;; 	!current_package![:very_simple_debugger].open_with_file(filename)
;;    _endproc"
;;    filename))

(defun dev-tools-object-inspector (arg &optional buffer)
  "Use the Dev Tools application to inspect the current object."
  (interactive
   (let ((buffer (sw-get-buffer-mode (and (eq major-mode 'gis-mode) (buffer-name (current-buffer)))
				     'gis-mode
				     resources-gis-enter-buffer
				     gis-buffer
				     'gis-buffer-alist-prefix-function)))
     (barf-if-no-gis buffer)
     (list (sw-find-tag-tag (concat resources-deep-print-prompt ": ")) buffer)))
  (if (and (not (equal arg ""))
           (not (equal arg nil)))
      (let ((p (get-buffer-process buffer)))
        (or (and p (eq (process-status p) 'run))
	    (error resources-sw-no-process-error buffer))
	(and (get-buffer buffer)
	   (not (get-buffer-window buffer 'visible))
	   (pop-to-buffer buffer t))
	(process-send-string
	 p
	 (format
	  "_proc(object) 
        _handling sw_module_already_loaded_same_version _with procedure
        _dynamic !current_package!
        _if (prd << smallworld_product.product(:sw_dev_tools)) _is _unset 
        _then 
	     _local dir << system.canonicalise('modules/sw_dev_tools',smallworld_product.product(:sw_core).directory)
	     prd << smallworld_product.load_product_definition(dir)
             write('Added product ',prd)
        _else
             write('Already loaded ',Prd)
        _endif

	sw_module_manager.load_module(:dev_tools_application, _unset, 
                                      :update_image?, _false)
	!current_package![:object_inspector].open( object )
_endproc(%s)\n$\n"
	  arg)))))

(provide 'rw-dev-tools-enhancements)
