;;;; signals.lisp

(in-package #:any-ui)

;; contains list of slots for particular signal
(defparameter *slot-resolve-table* (make-hash-table))
;; contains function triggered by emiting signal
(defparameter *signal-resolve-table* (make-hash-table))


(defun event-slot-p (slot-symbol)
  "Verifies, if symbol is registered as slot"
  (nth-value 1 (gethash slot-symbol *signal-resolve-table*)))

(defun event-signal-p (signal-symbol)
  "Verifies, if symbol is registered as signal AND as slot"
  (and
   (nth-value 1 (gethash signal-symbol *signal-resolve-table*))
   (nth-value 1 (gethash signal-symbol *slot-resolve-table*))))

(deftype event-slot ()
  "Slot which is capable of being triggered by signal"
  `(satisfies event-slot-p))

(deftype event-signal ()
  "Signal which can trigger number of slots (signal is also a slot)"
  `(satisfies event-signal-p))

;; Use with caution, you can enter infinite recursion
;; Can by solved with spanning tree calculation
(defun connect-signals (signal-s slot-s)
  (check-type signal-s event-signal)
  (check-type slot-s event-slot)
  (push slot-s (gethash signal-s *slot-resolve-table*)))

(defun emit (slot-symbol &rest args)
  "Emits signal, which triggers connected slots"
  (apply #'funcall 
	 (cons (gethash slot-symbol *signal-resolve-table*)
	       args)))

(defmacro defslot (slot-symbol args &body body)
  `(setf (gethash ',slot-symbol *signal-resolve-table*)
	 #'(lambda (,@args)
	     ,@body)))

(defmacro defsignal (signal-symbol args)
  (with-gensyms (x)
    `(progn
       (setf (gethash ',signal-symbol *slot-resolve-table*) nil)
       (defslot ,signal-symbol (,@args)
	 (mapcar (lambda (,x)
		   (bordeaux-threads:make-thread
		    (lambda () (emit ,x ,@args))))
		 (gethash ',signal-symbol *slot-resolve-table*))))))

