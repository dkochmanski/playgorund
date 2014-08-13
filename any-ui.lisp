;;;; any-ui.lisp

(in-package #:any-ui)

;;; "any-ui" goes here. Hacks and glory await!

(defun gui! (&key menu)
  (with-ltk ()
    (let* ((frame (make-instance 'frame))
	   (menubar (make-menubar))
	   (text (make-text frame)))
      (pack frame :fill :both :expand t)
      (pack text :fill :none :expand t :side :bottom)
      (check-type menu list)
      (labels ((create-menu (menu parent)
		 (typecase (cdr menu)
		   (symbol (make-menubutton
			    parent
			    (car menu)
			    (lambda () (emit (cdr menu)))))
		   (list (let ((this (make-menu
					parent
					(car menu))))
			   (dolist (var (cdr menu))
			     (create-menu var this)))))))
	(create-menu menu menubar)))))

(defslot :sig1 ()
  (format t "hi~%"))

(defslot :sig2 ()
  (format t "sig2!~%"))

(defslot :sig3 ()
  (sleep 2)
  (format t "sig3!~%"))

(defslot :sig4 ()
  (exit-wish))

(defun testcase ()
  (gui! :menu
	'("Menu-root"
	  ("Menu1"
	   ("Menu1-Sub1" . :sig1)
	   ("Menu1-Sub2" . :sig2))
	  ("Menu2" . :sig3)
	  ("Exit" . :sig4))))
