;;;; any-ui.asd

(asdf:defsystem #:any-ui
  :serial t
  :description "Describe any-ui here"
  :author "Daniel Kochmański"
  :license "GPLv3"
  :depends-on (#:alexandria
               #:lparallel
	       #:ltk)
  :components ((:file "package")
	       (:file "signals")
               (:file "any-ui")))

