(require 'htmlize)

(defun htmlize-css-insert-head (buffer-faces face-map)
  "Simple overwrite to replace <style> tag with a link to 'magik.css'"
  (insert "    <link type=\"text/css\" href=\"magik.css\" rel=\"stylesheet\">\n")
  )
