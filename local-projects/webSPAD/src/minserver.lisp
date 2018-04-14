(load "~/quicklisp/setup")
(ql:quickload :hunchentoot)

;;; test: http://localhost:4242/eval?code=D(x^n,x,6)

(in-package :boot)

;;;
;;; Config
;;;
(defparameter +port+ 4242)




;;;
;;; SPAD eval
;;;
(defun spad_eval (code)
  (let ((*package* (find-package :boot))
        (alg (boot::|parseAndEvalToString| code)))
          (format nil "~{~A~%~}" alg)))   
    


;;;
;;; WEB server
;;;  
(hunchentoot:define-easy-handler (fricas-eval :uri "/eval") (code)
  (setf (hunchentoot:content-type*) "text/plain")
  (format nil "~A~%" (spad_eval code)))
    

(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port +port+))

;;; add :address "localhost"  if you wish local access only