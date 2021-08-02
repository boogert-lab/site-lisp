;;; rw-key-bindings.el --- 

(require 'gis)
(require 'swkeys)

;; assign ctrl-arrows for command history - better than F2-p/n
(define-key gis-mode-map [\C-up]     'recall-prev-matching-gis-cmd)
(define-key gis-mode-map [\C-down]   'recall-next-matching-gis-cmd)

;; navigate through a magik buffer with Ctrl-arrows
(define-key magik-mode-map [\C-up] '(lambda () (interactive) (backward-method t)))
(define-key magik-mode-map [\C-down] '(lambda () (interactive) (forward-method t)))

;; outline
(define-key magik-mode-map [M-up] 'hide-entry)
(define-key magik-mode-map [M-down] 'show-entry)
(define-key magik-mode-map [M-left] 'hide-body)
(define-key magik-mode-map [M-right] 'show-all)

;; deep-print
(sw-define-key deep-print-mode-map [C-right] 'deep-print-unfold)

;; add a debug statement for a method and its parameters
(define-key magik-f4-map "t" 'rw-debug-method-and-params)

;; Run current stanza in alias file with F2
(define-key aliases-mode-map [f2] 'aliases-run-program)

;; Jump to a file anywhere in any buffer with F2-J
(define-key sw-f2-map "j" 'rw-find-file-under-point)

(sw-multi-define-key
 (list sw-f2-map gis-f2-map magik-f2-map) "x" 'dev-tools-object-inspector)

(define-key sw-f2-map "H" 'rw-load-shortcuts)

(define-key global-map (kbd "M-f") 'rw-findstr)

(provide 'rw-key-bindings)
;;; roos-key-bindings.el ends here
