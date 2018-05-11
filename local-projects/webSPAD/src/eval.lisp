(in-package :webspad)

;; Tempfile for multiline input -> )read
(defparameter +SPAD-TMP+ (format nil ".tmp-ispad-~S.input" (random 100000)))


(defstruct ws-format
    (algebra  boot::|$algebraFormat|)
    (tex      boot::|$texFormat|)
    (html     boot::|$htmlFormat|)
    (mathml   boot::|$mathmlFormat|)
    (formula  boot::|$formulaFormat|)
    (fortran  boot::|$fortranFormat|)
    (texmacs  boot::|$texmacsFormat|)
    (openmath boot::|$openMathFormat|))

;; (type-of x) => SB-IMPL::STRING-OUTPUT-STREAM

(defstruct ws-out-stream
    (stdout   nil)
    (stderr   nil)
    (algebra  nil)
    (tex      nil)
    (html     nil)
    (mathml   nil)
    (formula  nil)
    (fortran  nil)
    (texmacs  nil)
    (openmath nil))


(defstruct webspad-data
    (input           ""       :type string  )
    (stdout          ""       :type string  )
    (stderr          ""       :type string  )
    (multiline?      nil      :type boolean )
    (spad-type       ""       :type string  )
    (algebra         ""       :type string  )
    (charybdis       ""       :type string  )
    (tex             ""       :type string  )
    (html            ""       :type string  )
    (mathml          ""       :type string  )
    (formula         ""       :type string  )
    (fortran         ""       :type string  )
    (texmacs         ""       :type string  )
    (openmath        ""       :type string  )
    (format-flags    (make-ws-format)      :type ws-format))


(defun webspad-eval (s)
    
    (setf fmt (make-ws-format)) 
    (setf out (make-ws-out-stream))
    
    (setf data (make-webspad-data :input s :format-flags fmt))
    
    (progn (setf (ws-out-stream-stdout out) boot::*standard-output*) 
           (setf (ws-out-stream-stderr out) boot::*error-output*) 
         (setf boot::*standard-output* (make-string-output-stream))
         (setf boot::*error-output* (make-string-output-stream)))
    
    
    (if (ws-format-tex fmt) 
        (progn (setf (ws-out-stream-tex out) boot::|$texOutputStream|) 
         (setf boot::|$texOutputStream| (make-string-output-stream))))
          
    (if (ws-format-html fmt) 
        (progn (setf (ws-out-stream-html out) boot::|$htmlOutputStream|) 
         (setf boot::|$htmlOutputStream| (make-string-output-stream))))
          
    (if (ws-format-mathml fmt) 
        (progn (setf (ws-out-stream-mathml out) boot::|$mathmlOutputStream|) 
         (setf boot::|$mathmlOutputStream| (make-string-output-stream))))
                    
    (if (ws-format-formula fmt) 
        (progn (setf (ws-out-stream-formula out) boot::|$formulaOutputStream|) 
         (setf boot::|$formulaOutputStream| (make-string-output-stream))))
          
    (if (ws-format-fortran fmt) 
        (progn (setf (ws-out-stream-fortran out) boot::|$fortranOutputStream|) 
         (setf boot::|$fortranOutputStream| (make-string-output-stream))))
 
    (if (ws-format-texmacs fmt) 
        (progn (setf (ws-out-stream-texmacs out) boot::|$texmacsOutputStream|) 
           (setf boot::|$texmacsOutputStream| (make-string-output-stream))))
          
    (if (ws-format-openmath fmt) 
        (progn 
           (setf (ws-out-stream-openmath out) boot::|$openMathOutputStream|) 
           (setf boot::|$openMathOutputStream| (make-string-output-stream))))
    
    (setf s (let ((nl (count #\newline s)))
      (if (> nl 0)
        (when t (with-open-file
          (stream +SPAD-TMP+ :direction :output :if-exists :supersede)
          (format stream s))
           (setf (webspad-data-multiline? data) t)
           (format nil ")read ~S )quiet )ifthere" +SPAD-TMP+))
         s)))
    
    (setf alg (boot::|parseAndEvalToString| s))
    
 
    (progn (setf (webspad-data-stdout data) 
                   (get-output-stream-string boot::*standard-output*))
           (setf (webspad-data-stderr data) 
                   (get-output-stream-string boot::*error-output*))
           (setf boot::*standard-output* (ws-out-stream-stdout out))
           (setf boot::*error-output* (ws-out-stream-stderr out)))
             
    
    (if (ws-format-tex fmt) 
        (progn (setf (webspad-data-tex data) 
                   (get-output-stream-string boot::|$texOutputStream|))
           (setf boot::|$texOutputStream| (ws-out-stream-tex out))))
          
    (if (ws-format-html fmt) 
        (progn (setf (webspad-data-html data)
                   (get-output-stream-string boot::|$htmlOutputStream|))
           (setf boot::|$htmlOutputStream| (ws-out-stream-html out))))
          
    (if (ws-format-mathml fmt) 
        (progn (setf (webspad-data-mathml data)
                   (get-output-stream-string boot::|$mathmlOutputStream|))
           (setf boot::|$matmlOutputStream| (ws-out-stream-mathml out))))
          
    (if (ws-format-formula fmt) 
        (progn (setf (webspad-data-formula data)
                   (get-output-stream-string boot::|$formulaOutputStream|))
           (setf boot::|$formulaOutputStream| (ws-out-stream-formula out))))        
          
    (if (ws-format-fortran fmt) 
        (progn (setf (webspad-data-fortran data)
                   (get-output-stream-string boot::|$fortranOutputStream|))
           (setf boot::|$fortranOutputStream| (ws-out-stream-fortran out))))

    (if (ws-format-texmacs fmt) 
        (progn (setf (webspad-data-texmacs data)
                   (get-output-stream-string boot::|$texmacsOutputStream|))
           (setf boot::|$texmacsOutputStream| (ws-out-stream-texmacs out))))        
          
    (if (ws-format-openmath fmt) 
        (progn (setf (webspad-data-openmath data)
                   (get-output-stream-string boot::|$openMathOutputStream|))
           (setf boot::|$openMathOutputStream| (ws-out-stream-openmath out))))
    
    (setf (webspad-data-algebra data) (get-algform alg))
    (setf (webspad-data-spad-type data) (get-type-string alg))
    (setf (webspad-data-charybdis data) (get-charybdis alg))
    data)
          
 
          
(defun webspad-eval-if-texformat (s)
  (let ((*package* (find-package :boot)))
    (let ((tmpout (make-string-output-stream))
          (save boot::|$texOutputStream|))
      (setq boot::|$texOutputStream| tmpout)
      (let ((alg (boot::|parseAndEvalToString| s))
            (tex (get-output-stream-string boot::|$texOutputStream|)))
        (setq boot::|$texOutputStream| save)
            (make-webspad-data :input s
                               :algebra (get-algform alg)
                               :spad-type  (get-type-string alg)
                               :tex tex)))))

(defun webspad-eval-default (s)
    (let ((alg (boot::|parseAndEvalToString| s)))
        (make-webspad-data :input s
                           :algebra  (get-algform alg)
                           :spad-type  (get-type-string alg))))


(defun spad-eval (code)
  (let ((*package* (find-package :boot))
        (alg (boot::|parseAndEvalToString| code)))
          (format nil "~{~A~%~}" alg)))


(defun has-type (result)
    (let ((ts (string-trim " " (car(last result)))))
        (if (< (length ts) 5) nil
          (if (string-equal (subseq ts 0 5) "Type:") t nil))))


(defun has-error (result)
    (if (string-equal (car result) "error") t nil))


(defun get-type (result)
    (let ((ts (string-trim " " (car(last result)))))
        (string-trim " " (subseq ts 6))))


(defun get-algform (result)
    (format nil "~{~A~%~}" (butlast result)))

(defun get-charybdis (result)
    (format nil "~{~A~%~}" result))

(defun get-type-string (result)
    (if (has-type result) 
        (get-type result) ""))
